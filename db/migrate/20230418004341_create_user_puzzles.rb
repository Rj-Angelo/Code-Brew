class CreateUserPuzzles < ActiveRecord::Migration[7.0]
  def change
    create_table :user_puzzles do |t|
		t.references :user, null: false, foreign_key: true
		t.references :puzzle, null: false, foreign_key: true
		t.boolean :completed
		t.text :playback
		t.timestamps
    end
  end
end
