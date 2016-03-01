require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'

get '/' do
  @title = 'Dynamic Directory Index'
  @directory_name = File.join Dir.pwd, 'public'
  @files = Dir.entries(@directory_name).select do |file_name|
    File.file? File.join(@directory_name, file_name)
  end

  erb :index
end
