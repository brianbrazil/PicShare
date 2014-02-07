class Media
  include Mongoid::Document
  include Magick
  belongs_to :event

  field :md5
  field :caption
  field :adult_content, type: Mongoid::Boolean

  def media_file=(file)
    self._s3_filename = SecureRandom.uuid
    obj = AWS::S3::S3Object.new(bucket, self._s3_filename)
    obj.write(file)
  end

  def media_url
    obj = bucket.objects[self._s3_filename]
    obj.url_for(:read)
  end

  def media_url_240_wide
    if resized_bucket.objects[resized_s3_filename].exists?
      resized_bucket.objects[resized_s3_filename].url_for(:read)
    else
      obj = bucket.objects[self._s3_filename]
      Image.from_blob(obj.read).first.change_geometry('240x') do |cols, rows, img|
        resized_obj = AWS::S3::S3Object.new(resized_bucket, resized_s3_filename)
        resized_obj.write(img.resize(cols, rows).to_blob)
        resized_obj.url_for(:read)
      end
    end
  end

  def delete(options)
    bucket.objects[self._s3_filename].delete
    super
  end

  private

  field :_s3_filename, type: String

  def resized_s3_filename
    "#{self._s3_filename}-240-wide"
  end

  def bucket
    s3.buckets['PicShare']
  end

  def resized_bucket
    s3.buckets['PicShare-resized']
  end

  def s3
    AWS::S3.new(access_key_id: ENV['PICSHARE_AWS_ID'], secret_access_key: ENV['PICSHARE_AWS_SECRET'])
  end


end