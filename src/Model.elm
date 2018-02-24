module Model exposing (..)

import Game exposing (..)


type alias Tab =
    {}


type alias Model =
    { game : Game
    , nRows : Int
    , nCols : Int
    , squareSize : Float
    , saves : List String
    , placeMode : Bool
    , playable : List Checker
    , selected : Maybe Checker
    , errLog : List String
    }


initialModel : Model
initialModel =
    { game = initGame
    , nRows = 10
    , nCols = 16
    , squareSize = 50
    , saves = []
    , placeMode = True
    , playable = []
    , selected = Nothing
    , errLog = []
    }
