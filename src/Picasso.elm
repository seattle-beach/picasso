-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/web_sockets.html

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket
import Json.Decode as Json



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
  | KeyDown Int


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Input newInput ->
      ({ model | input=newInput }, Cmd.none)

    Send ->
      ({ model | input="" }, WebSocket.send model.wsURL model.input)

    NewMessage str ->
      ({ model | messages=(str :: model.messages)}, Cmd.none)

    KeyDown key ->
      if key == 13 then
        ({ model | input="" }, WebSocket.send model.wsURL model.input)
      else
        (model, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen model.wsURL NewMessage



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ input [onKeyDown KeyDown, onInput Input, value model.input] []
    , button [onClick Send] [text "Send"]
    , div [] (List.map viewMessage model.messages)
    ]


viewMessage : String -> Html msg
viewMessage msg =
  div [] [ text msg ]


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
  on "keydown" (Json.map tagger keyCode)
