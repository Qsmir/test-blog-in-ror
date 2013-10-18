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
    @value = params[:comment][:vote]

    self.crud_vote(@comment, @user, @value)
  end

  def vote_down
    @comment = Comment.find(params[:id])
    @user = User.find(current_user.id)
    @value = params[:comment][:vote].to_i

    if self.count_vote(@comment) <= -2
      @comment.abusive = true
      @comment.save
    end

    self.crud_vote(@comment, @user, @value)
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
      v = Vote.new(:value => value)
      v.user = user
      v.comment = comment
      v.save
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
    
    def count_vote(comment)
      # obliczanie sumy glosow dla danego komentarza
      count = 0
      Vote.where(:comment_id => comment.id).each do |val|
	  count += val.value	
      end
      return count
    end

end
