module Parser
	require 'treetop'
	require 'json'

	require_relative 'template_nodes'

	$base_path = File.expand_path(File.dirname(__FILE__))

	class Parser
		Treetop.load(File.join($base_path, 'template_parser.treetop'))
		@@parser = TemplateParser.new

		def self.parse(data)
			tree = @@parser.parse(data)

			if (tree.nil?)
				raise Exception, "Parse error at offset: #{@@parser.index}\nThe parser says: #{@@parser.failure_reason}"
			end

			tree.value
		end

	end

	tree = Parser.parse('<<value>> This {|thing> <<is>> an {|nested> stuff <<and>> things} |other> option } test.')
	puts tree
	require_relative 'compiler'
	puts Compiler::Compiler.compile(tree, { :variables => { :is => "are",
																													:and => "'n'",
																													:value => "blahblah" },
																					:options => ["thing","nested"] }
																 ).gsub(/\s+/, ' ') #reduce all spaces down to just one
end
