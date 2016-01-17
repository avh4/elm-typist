module Stats (..) where

import Json.Encode
import Json.Decode exposing ((:=))
import Dict exposing (Dict)


type alias Stat =
  { correct : Int
  , incorrect : Int
  }


type alias Stats =
  Dict String Stat


init : Stats
init =
  Dict.empty


add : Stats -> Stats -> Stats
add a b =
  let
    addStat a b =
      { correct = a.correct + b.correct
      , incorrect = a.incorrect + b.incorrect
      }
  in
    ((Dict.toList a) ++ (Dict.toList b))
      |> List.foldl
          (\( k, v ) ->
            Dict.update
              k
              (Maybe.map (addStat v)
                >> Maybe.withDefault v
                >> Just
              )
          )
          init


get : Stats -> String -> Maybe Float
get stats key =
  case Dict.get key stats of
    Nothing ->
      Nothing

    Just { correct, incorrect } ->
      Just <| (toFloat correct) / (toFloat (correct + incorrect))


encode : Stats -> Json.Encode.Value
encode stats =
  let
    stat v =
      Json.Encode.object
        [ ( "correct", Json.Encode.int v.correct )
        , ( "incorrect", Json.Encode.int v.incorrect )
        ]
  in
    Dict.toList stats
      |> List.map
          (\( k, v ) ->
            Json.Encode.list
              [ Json.Encode.string k
              , stat v
              ]
          )
      |> Json.Encode.list


decoder : Json.Decode.Decoder Stats
decoder =
  let
    stat =
      Json.Decode.object2
        Stat
        ("correct" := Json.Decode.int)
        ("incorrect" := Json.Decode.int)
  in
    Json.Decode.list
      (Json.Decode.tuple2 (,) Json.Decode.string stat)
      |> Json.Decode.map Dict.fromList
