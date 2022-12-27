class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def authorize_user
    @post = Post.find(params[:id])
    unless current_user == @post.user
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to @post
    end
  end  

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    if @post.save
      redirect_to @post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = Post.find(params[:id])
    if current_user != @post.user
      flash[:alert] = "You are not authorized to edit this post."
      redirect_to @post
    end
  end

  def update
    @post = Post.find(params[:id])

    if current_user == @post.user
      if @post.update(post_params)
        redirect_to @post
      else
        render :edit, status: :unprocessable_entity
      end
    else
      flash[:alert] = "You are not authorized to update this post."
      redirect_to @post
    end
  end

  def destroy
    @post = Post.find(params[:id])

    if current_user == @post.user
      @post.destroy
      redirect_to root_path, status: :see_other
    else
      flash[:alert] = "You are not authorized to delete this post."
      redirect_to @post
    end
  end

  private
    def post_params
      params
        .require(:post)
        .permit(:title, :body)
    end
end
