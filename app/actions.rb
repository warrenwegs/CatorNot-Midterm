# Homepage (Root path)

get '/' do
  erb :index
end

get "/signup" do
  erb :'users/signup'
end

get '/vote' do
  erb :vote
end

get '/user/results' do
  erb :'user/results'
end
