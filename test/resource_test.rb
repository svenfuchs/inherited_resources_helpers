require File.expand_path('../test_helper', __FILE__)

class ResourceTest < Test::Unit::TestCase
  attr_reader :controller, :blog, :post

  def setup
    @blog = Blog.create
    @post = blog.posts.create!
    @controller = setup_controller(Admin::PostsController)
    controller.params = { :blog_id => blog.id }
  end

  test "resource on posts#index returs a new Post" do
    controller.params.merge! :action => 'index'
    assert_new_record(Post, controller.resource)
  end

  test "resource on posts#new returs a new Post" do
    controller.params.merge! :action => 'new'
    assert_new_record(Post, controller.resource)
  end

  test "resource on posts#create returs a post" do
    controller.params.merge! :action => 'create'
    assert_new_record(Post, controller.resource)
  end

  test "resource on posts#show returs a post" do
    controller.params.merge! :action => 'show', :id => post.id
    assert_equal post, controller.resource
  end

  test "resource on posts#edit returs a post" do
    controller.params.merge! :action => 'edit', :id => post.id
    assert_equal post, controller.resource
  end

  test "resource on posts#update returs a post" do
    controller.params.merge! :action => 'update', :id => post.id
    assert_equal post, controller.resource
  end

  test "resource on posts#destroy returs a post" do
    controller.params.merge! :action => 'destroy', :id => post.id
    assert_equal post, controller.resource
  end
end