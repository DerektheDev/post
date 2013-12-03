class CompilerController < ApplicationController

  def index
    compile_styles(:css, "app/assets/stylesheets/test.css")
    compile_markup(:html, "app/views/markup/example_email.html")
  end

  def compile_markup filetype, doc_path
    if File.extname(doc_path) == '.html'
      send "compile_#{filetype}", doc_path
    end
  end

  def compile_styles filetype, doc_path
    if File.extname(doc_path) == '.css'
      @css_doc   = CSSPool.CSS(open(doc_path))
      @input_css = CodeRay.scan(@css_doc, :css).div(line_numbers: nil).gsub(/\n/, '<br>')
    end
  end

  def compile_html doc_path
    #
    # For media queries, we'll probably have to open the document,
    # quarantine the media queries out of the file (into a separate
    # array), and then place them in the head of the document when
    # finished.
    #

    html_doc      = Nokogiri::HTML open(doc_path)
    @input_html   = CodeRay.scan(html_doc, :html).div(line_numbers: nil).gsub(/\n/, '<br>')

    dom_output ||= []

    @css_doc.rule_sets.each do |rule_set|
      rule_set.selectors.each do |selector|
        # find elements matching this selector
        matched_elems = html_doc.css(selector.to_s)
        if matched_elems
          matched_elems.each do |node|
            # create an array of found elements
            # If we already have an element in this array that has the same
            # node path, simply add to its style string. This will prevent
            # styles from being overwritten by the new style declaration block.
            if index_match = dom_output.index{|pocket| pocket[:node].path == node.path}
              dom_output[index_match][:css].push selector.declarations
              dom_output[index_match][:node][:style] = dom_output[index_match][:css].join('').strip
            else
              # but if this is a new DOM element that has not yet been styled
              # then we can push it into the array as such
              node[:style] = selector.declarations.join('').strip
              dom_output.push({ node: node, css: selector.declarations })
            end
          end
        end
      end
    end

    @output_html = dom_output.map{|pocket| pocket[:node].to_html}.join("\n")
    @output_html_colored = CodeRay.scan(@output_html, :html).div(line_numbers: nil).gsub(/\n/, '<br>')
  end

end
