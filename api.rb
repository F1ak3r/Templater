require 'sinatra'
require_relative 'parser'
require_relative 'compiler'

$tree = Parser::Parser.parse('<<value>> This {t<test>t} {{|thing> <<is>> an {{|nested> (stuff) <<and>> things}} |other> option }} test.')

get '/edit-test' do
	"<p contentEditable='true'>#{Rack::Utils.escape_html($tree.test)}</p>"
end

get '/submit-test' do
	compiled = Compiler::Compiler.compile(tree, { :variables => { :is => "are",
																													:and => "'n'",
																													:value => "blahblah" },
																					:options => ["thing","nested"] }
																 ).gsub(/\s+/, ' ') #reduce all spaces down to just one
	Rack::Utils.escape_html(compiled)
end
