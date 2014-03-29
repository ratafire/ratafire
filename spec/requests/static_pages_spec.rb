require 'spec_helper'

describe "Static pages" do

	subject { page }

#---Home Page---

	describe "Home page" do

		before { visit root_path }
		#Page Title
		it {should have_selector('title', text: full_title('')) }

	#end of "Home page" do	
	end


#---Help Page---

	describe "Help page" do
		before { visit help_path }

		#Page Title
		it {should have_selector('title', text: full_title('Help')) }

	#end of "Help page" do
	end


#---About Page---

	describe "About page" do
		before { visit about_path }

		#Page Title
		it {should have_selector('title', text: full_title('About')) }

	#end of "About page" do
	end

#---Contact Page---

	describe "Contact page" do
		before { visit contact_path }

		#Page Title
		it {should have_selector('title', text: full_title('Contact')) }

	end

#end of describe "Static pages" do
end