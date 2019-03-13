module CoreHelper
  def attachment_path(filename)
    Rails.root.join('spec', 'fixtures', filename)
  end
end
