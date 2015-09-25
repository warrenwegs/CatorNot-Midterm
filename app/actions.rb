# Homepage (Root path)
helpers do
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end

before do
  @errors = []
end

get '/' do
  erb :index
end

get "/signup" do
  @user = User.new
  erb :'users/signup'
end

get '/vote' do
  @questions = Question.last
  erb :vote
end

get '/user/results' do
  @questions = current_user.questions
  erb :'user/results'
end

post '/signup' do
  @user = User.new(
    first_name: params[:first_name],
    last_name: params[:last_name],
    user_name: params[:username],
    email: params[:email],
    password: params[:password],
    password_confirmation: params[:password_confirmation]
    )
  if @user.save
    session[:user_id] = user.id
    redirect '/'
  else
    @errors.concat [@user]
        .map(&:errors)
        .flat_map(&:to_a)
    erb :'users/signup'
  end
end


get '/new_post' do
  redirect '/signin' if current_user.nil?
  @question = Question.new
  @item1 = Item.new
  @item2 = Item.new
  erb :new_post
end

post '/new_post' do

  Question.transaction do
    @question = Question.create(user_id: current_user.id, category: params[:category])
    @item1 = Item.create(question: @question, name: params[:item1_name], url: params[:item1_url] )
    @item2 = Item.create(question: @question, name: params[:item2_name], url: params[:item2_url] )
    @question.update(item1: @item1, item2: @item2)

    if @question.valid? && @item1.valid? && @item2.valid?
      return redirect '/user/results'
    else
      @errors.concat [@question, @item1, @item2]
        .map(&:errors)
        .flat_map(&:to_a)
      raise ActiveRecord::Rollback, "Validation failed"
    end
  end
  erb :new_post
end


get '/signin' do
  erb :'/users/signin'
end

post '/signin' do
  @user = User.where(email: params[:email])
             .first
             .authenticate(params[:password])
  if @user
    session[:user_id] = @user.id
    redirect '/'
  else
    @errors << "Username/Password combination is incorrect"
    erb :'users/signin'
  end
end

get "/logout" do
  session.clear
  redirect '/'
end