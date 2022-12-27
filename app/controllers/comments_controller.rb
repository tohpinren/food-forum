class CommentsController < ApplicationController
    before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
    before_action :authorize_user, only: [:edit, :update, :destroy]
    skip_before_action :verify_authenticity_token

    def authorize_user
        @post = Post.find(params[:post_id])
        @comment = @post.comments.find(params[:id])
        unless current_user == @comment.user
          flash[:alert] = "You are not authorized to perform this action."
          redirect_to @post
        end
    end

    def create
        @post = Post.find(params[:post_id])
        @comment = @post.comments.create(comment_params)
        @comment.user_id = current_user.id

        if @comment.save
            redirect_to post_path(@post)
          else
            render :new, status: :unprocessable_entity
        end
    end

    def destroy
        @post = Post.find(params[:post_id])
        @comment = @post.comments.find(params[:id])

        if current_user == @comment.user
            @comment.destroy
            redirect_to @post, status: :see_other
        else
            flash[:alert] = "You are not authorized to delete this comment."
            redirect_to @post
        end
    end

    def edit
        @post = Post.find(params[:post_id])
        @comment = @post.comments.find(params[:id])
        if current_user != @comment.user
          flash[:alert] = "You are not authorized to edit this comment."
          redirect_to @post
        end
    end

    def update
        @post = Post.find(params[:post_id])
        @comment = @post.comments.find(params[:id])

        if current_user == @comment.user
            if @comment.update(comment_params)
                redirect_to post_path(@post)
            else
                flash.now[:alert] = "There was an error updating the comment."
                render :edit, status: :unprocessable_entity
            end
        else
            flash[:alert] = "You are not authorized to update this comment."
            redirect_to @post
        end
    end

    private
        def comment_params
            params
                .require(:comment)
                .permit(:body)
        end
end
