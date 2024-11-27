class CommentsController < ApplicationController
    before_action :require_login
    before_action :set_post
    before_action :set_comment, only: [:destroy]
  
    # ฟังก์ชันสร้างคอมเมนต์
    def create
      @comment = @post.comments.build(comment_params.merge(user: current_user))
      if @comment.save
        redirect_to root_path
      else
        redirect_to root_path
      end
    end
  
    
    def destroy
      if @comment.nil? || @post.nil?
        redirect_to root_path
        return
      end
  
      
      if @comment.user == current_user || @post.user == current_user
        @comment.destroy
        redirect_to root_path
      else
        redirect_to root_path
      end
    end
  
    private
  
    def comment_params
      params.require(:comment).permit(:content)
    end
  
    # ฟังก์ชันนี้จะค้นหาตัวโพสต์ตาม id
    def set_post
      @post = Post.find_by(id: params[:post_id])
      if @post.nil?
        redirect_to root_path, alert: "Post not found."
      end
    end
  
    # ฟังก์ชันนี้จะค้นหาคอมเมนต์ตาม id ที่อยู่ในโพสต์
    def set_comment
      @comment = @post.comments.find_by(id: params[:id])
      if @comment.nil?
        redirect_to post_path(@post), alert: "Comment not found."
      end
    end
  end