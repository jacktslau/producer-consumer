require 'sinatra'

set :port, ENV["PORT"] || 5000

get '/' do
  File.read(File.join('views', 'index.html'))
end
