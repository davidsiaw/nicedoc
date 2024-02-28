class BlogPageGenerator < ContentGenerator
  def generate!
    sections.each do |s|
      s.display(@context, debug: debug)
    end
  end
end
