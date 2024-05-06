class BlogPageGenerator < ContentGenerator
  def section_handler_list
    [
      HeaderSectionHandler.new,
      ParaSectionHandler.new
    ]
  end

  def generate!
    this = self
    flatlist.each do |s|

      @context.row do
        col 12 do
          div class: 'blog_style' do

            consumed_by_handler = false
            this.section_handler_list.each do |sh|

              sh.pi = this.pi
              handled = sh.handle(s, self)

              if handled
                consumed_by_handler = true
                break
              end
            end
            raise "unconsumed section: #{s.type.inspect}" unless consumed_by_handler

          end
        end
      end

    end
  end
end
