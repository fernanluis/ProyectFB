class PostsController < ApplicationController

  # The index method creates an instance variable which stores the result of the previously
  # created method in the User model,‘friends_and_own_posts’
  # to gather all the posts of this user and his friends
  def index
    our_posts = current_user.friends_and_own_posts
  end

  # The show method grabs a particular post depending on the id supplied by the route
  # and stores it into an instance variable called @post.
  def show
    @post =  Post.find(params[:id])
  end

  # The new method creates a new Post record and assigns it to the @post variable but doesn’t save it.
  def new
    @post =  Post.new
  end

  # The create method creates a new Post record, assigning the user_id of that post
  # to that of the current_user that is signed in. (current_user is a devise included helper method)
  def create
    @post = current_user.posts.build(posts_params)
    if @post.save
      redirect_to @post
    else
      render "new"
    end
  end

  def destroy;  end

  # posts_params method is declared as a private method (method is only accessible within current file)
  # which permits the parameters :content and :imageURL provided by the create post route returning
  # them in a Hash format:
  # # => <ActionController::Parameters {"content"=>"Example post", "imageURL"=>"http://example.com"} permitted: true>
  private

  def posts_params
    params.require(:post).permit(:content, :imageURL)
  end

end
