class Majorpost < ActiveRecord::Base

    #----------------Utilities----------------

    #--------Friendlyid--------
    extend FriendlyId
    friendly_id :perlink, :use => :slugged

    #--------Track activities--------
    include PublicActivity::Model
    tracked except: [:update, :destroy], owner: ->(controller, model) { controller && controller.current_user }

    #----------------Relationships----------------
    #Belongs to
    belongs_to :user
    #Has many
    has_many :comments, dependent: :destroy
    has_many :artwork, dependent: :destroy
    #Has one
    has_one :video, dependent: :destroy
    has_one :audio, dependent: :destroy
    has_one :pdf, dependent: :destroy

    #----------------Validations----------------
    validates :user_id, presence: true, :on => :create
end
