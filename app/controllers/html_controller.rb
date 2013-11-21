class HtmlController < CompilerController

  def index
    src_html_path = "app/views/html/example_email.html"
    src_html_file = File.open(src_html_path, 'r').read
    @input_html   = CodeRay.scan(src_html_file, :html).div(line_numbers: nil).gsub(/\n/, '<br>')

    src_css_path  = "app/assets/stylesheets/test.css"
    src_css_file  = File.open(src_css_path, 'r').read
    @input_css    = CodeRay.scan(src_css_file, :css).div(line_numbers: nil).gsub(/\n/, '<br>')

    html_doc  = Hpricot.parse(File.read(src_html_path))
    css_doc   = CSSPool.CSS open(src_css_path)
    output_array = []
    css_doc.rule_sets.each do |rule_set|
      rule_set.selectors.each do |selector|
        elements = html_doc.search(selector)
        elements.each do |matched_elem|
          style_array = rule_set.declarations.map{|d| d}
          matched_elem.set_attribute :style, style_array.join(' ')
          output_array.push matched_elem
        end
      end
    end
    @output_html = output_array.join("\n")
    @output_html_colored = CodeRay.scan(@output_html, :html).div(line_numbers: nil).gsub(/\n/, '<br>')
    # p_tag     = html_doc.search('//p').first
    # css_doc.rules_matching(p_tag).each do |rule|
    #   p rule
    # end

  end

  def compile
    # grab the uploaded file
    # file = retrieve_source

    # fetch stylesheets (style tags, both in-doc and external
    # in the order they are declared
    # find_style_declarations

    # compress them into one block of text


    # take each declared block of the CSS,
    # search the DOM for where the rule would target

    # apply the styles inline

    # start building a JSON object which will output as HTML

    # properly indent it all
  end

  def retrieve_source
  end

end
