module Storage.Local (..) where

import Native.Storage.Local
import Json.Decode as Json


put : String -> Json.Value -> Result String ()
put =
  Native.Storage.Local.put


get : String -> Result String Json.Value
get =
  Native.Storage.Local.get


isAvailable : Bool
isAvailable =
  Native.Storage.Local.isAvailable


object :
  String
  -> (a -> Json.Value)
  -> Json.Decoder a
  -> { put : a -> Result String a
     , get : () -> Result String a
     }
object key encode decoder =
  { put =
      \value ->
        put key (encode value)
          |> Result.map (always value)
  , get =
      \_ ->
        get key
          `Result.andThen` (Json.decodeValue decoder)
  }
