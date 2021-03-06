require File.expand_path('../test_helper', __FILE__)

class ResourcesUrlHelpersTest < Test::Unit::TestCase
  COLLECTION_ACTIONS = [:index, :new, :create]
  MEMBER_ACTIONS     = [:show, :edit, :update, :destroy]
  ACTIONS = COLLECTION_ACTIONS + MEMBER_ACTIONS

  attr_reader :controller, :params, :blog, :category, :post, :comment

  def setup
    @blog = Blog.create
    @category = blog.categories.create!
    @post = blog.posts.create!
    @comment = post.comments.create!
    @params = {  }
  end

  def assert_path(expected, kind, options = { :raises => [] })
    ACTIONS.each do |action|
      params = { :action => action, :blog_id => blog.id }
      params.merge!(:id => post.id) if MEMBER_ACTIONS.include?(action)
      controller = setup_controller(Admin::PostsController, params)

      if options[:raises].include?(action)
        assert_raises(RuntimeError, NoMethodError) { controller.send(*Array(kind)) }
      else
        actual = controller.send(*Array(kind))
        assert_equal(expected, actual, "expected #{kind} to be #{expected.inspect} on action #{action} but was #{actual.inspect}")
      end
    end
  end

  # index_path

  test "index_path returns /admin/blogs/1/posts" do
    expected = "/admin/blogs/#{blog.id}/posts"
    assert_path expected, :index_path
  end

  test "index_path(comment) returns /admin/blogs/1/posts (but raises on :index, :new and :create)" do
    expected  = "/admin/blogs/#{blog.id}/posts/#{post.id}/comments"
    assert_path expected, [:index_path, comment], :raises => COLLECTION_ACTIONS
  end

  test "index_path(:comment) returns /admin/blogs/1/posts (but raises on :index, :new and :create)" do
    expected  = "/admin/blogs/#{blog.id}/posts/#{post.id}/comments"
    assert_path expected, [:index_path, :comment], :raises => COLLECTION_ACTIONS
  end

  test "index_path(Comment) returns /admin/blogs/1/posts (but raises on :index, :new and :create)" do
    expected  = "/admin/blogs/#{blog.id}/posts/#{post.id}/comments"
    assert_path expected, [:index_path, Comment], :raises => COLLECTION_ACTIONS
  end

  test "index_path([:admin, blog, post, comment]) returns /admin/blogs/1/posts" do
    expected  = "/admin/blogs/#{blog.id}/posts/#{post.id}/comments"
    assert_path expected, [:index_path, [:admin, blog, post, comment]]
  end

  test "index_path([:admin, blog, post, :comment]) returns /admin/blogs/1/posts" do
    expected = "/admin/blogs/#{blog.id}/posts/#{post.id}/comments"
    assert_path expected, [:index_path, [:admin, blog, post, :comment]]
  end

  test "index_path([:admin, blog, post, Comment]) returns /admin/blogs/1/posts" do
    expected = "/admin/blogs/#{blog.id}/posts/#{post.id}/comments"
    assert_path expected, [:index_path, [:admin, blog, post, Comment]]
  end

  # new_path

  test "new_path returns /admin/blogs/1/posts/new" do
    expected = "/admin/blogs/#{blog.id}/posts/new"
    assert_path expected, :new_path
  end

  test "new_path(comment) returns /admin/blogs/1/posts/1/comments/new (but raises on :index, :new and :create)" do
    expected = "/admin/blogs/#{blog.id}/posts/#{post.id}/comments/new"
    assert_path expected, [:new_path, comment], :raises => COLLECTION_ACTIONS
  end

  test "new_path(:comment) returns /admin/blogs/1/posts/new (but raises on :index, :new and :create)" do
    expected = "/admin/blogs/#{blog.id}/posts/#{post.id}/comments/new"
    assert_path expected, [:new_path, :comment], :raises => COLLECTION_ACTIONS
  end

  test "new_path(Comment) returns /admin/blogs/1/posts/new (but raises on :index, :new and :create)" do
    expected = "/admin/blogs/#{blog.id}/posts/#{post.id}/comments/new"
    assert_path expected, [:new_path, Comment], :raises => COLLECTION_ACTIONS
  end

  test "new_path([:admin, blog, post, comment]) returns /admin/blogs/1/posts/1/comments/new" do
    expected = "/admin/blogs/#{blog.id}/posts/#{post.id}/comments/new"
    assert_path expected, [:new_path, [:admin, blog, post, comment]]
  end

  test "new_path([:admin, blog, post, :comment]) returns /admin/blogs/1/posts/new" do
    expected = "/admin/blogs/#{blog.id}/posts/#{post.id}/comments/new"
    assert_path expected, [:new_path, [:admin, blog, post, :comment]]
  end

  test "new_path([:admin, blog, post, Comment]) returns /admin/blogs/1/posts/new" do
    expected = "/admin/blogs/#{blog.id}/posts/#{post.id}/comments/new"
    assert_path expected, [:new_path, [:admin, blog, post, Comment]]
  end

  # show_path

  test "show_path returns /admin/blogs/1/posts/1 (but raises on :index, :new and :create)" do
    expected = "/admin/blogs/#{blog.id}/posts/#{post.id}"
    assert_path expected, :show_path, :raises => COLLECTION_ACTIONS
  end

  test "show_path(comment) returns /admin/blogs/1/posts1/comments/1 (but raises on :index, :new and :create)" do
    expected = "/admin/blogs/#{blog.id}/posts/#{post.id}/comments/#{comment.id}"
    assert_path expected, [:show_path, comment], :raises => COLLECTION_ACTIONS
  end

  test "show_path(:comment) always raises" do
    assert_path nil, [:show_path, :comment], :raises => ACTIONS
  end

  test "show_path(Comment) always raises" do
    assert_path nil, [:show_path, Comment], :raises => ACTIONS
  end

  test "show_path([:admin, blog, post, comment]) returns /admin/blogs/1/posts1/comments/1" do
    expected = "/admin/blogs/#{blog.id}/posts/#{post.id}/comments/#{comment.id}"
    assert_path expected, [:show_path, [:admin, blog, post, comment]]
  end

  test "show_path([:admin, blog, post, :comment]) always raises" do
    assert_path nil, [:show_path, [:admin, blog, post, :comment]], :raises => ACTIONS
  end

  test "show_path([:admin, blog, post, Comment]) always raises" do
    assert_path nil, [:show_path, [:admin, blog, post, Comment]], :raises => ACTIONS
  end

  # edit_path

  test "edit_path returns /admin/blogs/1/posts/1/edit (raises on :index)" do
    expected = "/admin/blogs/#{blog.id}/posts/#{post.id}/edit"
    assert_path expected, :edit_path, :raises => COLLECTION_ACTIONS
  end

  test "edit_path(comment) returns /admin/blogs/1/posts1/comments/1 (but raises on :index, :new and :create)" do
    expected = "/admin/blogs/#{blog.id}/posts/#{post.id}/comments/#{comment.id}/edit"
    assert_path expected, [:edit_path, comment], :raises => COLLECTION_ACTIONS
  end

  test "edit_path(:comment) always raises" do
    assert_path nil, [:edit_path, :comment], :raises => ACTIONS
  end

  test "edit_path(Comment) always raises" do
    assert_path nil, [:edit_path, Comment], :raises => ACTIONS
  end

  test "edit_path([:admin, blog, post, comment]) returns /admin/blogs/1/posts1/comments/1" do
    expected = "/admin/blogs/#{blog.id}/posts/#{post.id}/comments/#{comment.id}/edit"
    assert_path expected, [:edit_path, [:admin, blog, post, comment]]
  end

  test "edit_path([:admin, blog, post, :comment]) always raises" do
    assert_path nil, [:edit_path, [:admin, blog, post, :comment]], :raises => ACTIONS
  end

  test "edit_path([:admin, blog, post, Comment]) always raises" do
    assert_path nil, [:edit_path, [:admin, blog, post, Comment]], :raises => ACTIONS
  end

  # parent paths

  test "index_parent_path returns /admin/blogs" do
    assert_path "/admin/blogs", :index_parent_path
  end

  test "new_parent_path returns /admin/blogs/new" do
    assert_path "/admin/blogs/new", :new_parent_path
  end

  test "show_parent_path returns /admin/blogs/1" do
    assert_path "/admin/blogs/#{blog.id}", :show_parent_path
  end

  test "edit_parent_path returns /admin/blogs/1/edit" do
    assert_path "/admin/blogs/#{blog.id}/edit", :edit_parent_path
  end

  test "index_parent_path(:categories) returns /admin/blogs/1/categories" do
    assert_path "/admin/blogs/#{blog.id}/categories", [:index_parent_path, :categories]
  end

  test "new_parent_path(:category) returns /admin/blogs/1/categories/new" do
    assert_path "/admin/blogs/#{blog.id}/categories/new", [:new_parent_path, :category]
  end

  test "show_parent_path(category) returns /admin/blogs/1/categories/1" do
    assert_path "/admin/blogs/#{blog.id}/categories/#{category.id}", [:show_parent_path, category]
  end

  test "edit_parent_path(category) returns /admin/blogs/1/categories/1/edit" do
    assert_path "/admin/blogs/#{blog.id}/categories/#{category.id}/edit", [:edit_parent_path, category]
  end
end
