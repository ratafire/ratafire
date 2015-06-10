class MasspayError < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :masspay_batches
end
