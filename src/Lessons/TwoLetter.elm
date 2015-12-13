module Lessons.TwoLetter (lesson) where

import String


lesson : String -> String -> String
lesson a b =
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
