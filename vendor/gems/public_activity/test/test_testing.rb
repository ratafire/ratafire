require 'test_helper'
describe PublicActivity do

  describe "self.with_tracking" do
    it "enables tracking inside the block" do
      PublicActivity.enabled = false

      PublicActivity.with_tracking do
        PublicActivity.enabled?.must_equal true
      end
    end

    it "restores previous `enabled` state" do
      PublicActivity.enabled = false
      PublicActivity.with_tracking do
        # something
      end
      PublicActivity.enabled?.must_equal false
    end
  end

  describe "self.without_tracking" do
    it "disables tracking inside the block" do
      PublicActivity.enabled = true

      PublicActivity.without_tracking do
        PublicActivity.enabled?.must_equal false
      end
    end
  end
end