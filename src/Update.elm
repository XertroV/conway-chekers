module Update exposing (..)

import Const exposing (tabRowHeight, utilityRowHeight)
import Debug exposing (log)
import Game exposing (..)
import Model exposing (..)
import Msg exposing (Msg(..))
import Ports exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ScreenSize { width, height } ->
            let
                sqSize =
                    toFloat width / toFloat model.nCols

                nRows =
                    (floor <|
                        toFloat (height - utilityRowHeight - tabRowHeight)
                            / sqSize
                    )
                        - 1
            in
            { model | squareSize = sqSize, nRows = nRows } ! []

        ClickSquare checker ->
            let
                genPlayable { x, y } =
                    List.concat <|
                        List.map
                            (\i ->
                                [ { x = x + i, y = y }, { x = x, y = y + i } ]
                            )
                            [ -2, 2 ]

                updateMkPlay model c =
                    case model.selected of
                        Just s ->
                            let
                                mid =
                                    Checker ((c.x + s.x) // 2) ((c.y + s.y) // 2)

                                weHaveMid =
                                    List.member mid model.game.checkers

                                game_ =
                                    if weHaveMid then
                                        gameModCheckers model.game { remove = [ mid, s ], add = [ c ] }
                                    else
                                        model.game
                            in
                            { model | selected = Nothing, playable = [], game = game_ } ! []

                        Nothing ->
                            doReset model False

                updateSq c =
                    let
                        isPlayable =
                            List.member c model.playable
                    in
                    if isPlayable then
                        updateMkPlay model c
                    else
                        doReset model False
            in
            if model.placeMode then
                addRemChecker model checker
            else
                case model.selected of
                    -- clicked somewhere when we had a selected square
                    Just { x, y } ->
                        updateSq checker

                    _ ->
                        { model | selected = Just checker, playable = genPlayable checker } ! []

        NoOp ->
            ( model, Cmd.none )

        ResetGame ->
            doReset model True

        TogglePlaceMode ->
            { model | placeMode = not model.placeMode } ! []

        SaveGame ->
            model ! [ saveGame { game = model.game } ]

        ListGames res ->
            case res of
                Ok saves ->
                    { model | saves = saves } ! []

                Err e ->
                    { model | errLog = log e e :: model.errLog } ! []

        LoadSave name ->
            model ! [ loadGame name ]

        GotLoadSave game ->
            case game of
                Ok g ->
                    { model | game = g, placeMode = True } ! []

                Err e ->
                    { model | errLog = log e e :: model.errLog } ! []

        DelSave g ->
            model ! [ delSave g ]


doReset model wipeGame =
    let
        g =
            if wipeGame then
                initGame
            else
                model.game

        -- placeMode
        pm =
            wipeGame
    in
    { model | selected = Nothing, playable = [], game = g, placeMode = pm } ! []


addRemChecker model c =
    let
        exists =
            List.member c model.game.checkers

        remove =
            if exists then
                [ c ]
            else
                []

        add =
            if exists || onRightOfLine model.nCols c.x then
                []
            else
                [ c ]
    in
    { model
        | game =
            gameModCheckers model.game
                { remove = remove, add = add }
    }
        ! []
