class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable

  field :body, type: String
  field :title, type: String
  field :archived, type: Boolean, default: false
  ## Trackable
  field :hotness, type: Integer, default:0

  validates_presence_of :body, :title

  belongs_to :user
  has_many :comments

  default_scope ne(archived: true)

  def archive!
    update_attribute :archived, true
  end

  def hotness
    @days = (Time.now.minus_with_coercion(self.created_at)/86400).round
    @hours = (Time.now.minus_with_coercion(self.created_at)/3600).round
    @comments = Comment.where(:post_id => self.id).length
    
    if @hours <= 24
      @counter = 3
    elsif @hours > 24 and @hours <= 72
      @counter = 2
    elsif @days > 3 and @days <= 7
      @counter = 1
    else 
      @counter = 0 
    end
    if @comments >= 3
      @counter += 1
    end
    return @counter
  end 

end
