class AbandonLog < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :projects

  default_scope order: 'abandon_logs.created_at DESC'
end
