class Studio::TraitsController < ApplicationController

	layout 'studio'

	#Before filters
	before_filter :load_user
	before_filter :load_trait, only:[:create, :destroy]

	#REST Methods -----------------------------------

	#create_user_studio_traits POST
	#/users/:user_id/studio/traits/create/:trait_id
	def create
		if @user.traits.try(:last).try(:id) == @trait.id || @user.traits.try(:second).try(:id) == @trait.id || @user.traits.try(:first).try(:id) == @trait.id
			@deleted_tarit_id = @trait.id 
			if @trait_relationship = TraitRelationship.find_by_trait_id_and_user_id(@trait.id,@user.id)
				unless @trait_relationship.destroy
					@deleted_tarit_id = nil
				end
			end
		else
			if @user.traits.count < 3
				@trait_relationship = TraitRelationship.create(
					user_id:@user.id,
					trait_id:@trait.id
					)
			end
		end
	end

	#user_studio_traits GET
	#/users/:user_id/studio/traits
	def show
	end

	#destroy_user_studio_traits DELETE
	#/users/:user_id/studio/traits/destroy/:trait_id
	def destroy
		@deleted_tarit_id = @trait.id 
		if @trait_relationship = TraitRelationship.find_by_trait_id_and_user_id(@trait.id,@user.id)
			unless @trait_relationship.destroy
				@deleted_tarit_id = nil
			end
		end
	end

	#NoREST Methods -----------------------------------

protected

	def load_user
		#Load user by username due to FriendlyID
		unless @user = User.find_by_uid(params[:user_id])
			unless @user = User.find_by_username(params[:user_id])
				@user = User.find(params[:user_id])
			end
		end
	end	

	def load_trait
		@trait = Trait.find(params[:trait_id])
	end

end