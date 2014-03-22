class PhotoResizer
  include SuckerPunch::Job
  include Magick
  include PicShareS3

  def perform(photo_id: nil, file: nil, width: nil, height: nil, &block)
    fail 'height and/or width must be provided' if width.nil? && height.nil?
    fail 'photo_id and/or file must be provided' if photo_id.nil? && file.nil?
    photo = Photo.find(photo_id)
    image = image(s3_filename: photo._s3_filename, file: file)
    dimensions = dimensions(height: height, width: width)
    photo._resized_s3_filename = resize image, dimensions
    p photo._resized_s3_filename
    photo.save!
  end

  private

  def image(s3_filename: nil, file: nil)
    if file.nil?
      Image.from_blob(bucket.objects[s3_filename].read).first
    else
      Image.read(file.path).first
    end
  end

  def dimensions(height: nil, width: nil)
    "#{width}x#{height}"
  end

  def resize(image, dimensions)
    resized_s3_filename = SecureRandom.uuid
    image.change_geometry(dimensions) do |cols, rows, img|
      resized_obj = AWS::S3::S3Object.new(resized_bucket, resized_s3_filename)
      resized_obj.write(img.resize(cols, rows).to_blob)
      resized_obj.url_for(:read)
    end

    resized_s3_filename
  end

end
