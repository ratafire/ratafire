class Majorpost < ActiveRecord::Base
    #----------------Utilities----------------

    before_validation :generate_uuid!, :on => :create

    #--------Friendlyid--------
    extend FriendlyId
    friendly_id :uuid

    #---------ActsasTaggable--------
    acts_as_taggable

    #--------Track activities--------
    include PublicActivity::Model
    tracked except: [:update, :destroy], 
            owner: ->(controller, model) { controller && controller.current_user }

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
    validates :content, :presence => true

private

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(6)
        end while Majorpost.find_by_uuid(self.uuid).present?
    end
end
