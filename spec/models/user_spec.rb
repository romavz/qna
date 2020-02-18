require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:some_content) { double }

    context 'for owned entities' do
      before { some_content.stub(:user_id) { user.id } }
      it 'should return true' do
        expect(user).to be_author_of(some_content)
      end
    end

    context 'for non owned entities' do
      before { some_content.stub(:user_id) { 0 } }
      it 'should return false' do
        expect(user).not_to be_author_of(some_content)
      end
    end

  end
end
