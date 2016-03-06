require 'sinatra'
require 'sinatra/reloader' if development?
require 'tilt/erubis'

TABLE_OF_CONTENTS = 'data/toc.txt'
CHAPTER_TEXT = 'data/chp%{chapter_number}.txt'

before do
  @contents = File.readlines TABLE_OF_CONTENTS
end

helpers do
  def emphasize(text, word)
    word_re = Regexp.new(word, Regexp::IGNORECASE)
    text.gsub(word_re, "<strong>#{word}</strong>")
  end

  def in_paragraphs(text)
    paragraphs = text.split("\n\n").each_with_index.map do |paragraph, index|
      "<p id='para_#{index}'>#{paragraph}</p>"
    end
    paragraphs.join
  end
end

def load_chapter(chapter_number)
  chapter_file = format CHAPTER_TEXT, chapter_number: chapter_number
  File.read chapter_file, encoding: 'UTF-8'
end

def search(contents, query)
  search_term = query.downcase
  contents.each_with_index.each_with_object([]) do |chapter, found|
    chapter_title, chapter_number = chapter
    text = load_chapter(chapter_number + 1)
    text.split("\n\n").each_with_index do |paragraph, paragraph_index|
      next unless paragraph.downcase.include? search_term
      found << [chapter_title, chapter_number, paragraph, paragraph_index]
    end
  end
end

get '/' do
  @title = 'The Adventures of Sherlock Holmes'

  erb :home
end

get '/chapter/:chapter_number' do |chapter_number|
  @title = "Chapter #{chapter_number}: #{@contents[chapter_number.to_i - 1]}"
  @text = load_chapter chapter_number

  erb :chapter
end

get '/search' do
  @results = search @contents, params[:query] if params[:query]

  erb :search
end

not_found do
  redirect '/'
end
