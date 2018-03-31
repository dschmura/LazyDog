class Feedback
  include ActiveModel::Model
  attr_accessor :full_name, :email, :topic, :comment
  validates :topic, :comment, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "only allows valid emails" }
end
