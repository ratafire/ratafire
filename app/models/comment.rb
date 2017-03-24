class Comment < ActiveRecord::Base

    #----------------Utilities----------------

    #Generate uuid
    before_validation :generate_uuid!, :on => :create

    #Default scope
    default_scope  { order(:created_at => :asc) }

    #--------Friendlyid--------
    extend FriendlyId
    friendly_id :uuid

    #--------Track activities--------
    include PublicActivity::Model
    tracked except: [:update, :destroy], 
            owner: ->(controller, model) { controller && controller.current_user }

    #----------------Relationships----------------
    #Belongs to
    belongs_to :user
    belongs_to :majorpost
    belongs_to :campaign

    #----------------Validations----------------

    #uuid
    validates_uniqueness_of :uuid, case_sensitive: false

private

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(16)
        end while Comment.find_by_uuid(self.uuid).present?
    end

end