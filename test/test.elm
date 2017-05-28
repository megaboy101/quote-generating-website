port module Main exposing (..)




import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Decode as Json
import Http
import Debug



type alias Model = 
    { content : String
    , error : Maybe Http.Error
    }



type Msg 
    = NewQuote (Result Http.Error String)
    | Request



main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


init : (Model, Cmd Msg)
init = { content = "Nothing has happened yet", error = Nothing } ! []


view : Model -> Html Msg
view model = 
    div [] 
        [ p [] [ text model.content ]
        , button [ onClick Request ] [ text "Button" ]
        , viewError model
        ]


update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of
        Request ->
            model ! [ getJson ]
        NewQuote (Ok s) ->
            Debug.log s { model | content = s } ! []

        NewQuote (Err error) ->
            Debug.log "Testing" { model | error = Just error } ! []




viewError : Model -> Html Msg
viewError model = 
    case model.error of
        Nothing ->
            p [] []
        
        Just error -> 
            case error of
                Http.BadUrl s -> 
                    p [ class "error" ] [ text <| "bad url: " ++ s ] 
                
                Http.Timeout ->
                    p [ class "error" ] [ text "network timeout" ]
                
                Http.NetworkError ->
                    p [ class "error" ] [ text "unknown network error" ]
                
                Http.BadStatus resp ->
                    p [ class "error" ] [ text <| "Bad status: " ++ resp.status.message ]
                Http.BadPayload s resp ->
                    p [ class "error" ] [ text <| "Bad payload: " ++ s  ++ "\nother debugg: " ++ resp.status.message ]




getJson : Cmd Msg 
getJson = 
    let 
        request = Http.getString apiUrl
    in
        Http.send NewQuote request





apiUrl : String
apiUrl = "https://api.forismatic.com/api/1.0/?method=getQuote&lang=en&format=jsonp&jsonp=?"








