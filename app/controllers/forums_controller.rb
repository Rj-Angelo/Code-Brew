class ForumsController < ApplicationController
	def create
		@puzzle = Puzzle.find(params[:puzzle_id])
		@post = @puzzle.forums.new(forum_params)
		@post.user_id = current_user.id

		if @post.valid?
			@post.save
			@html = render_to_string(partial: "/puzzles/partials/post")
		else
			@errors = @post.errors.full_messages
		end
		
		respond_to do |format|
			format.json {render json: { post: @post, errors: @errors, html: @html }}
		end
	end

	def update
		@puzzle = Puzzle.find(params[:puzzle_id])
		@post = @puzzle.forums.find(params[:id])
		@post.update(forum_params)
		
		@errors = @post.errors.full_messages unless @post.valid?
		
		respond_to do |format|
			format.json {render json: { errors: @errors }}
		end
	end

	def destroy
		@puzzle = Puzzle.find(params[:puzzle_id])
		@post = @puzzle.forums.find(params[:id])
		@post.destroy
	end

	private
	def forum_params
		params.require(:forum).permit(:content)
	end
end
