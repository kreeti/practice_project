if Rails.env.production?
  Paperclip::Attachment.default_options.update(
    path: ":class/:attachment/:id_partition/:style/:filename",
    hash_secret: "31f264fd35f07168b38829aaeffe3ccfb853ce69f580480323cdf103a18ee092a0be1ec16abb425054b",
    convert_options: {
      all: "-interlace Plane -strip"
    },
    storage: :s3,
    s3_credentials: {
      bucket: Rails.application.credentials.aws[:bucket],
      s3_region: Rails.application.credentials.aws[:s3_region],
      s3_host_name: "#{ENV['AWS_BUCKET']}.s3.amazonaws.com"
    },
    s3_permissions: :private
  )
end
