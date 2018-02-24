module Checkers.Style exposing (..)

import Color exposing (black, darkGrey, darkRed, green, grey, red, rgba, white)
import Style exposing (style, variation)
import Style.Border exposing (..)
import Style.Color as C exposing (..)
import Style.Font as F


type Styles
    = TabRow
    | Title
    | SqSty
    | OverlaySty
    | CheckerVisSty
    | CheckerHiddenSty
    | BtnSty
    | CheckerSty
    | NoSty


type Vars
    = BlackSquare
    | WhiteSquare
    | HasChecker
    | NoChecker
    | CanPlaceHere
    | SqSelected
    | AdjacentToLine


stylesheet =
    Style.styleSheet
        [ style Title
            [ C.text darkGrey
            , C.background white
            , F.size 5 -- all units given as px
            ]
        , style OverlaySty
            [ background <| rgba 255 255 255 1
            , all 2.0
            ]
        , style
            CheckerHiddenSty
            []
        , style SqSty
            [ variation BlackSquare
                [ background black ]
            , variation WhiteSquare
                [ background white ]
            , variation CanPlaceHere
                [ background green ]
            , variation SqSelected
                [ background darkRed ]
            , variation AdjacentToLine
                [ right 4.0, solid, border red ]
            ]
        , style CheckerSty
            [ background red
            ]
        , style BtnSty
            [ F.size 15
            , all 1
            , border black
            , rounded 4
            ]
        , style NoSty []
        ]
