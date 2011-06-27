ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define :version => 0 do
  create_table :blogs, :force => true do |t|
    t.string :name
  end

  create_table :categories, :force => true do |t|
    t.references :blog
    t.string :name
  end

  create_table :posts, :force => true do |t|
    t.references :blog
    t.string :title
  end

  create_table :comments, :force => true do |t|
    t.references :post
    t.string :text
  end
end

class Blog < ActiveRecord::Base
  has_many :posts
  has_many :categories
end

class Category < ActiveRecord::Base
end

class Post < ActiveRecord::Base
  has_many :comments
end

class Comment < ActiveRecord::Base
end

module Admin
  class BlogsController < InheritedResources::Base
    routes = ActionDispatch::Routing::RouteSet.new
    routes.draw { namespace(:admin) { resources(:blogs) { resources(:categories); resources(:posts) { resources(:comments) } } } }
    include routes.url_helpers
    public :resource
  end

  class PostsController < InheritedResources::Base
    belongs_to :blog
    routes = ActionDispatch::Routing::RouteSet.new
    routes.draw { namespace(:admin) { resources(:blogs) { resources(:categories); resources(:posts) { resources(:comments) } } } }
    include routes.url_helpers
    public :resource
  end

  class CommentsController < InheritedResources::Base
    nested_belongs_to :blog, :post
    routes = ActionDispatch::Routing::RouteSet.new
    routes.draw { namespace(:admin) { resources(:blogs) { resources(:categories); resources(:posts) { resources(:comments) } } } }
    include routes.url_helpers
    public :resource
  end
end


