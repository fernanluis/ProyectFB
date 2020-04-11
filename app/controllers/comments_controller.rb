class CommentsController < ApplicationController
  include AplicationHelper

  def new
    @comment = Comment.new
  end

  def create
    @comment = current_user.comments.build(comment_params)
    @post = Post.find(params[:comment][:post_id])
    if @comment.save
      @notification = new_notification(@post.user, @post.id, 'comment')
      @notification.save
    end
    redirect_to @post
  end

  def destroy
    @comment = Comment.find(params[:id])
    return unless current_user.id == @comment.user_id
    @comment.destroy
    flash[:success] ='Comment deleted'
    redirect_back(fallback_location: root_path) # redirect_back simplement actualiza la página actual.
  end


  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end

end
