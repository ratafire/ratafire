class Majorpost < ActiveRecord::Base
    #----------------Utilities----------------

    #--------Friendlyid--------
    extend FriendlyId
    friendly_id :perlink, :use => :slugged

    #---------ActsasTaggable--------
    acts_as_taggable

    #--------Track activities--------
    include PublicActivity::Model
    tracked except: [:update, :destroy], owner: ->(controller, model) { controller && controller.current_user }

    #----------------Relationships----------------
    #Belongs to
    belongs_to :user
    has_many :postimage
    #Has many
    has_many :comments, dependent: :destroy
    has_many :artwork, dependent: :destroy
    #Has one
    has_one :video, dependent: :destroy
    has_one :audio, dependent: :destroy
    has_one :pdf, dependent: :destroy

    #----------------Validations----------------
    validates :user_id, presence: true, :on => :create

    #Turn all majorpost into activity
    def majorpost_add_activity
        Majorpost.all.each do |m|
            activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(m.id,'Majorpost')
            if activity == nil then
                updateactivity = PublicActivity::Activity.new
                if updateactivity != nil then
                    updateactivity.trackable_id = m.id
                    updateactivity.trackable_type = "Majorpost"
                    updateactivity.key = "majorpost.create"
                    updateactivity.created_at = m.created_at
                    updateactivity.commented_at = m.commented_at
                    updateactivity.owner_type = "User"
                    updateactivity.test = m.test
                    updateactivity.owner_id = m.user_id
                    updateactivity.save
                end                
            end
        end
    end

    def clean_up_not_useful_activity
        Majorpost.all.each do |m|
            if m.deleted == true  then
                activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(m.id,'Majorpost')
                if activity != nil then
                    activity.deleted = true
                    activity.deleted_at = m.deleted_at
                    activity.save
                end
            end
            if m.published == false then
                activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(m.id,'Majorpost')
                if activity != nil then
                    activity.deleted = true
                    activity.deleted_at = m.deleted_at
                    activity.save
                end
            end
        end
    end
end
