require File.expand_path('../test_helper', __FILE__)

class AccessorsTest < Test::Unit::TestCase
  attr_reader :controller, :blog, :post

  def setup
    @blog = Blog.create
    @post = blog.posts.create!
    @controller = setup_controller(Admin::PostsController)
    controller.params = { :blog_id => blog.id }
  end

  test "post accessor" do
    controller.params.merge! :action => 'index'
    assert_equal post, controller.post
  end

  test "blog accessor" do
    controller.params.merge! :action => 'index'
    assert_equal blog, controller.blog
  end
end