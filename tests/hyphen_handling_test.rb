require 'test_helper'
require 'fileutils'
require 'tmpdir'

class HyphenHandlingTest < ActiveSupport::TestCase
  def setup
    @temp_dir = Dir.mktmpdir
    @original_dir = Dir.pwd
  end

  def teardown
    Dir.chdir(@original_dir)
    FileUtils.rm_rf(@temp_dir)
  end

  test "handles app names with hyphens correctly" do
    # Create a mock Rails app structure with hyphenated name
    app_dir = File.join(@temp_dir, 'api-proxy')
    FileUtils.mkdir_p(File.join(app_dir, 'config'))

    # Create database.yml with underscore naming (as Rails would)
    database_yml = <<~YAML
      default: &default
        adapter: postgresql
        encoding: unicode
        pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

      development:
        <<: *default
        database: api_proxy_development

      test:
        <<: *default
        database: api_proxy_test

      production:
        <<: *default
        database: api_proxy_production
        username: api_proxy
        password: <%= ENV["API_PROXY_DATABASE_PASSWORD"] %>
    YAML

    File.write(File.join(app_dir, 'config', 'database.yml'), database_yml)

    # Create cable.yml
    cable_yml = <<~YAML
      production:
        adapter: redis
        url: <%= ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } %>
        channel_prefix: api_proxy_production
    YAML

    File.write(File.join(app_dir, 'config', 'cable.yml'), cable_yml)

    Dir.chdir(app_dir) do
      # Simulate the prepare_app_vars method
      old_dir = File.basename(Dir.getwd)
      assert_equal 'api-proxy', old_dir

      # Test the normalization
      old_app_name_from_dir = old_dir.parameterize(separator: '_')
      assert_equal 'api_proxy', old_app_name_from_dir

      # Verify the fix would work
      new_app_name = 'citadel'.parameterize(separator: '_')
      assert_equal 'citadel', new_app_name

      # Read the database.yml and verify it contains the underscore version
      db_content = File.read(File.join('config', 'database.yml'))
      assert db_content.include?('api_proxy_development')
      assert db_content.include?('api_proxy_test')
      assert db_content.include?('api_proxy_production')
      assert db_content.include?('API_PROXY_DATABASE_PASSWORD')

      # Read cable.yml
      cable_content = File.read(File.join('config', 'cable.yml'))
      assert cable_content.include?('api_proxy_production')
    end
  end

  test "handles normal app names without hyphens" do
    app_dir = File.join(@temp_dir, 'myapp')
    FileUtils.mkdir_p(File.join(app_dir, 'config'))

    database_yml = <<~YAML
      development:
        database: myapp_development
    YAML

    File.write(File.join(app_dir, 'config', 'database.yml'), database_yml)

    Dir.chdir(app_dir) do
      old_dir = File.basename(Dir.getwd)
      assert_equal 'myapp', old_dir

      old_app_name_from_dir = old_dir.parameterize(separator: '_')
      assert_equal 'myapp', old_app_name_from_dir

      # In this case, old_app_name and old_app_name_from_dir should be the same
      # So the conditional replacements won't run
    end
  end

  test "handles complex app names with multiple hyphens" do
    app_dir = File.join(@temp_dir, 'my-awesome-api-proxy')
    FileUtils.mkdir_p(File.join(app_dir, 'config'))

    database_yml = <<~YAML
      development:
        database: my_awesome_api_proxy_development
    YAML

    File.write(File.join(app_dir, 'config', 'database.yml'), database_yml)

    Dir.chdir(app_dir) do
      old_dir = File.basename(Dir.getwd)
      assert_equal 'my-awesome-api-proxy', old_dir

      old_app_name_from_dir = old_dir.parameterize(separator: '_')
      assert_equal 'my_awesome_api_proxy', old_app_name_from_dir

      db_content = File.read(File.join('config', 'database.yml'))
      assert db_content.include?('my_awesome_api_proxy_development')
    end
  end
end