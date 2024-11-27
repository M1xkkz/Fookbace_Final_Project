class PostsController < ApplicationController
    before_action :require_login, except: [:index]
    before_action :set_post, only: [:edit, :update, :destroy]
  
    def index
      if params[:search].present?
        # ค้นหาจากหัวข้อโพสต์ (title) ที่ตรงกับคำค้นหา
        @posts = Post.where("title LIKE ?", "%#{params[:search]}%")
      else
        @posts = Post.includes(:user).all
      end


      if params[:search].present?
        # ค้นหาจากหัวข้อโพสต์ (title) ที่ตรงกับคำค้นหา พร้อมกับดึงข้อมูลผู้ใช้และคอมเมนต์ที่เกี่ยวข้อง
        @posts = Post.includes(:user, :comments).where("title LIKE ?", "%#{params[:search]}%")
      else
        # ดึงโพสต์ทั้งหมดพร้อมกับผู้ใช้และคอมเมนต์ที่เกี่ยวข้อง
        @posts = Post.includes(:user, :comments).all
      end
    
    end
  
    def new
      @post = Post.new
    end
  
    def create
      @post = current_user.posts.build(post_params)
      if @post.save
        redirect_to root_path, notice: "Post created successfully."
      else
        render :new
      end
    end
  
    def edit; end
  
    def update
      if @post.update(post_params)
        redirect_to root_path, notice: "Post updated successfully."
      else
        render :edit
      end
    end
  
    def destroy
      @post.destroy
      redirect_to root_path, notice: "Post deleted successfully."
    end
  
    private
  
    def set_post
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_path, alert: "Unauthorized action." if @post.nil?
    end
  
    def post_params
      params.require(:post).permit(:title, :content)
    end
  end