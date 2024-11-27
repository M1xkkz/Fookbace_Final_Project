class LikesController < ApplicationController
    before_action :require_login
  
    def create
      @post = Post.find(params[:post_id])
      @like = @post.likes.build(user: current_user)
      if @like.save
        redirect_to root_path
      else
        redirect_to root_path, alert: "Failed to like post."
      end
    end
  
    def destroy
      @like = current_user.likes.find_by(post_id: params[:post_id])
      @like.destroy if @like
      redirect_to root_path
    end
  end   