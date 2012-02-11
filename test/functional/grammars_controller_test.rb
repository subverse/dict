require File.dirname(__FILE__) + '/../test_helper'

class GrammarsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:grammars)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_grammar
    assert_difference('Grammar.count') do
      post :create, :grammar => { }
    end

    assert_redirected_to grammar_path(assigns(:grammar))
  end

  def test_should_show_grammar
    get :show, :id => grammars(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => grammars(:one).id
    assert_response :success
  end

  def test_should_update_grammar
    put :update, :id => grammars(:one).id, :grammar => { }
    assert_redirected_to grammar_path(assigns(:grammar))
  end

  def test_should_destroy_grammar
    assert_difference('Grammar.count', -1) do
      delete :destroy, :id => grammars(:one).id
    end

    assert_redirected_to grammars_path
  end
end
