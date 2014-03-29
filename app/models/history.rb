class History < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :subscription_history
end
