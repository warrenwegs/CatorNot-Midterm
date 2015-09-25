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
  erb :'user/signup'
end

get '/user/results' do
  @user = User.find(current_user.id)
  @item1 = @user.questions.last.item1
  @item2 = @user.questions.last.item2
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

get '/new_post' do
  erb :'new_post'
end

post '/submit' do
  @question = Question.create(user_id: current_user.id, category: params[:category])
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
  erb :'/user/signin'
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

get '/vote' do
  @question_ids = Question.pluck(:id).shuffle
  i = 0
  until current_user.can_vote?(@question_ids[i]) || i == @question_ids.count - 1 do
    i += 1
  end

  if current_user.can_vote?(@question_ids[i])
    @question = Question.find(@question_ids[i])
    erb :vote
  else
    redirect '/'
  end

end

post "/vote" do
  if current_user.can_vote?(params[:question_id])
    Vote.create(
      user_id: params[:user_id],
      question_id: params[:question_id],
      item_id: params[:vote]
      )
    Comment.create(
      user_id: params[:user_id],
      question_id: params[:question_id],
      text: params[:comment_text]
      )
  end
  redirect '/vote'
end


