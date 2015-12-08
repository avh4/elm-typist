module LessonTests (..) where

import TestHelper exposing (..)
import Lesson exposing (..)


all =
    suite
        "Lesson"
        [ lesson "ABC CBA"
            |> remaining
            => shouldEqual "ABC CBA"
            |> because "remaining should be populated"
        , (lesson "ABC" |> typeLetter "A")
            |> completed
            => shouldEqual "A"
            |> because "typing a correct letter marks it completed"
        , (lesson "ABC" |> typeLetter "A")
            |> remaining
            => shouldEqual "BC"
            |> because "typing a correct letter removes it from the remaining text"
        , lesson "ABC"
            |> typeLetter "A"
            |> typeLetter "B"
            |> completed
            => shouldEqual "AB"
            |> because "typing a second correct letters adds it to completed"
        , lesson "ABC"
            |> typeLetter "X"
            |> wrong
            => shouldEqual "X"
            |> because "typing an incorrect letter marks it as wrong"
        , lesson "ABC"
            |> (typeLetter "X" >> typeLetter "Y")
            |> wrong
            => shouldEqual "XY"
            |> because "typing a second incorrect letter adds it to wrong"
        , lesson "ABC"
            |> typeLetter "X"
            |> typeLetter "A"
            |> completed
            => shouldEqual ""
            |> because "cannot advance with incorrect letters"
        , lesson "ABC"
            |> (typeLetter "X" >> typeLetter "Y")
            |> backspace
            |> wrong
            => shouldEqual "X"
            |> because "backspace removes a wrong letter"
        , lesson "ABC"
            |> (typeLetter "A" >> typeLetter "B")
            |> backspace
            |> completed
            => shouldEqual "A"
            |> because "backspace removes a correct letter if there are no wrong letters"
        , lesson "ABC"
            |> typeLetter "A"
            |> backspace
            |> remaining
            => shouldEqual "ABC"
            |> because "backspace over a correct letter should put it back"
        ]
