class Media
  include Mongoid::Document
  belongs_to :event

  field :md5
  field :caption
  field :adult_content, type: Mongoid::Boolean

  def media_file=(file)
    p ENV['PICSHARE_AWS_ID']
    self._s3_filename = SecureRandom.uuid
    s3 = AWS::S3.new(access_key_id: ENV['PICSHARE_AWS_ID'], secret_access_key: ENV['PICSHARE_AWS_SECRET'])
    obj = AWS::S3::S3Object.new(s3.buckets['PicShare'], self._s3_filename)
    obj.write(file)
  end

  def media_url
    s3 = AWS::S3.new(access_key_id: ENV['PICSHARE_AWS_ID'], secret_access_key: ENV['PICSHARE_AWS_SECRET'])
    obj = s3.buckets['PicShare'].objects[self._s3_filename]
    obj.url_for(:read)
  end

  field :_s3_filename, type: String

  def delete(options)
    s3 = AWS::S3.new(access_key_id: ENV['PICSHARE_AWS_ID'], secret_access_key: ENV['PICSHARE_AWS_SECRET'])
    s3.buckets['PicShare'].objects[self._s3_filename].delete
    super
  end

end