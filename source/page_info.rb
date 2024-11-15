class PageInfo
  attr_reader :root_page, :cur_page, :tree
  attr_accessor :yaml
  
  def initialize(root_page, cur_page, tree)
    @root_page = root_page
    @cur_page = cur_page
    @tree = tree
  end

  def rel_filepath
    cur_page.sub(/^#{root_page}/, '')
  end

  def rel_location
    if cur_page == "#{root_page}/top.nd"
    	return "/"
    end

    rel_filepath.sub(/\.nd$/, '/')
  end

  def title
  end
end
