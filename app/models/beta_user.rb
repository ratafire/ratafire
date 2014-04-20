class BetaUser < ActiveRecord::Base
  attr_accessible :username, :email, :fullname, :website, :realm, :creator

  	#username
	VALID_USERNAME_REGEX = /\A[a-zA-Z0-9]+\z/
	validates_presence_of :username, :message => "Pick a username."
	validates_length_of :username, :minimum => 3, :message => "Username must be at least 3 characters."
	validates_length_of :username, :maximum => 50, :message => "Username is too long (maximum 50)."
	validates_format_of :username, with: VALID_USERNAME_REGEX, :message => "Alphanumerics only."
	validates_uniqueness_of :username, case_sensitive: false, :message => "This username is already taken."

	#email
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates_presence_of :email, :message => "Don't forget your email address."
	validates_format_of :email, with: VALID_EMAIL_REGEX, :message => "Doesn't look like a valid email."
	validates_uniqueness_of :email, case_sensitive: false, :message => "This email is already taken."

	
	#fullname
	validates_presence_of :fullname, :message => "Enter your first and last name."
	validates_length_of :fullname, :minimum => 3, :message => "Name must be at least 3 characters."
	validates_length_of :fullname, :maximum => 50, :message => "Aww, this is such a long name! (maximum 50)"

	validates_presence_of :realm, :message => "Please select a realm."	

	default_scope order: 'beta_users.created_at DESC'
end
