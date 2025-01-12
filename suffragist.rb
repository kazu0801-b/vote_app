require 'yaml/store'
require 'sinatra'

get '/' do
    @title = 'Welcome to the Suffragist!'
    erb :index
end

Choices = {
  'HAM' => 'Hamburger',
  'PIZ' => 'Pizza',
  'CUR' => 'Curry',
  'NOO' => 'Noodles',
}

post '/cast' do
    @title = 'Thanks for casting your vote!'
    @vote  = params['vote']
    @store = YAML::Store.new 'votes.yaml'
    @store.transaction do
      @store['votes'] ||= {}
      @store['votes'][@vote] ||= 0
      @store['votes'][@vote] += 1
    end
    erb :cast
end

get '/results' do
    @title = 'Results so far:'
    @store = YAML::Store.new 'votes.yaml'
    @votes = @store.transaction { @store['votes'] }
    erb :results
end