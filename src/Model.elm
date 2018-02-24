module Model exposing (..)

import Game exposing (..)


type alias Tab =
    {}


type alias Model =
    { game : Game
    , nRows : Int
    , squareSize : Float
    , saves : List String
    , placeMode : Bool
    , playable : List Checker
    , selected : Maybe Checker
    , errLog : List String
    , sharingOpen : Bool
    }


initialModel : Model
initialModel =
    { game = initGame
    , nRows = 10
    , squareSize = 50
    , saves = []
    , placeMode = True
    , playable = []
    , selected = Nothing
    , errLog = []
    , sharingOpen = False
    }
