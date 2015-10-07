require 'sinatra'
require_relative 'parser'
require_relative 'compiler'

def build_options(params)
	options = { :variables => Hash.new, :options => Array.new }
	params.each do |k,v|
		options[:options] << k.split('_').drop(1).join if k =~ /^option_.*/
		options[:variables][k.split('_').drop(1).join.to_sym] = v if k =~ /^variable_.*/
	end
	options
end

get '/styles' do
	css :style
end

get '/' do
	erb :index
end

post '/submit-test' do
	options = build_options(params)
	puts options
	tree = Parser::Parser.parse("Testing revealed that this web application returned verbose error messages that revealed information about the <<thing>>. {{|normalinteraction> Some of the errors encountered were the result of unexpected user input, however, others were encountered during normal interactions with the web application.|unexpectedinput> Verbose error messages were primarily the result of the submission of unexpected user input.}} The information in these messages could be used by an attacker to develop targeted attacks against the application.")
	compiled = Compiler::Compiler.compile(tree,options).gsub(/\s+/, ' ') #reduce all spaces down to just one
	Rack::Utils.escape_html(compiled)
end
