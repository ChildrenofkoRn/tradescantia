require 'rails_helper'

feature 'User can see a list of reviews or a review', %q(
  I would like to see a list of reviews and be able to view an individual review,
  even if i am not registered
) do

  given!(:reviews) { create_list(:review, 4) }

  describe 'Unauthenticated user' do

    describe 'sees' do
      background do
        visit reviews_path
      end

      scenario 'a list of reviews' do
        reviews.each { |review| expect(page).to have_content(review.title) }
      end

      scenario 'a review' do
        review = reviews.first
        click_on review.title

        expect(page).to have_content(review.title)
        expect(page).to have_content(review.body)
        expect(page).to have_content(review.author.username)
      end
    end

    describe 'pagination' do
      given!(:reviews) { create_list(:review, 25) }

      background do
        visit reviews_path
      end

      scenario 'sees two paginations' do
        expect(page.all("nav.page.pagination").count).to eql(2)
      end

      scenario '15 reviews per page' do
        expect(page.all('a.link-review').count).to eql(15)
      end

      scenario 'goes to the second page'  do
        within(all("nav.page.pagination").first) do
          click_link('2', href: /\/\?page=2*/)
        end

        expect(page.all("nav.page.pagination").count).to eql(2)
        expect(page.all('a.link-review').count).to eql(10)
      end
    end

  end

  describe 'Authenticated' do

    describe 'as User' do
      background do
        log_in(create(:user))
      end

      describe 'sees' do
        background do
          visit reviews_path
        end

        scenario 'a list of reviews' do
          reviews.each { |review| expect(page).to have_content(review.title) }
        end

        scenario 'a review' do
          review = reviews.first
          click_on review.title

          expect(page).to have_content(review.title)
          expect(page).to have_content(review.body)
        end
      end

      describe 'pagination' do
        given!(:reviews) { create_list(:review, 25) }

        background do
          visit reviews_path
        end

        scenario 'sees two paginations' do
          expect(page.all("nav.page.pagination").count).to eql(2)
        end

        scenario '15 reviews per page' do
          expect(page.all('a.link-review').count).to eql(15)
        end

        scenario 'goes to the second page'  do
          within(all("nav.page.pagination").first) do
            click_link('2', href: /\/\?page=2*/)
          end

          expect(page.all("nav.page.pagination").count).to eql(2)
          expect(page.all('a.link-review').count).to eql(10)
        end
      end
    end

    describe 'as Admin' do
      background do
        log_in(create(:admin))
      end


      describe 'sees' do
        background do
          visit reviews_path
        end

        scenario 'a list of reviews' do
          reviews.each { |review| expect(page).to have_content(review.title) }
        end

        scenario 'a review' do
          review = reviews.first
          click_on review.title

          expect(page).to have_content(review.title)
          expect(page).to have_content(review.body)
        end
      end

      describe 'pagination' do
        given!(:reviews) { create_list(:review, 25) }

        background do
          visit reviews_path
        end

        scenario 'sees two paginations' do
          expect(page.all("nav.page.pagination").count).to eql(2)
        end

        scenario '15 reviews per page' do
          expect(page.all('a.link-review').count).to eql(15)
        end

        scenario 'goes to the second page'  do
          within(all("nav.page.pagination").first) do
            click_link('2', href: /\/\?page=2*/)
          end

          expect(page.all("nav.page.pagination").count).to eql(2)
          expect(page.all('a.link-review').count).to eql(10)
        end
      end
    end
  end
end
