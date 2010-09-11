require File.expand_path('../test_helper', __FILE__)

class UrlHelpersTest < Test::Unit::TestCase
  COLLECTION_ACTIONS = %w(index new create)
  MEMBER_ACTIONS   = %w(show edit update destroy)
  ACTIONS = COLLECTION_ACTIONS + MEMBER_ACTIONS

  attr_reader :controller, :blog, :post

  def setup
    @blog = Blog.create
    @post = blog.posts.create!
    @controller = setup_controller(Admin::PostsController)
    controller.params = { :blog_id => blog.id, :id => post.id }
  end

  ACTIONS.each do |action|
    test "index_path returns /admin/blogs/:blog_id/posts on posts##{action}" do
      controller.params.merge!(:action => action)
      assert_equal "/admin/blogs/#{blog.id}/posts", controller.index_path
    end

    test "new_path returns /admin/blogs/:blog_id/posts/new on posts##{action}" do
      controller.params.merge!(:action => action)
      assert_equal "/admin/blogs/#{blog.id}/posts/new", controller.new_path
    end

    test "parent_index_path returns /admin/blogs on posts##{action}" do
      controller.params.merge!(:action => action)
      assert_equal "/admin/blogs", controller.parent_index_path
    end

    test "parent_new_path returns /admin/blogs/new on posts##{action}" do
      controller.params.merge!(:action => action)
      assert_equal "/admin/blogs/new", controller.parent_new_path
    end
  end

  COLLECTION_ACTIONS.each do |action|
    test "show_path raises on posts##{action}" do
      controller.params.merge!(:action => action)
      assert_raises(RuntimeError) { controller.show_path }
    end

    test "edit_path raises on posts##{action}" do
      controller.params.merge!(:action => action)
      assert_raises(RuntimeError) { controller.edit_path }
    end

    test "children_index_path(:comments) raises on posts##{action}" do
      controller.params.merge!(:action => action)
      assert_raises(RuntimeError) { controller.children_new_path(:comments) }
    end

    test "children_new_path(:comments) raises on posts##{action}" do
      controller.params.merge!(:action => action)
      assert_raises(RuntimeError) { controller.children_new_path(:comments) }
    end
  end

  MEMBER_ACTIONS.each do |action|
    test "show_path returns /admin/blogs/:blog_id/posts/:id on posts##{action}" do
      controller.params.merge!(:action => action, :id => post.id)
      assert_equal "/admin/blogs/#{blog.id}/posts/#{post.id}", controller.show_path
    end

    test "edit_path returns /admin/blogs/:blog_id/posts/:id/edit on posts##{action}" do
      controller.params.merge!(:action => action, :id => post.id)
      assert_equal "/admin/blogs/#{blog.id}/posts/#{post.id}/edit", controller.edit_path
    end

    test "children_index_path(:comments) returns /admin/blogs/:blog_id/posts/:id/comments on posts##{action}" do
      controller.params.merge!(:action => action)
      assert_equal "/admin/blogs/#{blog.id}/posts/#{post.id}/comments", controller.children_index_path(:comments)
    end

    test "children_new_path(:comments) returns /admin/blogs/:blog_id/posts/:id/comments/new on posts##{action}" do
      controller.params.merge!(:action => action)
      assert_equal "/admin/blogs/#{blog.id}/posts/#{post.id}/comments/new", controller.children_new_path(:comments)
    end
  end
end