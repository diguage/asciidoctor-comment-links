require 'minitest/autorun'
require 'asciidoctor'
require 'asciidoctor-comment-links'
require 'pathname'

class AsciidoctorCommentLinksTest < Minitest::Test
  def test_black_box_docs
    Asciidoctor.convert_file "#{Pathname.new(File.dirname(__FILE__)).realpath}/index.adoc", safe: :safe
  end
end