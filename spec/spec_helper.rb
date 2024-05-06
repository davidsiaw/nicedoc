puts 'using spec_helper'

require_relative '../source/content_generator'
Dir["source/content_generators/*.rb"].each { |x| require_relative "../#{x}" }

require_relative '../source/section_handler'
Dir["source/section_handlers/*.rb"].each { |x| require_relative "../#{x}" }

require_relative '../source/block_handler'
Dir["source/block_handlers/*.rb"].each { |x| require_relative "../#{x}" }

Dir["source/line_handlers/*.rb"].sort.reverse.each { |x| require_relative "../#{x}" }

require_relative '../source/state_machine'
require_relative '../source/parser_builder'
require_relative '../source/parser_walker'
require_relative '../source/line_parser'
require_relative '../source/line_renderer'
require_relative '../source/block'
require_relative '../source/blockifier'
require_relative '../source/nicedoc_renderer'
require_relative '../source/section'
require_relative '../source/sectionifier'
