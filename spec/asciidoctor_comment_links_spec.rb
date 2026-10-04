# frozen_string_literal: true

describe AsciidoctorCommentLinks do
  context 'require' do
    it 'should register the Rouge syntax highlighter adapter when the library is required' do
      (expect Asciidoctor::SyntaxHighlighter.for('rouge')).to be described_class::CommentLinksRougeAdapter
    end

    it 'should be able to require the library from a fresh Ruby process' do
      script_file = fixture_file 'require.rb'
      begin
        File.write script_file, <<~'END'
        require 'asciidoctor'
        require 'asciidoctor-comment-links'
        puts Asciidoctor::SyntaxHighlighter.for 'rouge'
        END
        output = %x(#{ruby} #{Shellwords.escape script_file}).lines.map(&:chomp)
        (expect output).to eql ['AsciidoctorCommentLinks::CommentLinksRougeAdapter']
      ensure
        File.unlink script_file
      end
    end
  end

  context 'VERSION' do
    it 'should define a VERSION constant that adheres to SemVer' do
      (expect described_class::VERSION).to match %r/^\d+\.\d+\.\d+(\.[a-z]\S*)?$/
    end

    it 'should be able to require the version file from a fresh Ruby process' do
      script_file = fixture_file 'print_version.rb'
      begin
        File.write script_file, <<~'END'
        require 'asciidoctor-comment-links/version'
        puts AsciidoctorCommentLinks::VERSION
        END
        output = %x(#{ruby} #{Shellwords.escape script_file}).lines.map(&:chomp)
        (expect output).to eql [described_class::VERSION]
      ensure
        File.unlink script_file
      end
    end
  end

  context 'Rouge formatter' do
    it 'should convert HTTP and HTTPS URLs in comments into links that open in a new window' do
      input = <<~'END'
      :source-highlighter: rouge

      [source,java]
      ----
      // Visit https://example.com/docs and http://example.org/docs
      String url = "https://example.com/internal";
      ----
      END

      actual = Asciidoctor.convert input, safe: :safe
      (expect actual).to include '<a href="https://example.com/docs" target="_blank">https://example.com/docs</a>'
      (expect actual).to include '<a href="http://example.org/docs" target="_blank">http://example.org/docs</a>'
    end

    it 'should convert URLs in block comments into links' do
      input = <<~'END'
      :source-highlighter: rouge

      [source,java]
      ----
      /**
       * @author D瓜哥 · https://www.diguage.com/
       */
      ----
      END

      actual = Asciidoctor.convert input, safe: :safe
      (expect actual).to include '<a href="https://www.diguage.com/" target="_blank">https://www.diguage.com/</a>'
    end

    it 'should convert a plain HTTP URL in a comment into a link' do
      input = <<~'END'
      :source-highlighter: rouge

      [source,java]
      ----
      // Visit http://example.org/docs
      ----
      END

      actual = Asciidoctor.convert input, safe: :safe
      (expect actual).to include '<a href="http://example.org/docs" target="_blank">http://example.org/docs</a>'
    end

    it 'should not include trailing punctuation in the generated link' do
      input = <<~'END'
      :source-highlighter: rouge

      [source,java]
      ----
      // See (https://example.com/docs).
      ----
      END

      actual = Asciidoctor.convert input, safe: :safe
      (expect actual).to include '<a href="https://example.com/docs" target="_blank">https://example.com/docs</a>'
      (expect actual).not_to include 'href="https://example.com/docs)"'
    end

    it 'should not convert URLs that appear outside comments' do
      input = <<~'END'
      :source-highlighter: rouge

      [source,java]
      ----
      // Visit https://example.com/docs
      String url = "https://example.com/internal";
      ----
      END

      actual = Asciidoctor.convert input, safe: :safe
      (expect actual).to include 'href="https://example.com/docs"'
      (expect actual).not_to include '<a href="https://example.com/internal"'
    end
  end
end
