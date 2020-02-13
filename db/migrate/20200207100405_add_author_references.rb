class AddAuthorReferences < ActiveRecord::Migration[6.0]
  def up
    Answer.destroy_all
    Question.destroy_all

    add_reference :questions, :user, foreign_key: { to_table: :users, on_delete: :cascade }, null: false
    add_reference :answers, :user, foreign_key: { to_table: :users, on_delete: :cascade }, null: false
  end

  def down
    remove_reference :questions, :user
    remove_reference :answers, :user
  end
end
