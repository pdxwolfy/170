require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'

get '/' do
  @title = 'Dynamic Directory Index'
  @directory_name = File.join Dir.pwd, 'public'
  @sequence = params['sequence']

  @files = select_files all_entries_in(@directory_name), @directory_name
  @files.reverse! if @sequence == 'descending'

  erb :index
end

def all_entries_in(directory_name)
  Dir.entries(directory_name).sort do |name_a, name_b|
    name_a.downcase <=> name_b.downcase
  end
end

def select_files(directory_entries, directory_name)
  directory_entries.select do |file_name|
    File.file? File.join(directory_name, file_name)
  end
end
