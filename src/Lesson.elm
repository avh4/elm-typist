module Lesson (..) where

import Lazy exposing (Lazy)


type Lesson
  = Lesson String (Lazy String)


lesson : String -> (() -> String) -> Lesson
lesson name generate =
  Lesson name (Lazy.lazy generate)


name : Lesson -> String
name (Lesson name _) =
  name


generate : Lesson -> String
generate (Lesson _ gen) =
  Lazy.force gen
