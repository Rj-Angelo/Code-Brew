class PuzzlesController < ApplicationController
	before_action :check_user

	def index
		@puzzles = 	Puzzle.all
		@user_puzzles = current_user.user_puzzles.index_by(&:puzzle_id)
	end

	def new
		@puzzle = Puzzle.new
		@difficulty = ["Easy", "Medium", "Hard"]
	end

	def edit
		@puzzle = Puzzle.find(params[:id])
		@difficulty = ["Easy", "Medium", "Hard"]
	end

	def destroy
		Puzzle.find(params[:id]).destroy
		redirect_to(brew_puzzles_path)
	end

	def show
		@puzzle = Puzzle.find(params[:id])
		@completed_puzzles = UserPuzzle.where(puzzle_id: params[:id], completed: true)
		@new_post = Forum.new
		@puzzle_posts = @puzzle.forums
		
		if params[:result]
			@result = params[:result]
		end
		
		gon.completed_puzzles = @completed_puzzles
	end

	def create
		@puzzle = current_user.puzzles.create(puzzle_params)
		if @puzzle.valid?
			redirect_to brew_puzzles_path 
		else
			@difficulty = ["Easy", "Medium", "Hard"]
			flash[:errors] = @puzzle.errors.full_messages
			redirect_to new_puzzle_path
		end
	end

	def update
		@puzzle = current_user.puzzles.find(params[:id])
		@puzzle.update(puzzle_params)

		if @puzzle.valid?
			redirect_to puzzles_path
		else
			@difficulty = ["Easy", "Medium", "Hard"]
			flash[:errors] = @puzzle.errors.full_messages
			redirect_to edit_puzzle_path(@puzzle)
		end
	end

	def validate_code
		#get puzzle data and prep variables
		@puzzle = Puzzle.find(params[:id])
		@completed = false;
		@console = [];
		@status = [];

		#extract form data from parameters
		form_data = Rack::Utils.parse_nested_query(params[:form])
		code = form_data['code']

		@puzzle.test_cases.each_with_index do |test_case, index|
			# Generate function to be used for testing
			generate_function = "def #{@puzzle.function}\n"
			generate_function += code+"\n"
			generate_function += "end\n"
			generate_function += test_case
			
			# Capture output of eval and puts statements in a string buffer
			output_buffer = StringIO.new
			$stdout = output_buffer
			
			#evaluate function generated
			begin
				@result = eval(generate_function)
				if @result.to_s == @puzzle.expected_outputs[index]
					@status << "pass"
				else
					@status << "fail"
				end
				
				# Reset stdout back to STDOUT
				$stdout = STDOUT
				@console << "\n"+output_buffer.string

			rescue SyntaxError, StandardError => e
				@error = "fail\nError: #{e.message}"
			end
		end

		#if user passes all test cases add user to user_puzzles
		if @status.all? { |status| status == "pass" }
			@completed = true;
		
			unless UserPuzzle.exists?(user_id: current_user.id, puzzle_id: params[:id], completed: true)				
				playback = JSON.parse(params[:playback])
				@completed_puzzle = UserPuzzle.create(user_id: current_user.id, puzzle_id: params[:id], completed: true, playback: playback)	
				@html = render_to_string(partial: "/puzzles/partials/playback")
			end
		end

		# Include captured output in result
		respond_to do |format|
			
			format.json {render json: { console: @console, status: @status, completed: @completed, error: @error, completed_puzzle: @completed_puzzle, html: @html }}
		end
	end

	private
	def puzzle_params
		params.require(:puzzle).permit(:user_id, :title, :difficulty, :description, :function, test_cases:[], expected_outputs:[])
	end
end
