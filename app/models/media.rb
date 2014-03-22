class Media
  include Mongoid::Document
  include Magick
  include PicShareS3

  belongs_to :event

  field :md5
  field :caption
  field :adult_content, type: Mongoid::Boolean

  def media_file=(file)
    Uploader.new.async.perform file: file, photo_id: id
  end

  def media_url
    obj = bucket.objects[self._s3_filename]
    obj.url_for(:read)
  end

  def delete(options)
    bucket.objects[self._s3_filename].delete
    super
  end

  #protected

  field :_s3_filename, type: String
  field :_resized_s3_filename, type: String

end
