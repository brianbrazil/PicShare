class Uploader < Media
  include SuckerPunch::Job
  include PicShareS3

  def perform(file: nil, photo_id: nil)
    s3_filename = SecureRandom.uuid
    obj = AWS::S3::S3Object.new(bucket, s3_filename)
    obj.write(file)

    photo = Photo.find(photo_id)
    photo._s3_filename = s3_filename
    photo.save!
  end

end
