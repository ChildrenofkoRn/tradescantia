class AddAuthorToReview < ActiveRecord::Migration[6.1]
  def change
    add_reference :reviews, :author, null: true, foreign_key: { to_table: :users }

    # fill in the field for existing records,
    # that's enough for us now.
    reversible do |change|
      change.up do
        first_user = User.first

        Review.find_each do |review|
          review.author_id = first_user.id
          review.save!
        end
      end
    end

    # sets null to false for author_id
    change_column_null :reviews, :author_id, false
  end
end
