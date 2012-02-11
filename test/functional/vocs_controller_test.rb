require File.dirname(__FILE__) + '/../test_helper'

class VocsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:vocs)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_voc
    assert_difference('Voc.count') do
      post :create, :voc => { }
    end

    assert_redirected_to voc_path(assigns(:voc))
  end

  def test_should_show_voc
    get :show, :id => vocs(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => vocs(:one).id
    assert_response :success
  end

  def test_should_update_voc
    put :update, :id => vocs(:one).id, :voc => { }
    assert_redirected_to voc_path(assigns(:voc))
  end

  def test_should_destroy_voc
    assert_difference('Voc.count', -1) do
      delete :destroy, :id => vocs(:one).id
    end

    assert_redirected_to vocs_path
  end
end
