module Keyboards.Alphagrip (..) where

import Lessons.TwoLetter
import Lessons.Letters
import String
import Lesson exposing (Lesson)


lessons : List Lesson
lessons =
  let
    pairedLesson s =
      let
        a =
          String.slice 0 1 s

        b =
          String.slice 1 2 s
      in
        Lessons.TwoLetter.lesson a b

    letterLessons =
      [ "tn", "fu", "ei", "so", "ap", "d,", "w.", "qb", "gm", "rh", "vx", "jz" ]
        |> List.map pairedLesson

    redLessons =
      [ "12", "34", "56", "78", "90", "++", "-*", "=/", "#$", ".," ]
        |> List.map pairedLesson

    greenLessons =
      [ "()", "&|", "{}", "<>", "[]", "`\\", "'?", "%_", "~^", "\"!" ]
        |> List.map pairedLesson

    topLeftLesson =
      Lessons.Letters.lesson [ "c", "y", "k", "l" ]
  in
    letterLessons ++ [ topLeftLesson ] ++ redLessons ++ greenLessons
