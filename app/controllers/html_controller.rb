class HtmlController < CompilerController

  def index
    source_path = "app/views/html/example_email.html"
    source_file = File.open(source_path, 'r')
    contents = source_file.read
    @input_file = CodeRay.scan(contents, :html).div(line_numbers: nil).gsub(/\n/, '<br>')
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
