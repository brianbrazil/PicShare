class Media
  include Mongoid::Document
  include Magick
  belongs_to :event

  field :md5
  field :caption
  field :adult_content, type: Mongoid::Boolean

  def media_file=(file)
    self._s3_filename = SecureRandom.uuid
    obj = AWS::S3::S3Object.new(s3.buckets['PicShare'], self._s3_filename)
    obj.write(file)
  end

  def media_url
    obj = s3.buckets['PicShare'].objects[self._s3_filename]
    obj.url_for(:read)
  end

  def media_url_240_wide
    resized_s3_filename = "#{self._s3_filename}-240-wide"
    if s3.buckets['PicShare-resized'].objects[resized_s3_filename].exists?
      p 'return from cache'
      s3.buckets['PicShare-resized'].objects[resized_s3_filename].url_for(:read)
    else
      p 'generating new'
      obj = s3.buckets['PicShare'].objects[self._s3_filename]
      Image.from_blob(obj.read).first.change_geometry('240x') do |cols, rows, img|
        resized_obj = AWS::S3::S3Object.new(s3.buckets['PicShare-resized'], resized_s3_filename)
        resized_obj.write(img.resize(cols, rows).to_blob)
        resized_obj.url_for(:read)
      end
    end
  end

  def delete(options)
    s3.buckets['PicShare'].objects[self._s3_filename].delete
    super
  end

  private

  field :_s3_filename, type: String

  def s3
    AWS::S3.new(access_key_id: ENV['PICSHARE_AWS_ID'], secret_access_key: ENV['PICSHARE_AWS_SECRET'])
  end


end