port module Ports exposing (..)

import Game exposing (Checker, Game)
import Json.Decode exposing (Decoder, Value, int, list, string)
import Json.Decode.Pipeline exposing (decode, required)
import Msg exposing (..)


port saveGame : { game : Game } -> Cmd msg


port listGames : () -> Cmd msg


port loadGame : String -> Cmd msg


port listGamesResp : (Value -> msg) -> Sub msg


onListGames : Sub Msg
onListGames =
    listGamesResp (ListGames << Json.Decode.decodeValue (Json.Decode.list <| Json.Decode.string))


port loadGameResp : (Value -> msg) -> Sub msg


onLoadGame : Sub Msg
onLoadGame =
    let
        doDecode =
            GotLoadSave << Json.Decode.decodeValue gameDecoder
    in
    loadGameResp doDecode


checkerDecoder : Decoder Checker
checkerDecoder =
    decode Checker
        |> required "x" int
        |> required "y" int


gameDecoder : Decoder Game
gameDecoder =
    decode Game
        |> required "width" int
        |> required "checkers" (list checkerDecoder)


port delSave : String -> Cmd msg
