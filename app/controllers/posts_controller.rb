class PostsController < ApplicationController
    
    before_action :find_post, only: [:show, :edit, :update, :destroy]
    before_filter :authenticate_user!, except: [:index, :show]
    
    def index
        session[:sort] = params[:sort] if params[:sort] != nil
        session[:tag] = params[:tag] if params[:tag] != nil
        @posts = Post.all
        
        if current_user.nil?
            @posts = Post.where(public: true)
        end
        
        if session[:tag]
            @posts = @posts.tagged_with(session[:tag])
        end
        
        @posts = @posts.order(session[:sort])
        if params[:all]
            session[:tag] = nil
            session[:sort] = nil
            redirect_to posts_path
        end
        
    end
    
    def show 
    end
    
    def new
        #@post = Post.new
        @post = current_user.posts.build
    end
     
    def edit
        @post = Post.find(params[:id])
        if current_user.id != @post.user_id
            redirect_to post_path(@post)
        end
    end
    
    def update
        if @post.update(post_params)
            redirect_to @post
        else
            render 'new'
        end
    end
    
    def destroy
        @post.destroy
        redirect_to posts_path
    end

    def create
        @post = current_user.posts.build(post_params)
        #@post = Post.new(post_params)
        if @post.save
            redirect_to @post
        else
            render 'new'
        end
    end
    
    private
    
    def find_post
        @post = Post.find(params[:id])
    end
    
    def post_params
        params.require(:post).permit(:title, :content, :all_tags)
    end
end