# Homepage (Root path)

get '/' do
  erb :index
end

get "/signup" do
  erb :'users/signup'
end
