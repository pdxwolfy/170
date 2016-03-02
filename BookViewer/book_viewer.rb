require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'

TABLE_OF_CONTENTS = 'data/toc.txt'
CHAPTER_TEXT = 'data/chp%{chapter_number}.txt'

def initialize_common_variables
  @contents = File.readlines TABLE_OF_CONTENTS
end

get '/' do
  initialize_common_variables
  @title = 'The Adventures of Sherlock Holmes'
  erb :home
end

get '/chapter/:chapter_number' do |chapter_number|
  initialize_common_variables
  @title = "Chapter #{chapter_number}: #{@contents[chapter_number.to_i - 1]}"
  chapter_file = format CHAPTER_TEXT, chapter_number: chapter_number
  @paragraphs = File.readlines chapter_file, "\n\n"
  erb :chapter
end

get '/show/:name' do
  params[:name]
end
