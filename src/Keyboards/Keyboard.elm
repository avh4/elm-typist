module Keyboards.Keyboard (..) where

import Lesson exposing (Lesson)


type alias Keyboard =
  { name : String
  , lessons : List Lesson
  }
