require 'rails_helper'

RSpec.describe Review, type: :model do

  it { should belong_to(:author) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it_behaves_like 'be Modulable', %w[Authorable]
end
