module Game exposing (..)


type alias Checker =
    { x : Int
    , y : Int
    }


type alias Game =
    { width : Int
    , checkers : List Checker
    }


initGame =
    { width = 20
    , checkers = []
    }


gameModCheckers oldGame { remove, add } =
    { oldGame
        | checkers =
            add
                ++ List.filter
                    (\c -> not <| List.member c remove)
                    oldGame.checkers
    }


onRightOfLine nCols x =
    lineX nCols < x


lineX nCols =
    nCols // 2


countFurthestRight model =
    let
        maxX =
            List.foldl (\{ x } m -> max m x) 0 model.game.checkers
    in
    max 0 (maxX - lineX model.nCols)
