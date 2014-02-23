class Photo < Media
  include Mongoid::Document

  def media_file=(file)
    super
    save_as_240
  end

  def media_url_240_wide
    if resized_bucket.objects[resized_s3_filename].exists?
      resized_bucket.objects[resized_s3_filename].url_for(:read)
    else
      save_as_240
    end
  end

  def save_as_240
    obj = bucket.objects[self._s3_filename]
    Image.from_blob(obj.read).first.change_geometry('240x') do |cols, rows, img|
      resized_obj = AWS::S3::S3Object.new(resized_bucket, resized_s3_filename)
      resized_obj.write(img.resize(cols, rows).to_blob)
      resized_obj.url_for(:read)
    end
  end

end
