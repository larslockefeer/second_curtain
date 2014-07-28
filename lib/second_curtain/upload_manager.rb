require 'aws-sdk'
require 'upload'

class UploadManager
  def initialize (bucket, path_prefix)
    abort "error: Second Curtain must supply an S3 bucket".red unless bucket
    abort "error: Second Curtain must supply a path prefix of at least '/'".re unless path_prefix

    @uploads = []
    @path_prefix = path_prefix
    @bucket = bucket
  end

  def enqueue_upload(expected_path, actual_path)
    @uploads.push(Upload.new(expected_path, actual_path))
  end

  def upload(folder_name)
    return nil unless @uploads.count > 0

    @uploads.each do |upload|
      upload.upload(@bucket, @path_prefix)
    end

    index_object = @bucket.objects[@path_prefix + folder_name + "/index.html"]
    index_object.write(to_html)
    index_object.url_for(:read).to_s
  end

  def to_html
    "<html><body>#{@uploads.map(&:to_html).join}</body></html>"
  end
end
