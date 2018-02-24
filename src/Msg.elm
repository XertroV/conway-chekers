module Msg exposing (..)

import Game exposing (Checker, Game)


type Msg
    = NoOp
    | ScreenSize { width : Int, height : Int }
    | ClickSquare Checker
    | ResetGame
    | TogglePlaceMode
    | SaveGame
    | ListGames (Result String (List String))
    | LoadSave String
    | GotLoadSave (Result String Game)
    | DelSave String
    | ZoomIn
    | ZoomOut
