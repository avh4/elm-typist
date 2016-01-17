module Stats (..) where

import Json.Encode
import Json.Decode


type alias Stats =
  ()


init : Stats
init =
  ()


encode : Stats -> Json.Encode.Value
encode stats =
  Json.Encode.string "<Stats>"


decoder : Json.Decode.Decoder Stats
decoder =
  Json.Decode.succeed ()


decode : Json.Decode.Value -> Result String Stats
decode =
  Json.Decode.decodeValue decoder
