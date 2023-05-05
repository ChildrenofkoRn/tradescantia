class CreateAssociationStatForAllReviews < ActiveRecord::Migration[6.1]

  def up
    Review.select(:id).find_each(batch_size: 500) do |review|
      review.create_stat.rebuild_ranks_stat
    end
  end

  def down
    Stat.destroy_all
  end
end
