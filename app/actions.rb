# Homepage (Root path)
helpers do
  def current_user
    @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
  end
end

get '/' do
  erb :'index'
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
    redirect '/signup'
  end
end

get '/signin' do
  erb :'signin'
end
# get "/logout"
# end
