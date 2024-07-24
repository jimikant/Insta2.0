# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authorize_user

  def show
    @user = current_user
    @profile = @user.profile
  end

  def new
    @user = current_user
    @profile = Profile.new
  end

  def edit
    @user = current_user
    @profile = @user.profile
  end

  def create
    @user = current_user
    @profile = Profile.new(profile_params)
    @profile.user = @user
    if @profile.save
      redirect_to profile_path
    else
      render :new
    end
  end

  def update
    @user = current_user
    @profile = @user.profile
    if @profile.update(profile_params)
      redirect_to profile_path
    else
      render :edit
    end
  end

  def destroy
    @user = current_user
    @profile = @user.profile
    @profile.destroy
    redirect_to profile_path
  end

  def delete_avtar
    @user = current_user
    @profile = @user.profile
    @profile.avtar.purge
    redirect_to edit_profile_path, notice: 'Avtar deleted successfully.'
  end

  private

  def profile_params
    params.require(:profile).permit(:avtar, :first_name, :last_name, :phone, :address)
  end

  def authorize_user
    authorize! action_name.to_sym, @profile || Profile
  end
end
