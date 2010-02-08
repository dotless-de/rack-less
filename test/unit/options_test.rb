require "#{File.dirname(__FILE__)}/../test_helper"
require 'rack/less/options'
require 'fixtures/mock_options'

class OptionsTest < Test::Unit::TestCase
  context 'Rack::Less::Options' do
    setup { @options = MockOptions.new }
    
    should "use a namespace" do
      assert_equal 'rack-less', Rack::Less::Options::RACK_ENV_NS
    end
    
    should "provide an option_name helper" do
      assert_respond_to MockOptions, :option_name
    end

    should "provide defaults" do
      assert_respond_to MockOptions, :defaults
    end
    
    { :source_root => 'app/stylesheets',
      :hosted_at => '/stylesheets',
      :cache => false,
      :compress => false,
      :concat => {}
    }.each do |k,v|
      should "default #{k} correctly" do
        assert_equal v, @options.options[MockOptions.option_name(k)]
      end
    end

    context '#set' do
      should "set a Symbol option as #{Rack::Less::Options::RACK_ENV_NS}.symbol" do
        @options.set :foo, 'bar'
        assert_equal 'bar', @options.options[MockOptions.option_name(:foo)]
      end
      should 'set a String option as string' do
        @options.set 'foo.bar', 'baz'
        assert_equal 'baz', @options.options['foo.bar']
      end
      should 'set all key/value pairs when given a Hash' do
        @options.set :foo => 'bar', 'foo.bar' => 'baz'
        assert_equal 'bar', @options.options[MockOptions.option_name(:foo)]
        assert_equal 'baz', @options.options['foo.bar']
      end
    end

    should 'allow setting multiple options via assignment' do
      @options.options = { :foo => 'bar', 'foo.bar' => 'baz' }
      assert_equal 'bar', @options.options[MockOptions.option_name(:foo)]
      assert_equal 'baz', @options.options['foo.bar']
    end

    should "allow storing the value as a block" do
      block = Proc.new { "bar block" }
      @options.set(:foo, &block)
      assert_equal block, @options.options[MockOptions.option_name(:foo)]
    end

  end
end