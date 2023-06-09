require 'rails_helper'

describe 'Review API', type: :request do
  let(:headers) { ref_headers.except('CONTENT_TYPE') }

  describe 'PATCH /api/v1/reviews/:id' do
    let(:review) { create(:review) }
    let(:api_path) { "/api/v1/reviews/#{review.id}" }

    it_behaves_like 'API Authorizable' do
      let(:action) { :patch }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:review) { create(:review) }
      let(:token) { create(:api_token, resource_owner_id: user.id).token }
      let(:new_attrs) { attributes_for(:review) }

      context 'by Author' do
        let(:review) { create(:review, author: user) }

        context 'with valid attributes' do

          before do
            patch api_path, params: { access_token: token, id: review, review: new_attrs }, headers: headers
          end

          it_behaves_like 'API Successfulable'

          it_behaves_like 'API Returns fields' do
            let(:object) { review.reload }
            let(:resource) { json }
            let(:public_fields) { %w[title body created_at updated_at] }
            let(:private_fields) { %w[] }
          end

        end

        context 'with invalid attributes' do
          let(:invalid_attrs) { attributes_for(:review, :invalid) }

          before do
            patch api_path, params: { access_token: token, id: review, review: invalid_attrs }, headers: headers
          end

          it_behaves_like 'API Unprocessable'

          it 'doesnt change review' do
            expect { review.reload }.to not_change(review, :title).and not_change(review, :body)
          end

        end
      end

      context 'by Admin' do
        let(:admin) { create(:admin) }
        let(:token) { create(:api_token, resource_owner_id: admin.id).token }

        context 'with valid attributes' do

          before do
            patch api_path, params: { access_token: token, id: review, review: new_attrs }, headers: headers
          end

          it_behaves_like 'API Successfulable'

          it_behaves_like 'API Returns fields' do
            let(:object) { review.reload }
            let(:resource) { json }
            let(:public_fields) { %w[title body created_at updated_at] }
            let(:private_fields) { %w[] }
          end

        end

        context 'with invalid attributes' do
          let(:invalid_attrs) { attributes_for(:review, :invalid) }

          before do
            patch api_path, params: { access_token: token, id: review, review: invalid_attrs }, headers: headers
          end

          it_behaves_like 'API Unprocessable'

          it 'doesnt change review' do
            expect { review.reload }.to not_change(review, :title).and not_change(review, :body)
          end

        end
      end

      context 'by Non-Author' do
        let(:review) { create(:review) }

        before do
          patch api_path, params: { access_token: token, id: review, review: new_attrs }, headers: headers
        end

        it_behaves_like 'API Unauthorizable'

        it 'doesnt change review' do
          expect { review.reload }.to not_change(review, :title).and not_change(review, :body)
        end

      end

    end
  end

end
