require 'asciidoctor'

module AsciidoctorCommentLinks
  # Matches http:// and https:// URLs in comments. Whitespace, quotes, angle
  # brackets, and closing brackets are excluded so the generated link does not
  # swallow trailing punctuation.
  URL_PATTERN = %r!https?://[^\s<>"'\])}]+!i

  # CodeRay wraps a comment in a single span: <span class="comment">...</span>.
  CODERAY_COMMENT_SPAN_RX = %r{<span class="comment">[^<]*</span>}

  # Pygments wraps a comment in a span whose class starts with tok-c, e.g.
  # tok-c1 (single), tok-cm (multiline), tok-cp (preproc), tok-cs (special).
  PYGMENTS_COMMENT_SPAN_RX = %r{<span class="tok-c(?:pf|1|m|p|s|h)?">[^<]*</span>}

  # Converts URLs in +text+ into HTML links that open in a new tab.
  def self.linkify(text)
    text.gsub URL_PATTERN, '<a href="\&" target="_blank">\&</a>'
  end

  # Links URLs inside comment spans in HTML returned by a server-side
  # highlighter. +result+ may be a String or a [html, line_offset] tuple.
  def self.linkify_highlight_result(result, comment_span_rx)
    html = result.is_a?(Array) ? result[0] : result
    linked = html.gsub(comment_span_rx) { |span| linkify span }
    result.is_a?(Array) ? [linked, result[1]] : linked
  end

  # Rouge
  class CommentLinksRougeAdapter < (Asciidoctor::SyntaxHighlighter.for 'rouge')
    register_for 'rouge'

    def create_formatter node, source, lang, opts
      formatter = super
      formatter.singleton_class.prepend (Module.new do
        def safe_span tok, safe_val
          if tok.token_chain[0].matches? ::Rouge::Token::Tokens::Comment
            safe_val = AsciidoctorCommentLinks.linkify safe_val
          end
          super
        end
      end)
      formatter
    end
  end

  # CodeRay
  class CommentLinksCodeRayAdapter < (Asciidoctor::SyntaxHighlighter.for 'coderay')
    register_for 'coderay'

    def highlight node, source, lang, opts
      AsciidoctorCommentLinks.linkify_highlight_result super, CODERAY_COMMENT_SPAN_RX
    end
  end

  # Pygments
  class CommentLinksPygmentsAdapter < (Asciidoctor::SyntaxHighlighter.for 'pygments')
    register_for 'pygments'

    def highlight node, source, lang, opts
      AsciidoctorCommentLinks.linkify_highlight_result super, PYGMENTS_COMMENT_SPAN_RX
    end
  end

  # highlight.js performs highlighting in the browser, so the links have to be
  # added client-side after highlight.js has run.
  class CommentLinksHighlightJsAdapter < (Asciidoctor::SyntaxHighlighter.for 'highlight.js')
    register_for 'highlightjs', 'highlight.js'

    def docinfo location, doc, opts
      result = super
      location == :footer ? %(#{result}\n#{LINKIFY_COMMENT_LINKS_SCRIPT}) : result
    end
  end

  LINKIFY_COMMENT_LINKS_SCRIPT = <<~'SCRIPT'.rstrip
    <script>
    (function () {
      var re = /https?:\/\/[^\s<>"'\])}]+/gi;
      var comments = document.querySelectorAll('.hljs-comment');
      for (var i = 0; i < comments.length; i++) {
        comments[i].innerHTML = comments[i].innerHTML.replace(re, '<a href="$&" target="_blank">$&</a>');
      }
    })();
    </script>
  SCRIPT
end
