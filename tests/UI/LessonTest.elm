module UI.LessonTest (..) where

import TestHelper exposing (..)
import UI.Lesson exposing (..)
import Keys


all =
    suite
        "UI.Lesson"
        [ init "ABC"
            |> key (Keys.Character "A") >> fst
            |> key (Keys.Character "B") >> fst
            |> key (Keys.Character "C")
            |> snd
            => shouldEqual (Just Completed)
            |> because "it should report when the lesson is completed"
        ]
