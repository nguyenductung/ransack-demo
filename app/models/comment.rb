class Comment < ActiveRecord::Base
  belongs_to :entry
  belongs_to :user
  validates :entry_id, presence: true
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 6000 }
  default_scope -> { order('created_at DESC') }

  private
  ransacker :id_str do |parent|
    Arel::Nodes::SqlLiteral.new("comments.id")
  end

  ransacker :commented_date do |parent|
    Arel::Nodes::SqlLiteral.new("date(comments.created_at)")
  end
end
