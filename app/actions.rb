# Homepage (Root path)
helpers do
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end

get '/' do
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
  @user = User.find(session[:user])
  @item1 = @user.questions.last.items.first
  @item2 = @user.questions.last.items.last
  erb :'user/results'
end

post '/signup' do
  user = User.new(
    first_name: params[:first_name],
    last_name: params[:last_name],
    user_name: params[:username],
    email: params[:email],
    password: params[:password],
    password_confirmation: params[:password_confirmation]
    )
  if user.save
    session[:user_id] = user.id
    redirect '/'
  else
    @error = "Some shit happened"
    erb :'/signup'
  end
end

post '/submit' do
  @question = Question.create(user_id: session[:user], category: params[:category])
  @item1 = Item.create(question_id: @question.id, name: params[:item1_name], url: params[:item1_url] )
  @item2 = Item.create(question_id: @question.id, name: params[:item2_name], url: params[:item2_url] )
  @question.update(item1_id: @item1.id, item2_id: @item2.id)

  if @question.errors.empty? && (@item1.errors.empty? && @item2.errors.empty?)
     redirect 'user/results'
  else
    redirect '/'
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


