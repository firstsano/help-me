module AttachmentHelper
  def attach_file(locator = nil, filename, make_visible: nil, **options)
    path = Rails.root.join('spec', 'fixtures', filename)
    super locator, path, make_visible: make_visible, **options
  end
end
