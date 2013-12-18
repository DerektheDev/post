module Compiler

  def self.syntax_highlight input, ext
    input_string = input.kind_of?(File) ? File.read(input) : input
    CodeRay.scan(input_string, ext).div(line_numbers: nil).gsub(/\n/, '<br>')
  end

  def self.get_ext file
    output = File.extname(File.basename file).gsub(/\./,'').to_sym
    output = output == :scss ? :sass : output
  end

end
