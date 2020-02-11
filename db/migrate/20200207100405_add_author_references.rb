class AddAuthorReferences < ActiveRecord::Migration[6.0]
  def up
    Answer.destroy_all
    Question.destroy_all

    add_reference :questions, :author, foreign_key: { to_table: :users, on_delete: :cascade }, null: false
    add_reference :answers, :author, foreign_key: { to_table: :users, on_delete: :cascade }, null: false
  end

  def down
    remove_reference :questions, :author
    remove_reference :answers, :author
  end
end
