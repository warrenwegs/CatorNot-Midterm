# Homepage (Root path)
helpers do
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end

get '/' do

  # Doing extra stuff

  erb :index
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

post '/signup' do
  user = User.new(
    first_name: params[:first_name],
    last_name: params[:last_name],
    user_name: params[:username],
    email: params[:email],
    password: params[:password],
    password_confirmation: params[:password_confirmation],
    )
  if user.save
    session[:user_id] = user.id
    redirect '/'
  else
    @error = "Some shit happened"
    erb :'/signup'
  end
end


get '/signin' do
  erb :'/users/signin'
end

post '/signin' do
  user = User.where(email: params[:email])
             .first
             .authenticate(params[:password])

  if user
    session[:user_id] = user.id
    redirect '/'
  else
    @error = "Username/Password combination is incorrect"
    erb :signin
  end
end



get "/logout" do
  session.clear
  redirect '/'
end

