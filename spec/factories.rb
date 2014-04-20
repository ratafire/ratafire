FactoryGirl.define do 

	factory :user do
		username "brucewayne"
		email "bruce.wayne@wayneenterprise.com"
		fullname "Bruce Wayne"
		password "skynet"
		#password_confirmation "skynet"
		tagline "Batman"
	end
end