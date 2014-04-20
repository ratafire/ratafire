require 'spec_helper'

describe "User Pages" do

	subject { page }

	#---Signup Page---
	describe "signup page" do
		before { visit signup_path }

		let(:submit) { "SIGN UP" }

		#Check validity before creating a user
		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end
		end

		#After checked validity, create a user
		describe "with valid information" do
			before do
				fill_in "fullname", with: "Bruce Wayne"
				fill_in "Email", with: "bruce.wayne@wayneenterprise.com"
				fill_in "Password", with: "skynet"
				fill_in "username", with: "brucewayne"
			end

			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end
		end

		#Page Title
		it { should have_selector('title', text: full_title('Sign up'))}
	end

	#---Profile Page---
	describe "profile page" do

		# Code to make a user variable
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }

	end

	#---Edit Page---
	describe "edit" do
		let(:user) { FactoryGirl.create(:user)}
		before { visit edit_user_path(user) }

		before do
			sign_in user
			visit edit_user_path(user)
		end

		describe "with invalid information" do
			before { click_button "Save Changes" }

			it { should have_content('error') }
		end
	end

end


