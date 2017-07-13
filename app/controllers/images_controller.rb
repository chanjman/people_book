class ImagesController < ApplicationController
  before_action :set_photo_album, only: %i[create destroy]
  before_action :set_image, only: %i[show edit update destroy]

  def show
    @photo_album = @image.photo_album
    @author = @photo_album.author
  end

  def edit
    @photo_album = @image.photo_album
    @author = @photo_album.author
  end

  def create
    add_more_images(images_params[:images])
    flash[:error] = 'Failed uploading images' unless @photo_album.save
    redirect_to user_photo_album_path(current_user, @photo_album)
  end

  def update
    if @image.update(images_params)
      flash[:success] = 'Image was successfuly updated'
      redirect_to @image
    end
  end

  def destroy
    @image.destroy
    flash[:success] = 'Image was successfuly destroyed'
    redirect_to user_photo_album_path(current_user, @photo_album)
  end

  private

  def set_photo_album
    @photo_album = PhotoAlbum.find(params[:photo_album_id])
  end

  def set_image
    @image = Image.find(params[:id])
  end

  def add_more_images(new_images)
    images = @photo_album.images
    images += new_images
    @photo_album.images = images
  end

  def images_params
    params.permit(:description, images: [])
  end
end