module Compiler

  def self.syntax_highlight file
    CodeRay.scan(file, self.get_ext(file)).div(line_numbers: nil).gsub(/\n/, '<br>')
  end

  def self.get_ext file
    output = File.extname(File.basename file).gsub(/\./,'').to_sym
    output = output == :scss ? :sass : output
  end

end
