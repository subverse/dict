require File.dirname(__FILE__) + '/../test_helper'

class QuestsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:quests)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_quest
    assert_difference('Quest.count') do
      post :create, :quest => { }
    end

    assert_redirected_to quest_path(assigns(:quest))
  end

  def test_should_show_quest
    get :show, :id => quests(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => quests(:one).id
    assert_response :success
  end

  def test_should_update_quest
    put :update, :id => quests(:one).id, :quest => { }
    assert_redirected_to quest_path(assigns(:quest))
  end

  def test_should_destroy_quest
    assert_difference('Quest.count', -1) do
      delete :destroy, :id => quests(:one).id
    end

    assert_redirected_to quests_path
  end
end
