class Majorpost < ActiveRecord::Base
    #----------------Utilities----------------

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
    has_many :artwork, foreign_key: "majorpost_uuid", primary_key: 'uuid', class_name:"Artwork", dependent: :destroy
    #Has one
    has_one :link, foreign_key: "majorpost_uuid", primary_key: 'uuid', class_name:"Link",dependent: :destroy
    has_one :video, foreign_key: "majorpost_uuid", primary_key: 'uuid', class_name:"Video",dependent: :destroy
    has_one :video_image, foreign_key:"majorpost_uuid", primary_key:"uuid", class_name:"VideoImage", dependent: :destroy
    has_one :audio, foreign_key: "majorpost_uuid", primary_key: 'uuid', class_name:"Audio",dependent: :destroy
    has_one :audio_image, foreign_key:"majorpost_uuid", primary_key:"uuid", class_name:"AudioImage", dependent: :destroy
    has_one :pdf, dependent: :destroy

    #----------------Validations----------------

    #uuid
    validates_uniqueness_of :uuid, case_sensitive: false

end
