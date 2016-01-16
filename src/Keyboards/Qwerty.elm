module Keyboards.Qwerty (..) where

import Lessons.TwoLetter
import String
import Lazy exposing (Lazy)


lessons : List ( String, Lazy String )
lessons =
  let
    pairedLesson s =
      let
        a =
          String.slice 0 1 s

        b =
          String.slice 1 2 s
      in
        ( a ++ b, Lazy.lazy <| \() -> Lessons.TwoLetter.lesson a b )

    homeLessons =
      [ "fj", "dk", "sl", "a;", "gh" ]

    topLessons =
      [ "ty", "ru", "ei", "wo", "qp", "{}" ]

    bottomLessons =
      [ "bn", "vm", "c,", "x.", "z/" ]

    numberLessons =
      [ "12", "34", "56", "78", "90", "-=", "`\\", "'\"" ]
  in
    [ homeLessons, topLessons, bottomLessons, numberLessons ]
      |> List.concat
      |> List.map pairedLesson
