class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable,
         authentication_keys: [:login],
         omniauth_providers: [:github]

  attr_writer :login

  has_many :reviews, foreign_key: 'author_id', dependent: :destroy
  has_many :ranks, foreign_key: 'author_id', dependent: :destroy

  has_many :authorizations, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false },
            format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
  validates :username, presence: true, uniqueness: { case_sensitive: false },
            format: { with: /\A[-_a-zA-Z0-9]+\z/, message: "allows letters, numbers and: - _" },
            length: { minimum: 1, maximum: 40 }

  ThinkingSphinx::Callbacks.append(
    self, :behaviours => [:real_time]
  )

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def login
    @login || self.username || self.email
  end

  def author_of?(resource)
    id == resource.author_id
  end

  def ranked?(resource)
    ranks.where(rankable: resource).present?
  end

  def self.find_for_oauth(auth)
    FindForOauthService.call(auth)
  end

  def admin?
    self.type == 'Admin'
  end

end
