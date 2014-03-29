require 'spec_helper'

describe User do 

	before do
		@user = User.new(username: "exampleuser", 
			email: "user@example.com", fullname: "Example User",
			password: "skynet", tagline: "batman",)
	end	

	subject { @user }

	#---Respond Test---
	it { should respond_to(:username) }
	it { should respond_to(:email) }
	it { should respond_to(:fullname) }
	#Password Digest from Bcrypt-ruby gem 
	it { should respond_to(:password_digest) }
	#Password and confirmation
	#it { should respond_to(:password_confirmation) }
	#Authentification
	it { should respond_to(:authenticate) }
	it { should respond_to(:tagline)}


	#----Limitations on Fields-----

	#---Valid Presence Test---
	#Validation for presence, these fields cannot be blank
	it { should be_valid }

		#username Validation
		describe "when username is not present" do
			before { @user.username = " " }
			it { should_not be_valid }
		end

		#email Validation
		describe "when email is not present" do
			before { @user.email = " " }
			it { should_not be_valid }
		end		

		#fullname Validation
		describe "when fullname is not present" do
			before { @user.fullname = " " }
			it { should_not be_valid }
		end	

		#password Validation
		#describe "when password is not present" do
		#	before { @user.password = @user.password_confirmation = " " }
		#	it { should_not be_valid }
		#end 

	#---Length Test---
	#These fields cannot be to short or toooooo long

		#username Length (3~50)
		describe "when username is too short or too long" do
			before { @user.username = "a" * 2 }
			it { should_not be_valid }
			before { @user.username = "a" * 51 }
			it { should_not be_valid }
		end

		#fullname length (3~50)
		describe "when fullname is too short or too long" do
			before { @user.fullname = "a" * 2 }
			it { should_not be_valid }
			before { @user.fullname = "a" * 51 }
			it { should_not be_valid }
		end		

		#password Length (6~50)
		describe "when password is too short or too long" do
			before { @user.password = "a" * 5 }
			it { should_not be_valid }
			before { @user.password = "a" * 51 }
			it { should_not be_valid }
		end		

		#tagline Length (0~42)
		describe "when tagline is too long" do
			before { @user.tagline = "a" * 43 }
			it { should_not be_valid }
		end

	#---Format Test---
	#They have to conform to formats, big brother is watching them!

		#Email Simple Format
		#Invalid
		describe "when email format is invalid" do
			it "should be invalid" do
				addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@baz_baz.com foo@bar+baz.com]
				addresses.each do |invalid_address|
					@user.email = invalid_address
					@user.should_not be_valid
				end
			end
		end

		#Valid
		describe "when email format is valid" do
			it "should be valid" do
				addresses = %w[user@foo.COM a_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn user@nyu.edu]
				addresses.each do |valid_address|
					@user.email = valid_address
					@user.should be_valid
				end
			end
		end	

	#---Uniqueness Test---
	#One Ring to rule them all, and one ring only

		#Username Uniqueness
		describe "when username is already taken" do
			before do
				user_with_same_username = @user.dup
				user_with_same_username.save
			end

			it { should_not be_valid }
		end

		#Email Uniqueness
		describe "when email is already taken" do
			before do
				user_with_same_email = @user.dup
				user_with_same_email.save
			end

			it { should_not be_valid }
		end

	#---Password Match Test---

		#password match valid
		#describe "when password doesn't match confirmation" do
		#	before { @user.password_confirmation = "mismatch" }
		#	it { should_not be_valid }
		#end

		#cannot create password with password_confirmation: nil
		#describe "when password confirmation is nil" do
		#	before { @user.password_confirmation = nil }
		#	it { should_not be_valid}
		#end

	#---Match of Password and Username

		#username->password
		describe "return value of authenticate method" do
			before { @user.save }
			let(:found_user) { User.find_by_email(@user.email) }

			describe "with valid password" do
				it { should == found_user.authenticate(@user.password) }
			end

			describe "with invalid password" do
				let(:user_for_invalid_password) { found_user.authenticate("invalid") }

				it { should_not == user_for_invalid_password }

				specify { user_for_invalid_password.should be_false }

			end
		end


#end of discribe User do
end