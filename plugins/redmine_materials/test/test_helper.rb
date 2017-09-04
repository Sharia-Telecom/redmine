# Load the Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

def redmine_materials_fixture_files_path
  "#{Rails.root}/plugins/redmine_materials/test/fixtures/files/"
end

module RedmineMaterials
  module TestHelper
    def with_materials_settings(options, &block)
      Setting.plugin_redmine_materials.stubs(:[]).returns(nil)
      options.each { |k, v| Setting.plugin_redmine_materials.stubs(:[]).with(k).returns(v) }
      yield
    ensure
      options.each { |k, v| Setting.plugin_redmine_materials.unstub(:[]) }
    end
  end
end

class RedmineMaterials::TestCase
  include ActionDispatch::TestProcess
    def self.plugin_fixtures(plugin, *fixture_names)
    plugin_fixture_path = "#{Redmine::Plugin.find(plugin).directory}/test/fixtures"
    if fixture_names.first == :all
      fixture_names = Dir["#{plugin_fixture_path}/**/*.{yml}"]
      fixture_names.map! { |f| f[(plugin_fixture_path.size + 1)..-5] }
    else
      fixture_names = fixture_names.flatten.map { |n| n.to_s }
    end

    ActiveRecord::Fixtures.create_fixtures(plugin_fixture_path, fixture_names)
  end
  
  def self.create_fixtures(fixtures_directory, table_names, class_names = {})
    if ActiveRecord::VERSION::MAJOR >= 4
      ActiveRecord::FixtureSet.create_fixtures(fixtures_directory, table_names, class_names = {})
    else
      ActiveRecord::Fixtures.create_fixtures(fixtures_directory, table_names, class_names = {})
    end
  end
  
  def self.prepare
    # User 2 Manager (role 1) in project 1
    # User 3 Developer (role 2) in project 1

    Role.where(:id => [1, 2, 3, 4]).each do |r|
      r.permissions << :show_materials
      r.save
    end

    Role.where(:id => [1, 2]).each do |r|
      #user_2, user_3
      r.permissions << :new_materials
      r.save
    end

    Role.where(:id => 1).each do |r|
      #user_2
      r.permissions << :new_material_cycles
      r.save
    end

    Role.where(:id => [1, 2]).each do |r|
      r.permissions << :edit_materials
      r.save
    end
    Role.where(:id => [1, 2, 3]).each do |r|
      r.permissions << :show_material_cycles
      r.save
    end

    Role.where(:id => 2).each do |r|
      r.permissions << :edit_material_cycles
      r.save
    end

    Project.where(:id => [1, 2, 3, 4, 5]).each do |project|
      EnabledModule.create(:project => project, :name => 'materials')
    end
  end
end
