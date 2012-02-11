require File.dirname(__FILE__) + '/../test_helper'

class ChallengesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:challenges)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_challenge
    assert_difference('Challenge.count') do
      post :create, :challenge => { }
    end

    assert_redirected_to challenge_path(assigns(:challenge))
  end

  def test_should_show_challenge
    get :show, :id => challenges(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => challenges(:one).id
    assert_response :success
  end

  def test_should_update_challenge
    put :update, :id => challenges(:one).id, :challenge => { }
    assert_redirected_to challenge_path(assigns(:challenge))
  end

  def test_should_destroy_challenge
    assert_difference('Challenge.count', -1) do
      delete :destroy, :id => challenges(:one).id
    end

    assert_redirected_to challenges_path
  end
end
