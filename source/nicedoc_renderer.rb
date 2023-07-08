class NicedocRenderer
    def initialize(contents, yaml)
      @contents = contents
      @yaml = yaml
    end
  
    def generate(path, context)
      rcontext = self
      yaml = @yaml
      theme = @yaml['theme'] || "indigo"

      context.empty_page path, "#{yaml['title'] || "_"}" do
        request_css "css/#{theme}.css"
        row do
          col 9 do
            h1 yaml['title']
          end
        end

        rcontext.generate_contents(self)
      end

      context.empty_page "#{path}.src", "source of #{path}" do
        request_css 'css/indigo.css'
        row do
          col 9 do
              pre File.read(filename)
          end
        end
      end
    end

    def generate_contents(context)
      contents = @contents
  
      blocks = []
      superblocks = []
  
      contents.split(/\n\n+/).select {|x| x.length != 0}.each do |blk|
        if blk.start_with?('#')
          superblocks << blocks if blocks.length != 0
          blocks = []
  
          blocks << Block.new(
            type: :header,
            lines: blk.split("\n")
          )
        elsif blk.start_with?('*note*')
          superblocks << blocks[0..-2]
          blocks = [blocks[-1]]
  
          blocks << Block.new(
            type: :note,
            lines: blk.split("\n")
          )
        elsif blk.start_with?(/\+(\-+\+)+/)
          blocks << Block.new(
            type: :table,
            lines: blk.split("\n")
          )
        elsif blk.start_with?('- ')
          blocks << Block.new(
            type: :ul,
            lines: blk.split("\n")
          )
        elsif blk.start_with?('--')
          blocks << Block.new(
            type: :hr,
            lines: []
          )
        elsif blk.start_with?(/  [^ ]/)
          blocks << Block.new(
            type: :paragraph,
            lines: blk.split("\n")
          )
        else
          blocks << Block.new(
            type: :ordinary,
            lines: blk.split("\n")
          )
        end
      end
  
      superblocks << blocks
  
      context.instance_exec do
        
        superblocks.each_with_index do |superblock, superindex|
  
          noteblock = []
  
          row do
            col 12, lg: 8, md: 9 do
              superblock.each_with_index do |block, index|
                if block.type == :note
                  noteblock << block
                  next
                end
        
                if block.type == :header
                  div class: :pagebreak do end if superindex != 0 || index != 0
                  h2 "#{block.lines.join('').sub(/^\# */, '')}"
                elsif block.type == :paragraph
                  p do
                    block.generate(self)
                  end
                elsif block.type == :ul
                  ul do
                    block.lines.each do |line|
                      li line.sub(/^- */, '')
                    end
                  end
                elsif block.type == :table
                  div class: "simpletable" do
                    table do
                      thead do
                        block.lines[1].split('|').compact.each do |x|
                          next if x.length == 0
                          th x
                        end
                      end
                      block.lines[2..-1].each do |line|
                        if line.start_with?('|')
                          tr do
                            line.split('|').compact.each do |x|
                              next if x.length == 0
                              td x
                            end
                          end
                        end
                      end
                    end
                  end
                elsif block.type == :hr
                  hr
                else
                  div do
                    block.generate(self)
                  end
                end
  
              end
        
            end
  
            col 12, lg: 3, md: 3 do
              noteblock.each_with_index do |block, index|
                blockquote block.lines[1..-1].join(' ')
              end
            end
          end
        end
      end
    end
  end
