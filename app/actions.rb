# Homepage (Root path)

get '/' do
  erb :new_post
end

get "/signup" do
  erb :'users/signup'
end

get '/vote' do
  @question = Question.first
  erb :vote
end

get '/user/results' do
  erb :'user/results'
end

# get '/nowhere' do
#   erb :'nowhere'
# end