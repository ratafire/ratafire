atom_feed do |feed|
	feed.title "The Ratafire Blog"
	feed.updated @blogpost.maximum(:updated_at)
	@blogpost.each do |blogpost|
		feed.entry blogpost, published:blogpost.created_at, url: blog_path do |entry|
			entry.title blogpost.title
			entry.content blogpost.content
			entry.author do |author|
				author.name blogpost.user.fullname
			end
		end
	end
end