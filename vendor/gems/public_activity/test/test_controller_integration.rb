require 'test_helper'

class StoringController < ActionView::TestCase::TestController
  include PublicActivity::StoreController
  include ActionController::Testing::ClassMethods
end

describe PublicActivity::StoreController do
  it 'stores controller' do
    controller = StoringController.new
    PublicActivity.set_controller(controller)
    controller.must_be_same_as Thread.current[:public_activity_controller]
    controller.must_be_same_as PublicActivity.get_controller
  end

  it 'stores controller with a filter in controller' do
    controller = StoringController.new
    controller._process_action_callbacks.select {|c| c.kind == :around}.map(&:filter).must_include :store_controller_for_public_activity
    controller.instance_eval do
      store_controller_for_public_activity do
        controller.must_be_same_as PublicActivity.get_controller
      end
    end
  end

  it 'stores controller in a threadsafe way' do
    PublicActivity.set_controller(1)
    PublicActivity.get_controller.must_equal 1

    a = Thread.new {
      PublicActivity.set_controller(2)
      PublicActivity.get_controller.must_equal 2
      PublicActivity.set_controller(nil)
    }

    PublicActivity.get_controller.must_equal 1

    PublicActivity.set_controller(nil)
  end
end
