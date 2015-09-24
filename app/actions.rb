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
  # need some items sir

  @user = User.find(session[:user])

  @item1 = @user.questions.last.items.first
  @item2 = @user.questions.last.items.last
  # binding.pry
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
    session[:user] = @user.id
    redirect '/'
  else
    redirect '/signup'
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