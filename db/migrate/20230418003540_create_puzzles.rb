class CreatePuzzles < ActiveRecord::Migration[7.0]
  def change
    create_table :puzzles do |t|
	  t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :difficulty
      t.text :description
	  t.string :function
	  t.text :test_cases
	  t.text :expected_outputs

      t.timestamps
    end
  end
end
