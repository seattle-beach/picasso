-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/web_sockets.html

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket



main =
  Html.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


type alias Flags =
  { wsURL : String
  }

-- MODEL


type alias Model =
  { wsURL: String
  , input : String
  , messages : List String
  }


init : Flags -> ( Model, Cmd Msg )
init flags =
  (Model flags.wsURL "" [], Cmd.none)



-- UPDATE


type Msg
  = Input String
  | Send
  | NewMessage String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Input newInput ->
      ({ model | input=newInput }, Cmd.none)

    Send ->
      ({ model | input="" }, WebSocket.send model.wsURL model.input)

    NewMessage str ->
      ({ model | messages=(str :: model.messages)}, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen model.wsURL NewMessage



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ input [onInput Input, value model.input] []
    , button [onClick Send] [text "Send Text"]
    , div [] (List.map viewMessage (List.reverse model.messages))
    ]


viewMessage : String -> Html msg
viewMessage msg =
  div [] [ text msg ]
