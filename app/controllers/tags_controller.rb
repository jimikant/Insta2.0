class TagsController < ApplicationController

  def index
    @user = current_user
    @tags = Tag.all.ordered_alphabetically
  end

  def new
    @tag = Tag.new
  end

  def show
    @user = current_user
    @tag = Tag.friendly.find(params[:id])
  end

  def create
    @user = current_user
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to tags_path
    else
      render :new
    end
  end

  def edit
    @user = current_user
    @tag = Tag.friendly.find(params[:id])
  end

  def update
    @user = current_user
    @tag = Tag.friendly.find(params[:id])
    if @tag.update(tag_params)
      redirect_to tags_path
    else
      render :edit
    end
  end

  def destroy
    @user = current_user
    @tag = Tag.friendly.find(params[:id])
    @tag.destroy

    redirect_to tags_path
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
