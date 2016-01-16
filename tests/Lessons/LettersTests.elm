module Lessons.LettersTests (..) where

import TestHelper exposing (..)
import Lessons.Letters exposing (..)
import String


all =
  suite
    "Lessons.Letters"
    [ lesson [ "a", "b", "c", "." ]
        |> (\x -> " " ++ x ++ " ")
        |> shouldContainAll
            [ " abc. "
            , " ab.c "
            , " acb. "
            , " ac.b "
            , " a.bc "
            , " a.cb "
            , " ba.c "
            , " bac. "
            , " bc.a "
            , " bca. "
            , " b.ca "
            , " b.ac "
            , " cab. "
            , " ca.b "
            , " cba. "
            , " cb.a "
            , " c.ab "
            , " c.ba "
            , " .acb "
            , " .abc "
            , " .bca "
            , " .bac "
            , " .cba "
            , " .cab "
            ]
        |> because "lesson should exercise all permutations"
    ]
