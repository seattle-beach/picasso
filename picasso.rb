require 'json'
require 'open-uri'

require 'faye/websocket'
require 'sinatra'

enable :sessions
set :session_secret, 'omg'

set :port, 9292
set :server, :puma

get '/' do
  return redirect('/login') unless session[:user]

  'hello world'
end

get '/ws' do
  return redirect('/login') unless session[:user]
  halt 403 unless Faye::WebSocket.websocket?(request.env)

  ws = Faye::WebSocket.new(request.env)

  ws.on(:open) do |event|
    puts 'On Open'
  end

  ws.on(:message) do |msg|
    ws.send(msg.data.reverse)  # Reverse and reply
  end

  ws.on(:close) do |event|
    puts 'On Close'
  end

  ws.rack_response
end

get '/login' do
  erb :login
end

post '/login' do
  id_token = params[:id_token]

  url = "https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{id_token}"
  resp = open(url)
  body = JSON.load(resp)

  halt 403 if body['aud'] != ENV['CLIENT_ID']

  user = {id: body['sub'], name: body['name'] }
  session[:user] = user

  user[:name]
end

__END__

@@ layout
<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title>Picasso</title>
    <meta name="google-signin-client_id" content="791729030283-ngqhrrsjbms8bnot81ra1mt1noujdhr8.apps.googleusercontent.com">
</head>

<body>
    <%= yield %>
</body>

</html>

@@ login
<script type="text/javascript">
    function onSignIn(googleUser) {
        var id_token = googleUser.getAuthResponse().id_token;
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '/login');
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onload = function() {
            console.log('Signed in as: ' + xhr.responseText);
        };
        xhr.send('id_token=' + id_token);
    }
</script>
<div class="g-signin2" data-onsuccess="onSignIn"></div>
<script src="https://apis.google.com/js/platform.js" async defer></script>