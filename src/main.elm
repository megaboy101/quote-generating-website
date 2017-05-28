port module Main exposing (..)


import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Decode as Json
import Http



--FIXME: in main.elm keep getting Http.NetworkError


--ERROR: No 'access-control-allow-origin' 
--look into ports in order to port the working jquery from https://codepen.io/dting/pen/PqrZgb?editors=1010


--Relevent links to solve problem:
--https://guide.elm-lang.org/interop/javascript.html
--https://gist.github.com/groteck/e4cc180ac182436f31f1d709466df768


type alias Model = 
    { quote : Quote
    , error : Maybe Http.Error
    }


type Msg 
    = NewQuote (Result Http.Error Quote)
    | Request


type alias Quote = 
    { author : String
    , content : String
    }


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


--INIT

init : (Model, Cmd Msg)
init = { quote = { author = "", content = ""}, error = Nothing } ! []


--VIEW

view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Quote Generator" ]
        , div []
            [ p [] [ text <| "author: " ++ model.quote.author ++ "\ncontent: " ++ model.quote.content ]
            , viewError model
            ]
        , button [ onClick Request ] [ text "Get new quote" ]
        ]


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




--UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of
        Request ->
            model ! [ getNewQuote ]

        NewQuote (Ok q) ->
            { model | quote = q } ! []
        
        NewQuote (Err error) -> 
            { model 
            | quote = { author = "Error", content = "Error" }
            , error = Just error
            } ! []


--FUNCTIONS


apiUrl : String
apiUrl = "https://api.forismatic.com/api/1.0/?method=getQuote&lang=en&format=jsonp&jsonp=?"


--testing

-- getNewQuote : Cmd Msg
-- getNewQuote = 
--     let 
--         request = Http.get apiUrl Json.string
--     in
--         Http.send NewQuote request

--testing

getNewQuote : Cmd Msg 
getNewQuote = 
    let 
        request = Http.get apiUrl decodeQuote
    in
        Http.send NewQuote request


decodeQuote : Json.Decoder Quote
decodeQuote = 
    Json.map2 (\x y -> { author = x, content = y } )
        (Json.field "quoteAuthor" Json.string)
        (Json.field "quoteText" Json.string)






