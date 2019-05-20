module AttachmentHelper
  def add_attachment(filename, link: 'Add attachment', klass: '.attachment-fields', field: 'File')
    click_on link
    last_attachment = find_all(klass, minimum: 1).last
    within(last_attachment) { attach_file field, attachment_path(filename) }
  end
end
