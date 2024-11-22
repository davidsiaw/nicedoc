class BasePageGenerator < ContentGenerator
  def section_handler_list
    [
      HeaderSectionHandler.new,
      ParaSectionHandler.new
    ]
  end

  def geninternalmenu(curpagepi, context, treehash, name, rel_location = nil, menutype = nil)

    this = self

    menutitle = %Q{<a href="#{rel_location}" class="menulink">#{name}</a>}

      menutype = :side
    if rel_location.nil?
      menutitle = name 
    end

    mtype = nil
    args = []
    case menutype
    when :side
      mtype = :accordion
    when :mobile
      mtype = :row
      #args = [class: "col-xs-2 col-sm-2 col-md-2 col-lg-2"]
    end

    if rel_location.nil?
      menutitle = name 
    end
    menutitle = %Q{<span id="selected">#{name}</span>} if curpagepi.rel_location == rel_location


    context.send(mtype, *args) do

      show_subfolders_only = false

      if !curpagepi.rel_location.start_with?(treehash[:name])
        collapsed true if menutype == :side
        show_subfolders_only = true if menutype == :mobile
      end

      # puts "DEBUGG #{curpagepi.rel_location} AND #{treehash[:name]}"

      if menutype == :mobile
        h5 menutitle
      end


      submtype = nil
      subargs = []
      case menutype
      when :side
        submtype = :tab
        subargs = [menutitle]
      when :mobile
        submtype = :div
        subargs = [class: "col-xs-12 col-sm-12 col-md-12 col-lg-12"]
      end

      send(submtype, *subargs) do

        emtype = nil
        eargs = []
        case menutype
        when :side
          emtype = :ul
        when :mobile
          emtype = :div
        end

        imtype = nil
        iargs = []
        ihash = {}
        case menutype
        when :side
          imtype = :li
        when :mobile
          imtype = :div
          ihash =  {style: "padding-left: 1em"}
        end

        send(emtype, *eargs) do
          treehash[:files].each do |pname, nm|

            next if show_subfolders_only

            # homepage link already made
            next if nm[:pi].rel_location == rel_location

            # dont make if this page has a directory
            next if treehash[:dirs].key?(pname)

            # link to child page
            if curpagepi.rel_location == nm[:pi].rel_location
              send(imtype, *iargs, ihash.merge(title: "This is the current page")) do 
                span nm[:pi].yaml['title'], id: "selected"
              end

            else
              a href: nm[:pi].rel_location do
                send(imtype, *iargs, ihash) do
                  text nm[:pi].yaml['title']
                end
              end
            end


          end

          send(imtype, *iargs, ihash) do
            treehash[:dirs].each do |k, tre|
              pageinfo = treehash[:files][k]&.fetch(:pi)
              loc = pageinfo&.rel_location
              title = pageinfo&.yaml&.fetch('title') || k.humanize
              this.geninternalmenu(curpagepi, self, tre, title, loc, menutype)
            end
          end

        end
      end

    end
  end

  def genmenu(context, menutype)
    this = self

    treehash = {
      name: '/',
      files: {},
      dirs: {}
    }

    pi.tree.sort_by{|a,b| a}.each do |path, tpi|
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

    cls = case menutype
    when :side
      "hidden-xs hidden-sm col-md-2 col-lg-2 col-print-hidden"
    when :mobile
      "col-xs-12 col-sm-12 hidden-md hidden-lg col-print-hidden"
    end

    context.div class: cls do
      div class: "menu #{menutype}menu" do
        homepage_title = this.pi.tree['pages/top.nd'].yaml&.fetch('title')
        this.geninternalmenu(this.pi, self, treehash, homepage_title, "/", menutype)
      end
    end

  end

  def gencontent(context)
    this = self
    flist = flatlist
    context.div class: "col-xs-12 col-sm-12 col-md-10 col-lg-10 col-print-12" do

      row do

        flist.each do |s|
          col 12 do
            div class: '' do

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

  def generate!
    this = self
    @context.row do
      # main page structure

      col 12 do
        # main
        div class: "row" do
          this.genmenu(self, :side)

          this.gencontent(self)
        end

        # mobilemenu
          this.genmenu(self, :mobile)
      end
    end
  end
end
