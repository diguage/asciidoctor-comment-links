require 'asciidoctor'

module AsciidoctorCommentLinks
  class CommentLinksTreeProcessor < Asciidoctor::Extensions::TreeProcessor
    def process(document)
      highlighter_type = document.attributes.fetch('source-highlighter')
      if blank?(highlighter_type)
        return;
      end
      code_blocks = document.blocks.select { |b| :source == b.style }
      if code_blocks.nil? || code_blocks.empty?
        return;
      end
      code_blocks.each do |block|
        language = block.attributes.fetch('language')
        if blank?(language)
          return;
        end
        # HTML
        # Java\
        block.lines.each_with_index do |element, index|
          if (element.include? 'http://') || (element.include? 'https://')
            puts element
          end
        end
      end
    end

    def blank? (str)
      str.nil? || str.strip.empty?
    end
  end
end

Asciidoctor::Extensions.register do
  tree_processor AsciidoctorCommentLinks::CommentLinksTreeProcessor
end