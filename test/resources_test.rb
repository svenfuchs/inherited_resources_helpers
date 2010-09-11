require File.expand_path('../test_helper', __FILE__)

class ResourcesTest < Test::Unit::TestCase
  attr_reader :controller, :blog, :post

  def setup
    @blog = Blog.create
    @post = blog.posts.create!
    @controller = setup_controller(Admin::PostsController)
    controller.params = { :blog_id => blog.id }
  end

  test "resources contains the route_prefix" do
    controller.params.merge! :action => 'index'
    assert_equal :admin, controller.resources.first
  end

  test "resources on posts#index returs an array containing a new Post" do
    controller.params.merge! :action => 'index'
    assert_new_record(Post, controller.resources.last)
  end

  test "resources on posts#new returs an array containing a new Post" do
    controller.params.merge! :action => 'new'
    assert_new_record(Post, controller.resources.last)
  end

  test "resources on posts#create returs an array containing a post" do
    controller.params.merge! :action => 'create'
    assert_new_record(Post, controller.resources.last)
  end

  test "resources on posts#show returs an array containing a post" do
    controller.params.merge! :action => 'show', :id => post.id
    assert_equal post, controller.resources.last
  end

  test "resources on posts#edit returs an array containing a post" do
    controller.params.merge! :action => 'edit', :id => post.id
    assert_equal post, controller.resources.last
  end

  test "resources on posts#update returs an array containing a post" do
    controller.params.merge! :action => 'update', :id => post.id
    assert_equal post, controller.resources.last
  end

  test "resources on posts#destroy returs an array containing a post" do
    controller.params.merge! :action => 'destroy', :id => post.id
    assert_equal post, controller.resources.last
  end
end