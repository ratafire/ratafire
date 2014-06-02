Paperclip::Attachment.default_options.merge!(
  storage:              :s3,
  s3_credentials:       Rails.configuration.aws,
  s3_protocol:          'https'
)