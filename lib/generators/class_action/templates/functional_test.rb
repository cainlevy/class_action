require 'test_helper'

module <%= controller_class_name %>Controller<% if options[:all] || options[:index] %>
  class IndexTest < ActionController::TestCase
    setup do
      @<%= singular_table_name %> = <%= table_name %>(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil @controller.<%= table_name %>
    end
  end<% end %><% if options[:all] || options[:new] %>

  class NewTest < ActionController::TestCase
    test "should get new" do
      get :new
      assert_response :success
    end
  end<% end %><% if options[:all] || options[:create] %>

  class CreateTest < ActionController::TestCase
    test "should create <%= singular_table_name %>" do
      assert_difference('<%= class_name %>.count') do
        post :create, <%= singular_table_name %>: { <%= attributes_hash %> }
      end

      assert_redirected_to <%= singular_table_name %>_path(@controller.<%= singular_table_name %>)
    end
  end<% end %><% if options[:all] || options[:show] %>

  class ShowTest < ActionController::TestCase
    setup do
      @<%= singular_table_name %> = <%= table_name %>(:one)
    end

    test "should show <%= singular_table_name %>" do
      get :show, id: @<%= singular_table_name %>.to_param
      assert_response :success
    end
  end<% end %><% if options[:all] || options[:edit] %>

  class EditTest < ActionController::TestCase
    setup do
      @<%= singular_table_name %> = <%= table_name %>(:one)
    end

    test "should get edit" do
      get :edit, id: @<%= singular_table_name %>.to_param
      assert_response :success
    end
  end<% end %><% if options[:all] || options[:update] %>

  class UpdateTest < ActionController::TestCase
    setup do
      @<%= singular_table_name %> = <%= table_name %>(:one)
    end

    test "should update <%= singular_table_name %>" do
      put :update, id: @<%= singular_table_name %>.to_param, <%= singular_table_name %>: { <%= attributes_hash %> }
      assert_redirected_to <%= singular_table_name %>_path(@controller.<%= singular_table_name %>)
    end
  end<% end %><% if options[:all] || options[:destroy] %>

  class DestroyTest < ActionController::TestCase
    setup do
      @<%= singular_table_name %> = <%= table_name %>(:one)
    end

    test "should destroy <%= singular_table_name %>" do
      assert_difference('<%= class_name %>.count', -1) do
        delete :destroy, id: @<%= singular_table_name %>.to_param
      end

      assert_redirected_to <%= index_helper %>_path
    end
  end<% end %>
end
