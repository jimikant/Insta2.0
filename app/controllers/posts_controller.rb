# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :find_user, except: %i[index update]
  before_action :set_post, except: %i[index new create]
  before_action :authorize_user, except: %i[index show]
  after_action :notify_user, only: [:create]

  def set_post
    @post = Post.friendly.find(params[:id])
  end

  def index
    @posts = Post.includes(:user, :tags).all
  end

  def show; end

  def new
    @post = Post.new
  end

  def edit; end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save!
      redirect_to profile_path, notice: 'Post Created successfully'
    else
      render :new
    end
  end

  def update
    @user = current_user
    @post = Post.friendly.find(params[:id])
    if @post.update(post_params)
      redirect_to profile_path, notice: 'Post Updated successfully'
    else
      render :edit
    end
  end

  def destroy
    @post = Post.friendly.find(params[:id])
    @post.destroy

    if current_user.admin?
      redirect_to user_index_path, notice: 'Post Deleted successfully'
    else
      redirect_to profile_path, notice: 'Post Deleted successfully'
    end
  end

  private

  def find_user
    @user = current_user
  end

  def notify_user
    Rails.logger.debug { "Sending notification for #{@post.title}" }
  end

  def post_params
    params.require(:post).permit(:image, :title, :description, tag_ids: [])
  end

  def authorize_user
    authorize! action_name.to_sym, @post || Post
  end
end
