FactoryBot.define do
  factory :oauth_app, class: 'Doorkeeper::Application' do
    name         { 'TestApp' }
    uid          { 'U2FsdGlsbG8gLSBJIEhhdGUgWW91' }
    secret       { 'TW9kZXJuIENsYXNzaWNhbCAvIFRyaXAgSG9w' }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
  end
end
