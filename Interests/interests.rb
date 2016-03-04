require 'psych'
require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'

LIST_OF_NAMES = 'public/users.yaml'

before do
  @info = Psych.load_file LIST_OF_NAMES
  @total_users = @info.size
  @total_interests = @info.inject(0) do |accum, info|
    $stderr.puts accum
    accum += info.last[:interests].size
  end
end

get '/' do
  redirect '/names'
end

get '/names' do
  @title = 'All Names'

  erb :names
end

get '/user' do
  @name = params['name']
  @title = "#{@name}'s Email and Interests"
  this_user = @info.find { |item| @name == item.first.to_s }
  @email = this_user.last[:email]
  @interests = this_user.last[:interests]

  erb :user
end

helpers do
  def other_users
    @info.reject { |item| item.to_s == @name }.map(&:first)
  end

  def user_as_link(name)
    <<-END
      <a href="/user?name=#{name}" class="navigate-to-user"
         id="navigate-to-user-#{name}">
        #{name}
      </a>
    END
  end
end
