class CommentsController < ApplicationController
	
	before_action :authenticate_user!
	@comment
    
	def create
		@post = Post.find(params[:post_id])
		@comment = @post.comments.create(params[:comment].permit(:comment))
		@comment.user_id = current_user.id if current_user
		@comment.save
		if @comment.save
			CommentBroadcastJob.perform_now(@post, @comment, current_user)
			redirect_to post_path(@post)
		else
			render 'new'
		end
	end
	
	def destroy
		@post = Post.find(params[:post_id])
		@comment = @post.comments.find(params[:id])
		@comment.destroy
		redirect_to post_path(@post)
	end
	
	def update
		@post = Post.find(params[:post_id])
		@comment = @post.comments.find(params[:id])
		
		if @comment.update(params[:comment].permit(:comment))
			redirect_to post_path(@post)
		else
			render 'edit'
		end
	end
	
	def edit
		@post = Post.find(params[:post_id])
		@comment = @post.comments.find(params[:id])
		if current_user.id != @comment.user_id && (!(current_user.admin))
			redirect_to post_path(@post)
		end
	end
end
