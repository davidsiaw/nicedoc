require 'yaml'

class LineParser

  def initialize(text)
    @text = text
  end

  def tree
    return {array: []} if @text.nil?
  
    pw = ParserWalker.new(@text)

    #p pw.parse_positions

    {
      array: pw.spans
    }
  end
end
