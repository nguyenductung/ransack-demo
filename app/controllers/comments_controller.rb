class CommentsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  before_action :owner_or_followed_user, only: :create

  def index
    @q = Comment.search params[:q]
    @comments = @q.result.page params[:page]
  end

  def create
    @comment = Comment.create(content: comment_params[:content],
                              entry_id: comment_params[:entry_id],
                              user_id: comment_params[:user_id])
    if @comment.save
      flash[:success] = "Comment posted!"
      redirect_back
    else
      @entry = Entry.find(comment_params[:entry_id])
      @comments = @entry.comments.paginate(page: params[:page]) unless @entry.nil?
      render 'entries/show'
    end
  end

  def destroy
    @comment.destroy
    redirect_back
  end

  private
  def comment_params
    params.require(:comment).permit(:content, :entry_id, :user_id)
  end

  def correct_user
    @comment = current_user.comments.find_by(id: params[:id])
    redirect_to root_url if @comment.nil?
  end

  def owner_or_followed_user
    entry = Entry.find(comment_params[:entry_id])
    owner = User.find(entry.user_id) unless entry.nil?
    if !owner.nil? && !(owner == current_user || current_user.following?(owner))
      redirect_to root_url
    end
  end
end