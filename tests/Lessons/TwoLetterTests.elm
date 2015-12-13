module Lessons.TwoLetterTests (..) where

import TestHelper exposing (..)
import Lessons.TwoLetter exposing (..)
import String


all =
    suite
        "Lessons.TwoLetter"
        [ lesson "f" "j"
            |> shouldContainAll
                [ "ff"
                , "fj"
                , "jf"
                , "jj"
                ]
            |> because "lesson should exercise all permutations"
        , lesson "f" "j"
            |> (\x -> " " ++ x ++ " ")
            |> shouldContainAll
                [ " ffff "
                , " jjjj "
                , " fj "
                , " jf "
                ]
            |> because "lesson should contain all useful combinations"
        , lesson "f" "j"
            |> shouldContainTimes 5 "ff"
            |> because "lesson should practice repeats"
        , lesson "f" "j"
            |> shouldContainTimes 5 "jj"
            |> because "lesson should practice repeats"
        , lesson "f" "j"
            |> shouldContainTimes 4 "fj"
            |> because "lesson should practice switches"
        , lesson "f" "j"
            |> shouldContainTimes 3 "jf"
            |> because "lesson should practice switches"
        ]
