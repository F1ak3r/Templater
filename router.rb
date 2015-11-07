# The router defines the behaviour of Templater's web frontend

require 'sinatra'
require 'haml'
require_relative 'parser'
require_relative 'compiler'

# Use the session cookie to store user-given templates and configurations
set :sessions, secret: "change_me",
  httponly: true

# Helper function for creating choice hashes for template compilation
def build_choices(params)
  choices = { variables: Hash.new, options: Array.new }
  params.each do |k,v|
    choices[:options] << v.split('_').drop(1).join if v =~ /^option_.*/
    choices[:variables][k.split('_').drop(1).join.to_sym] = v if k =~ /^variable_.*/
  end
  choices
end

# Serve CSS
get '/style.css' do
  scss :style
end

# Main page
get '/' do
  session[:tree] ||= Parser.parse(File.read("example.template"))
  session[:opts] = Compiler.get_options(session[:tree])
  haml :index
end

# Compile template with options
post '/submit' do
  compiled = Compiler.compile(session[:tree], build_choices(params))
  Rack::Utils.escape_html(compiled).gsub(/\n/,"<br>")
end

# Upload template
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
