module Main exposing (..)

import Game exposing (..)
import Html exposing (..)
import Model exposing (..)
import Msg exposing (..)
import Ports exposing (listGames, onListGames, onLoadGame)
import Task exposing (perform)
import Update exposing (..)
import View exposing (rootView)
import Window exposing (resizes, size, width)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = rootView
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( initialModel
    , Cmd.batch
        [ perform ScreenSize size
        , listGames ()
        ]
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ resizes ScreenSize, onListGames, onLoadGame ]
