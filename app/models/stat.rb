class Stat < ApplicationRecord

  belongs_to :statable, polymorphic: true

  validates :views, :ranks_count, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :rank_avg, numericality: { greater_than_or_equal_to: 0 }

  after_save :touch_parent

  def views_up
    self.views += 1
    save
  end

  def rank_add(score)
    ranks_sum = rank_avg * ranks_count
    self.ranks_count += 1
    self.rank_avg = (ranks_sum + score.abs) / ranks_count
    save
  end

  def rank_del(score)
    ranks_sum = rank_avg * ranks_count
    self.ranks_count -= 1
    self.rank_avg = ranks_count.zero? ? ranks_count : (ranks_sum - score.abs) / ranks_count
    save
  end

  def rebuild_ranks_stat
    self.ranks_count = statable.ranks.count
    self.rank_avg = statable.ranks.average(:score).to_f
    save
  end

  private

  def touch_parent
    statable.touch if saved_changes.keys.include?("rank_avg")
  end

end
