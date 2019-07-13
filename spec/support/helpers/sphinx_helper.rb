module SphinxHelper
  def sphinx_index
    ThinkingSphinx::Test.index
    # Wait for Sphinx to finish loading in the new index files.
    sleep 0.25 until sphinx_index_finished?
  end

  def sphinx_index_finished?
    Dir[Rails.root.join(ThinkingSphinx::Test.config.indices_location, '*.{new,tmp}*')].empty?
  end
end
