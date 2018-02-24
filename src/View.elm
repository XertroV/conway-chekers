module View exposing (..)

import Checkers.Style exposing (Styles(..), Vars(..), stylesheet)
import Const exposing (tabRowHeight, utilityRowHeight)
import Element exposing (Element, bold, button, circle, column, el, empty, h4, paragraph, row, screen, text)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import Game exposing (..)
import Html exposing (Html)
import List exposing (range)
import Model exposing (Model)
import Msg exposing (..)
import Style exposing (variation)


type alias Elem =
    Element Styles Vars Msg


scaled n =
    1.618 * n


rootView : Model -> Html Msg
rootView model =
    Element.viewport stylesheet <|
        column NoSty
            [ width fill, height fill ]
            [ tabBar model
            , controlBar model
            , mainView model
            ]


btn msg inner =
    button BtnSty [ onClick msg, padding 5, verticalCenter, center ] inner


tabBar : Model -> Elem
tabBar model =
    let
        drawTab t =
            row NoSty [ paddingLeft 5 ] [ btn (LoadSave t) <| text t, el NoSty [ paddingLeft 3 ] <| btn (DelSave t) <| text "✖" ]
    in
    el NoSty
        [ width fill
        , height <| px tabRowHeight
        , padding 10
        , alignLeft
        , verticalCenter
        ]
    <|
        row NoSty [ spacing 10, verticalCenter, width fill ] <|
            [ text "Save Games:" ]
                ++ List.map drawTab model.saves
                ++ []


controlBar model =
    row NoSty
        [ width fill
        , height <| px utilityRowHeight
        , padding 10
        , spacing 10
        , alignLeft
        ]
        [ btn ResetGame <| text "Reset"
        , btn SaveGame <| text "Save Layout"
        ]


mainView model =
    -- main row w/in prev
    row NoSty [ width fill, height fill ] <|
        [ empty
        , overlayTopLeft model
        , column NoSty [ width fill, height fill ] <|
            List.map (drawRow model) (range 0 model.nRows)
        ]


overlayTopLeft model =
    let
        content =
            if model.placeMode then
                [ h4 NoSty [] <| text "Placement Mode"
                , paragraph NoSty
                    []
                    [ text "Click a square to place a checker (to the left of the red line only), then click 'Start Game' when you're ready!" ]
                , btn TogglePlaceMode <|
                    text "Start Game"
                ]
            else
                [ h4 NoSty [] <| text "Game Mode"
                , paragraph NoSty
                    []
                    [ text "Your Score:", bold <| toString <| countFurthestRight model ]
                ]
    in
    screen <|
        el OverlaySty
            [ moveDown <| toFloat <| utilityRowHeight + tabRowHeight + 20
            , moveRight 20
            , width <| px 200
            ]
        <|
            el NoSty
                [ paddingXY 16.0 16.0 ]
            <|
                column NoSty
                    [ spacing 10 ]
                    content


drawRow model y =
    row NoSty [ width fill, height <| px model.squareSize ] <|
        List.map (drawSquare model y) (range 1 model.nCols)


drawSquare model y_ x_ =
    let
        isBlack =
            y_ % 2 == 0 && x_ % 2 == 1 || y_ % 2 == 1 && x_ % 2 == 0

        hasChecker =
            (<) 0 <|
                List.length <|
                    List.filter (\{ x, y } -> x_ == x && y_ == y)
                        model.game.checkers

        squareClick =
            if hasChecker || model.placeMode || isPlayable then
                [ onClick <| ClickSquare { x = x_, y = y_ } ]
            else
                []

        checker visible =
            el NoSty
                [ width fill
                , height fill
                , verticalCenter
                , center
                ]
                (if visible then
                    circle (model.squareSize / 2 * 0.8) CheckerSty [ verticalCenter, center ] empty
                 else
                    empty
                )

        inner =
            checker hasChecker

        this =
            Checker x_ y_

        isSelected =
            Just this == model.selected

        isPlayable =
            List.member this model.playable

        isOnLine =
            model.nCols // 2 == x_
    in
    el SqSty
        ([ width <| px model.squareSize
         , height <| px model.squareSize
         , vary BlackSquare isBlack
         , vary WhiteSquare (not isBlack)
         , vary CanPlaceHere isPlayable
         , vary SqSelected isSelected
         , vary AdjacentToLine isOnLine
         ]
            ++ squareClick
        )
        inner
