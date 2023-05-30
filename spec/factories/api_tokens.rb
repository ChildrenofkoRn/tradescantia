FactoryBot.define do
  factory :api_token, class: 'Doorkeeper::AccessToken' do
    association :application, factory: :oauth_app

    resource_owner_id { create(:user).id }
    # if default_scopes is set in Doorkeeper.configure
    scopes { 'public' }
  end
end
