module Lesson (..) where

import Lazy exposing (Lazy)
import Stats exposing (Stats)


type Lesson
  = Lesson
      { name : String
      , generate : Lazy String
      , focus : List String
      }


lesson : String -> (() -> String) -> List String -> Lesson
lesson name generate focus =
  Lesson
    { name = name
    , generate = (Lazy.lazy generate)
    , focus = focus
    }


name : Lesson -> String
name (Lesson { name }) =
  name


generate : Lesson -> String
generate (Lesson { generate }) =
  Lazy.force generate


score : Stats -> Lesson -> Float
score stats (Lesson { focus }) =
  focus
    |> List.filterMap (Stats.get stats)
    |> List.sum
    |> (\x -> x / toFloat (List.length focus))
