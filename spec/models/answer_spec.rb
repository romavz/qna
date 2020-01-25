require 'rails_helper'

RSpec.describe Answer, type: :model do
  it do
    should belong_to(:question)
      .with_foreign_key(:question_id)
      .dependent(:destroy)
      .required
  end
  it { should have_db_index :question_id }

  it { should validate_presence_of :body }
end
