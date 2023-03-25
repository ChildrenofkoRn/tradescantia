require 'rails_helper'

RSpec.describe ReviewPolicy, type: :policy do

  subject { described_class.new(user, review) }

  let(:review) { create(:review) }

  context "Visitor" do

    let(:user) { nil }

    it { should     authorize(:index)   }
    it { should     authorize(:show)    }
    it { should_not authorize(:new)     }
    it { should_not authorize(:create)  }
    it { should_not authorize(:edit)    }
    it { should_not authorize(:update)  }
    it { should_not authorize(:ranking) }
  end

  context "Admin" do

    let(:user) { create(:admin) }

    it { should     authorize(:index)   }
    it { should     authorize(:show)    }
    it { should     authorize(:new)     }
    it { should     authorize(:create)  }
    it { should     authorize(:edit)    }
    it { should     authorize(:update)  }
    it { should     authorize(:ranking) }

    it 'is expected not to authorize twice :ranking' do
      create(:rank, author: user, rankable: review)
      should_not authorize(:ranking)
    end
  end

  context "Author" do

    let(:user) { create(:user) }
    let(:review) { create(:review, author: user) }

    it { should     authorize(:index)   }
    it { should     authorize(:show)    }
    it { should     authorize(:new)     }
    it { should     authorize(:create)  }
    it { should     authorize(:edit)    }
    it { should     authorize(:update)  }
    it { should_not authorize(:ranking) }
  end

  context "User" do

    let(:user) { create(:user) }

    it { should     authorize(:index)   }
    it { should     authorize(:show)    }
    it { should     authorize(:new)     }
    it { should     authorize(:create)  }
    it { should_not authorize(:edit)    }
    it { should_not authorize(:update)  }
    it { should     authorize(:ranking) }

    it 'is expected not to authorize twice :ranking' do
      create(:rank, author: user, rankable: review)
      should_not authorize(:ranking)
    end
  end

end
