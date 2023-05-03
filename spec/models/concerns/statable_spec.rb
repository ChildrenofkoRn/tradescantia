require 'rails_helper'

RSpec.describe 'concern Statable' do

  with_model :WithStatable do
    table do |t|
    end

    model do
      include Statable
    end
  end

  it "should have one :stat" do
    object = WithStatable.create!
    expect(object.stat.statable).to eq object
  end

  it "stat object exist after create" do
    object = WithStatable.create!
    expect(object.stat).to be_a Stat
  end

  # another way
  describe 'associations' do
    subject { WithStatable.new }
    it { should have_one(:stat).dependent(:destroy) }
  end

end
