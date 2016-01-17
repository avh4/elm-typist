module Lessons.TwoLetter (lesson) where

import String
import Lesson exposing (Lesson)


lesson : String -> String -> Lesson
lesson a b =
  Lesson.lesson
    ("Lesson: " ++ a ++ b)
    (\_ ->
      String.join
        " "
        [ a ++ a ++ a ++ a
        , b ++ b ++ b ++ b
        , a ++ b
        , b ++ a
        , a ++ a ++ b ++ b
        , a ++ a ++ b ++ b
        , a ++ b
        , a ++ b
        , b ++ a
        , b ++ a
        ]
    )
    [ a, b, a ++ b, b ++ a ]
