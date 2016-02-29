require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'

TABLE_OF_CONTENTS = 'data/toc.txt'

get '/' do
  @title = 'The Adventures of Sherlock Holmes'
  @contents = File.readlines TABLE_OF_CONTENTS
  erb :home
end
