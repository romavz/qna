require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author?' do
    let(:user) { create(:user) }
    let(:some_content) { double }

    context 'for owned entities' do
      before { some_content.stub(:user) { user } }
      it 'should return true' do
        expect(user.author?(some_content)).to be true
      end
    end

    context 'for non owned entities' do
      before { some_content.stub(:user) { Object.new } }
      it 'should return false' do
        expect(user.author?(some_content)).to be false
      end
    end

    context 'for objects without user reference' do
      it 'should return false' do
        expect(user.author?(some_content)).to be false
      end
    end
  end
end
