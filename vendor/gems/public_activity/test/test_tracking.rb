require 'test_helper'

describe PublicActivity::Tracked do
  describe ".activity" do
    it "must raise depraction exception" do
      ->{article.new.activity}.must_raise PublicActivity::DeprecatedError
    end
  end

  it 'can be tracked and be an activist at the same time' do
    case PublicActivity.config.orm
      when :mongoid
        class ActivistAndTrackedArticle
          include Mongoid::Document
          include Mongoid::Timestamps
          include PublicActivity::Model

          belongs_to :user

          field :name, type: String
          field :published, type: Boolean
          tracked
          activist
        end
      when :mongo_mapper
        class ActivistAndTrackedArticle
          include MongoMapper::Document
          include PublicActivity::Model

          belongs_to :user

          key :name, String
          key :published, Boolean
          tracked
          activist
          timestamps!
        end
      when :active_record
        class ActivistAndTrackedArticle < ActiveRecord::Base
          self.table_name = 'articles'
          include PublicActivity::Model
          tracked
          activist

          if ::ActiveRecord::VERSION::MAJOR < 4
            attr_accessible :name, :published, :user
          end
          belongs_to :user
        end
    end

    art = ActivistAndTrackedArticle.new
    art.save
    art.activities.last.trackable_id.must_equal art.id
    art.activities.last.owner_id.must_equal nil
  end

  describe 'custom fields' do
    describe 'global' do
      it 'should resolve symbols' do
        a = article(nonstandard: :name).new(name: 'Symbol resolved')
        a.save
        a.activities.last.nonstandard.must_equal 'Symbol resolved'
      end

      it 'should resolve procs' do
        a = article(nonstandard: proc {|_, model| model.name}).new(name: 'Proc resolved')
        a.save
        a.activities.last.nonstandard.must_equal 'Proc resolved'
      end
    end
  end

  it 'should not accept global key option' do
    # this example tests the lack of presence of sth that should not be here
    a = article(key: 'asd').new
    a.save
    ->{a.create_activity}.must_raise PublicActivity::NoKeyProvided
    a.activities.count.must_equal 1
  end

  it 'should not change global custom fields' do
    a = article(nonstandard: 'global').new
    a.save
    a.create_activity key: 'asd', nonstandard: 'instance'
    a.class.activity_custom_fields_global.must_equal nonstandard: 'global'
  end

  describe 'disabling functionality' do
    it 'allows for global disable' do
      PublicActivity.enabled = false
      activity_count_before = PublicActivity::Activity.count

      @article = article().new
      @article.save
      PublicActivity::Activity.count.must_equal activity_count_before

      PublicActivity.enabled = true
    end

    it 'allows for class-wide disable' do
      activity_count_before = PublicActivity::Activity.count

      klass = article
      klass.public_activity_off
      @article = klass.new
      @article.save
      PublicActivity::Activity.count.must_equal activity_count_before

      klass.public_activity_on
      @article.save
      PublicActivity::Activity.count.must_be :>, activity_count_before
    end
  end

  describe '#tracked' do
    subject { article(options) }
    let(:options) { {} }

    it 'allows skipping the tracking on CRUD actions' do
      case PublicActivity.config.orm
        when :mongoid
          art = Class.new do
            include Mongoid::Document
            include Mongoid::Timestamps
            include PublicActivity::Model

            belongs_to :user

            field :name, type: String
            field :published, type: Boolean
            tracked :skip_defaults => true
          end
        when :mongo_mapper
          art = Class.new do
            include MongoMapper::Document
            include PublicActivity::Model

            belongs_to :user

            key :name, String
            key :published, Boolean
            tracked :skip_defaults => true

            timestamps!
          end
        when :active_record
          art = article(:skip_defaults => true)
      end

      art.must_include PublicActivity::Common
      art.wont_include PublicActivity::Creation
      art.wont_include PublicActivity::Update
      art.wont_include PublicActivity::Destruction
    end

    describe 'default options' do
      subject { article }

      specify { subject.must_include PublicActivity::Creation }
      specify { subject.must_include PublicActivity::Destruction }
      specify { subject.must_include PublicActivity::Update }

      # warning: these are not as exhaustive as they used to be
      specify { subject._create_callbacks.select { |c| c.kind.eql?(:after) }.wont_be_empty }
      specify { subject._update_callbacks.select { |c| c.kind.eql?(:after) }.wont_be_empty }
      specify { subject._destroy_callbacks.select { |c| c.kind.eql?(:before) }.wont_be_empty }
    end

    it 'accepts :except option' do
      case PublicActivity.config.orm
        when :mongoid
          art = Class.new do
            include Mongoid::Document
            include Mongoid::Timestamps
            include PublicActivity::Model

            belongs_to :user

            field :name, type: String
            field :published, type: Boolean
            tracked :except => [:create]
          end
        when :mongo_mapper
          art = Class.new do
            include MongoMapper::Document
            include PublicActivity::Model

            belongs_to :user

            key :name, String
            key :published, Boolean
            tracked :except => [:create]

            timestamps!
          end
        when :active_record
          art = article(:except => [:create])
      end

      art.wont_include PublicActivity::Creation
      art.must_include PublicActivity::Update
      art.must_include PublicActivity::Destruction
    end

    it 'accepts :only option' do
      case PublicActivity.config.orm
        when :mongoid
          art = Class.new do
            include Mongoid::Document
            include Mongoid::Timestamps
            include PublicActivity::Model

            belongs_to :user

            field :name, type: String
            field :published, type: Boolean

            tracked :only => [:create, :update]
          end
        when :mongo_mapper
          art = Class.new do
            include MongoMapper::Document
            include PublicActivity::Model

            belongs_to :user

            key :name, String
            key :published, Boolean

            tracked :only => [:create, :update]
          end
        when :active_record
          art = article({:only => [:create, :update]})
      end

      art.must_include PublicActivity::Creation
      art.wont_include PublicActivity::Destruction
      art.must_include PublicActivity::Update
    end

    it 'accepts :owner option' do
      owner = mock('owner')
      subject.tracked(:owner => owner)
      subject.activity_owner_global.must_equal owner
    end

    it 'accepts :parameters option' do
      params = {:a => 1}
      subject.tracked(:parameters => params)
      subject.activity_parameters_global.must_equal params
    end

    it 'accepts :on option' do
      on = {:a => lambda{}, :b => proc {}}
      subject.tracked(:on => on)
      subject.activity_hooks.must_equal on
    end

    it 'accepts :on option with string keys' do
      on = {'a' => lambda {}}
      subject.tracked(:on => on)
      subject.activity_hooks.must_equal on.symbolize_keys
    end

    it 'accepts :on values that are procs' do
      on = {:unpassable => 1, :proper => lambda {}, :proper_proc => proc {}}
      subject.tracked(:on => on)
      subject.activity_hooks.must_include :proper
      subject.activity_hooks.must_include :proper_proc
      subject.activity_hooks.wont_include :unpassable
    end

    describe 'global options' do
      subject { article(recipient: :test, owner: :test2, parameters: {a: 'b'}) }

      specify { subject.activity_recipient_global.must_equal :test }
      specify { subject.activity_owner_global.must_equal :test2    }
      specify { subject.activity_parameters_global.must_equal(a: 'b')  }
    end
  end

  describe 'activity hooks' do
    subject { s = article; s.activity_hooks = {:test => hook}; s }
    let(:hook) { lambda {} }

    it 'retrieves hooks' do
      assert_same hook, subject.get_hook(:test)
    end

    it 'retrieves hooks by string keys' do
      assert_same hook, subject.get_hook('test')
    end

    it 'returns nil when no matching hook is present' do
      nil.must_be_same_as subject.get_hook(:nonexistent)
    end

    it 'allows hooks to decide if activity should be created' do
      subject.tracked
      @article = subject.new(:name => 'Some Name')
      PublicActivity.set_controller(mock('controller'))
      pf = proc { |model, controller|
        controller.must_be_same_as PublicActivity.get_controller
        model.name.must_equal 'Some Name'
        false
      }
      pt = proc { |model, controller|
        controller.must_be_same_as PublicActivity.get_controller
        model.name.must_equal 'Other Name'
        true # this will save the activity with *.update key
      }
      @article.class.activity_hooks = {:create => pf, :update => pt, :destroy => pt}

      @article.activities.to_a.must_be_empty
      @article.save # create
      @article.name = 'Other Name'
      @article.save # update
      @article.destroy # destroy

      @article.activities.count.must_equal 2
      @article.activities.first.key.must_equal 'article.update'
    end
  end
end
