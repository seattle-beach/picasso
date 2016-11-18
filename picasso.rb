require 'json'
require 'open-uri'

require 'faye/websocket'
require 'sinatra'

enable :sessions
set :session_secret, 'omg'

set :server, :puma

get '/' do
  return redirect('/login') unless session[:user]

  if Faye::WebSocket.websocket?(request.env)
    handle_websocket(request)
  else
    ws_url = ENV['WS_URL']
    erb :index, locals: { ws_url: ws_url }
  end
end

### Auth ###

get '/login' do
  base_url = request.base_url
  erb :login, locals: { base_url: base_url }
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

### Business Logic ###

MESSAGES = []
SOCKETS = Set.new

def handle_websocket(request)
  ws = Faye::WebSocket.new(request.env)

  ws.on(:open) do
    MESSAGES.each do |msg|
      ws.send(msg)
    end
    SOCKETS << ws
  end

  ws.on(:message) do |msg|
    handle_message(msg.data)
  end

  ws.on(:close) do
    SOCKETS.delete(ws)
  end

  ws.rack_response
end

def handle_message(msg)
  return if msg.empty?

  MESSAGES << "#{session[:user][:name]}: #{msg}"
  SOCKETS.each do |socket|
    socket.send(MESSAGES.last)
  end
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

@@ index
<div id="picasso">Hello World</div>
<script src="picasso.js"></script>
<script>
    var node = document.getElementById('picasso');
    var app = Elm.Main.embed(node, {
      wsURL: "<%= ws_url %>"
    });
</script>

@@ login
<script type="text/javascript">
    function onSignIn(googleUser) {
        var id_token = googleUser.getAuthResponse().id_token;
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '/login');
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onload = function() {
            window.location = "<%= base_url %>";
        };
        xhr.send('id_token=' + id_token);
    }
</script>
<div class="g-signin2" data-onsuccess="onSignIn"></div>
<script src="https://apis.google.com/js/platform.js" async defer></script>