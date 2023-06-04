require 'rails_helper'

RSpec.describe FindForOauthService, type: :services do

  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '2244')}
  subject { FindForOauthService.call(auth) }

  context 'user already has authorization' do
    before do
      user.authorizations.create!(provider: 'github', uid: '2244')
    end

    it 'returns the user' do
      expect(subject).to eq user
    end

    it 'no new user created in DB' do
      expect{ subject }.to_not change(User, :count)
    end

    it 'not created new authorization' do
      expect{ subject }.to_not change(Authorization, :count)
    end
  end

  context 'user has not authorization' do
    context 'user already exists' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '8282', info: {email: user.email})}

      it 'does not create new user' do
        expect { subject }.to_not change(User, :count)
      end

      it 'creates authorization for user' do
        expect { subject }.to change(user.authorizations, :count).by(1)
      end

      it 'creates authorization with provider and uid' do
        authorization = subject.authorizations.first
        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end

      it 'returns the user' do
        expect(subject).to eq user
      end
    end

    context 'user does not exist' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'github',
                                          uid: '8282',
                                          info: { email: 'rnd@mail.space' }) }

      it 'creates new user' do
        expect { subject }.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(subject).to be_a(User)
      end

      it 'fills user email' do
        user = subject
        expect(user.email).to eq auth.info[:email]
      end

      it 'fills user name' do
        user = subject
        expect(user.username).to eq 'rnd'
      end

      it 'creates authorization' do
        expect{subject}.to change(Authorization, :count).by(1)
      end

      it 'creates authorization for user' do
        user = subject
        expect(user.authorizations).to_not be_empty
      end

      it 'creates authorization with provider and uid' do
        authorization = subject.authorizations.first
        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end

    context 'user doesnt exist, but username has already been taken' do
      let(:username)  { 'rnd' }
      let!(:another_user)  { create(:user, username: username) }
      let(:auth) { OmniAuth::AuthHash.new(provider: 'github',
                                          uid: '8282',
                                          info: { email: "#{username}@mail.space" }) }

      it 'creates new user' do
        expect { subject }.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(subject).to be_a(User)
      end

      it 'fills user email' do
        user = subject
        expect(user.email).to eq auth.info[:email]
      end

      it 'fills user name' do
        user = subject
        expect(user.username).to eq "#{username}_#{auth.uid}"
      end

      it 'creates authorization' do
        expect{subject}.to change(Authorization, :count).by(1)
      end

      it 'creates authorization for user' do
        user = subject
        expect(user.authorizations).to_not be_empty
      end

      it 'creates authorization with provider and uid' do
        authorization = subject.authorizations.first
        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end

    context 'user does not exist and doesn\'t email' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'github',
                                          uid: '8282') }
      it 'no new user created in DB' do
        expect{ subject }.to_not change(User, :count)
      end

      it 'not created new authorization' do
        expect{ subject }.to_not change(Authorization, :count)
      end

      it 'returns new user' do
        expect( subject ).to be_a(User)
      end

    end

  end

end
