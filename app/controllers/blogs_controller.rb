class BlogsController < ApplicationController
  before_action :set_blog, only: [:show, :edit, :update, :destroy]

  def index
    @blogs = Blog.all
  end

  def show
  end

  def new
    @blog = Blog.new
  end

  def edit
  end

  def create
    @blog = Blog.new(blog_params)

    if @blog.save
      render "cropper"
      # redirect_to @blog
    else
      render :new
    end
  end

  def cropper
    @blog = Blog.find(params[:id])
    @blog.update(blog_params)
    @blog.reprocess_image  #crop the image and then save it.
    redirect_to @blog
  end


  def update
      if @blog.update(blog_params)
        render "cropper"
      else
        render 'edit'
      end
  end


  def destroy
    @blog.destroy
    respond_to do |format|
      format.html { redirect_to blogs_url, notice: 'Blog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = Blog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_params
      params.require(:blog).permit(:title, :description, :image, :crop_x, :crop_y, :crop_w, :crop_h)
    end
end
