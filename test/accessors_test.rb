require File.expand_path('../test_helper', __FILE__)

class AccessorsTest < Test::Unit::TestCase
  attr_reader :controller, :blog, :post

  def setup
    @blog = Blog.create
    @post = blog.posts.create!
  end

  test "blog accessor on blog#index" do
    controller = setup_controller(Admin::BlogsController)
    controller.params = { :id => blog.id }
    controller.params.merge! :action => 'index'
    assert_equal blog, controller.blog
  end

  test "post accessor on post#index" do
    controller = setup_controller(Admin::PostsController)
    controller.params = { :blog_id => blog.id }
    controller.params.merge! :action => 'index'
    assert_equal post, controller.post
  end

  test "blog accessor on post#index" do
    controller = setup_controller(Admin::PostsController)
    controller.params = { :blog_id => blog.id }
    controller.params.merge! :action => 'index'
    assert_equal blog, controller.blog
  end
end