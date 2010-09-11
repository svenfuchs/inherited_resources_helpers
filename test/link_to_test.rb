require File.expand_path('../test_helper', __FILE__)

class LinkToTest < Test::Unit::TestCase
  include ActionView::Helpers::UrlHelper
  include InheritedResources::Helpers::LinkTo

  attr_reader :controller, :blog, :post

  def setup
    @blog = Blog.create
    @post = blog.posts.create!
    @controller = setup_controller(Admin::PostsController)
    controller.params = { :action => 'show', :blog_id => blog.id, :id => post.id }
  end

  def t(*)
    'foo'
  end

  test "link_to_index" do
    assert_equal %(<a href="/admin/blogs/#{blog.id}/posts" class="bar">foo</a>), link_to_index(:class => :bar)
  end
end