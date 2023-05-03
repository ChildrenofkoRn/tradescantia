require 'rails_helper'

RSpec.describe Stat, type: :model do

  describe 'associations' do
    it { should belong_to(:statable) }
  end

  describe 'validations' do
    it { should validate_numericality_of(:views).is_greater_than_or_equal_to(0).only_integer }
    it { should validate_numericality_of(:ranks_count).is_greater_than_or_equal_to(0).only_integer }
    it { should validate_numericality_of(:rank_avg).is_greater_than_or_equal_to(0) }
  end


  describe '#views_up' do
    let(:stat) { create(:stat)}

    it 'increases views by 1' do
      expect { stat.views_up }.to change { stat.views }.by(1)
    end
  end

  describe '#rank_add' do
    let(:stat) { create(:stat)}

    it 'increases ranks_count by 1' do
      expect { stat.rank_add(6) }.to change { stat.ranks_count }.by(1)
    end

    it 'update rank_avg' do
      expect { stat.rank_add(6) }.to change { stat.rank_avg }.by(6)
    end
  end

  describe '#rank_del' do
    let(:stat) { create(:stat, rank_avg: 5.5, ranks_count: 2)}

    it 'decreases ranks_count by 1' do
      expect { stat.rank_del(6) }.to change { stat.ranks_count }.by(-1)
    end

    it 'update rank_avg' do
      expect { stat.rank_del(6) }.to change { stat.rank_avg }.to(5)
    end
  end

  describe '#rebuild_ranks_stat' do
    let(:stat) { create(:stat)}
    let!(:ranks) { create_list(:rank, 3, rankable: stat.statable)}

    before do
      ranks.last.delete
    end

    it 'update ranks_count' do
      expect { stat.rebuild_ranks_stat }.to change { stat.ranks_count }.to(2)
    end

    it 'update rank_avg' do
      new_rank_avg = ( ranks[0].score + ranks[1].score ) / 2.0
      expect { stat.rebuild_ranks_stat }.to change { stat.rank_avg }.to(new_rank_avg)
    end
  end

end
