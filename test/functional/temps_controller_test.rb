require File.dirname(__FILE__) + '/../test_helper'

class TempsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:temps)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_temp
    assert_difference('Temp.count') do
      post :create, :temp => { }
    end

    assert_redirected_to temp_path(assigns(:temp))
  end

  def test_should_show_temp
    get :show, :id => temps(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => temps(:one).id
    assert_response :success
  end

  def test_should_update_temp
    put :update, :id => temps(:one).id, :temp => { }
    assert_redirected_to temp_path(assigns(:temp))
  end

  def test_should_destroy_temp
    assert_difference('Temp.count', -1) do
      delete :destroy, :id => temps(:one).id
    end

    assert_redirected_to temps_path
  end
end
