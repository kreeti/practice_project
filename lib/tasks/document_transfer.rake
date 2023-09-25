namespace :document_transfer do
  desc "transfer documents from Local to AWS"
  task migrate_to_s3: :environment do
    Attachment.find_each.with_index do |attachment, n|
      path = attachment.send(:document).path

      next if path.nil?

      begin
        file = File.join(Rails.public_path + "system", path)
        id = file.match(%r{/(\d+)\/original\/.+$/})[1]
        attach = File.open file
        Attachment.find(id).update(document: attach)
        puts "-> Saved #{path} to S3 (#{n}/#{Attachment.count})"
      rescue Aws::S3::Errors::NoSuchBucket => e
        puts "--- Bucket #{bucket_name} does not exists---"
      rescue StandardError => e
        puts "Error on (#{n}/#{Attachment.count}): #{e}"
      end
    end
  end
end
