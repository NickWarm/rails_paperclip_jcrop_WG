# 手動裁剪圖片 WG版

最初臨摹的專案寫法沒那麼恰當，我參考這篇改寫
- [Cropping an Image in Rails using Paperclip – OnGraph Technologies](http://www.ongraph.com/blog/cropping-image-in-rails-using-paperclip/)

過程大部份都與[Reverse_Image_cropping_in_rails4](./Reverse_Image_cropping_in_rails4.md)這篇一樣，所以僅講解，少數不同的地方

由於，我打算把裁剪(`cropper`)在controller裡獨立出來一個action，所以我要先去`routes.rb`設定它的路由
- [rails Guide - 路由 - 2.10 新增更多資源式路由 - 2.10.1 新增成員路由](http://rails.ruby.tw/routing.html#新增更多資源式路由)

`routes.rb`

```
Rails.application.routes.draw do
  resources :blogs do
    patch :cropper, on: :member
  end
end
```

此時去console `rake routes`就會看到能撈到某筆資料的cropper頁面

```
$ rake routes
      Prefix Verb   URI Pattern                  Controller#Action
cropper_blog PATCH  /blogs/:id/cropper(.:format) blogs#cropper
```

然後去`blogs_controller.rb`加入`cropper` action

```
def cropper
  @blog = Blog.find(params[:id])
  @blog.update(blog_params)
  @blog.reprocess_image  #crop the image and then save it.
  redirect_to @blog
end
```

PS：這邊的`reprocess_image`是定義在`blog.rb`裡面

```
def reprocess_image
  image.reprocess!
end
```


為了要編輯時也能裁剪圖片，把`update` action改成

```
def update
    if @blog.update(blog_params)
      render "cropper"
    else
      render 'edit'
    end
end
```

由於`cropper.html.erb`會對應到`cropper` action，但是`cropper` action是我們自己定義的，原始的表單`form_for`並不支援，所以我們必須去修改`cropper.html.erb`裡表單的路由，改成cropper所對應的`patch :cropper`

`cropper.html.erb`

```
<%= form_for @blog, url:cropper_blog_path(@blog.id) do |form| %>
  <% for attribute in [:crop_x, :crop_y, :crop_w, :crop_h] %>
    <%= form.text_field attribute, :id => attribute %>
  <% end %>
  <p><%= form.submit "Crop" %></p>
<% end %>
```

PS：

```
$ rake routes
      Prefix Verb   URI Pattern                  Controller#Action
cropper_blog PATCH  /blogs/:id/cropper(.:format) blogs#cropper
```
