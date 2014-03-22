class Photo < Media
  include Mongoid::Document

  def media_file=(file)
    super
    PhotoResizer.new.async.perform(photo_id: id, file: file, width: 240)
  end

  def media_url_240_wide
    if _resized_s3_filename.nil? || resized_bucket.objects[_resized_s3_filename].nil?
      PhotoResizer.new.perform(photo_id: id, width: 240)
    end
    resized_bucket.objects[self._resized_s3_filename].url_for(:read)
  end

end
