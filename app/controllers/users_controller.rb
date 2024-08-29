# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authorize_user, only: %i[user_index index edit]

  def user_index
    @users = User.all.user_asc_order
  end

  def dashboard
    @user = current_user
    @users = User.user_asc_order.includes(profile: { avtar_attachment: :blob })
    @posts = Post.includes(:user, :tags, image_attachment: :blob).page(params[:page]).per(2)
  end

  def show
    @user = User.friendly.find(params[:id])
    @can_like = current_user == @user
    @posts = @user.posts.includes(:tags, image_attachment: :blob)
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.friendly.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_index_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def update
    @user = User.friendly.find(params[:id])
    if @user.update(user_params)
      redirect_to user_index_path, notice: 'User updated!'
    else
      render :edit
    end
  end

  def destroy
    if current_user.admin?
      @user = User.friendly.find(params[:id])
      @profile = @user.profile

      @profile&.destroy

      @user.destroy
      redirect_to user_index_path, notice: 'User and associated Data deleted successfully.'
    else
      @user = current_user
      @profile = @user.profile

      @profile&.destroy

      @user.destroy
      redirect_to root_path, notice: 'User and associated Data deleted successfully.'
    end
  end

  def settings
    @user = current_user
    @subscription = current_user.subscriptions.find_by(active: true)
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :role, :stripe_customer_id)
  end

  def authorize_user
    authorize! action_name.to_sym, @user || User
  end
end
