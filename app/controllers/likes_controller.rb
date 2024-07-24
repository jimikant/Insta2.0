# frozen_string_literal: true

class LikesController < ApplicationController
  def create
    @like = Like.new(user_id: params[:user_id], post_id: params[:post_id])
    redirect_to request.referer
  end

  def destroy
    @like = Like.find(params[:id])
    @like.destroy

    redirect_to request.referer
  end
end
