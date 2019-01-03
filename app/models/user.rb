class User < ApplicationRecord

	  validates :name, format: { without: /\s/ }, uniqueness: true, presence: true, length: { maximum: 10 }, if: :can_validate
	  validates :email, uniqueness: true, presence: true, if: :can_validate, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }, if: :can_validate
	  devise :omniauthable, :omniauth_providers => [:facebook]
	
	  def can_validate
    	true
  	end

    has_many :requires
    has_many :reviews
    has_many :comments
    has_many :bookfavorites
		has_many :follow1s
	has_secure_password

	has_attached_file :user_img, :styles => { :user_index => "250x350>", :user_show => "325x475>" }, :default_url => "default.png"
  	validates_attachment_content_type :user_img, :content_type => /\Aimage\/.*\Z/

	  def self.new_with_session params, session
		super.tap do |user|
		  if data = session["devise.facebook_data"] &&
			session["devise.facebook_data"]["extra"]["raw_info"]
			user.email = data["email"] if user.email.blank?
		  end
		end
	  end
	
	  def self.from_omniauth auth
		where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
		  user.email = auth.info.email
		  user.password = Devise.friendly_token[0,20]
		  user.name = auth.info.name
		end
	  end
end
