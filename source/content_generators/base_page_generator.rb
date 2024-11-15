class BasePageGenerator < ContentGenerator
  def section_handler_list
    [
      HeaderSectionHandler.new,
      ParaSectionHandler.new
    ]
  end

  def geninternalmenu(curpagepi, context, treehash, name, rel_location = nil)

    this = self

    context.accordion do

      menutitle = %Q{<a href="#{rel_location}" class="menulink">#{name}</a>}

      menutitle = name if rel_location.nil?
      menutitle = %Q{#{name} <} if curpagepi.rel_location == rel_location

      collapsed true unless curpagepi.rel_location.start_with?(treehash[:name])
      # puts "DEBUGG #{curpagepi.rel_location} AND #{treehash[:name]}"

      tab menutitle do
        ul do
          treehash[:files].each do |pname, nm|

            # homepage link already made
            next if nm[:pi].rel_location == rel_location

            # dont make if this page has a directory
            next if treehash[:dirs].key?(pname)

            # link to child page
            if curpagepi.rel_location == nm[:pi].rel_location
              li title: "This is the current page" do 
                text "#{nm[:pi].yaml['title']} <"
              end

            else
              a href: nm[:pi].rel_location do
                li nm[:pi].yaml['title']
              end
            end
          end

          li do
            treehash[:dirs].each do |k, tre|
              pageinfo = treehash[:files][k]&.fetch(:pi)
              loc = pageinfo&.rel_location
              title = pageinfo&.yaml&.fetch('title') || k.humanize
              this.geninternalmenu(curpagepi, self, tre, title, loc)
            end
          end

        end
      end

    end
  end

  def genmenu(context)
    this = self

    treehash = {
      name: '/',
      files: {},
      dirs: {}
    }

    pi.tree.each do |path, tpi|
      z = treehash
      path.split('/')[1..-1].each do |part|
        if part.end_with?('.nd')
          z[:files][part[0..-4]] = { name: part, path: path, pi: tpi }
          break
        else
          z[:dirs][part] ||= { name: "/#{path.split('/')[1..-2].join('/')}", files: {}, dirs: {} }
          z = z[:dirs][part]
        end
      end
    end

    context.div class: "menu" do
      this.geninternalmenu(this.pi, self, treehash, "Home", "/")

    end

  end

  def generate!
    this = self
    flist = flatlist
    @context.row do

      col 12 do
        div class: "row" do

          div class: "hidden-xs hidden-sm col-md-2 col-lg-2" do
            this.genmenu(self)
          end

          div class: "col-xs-12 col-sm-12 col-md-10 col-lg-10 col-print-12" do

            row do

              flist.each do |s|

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
      end

    end
  end
end
