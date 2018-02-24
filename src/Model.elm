module Model exposing (..)

import Dict exposing (Dict)
import Game exposing (..)
import Types exposing (..)


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
    , sharingOpen : SharingStatus
    , startingGame : Game
    , fields : Dict String String
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
    , sharingOpen = NoSharing
    , startingGame = initGame
    , fields = Dict.empty
    }
