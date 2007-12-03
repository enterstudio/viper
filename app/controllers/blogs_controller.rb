class BlogsController < ApplicationController
  
  tab :blogs
  
  def index
    self.disable_maincols
    self.sidebar_one = nil
    self.sidebar_two = 'blogs/sidebar_index'
    
    respond_to do |format|
      format.html do
        @posts = Post.find_latest_by_unique_authors(10)
      end
      format.rss do
        @posts = Post.find_latest(25)
        render :action => 'index.rxml', :layout => false
      end
    end
  end
  
  def tag
    self.disable_maincols
    self.sidebar_one = nil
    self.sidebar_two = 'blogs/sidebar_index'
    
    @tag = Tag.find_by_name(params[:id])
    @posts = Post.find_tagged_with(@tag.name)
  end
  
  def show
    redirect_to blog_posts_url(params[:id])
  end
  
end