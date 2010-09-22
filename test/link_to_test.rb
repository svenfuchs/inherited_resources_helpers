require File.expand_path('../test_helper', __FILE__)

class LinkToTest < Test::Unit::TestCase
  include ActionView::Helpers::UrlHelper
  include InheritedResources::Helpers::LinkTo

  attr_reader :controller, :blog, :post

  delegate :t, :to => :I18n

  def setup
    @blog = Blog.create
    @post = blog.posts.create!
    @controller = setup_controller(Admin::BlogsController)
    controller.params = { :action => 'show', :id => blog.id }
    I18n.backend.store_translations(:en,
      :index   => 'index',
      :destroy => 'delete',
      :listing => 'Listing',
      :confirm_delete => 'Kill da %{model_name}?'
    )
  end

  test "link_to_index(:class => :bar)" do
    expected = %(<a href="/admin/blogs" class="index bar">index</a>)
    assert_equal expected, link_to_index(:class => :bar)
  end

  test "link_to_index('listing', :class => :bar)" do
    expected = %(<a href="/admin/blogs" class="index bar">listing</a>)
    assert_equal expected, link_to_index('listing', :class => :bar)
  end

  test "link_to_index(:listing, :class => :bar)" do
    expected = %(<a href="/admin/blogs" class="index bar">Listing</a>)
    assert_equal expected, link_to_index(:listing, :class => :bar)
  end

  test "link_to_index(:listing, 'url/to/foo', :class => :bar)" do
    expected = %(<a href="url/to/foo" class="index bar">Listing</a>)
    assert_equal expected, link_to_index(:listing, 'url/to/foo', :class => :bar)
  end

  test "link_to_index(:listing, :posts, :class => :bar)" do
    expected = %(<a href="/admin/blogs/#{blog.id}/posts" class="index bar">Listing</a>)
    assert_equal expected, link_to_index(:listing, :posts, :class => :bar)
  end

  test "link_to_index(:listing, [:admin, blog, :posts], :class => :bar)" do
    expected = %(<a href="/admin/blogs/#{blog.id}/posts" class="index bar">Listing</a>)
    assert_equal expected, link_to_index(:listing, [:admin, blog, :posts], :class => :bar)
  end

  test "link_to_destroy" do
    expected = %(<a href="/admin/blogs/#{blog.id}/posts/#{post.id}" class="destroy" data-confirm="Kill da Post?" data-method="delete" rel="nofollow">delete</a>)
    assert_equal expected, link_to_destroy(post)
  end
end