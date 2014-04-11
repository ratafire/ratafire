class AdminController < ApplicationController
	layout 'application'
	before_filter :admin_user

	def test
	end

	#This is a test for Resque workder: TestWorker
	def test_resque
		Resque.enqueue(TestWorker)
	end
	
private

	def admin_user
      redirect_to(root_url) unless current_user.admin?
    end	
end