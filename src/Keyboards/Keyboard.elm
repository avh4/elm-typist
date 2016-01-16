module Keyboards.Keyboard (..) where

import Lazy exposing (Lazy)


type alias Keyboard =
  { name : String
  , lessons : List ( String, Lazy String )
  }
