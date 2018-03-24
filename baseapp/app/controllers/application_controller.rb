class ApplicationController < ActionController::Base
  before_action :create_feedback

  private
  def create_feedback
    @feedback = Feedback.new
  end
end
