module PicShareS3

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
