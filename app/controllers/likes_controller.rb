# frozen_string_literal: true

class LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @like = @post.likes.create(user_id: params[:user_id])

    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js   # This will render create.js.erb
    end
  end

  def destroy
    @like = Like.find(params[:id])
    @post = @like.post
    @like.destroy

    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js   # This will render destroy.js.erb
    end
  end
end
