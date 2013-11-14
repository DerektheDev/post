class HtmlController < CompilerController

  def compile
    # grab the uploaded file
    file = retrieve_source

    # fetch stylesheets (style tags, both in-doc and external
    # in the order they are declared
    find_style_declarations

    # compress them into one block of text


    # take each declared block of the CSS,
    # search the DOM for where the rule would target

    # apply the styles inline

    # start building a JSON object which will output as HTML

    # properly indent it all
  end

  def retrieve_source
    source = File.open("my/file/path", "r")
  end

  def find_style_declarations
    style_block_open = false

    file.each_line do |line|
      if line =~ /\<style/
        style_block_open = true
        # if this line contains (not begins with, just contains)
        # "<style", copy that line all the way to the end of the tag
        # push the entire string into the first index of an array
      elsif line =~ /\<\/style/
        style_block_open = false
        # If the next line contains "</style", this is the last line.
        # Take all the contents of this line up until the tag closes
        # and push it into the next index of that array.
        # Close this json object, and move onto the next one.
        # (style_block_open = false)
      end

      # Otherwise, if this line does not qualify as a "beginning"
      # or an "end" to a style tag, but we have not yet reached
      # the end of the style tag block (style_block_open), this is
      # a CSS rule. Pass this line into the array of lines to
      # qualify as a CSS rule.

      # Finally, if the line does not fall in between two style blocks
      # (style_block_open = false), ignore it. Move onto the next bit.
    end
  end

end
