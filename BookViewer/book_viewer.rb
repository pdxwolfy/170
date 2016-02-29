require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'

TOC = 'data/toc.txt'

get '/' do
  @title = 'The Adventures of Sherlock Holmes'
  @toc = File.read TOC
  erb :home
end
