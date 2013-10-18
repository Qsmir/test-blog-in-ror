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
    if current_user.votes.where(:comment_id => @comment.id).to_a.length == 0
      self.create_vote(@comment, @user, 1)
    end
    redirect_to post_path(@comment.post_id)
  end

  def vote_down
    @comment = Comment.find(params[:id])
    @user = User.find(current_user.id)
    @value = params[:comment][:vote].to_i

    if current_user.votes.where(:comment_id => @comment.id).to_a.length == 0
      self.create_vote(@comment, @user, -1)
    end
    redirect_to post_path(@comment.post_id)
  end

  def mark_as_abusive(comment)
    @comment = comment
    @comment.abusive = true
    @comment.save
  end

  def mark_as_not_abusive
    @comment = Comment.find(params[:id])
    @user = User.find(current_user.id)
    if @user.id == @comment.user_id
      @comment.abusive = false
      @comment.save
    end
    redirect_to post_path(@comment.post_id)
  end

  protected

    def create_vote(comment,user,value)
    # tworzenie nowego glosu
      Vote.create(:value => value,:user => user, :comment => comment)
    end
    
    def crud_vote(comment,user,value)
    # logika obslugi glosow
      if current_user.votes.where(:comment_id => comment.id).to_a.length == 0
        # pierwszy oddany glos 
        self.create_vote(comment, user, value)
        redirect_to post_path(comment.post_id)
      elsif current_user.votes.where(:comment_id => comment.id).to_a[0]['value'] != value
        # wycofanie glosu [np. klikniecie vote_up(+1) a nastepnie vote_down(-1)]
        Vote.where(:user_id => user.id, :comment_id => comment.id).destroy
        redirect_to post_path(comment.post_id)
      else 
        # uzytkownik juz oddal swoj glos [np. klikniecie vote_up a nastepnie znowu vote_up]
        redirect_to post_path(comment.post_id)
      end
    end
end
