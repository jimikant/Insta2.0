class LikesController < ApplicationController

  def create
    @like = Like.new(user_id: params[:user_id], post_id: params[:post_id])
    if @like.save
      redirect_to request.referer
    else
      redirect_to request.referer
    end
  end

  def destroy
    @like = Like.find(params[:id])
    @like.destroy

    redirect_to request.referer
  end
end
