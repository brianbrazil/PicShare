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

  def delete(options)
    bucket.objects[self._s3_filename].delete
    super
  end

  protected

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