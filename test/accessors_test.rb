require File.expand_path('../test_helper', __FILE__)

class AccessorsTest < Test::Unit::TestCase
  attr_reader :blog, :post, :comment

  def setup
    @blog = Blog.create!
    blog.posts.create!
    @post = blog.posts.create!
    @comment = post.comments.create!
  end

  test "blog accessor on blog#index" do
    controller = setup_controller(Admin::BlogsController)
    controller.params = { :action => 'index' }
    assert_equal Blog.new.inspect, controller.blog.inspect
  end

  test "blog accessor on blog#show" do
    controller = setup_controller(Admin::BlogsController)
    controller.params = { :action => 'show', :id => blog.id }
    assert_equal blog.inspect, controller.blog.inspect
  end

  test "blog accessor on post#index" do
    controller = setup_controller(Admin::PostsController)
    controller.params = { :action => 'show', :blog_id => blog.id }
    assert_equal blog.inspect, controller.blog.inspect
  end

  test "post accessor on post#index" do
    controller = setup_controller(Admin::PostsController)
    controller.params = { :action => 'index', :blog_id => blog.id }
    assert_equal blog.posts.build.inspect, controller.post.inspect
  end

  test "blog accessor on post#show" do
    controller = setup_controller(Admin::PostsController)
    controller.params = { :action => 'show', :blog_id => blog.id, :id => post.id }
    assert_equal blog.inspect, controller.blog.inspect
  end

  test "post accessor on post#show" do
    controller = setup_controller(Admin::PostsController)
    controller.params = { :action => 'show', :blog_id => blog.id, :id => post.id }
    assert_equal post.inspect, controller.post.inspect
  end

  test "post accessor on comments#show" do
    controller = setup_controller(Admin::CommentsController)
    controller.params = { :action => 'show', :blog_id => blog.id, :post_id => post.id, :id => comment.id }
    assert_equal post.inspect, controller.post.inspect
  end
end