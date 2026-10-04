require 'asciidoctor'

module AsciidoctorCommentLinks
  class CommentLinksRougeAdapter < (Asciidoctor::SyntaxHighlighter.for 'rouge')
    register_for 'rouge'

    def create_formatter node, source, lang, opts
      formatter = super
      formatter.singleton_class.prepend (Module.new do
        def safe_span tok, safe_val
          if tok.token_chain[0].matches? ::Rouge::Token::Tokens::Comment
            safe_val = safe_val.gsub %r/https?:\/\/\S+/, '<a href="\&" target="_blank">\&</a>'
          end
          super
        end
      end)
      formatter
    end
  end
end
