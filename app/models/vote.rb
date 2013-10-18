class Vote
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :value, type: Integer, default: 0  
  belongs_to :comment
  belongs_to :user

  before_create do
    if Vote.where(:comment_id => self.comment_id, :value => -1).to_a.length > 1 and self.value == -1
      @comment = Comment.find(self.comment_id)
      @comment.abusive = true
      @comment.save 
    end
  end
end
