require 'psych'
require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'

LIST_OF_NAMES = 'public/users.yaml'

get '/' do
  redirect '/names'
end

get '/names' do
  @title = 'All Names'
  @names = Psych.load_file LIST_OF_NAMES

  erb :names
end

get '/user' do
  @name = params['name']

  erb :user
end
