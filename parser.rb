# The parser uses the grammar and behaviour definitions to actually parse some input

module Parser
  require 'treetop'
  require 'json'
  require_relative 'template_nodes'

  base_path = File.expand_path(File.dirname(__FILE__))

  Treetop.load(File.join(base_path, 'template_parser.treetop'))
  @@parser = TemplateParser.new

  module_function

  # Parse the given template source text and output tree
  def parse(data)
    tree = @@parser.parse data

    if tree.nil?
      raise Exception, "Parse error at offset: #{@@parser.index}\nThe parser says: #{@@parser.failure_reason}"
    end

    tree.value
  end
end
