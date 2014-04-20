#Base Title and Full Title
def full_title(page_title)
	base_title = "Ratafire"
	if page_title.empty?
		base_title
	else
		"#{base_title} - #{page_title}"
	end
end

def sign_in(user)
	visit signin_path
	fill_in "Email", with: user.email
	fill_in "Password", with: user.password
	click_button "Sign in"
	# Sign in when not using Capabara as well.
	cookies[:remember_token] = user.remember_token
end 