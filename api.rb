require 'sinatra'
require_relative 'parser'
require_relative 'compiler'

$tree = Parser::Parser.parse('This is a <<test>> of {|a> the |b> syntax |c> stuff }for this thing')

get '/edit-test' do
	options = Compiler::Compiler.get_options($tree)

	"<p contentEditable='true'>" + options.to_s
end

get '/submit-test' do
	Rack::Utils.escape_html(Compiler::Compiler.compile($tree, { :variables => {:test => "blahblah"},
																														  :options => ["c"] }
																										).to_s
												 )
end
