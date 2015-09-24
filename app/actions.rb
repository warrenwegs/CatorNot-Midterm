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
post '/new_user' do
  @user = User.new(
    first_name: params[:first_name],
    last_name: params[:last_name],
    user_name: params[:username],
    email: params[:email],
    password: params[:password],
    password_confirmation: params[:password_confirmation],
    )
  # binding.pry
  if @user.save
    redirect '/'
  else
    redirect '/signup'
  end
end

