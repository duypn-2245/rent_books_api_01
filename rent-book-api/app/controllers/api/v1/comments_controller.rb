class Api::V1::CommentsController < ApplicationController
  before_action :authenticate_request!, :preload_book
  before_action :preload_comment, only: %i(update destroy)

  authorize_resource

  def index
    page = params[:page] || Settings.per_page.default_1
    per_page = params[:per] || Settings.show_limit_per_page.comment.index_limit
    comments = @book.comments.includes(:user).recent.page(page).per(per_page)
    json_response comments, meta_pagination(page, per_page, comments)
  end

  def create
    comment = @book.comments.build create_comment_params
    comment.save!
    json_response comment, {}, :created
  end

  def update
    @comment.update! content: params[:content]
    json_response @comment
  end

  def destroy
    @comment.destroy!
    response_json I18n.t("comments.destroy.success"), :no_content
  end

  private

  def preload_book
    @book = Book.find params[:book_id].to_i
  end

  def create_comment_params
    params.permit(:content).merge(user_id: @current_user.id, parent_id: param_parent_id)
  end

  def param_parent_id
    params[:parent_id].blank? ? nil : Comment.find(params[:parent_id].to_i).id
  end

  def preload_comment
    @comment = Comment.find params[:id].to_i
  end
end
