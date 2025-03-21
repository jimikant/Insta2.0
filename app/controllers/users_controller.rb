# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authorize_user, only: %i[user_index index new edit destroy]

  def user_index
    @users = User.all.user_asc_order
  end

  def dashboard
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

    # Skip password validation and welcome email if the user is being created by an admin
    if current_user.admin?
      @user.instance_variable_set(:@skip_password_validation, true)
    end

    if @user.save!
      if current_user.admin?
        @user.generate_reset_password_token! # Generate password reset token
        UserMailer.with(user: @user).send_invite_email.deliver_now # Send invite email
      end
      redirect_to user_index_path, notice: 'User was successfully Created and Invite sent'
    else
      render :new
    end
  end

  def update
    @user = User.friendly.find(params[:id])
    if @user.update(user_params)
      redirect_to user_index_path, notice: 'User Updated successfully'
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
      redirect_to user_index_path, notice: 'User and Associated data Deleted successfully'
    else
      @user = current_user
      @profile = @user.profile

      @profile&.destroy

      @user.destroy
      redirect_to root_path, notice: 'User and Associated data Deleted successfully'
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
