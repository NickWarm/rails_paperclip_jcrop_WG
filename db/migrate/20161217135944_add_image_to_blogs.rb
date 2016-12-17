class AddImageToBlogs < ActiveRecord::Migration
  def change
    add_attachment :blogs, :image
  end
end
