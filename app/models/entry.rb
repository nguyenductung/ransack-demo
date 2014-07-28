class Entry < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  default_scope -> { order('created_at DESC') }
  validates :title,   presence: true, length: { maximum: 200 }
  validates :content, presence: true, length: { maximum: 6000 }
  validates :user_id, presence: true

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end

  private
  ransacker :id_str do |parent|
    Arel::Nodes::SqlLiteral.new("entries.id")
  end

  ransacker :written_date do |parent|
    Arel::Nodes::SqlLiteral.new("date(entries.created_at)")
  end
end
