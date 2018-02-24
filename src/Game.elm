module Game exposing (..)


type alias Checker =
    { x : Int
    , y : Int
    }


type alias Game =
    { width : Int
    , checkers : List Checker
    , squaresInverted : Bool
    }


initGame =
    { width = 20
    , checkers = []
    , squaresInverted = False
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
    max 0 (maxX - lineX model.game.width)


gameZoomIn { checkers, width, squaresInverted } =
    let
        -- since we decrease the board width by 2 we should shift all x co-ords across 1
        checkers_ =
            List.map (\{ x, y } -> Checker (x - 1) y) checkers
    in
    Game (width - 2) checkers_ (not squaresInverted)


gameZoomOut { checkers, width, squaresInverted } =
    let
        checkers_ =
            List.map (\{ x, y } -> Checker (x + 1) y) checkers
    in
    Game (width + 2) checkers_ (not squaresInverted)
