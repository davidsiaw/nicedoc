puts 'using spec_helper'

require_relative '../source/content_generator'
Dir["source/content_generators/*.rb"].each { |x| require_relative "../#{x}" }
Dir["source/section_handlers/*.rb"].each { |x| require_relative "../#{x}" }
Dir["source/block_handlers/*.rb"].each { |x| require_relative "../#{x}" }
Dir["source/line_handlers/*.rb"].reverse.each { |x| require_relative "../#{x}" }

require_relative '../source/block'
require_relative '../source/blockifier'
require_relative '../source/nicedoc_renderer'
require_relative '../source/section'
require_relative '../source/sectionifier'
