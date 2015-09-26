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
  erb :'user/signup'
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
    session[:user_id] = @user.id
    redirect '/'
  else
    @errors.concat [@user]
        .map(&:errors)
        .flat_map(&:to_a)
    erb :'user/signup'
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
    erb :new_post
  end
end

get '/signin' do
  erb :'/user/signin'
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
    erb :'user/signin'
  end
end


get "/comment/:question_id" do
  @comments = Comment.where(question_id: params[:question_id])
  erb :'comment'
end




get "/logout" do
  session.clear
  redirect '/'
end

get '/vote' do
  @question_ids = Question.pluck(:id).shuffle
  binding.pry
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


