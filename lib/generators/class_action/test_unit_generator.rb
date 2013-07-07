require 'rails/generators/resource_helpers'

module ClassAction
  module Generators
    class TestUnitGenerator < Rails::Generators::NamedBase
      class_option :all,      type: :boolean, default: false,
        desc: 'Generates test scaffolding for all actions'
      class_option :index,    type: :boolean, default: false,
        desc: 'Generates test scaffolding for #index'
      class_option :show,     type: :boolean, default: false,
        desc: 'Generates test scaffolding for #show'
      class_option :new,      type: :boolean, default: false,
        desc: 'Generates test scaffolding for #new'
      class_option :create,   type: :boolean, default: false,
        desc: 'Generates test scaffolding for #create'
      class_option :edit,     type: :boolean, default: false,
        desc: 'Generates test scaffolding for #edit'
      class_option :update,   type: :boolean, default: false,
        desc: 'Generates test scaffolding for #update'
      class_option :delete,   type: :boolean, default: false,
        desc: 'Generates test scaffolding for #delete'
      class_option :destroy,  type: :boolean, default: false,
        desc: 'Generates test scaffolding for #destroy'

      source_root File.join(File.dirname(__FILE__), 'templates')
      include Rails::Generators::ResourceHelpers

      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      def create_test_files
        template 'functional_test.rb', File.join('test/functional', controller_class_path, "#{controller_file_name}_controller_test.rb")
      end

      private

      def attributes_hash
        return if accessible_attributes.empty?

        accessible_attributes.map do |a|
          "#{a.name}: @#{singular_table_name}.#{a.name}"
        end.sort.join(', ')
      end

      def accessible_attributes
        attributes.reject(&:reference?)
      end
    end
  end
end
