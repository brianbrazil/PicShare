#require 'aws/s3'

class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :edit, :update, :destroy]

  # GET /photos
  # GET /photos.json
  def index
    @photos = Photo.all
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
  end

  # GET /photos/new
  def new
    @event = Event.find(params[:event_id])
    @photo = Photo.new
    @photo.event_id = params[:event_id]
  end

  # GET /photos/1/edit
  def edit
    @events = Event.all
  end

  # POST /photos
  # POST /photos.json
  def create
    @photo = Photo.new(photo_params)

    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo.event, notice: 'Photo was successfully created.' }
        format.json { render action: 'show', status: :created, location: @photo }
      else
        format.html { render action: 'new' }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photos/1
  # PATCH/PUT /photos/1.json
  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to photos_url }
      format.json { head :no_content }
    end
  end

  def upload
    @photos = []
    s3 = AWS::S3.new(access_key_id: 'AKIAIEI5ZVZM4HFZ6ONA', secret_access_key: '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')
    params[:files].each do |file|
      obj = AWS::S3::S3Object.new(s3.buckets['PicShare'], SecureRandom.uuid)
      obj.write(file.tempfile)
      Photo.new({event_id: params[:event_id], media_url: obj.url_for(:read) }).save
      @photos << { name: file.original_filename }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.require(:photo).permit(:caption, :adult_content, :media_url, :event_id)
    end
end
