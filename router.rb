require 'sinatra'
require 'haml'
require_relative 'parser'
require_relative 'compiler'

set :sessions, secret: "change_me",
	httponly: true
	

def build_choices(params)
	choices = { :variables => Hash.new, :options => Array.new }
	params.each do |k,v|
		choices[:options] << v.split('_').drop(1).join if v =~ /^option_.*/
		choices[:variables][k.split('_').drop(1).join.to_sym] = v if k =~ /^variable_.*/
	end
	choices
end

get '/style.css' do
	scss :style
end

get '/' do
	session[:tree] ||= Parser.parse("Here is some normal text. This is a <<variable>> for an insertion point. Include the same label in multiple places to save labour.\n\n{{|stuff> You can choose |otherstuff> One of these |yetotherstuff> Or you can leave the whole section out. {{|nested1> You can also <<nest>> elements. |nested2> Super rad! }} }}")
  session[:opts] = Compiler.get_options(session[:tree])
	haml :index
end

post '/submit' do
	compiled = Compiler.compile(session[:tree], build_choices(params))#.gsub(/\s+/, ' ') #reduce all spaces down to just one
	Rack::Utils.escape_html(compiled)
end

post '/upload' do
	if params[:file]
		tempfile = params[:file][:tempfile]
		name = params[:file][:filename]
	else
    return "No file selected"
  end

  while blk = tempfile.read(65536)
		session[:tree] = Parser.parse(blk)
  end
	session[:opts] = Compiler.get_options(session[:tree])
	redirect to '/'
end
