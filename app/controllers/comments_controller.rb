class CommentsController < ApplicationController
    skip_before_action :verify_authenticity_token

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
        @comment.destroy
        redirect_to post_path(@post), status: :see_other
    end

    def edit
        @post = Post.find(params[:post_id])
        @comment = @post.comments.find(params[:id])
    end

    def update
        @post = Post.find(params[:post_id])
        @comment = @post.comments.find(params[:id])

        if @comment.update(comment_params)
            redirect_to post_path(@post)
        else
            render :edit, status: :unprocessable_entity
        end
    end

    private
        def comment_params
            params
                .require(:comment)
                .permit(:commenter, :body)
        end
end
