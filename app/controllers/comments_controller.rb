class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(params[:comment])
    @comment.save
    redirect_to @post
  end

  def vote_up
    @comment = Comment.find(params[:id])
    @user = User.find(current_user.id)

    e = Vote.new(:value => 1)
    e.user = @user
    e.comment = @comment
    e.save
  end

  def vote_down
    @comment = Comment.find(params[:id])
    @user = User.find(current_user.id)

    e = Vote.new(:value => -1)
    e.user = @user
    e.comment = @comment
    e.save
  end
end
