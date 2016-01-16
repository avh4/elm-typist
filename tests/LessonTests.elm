module LessonTests (..) where

import TestHelper exposing (..)
import Lesson exposing (..)
import Dict


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
    , lesson "AABA"
        |> doAll (List.map typeLetter [ "A", "A", "B", "A" ])
        |> stats
        |> Dict.get "A"
        => shouldEqual (Just { correct = 3, incorrect = 0 })
        |> because "typeLetter should record correct letters"
    , lesson "AABA"
        |> doAll (List.map typeLetter [ "A", "X" ])
        |> backspace
        |> doAll (List.map typeLetter [ "A", "B", "A" ])
        |> stats
        |> Dict.get "A"
        => shouldEqual (Just { correct = 2, incorrect = 1 })
        |> because "typeLetter should record incorrect letters"
    , lesson "BAABA"
        |> doAll (List.map typeLetter [ "B", "A", "A", "B", "A" ])
        |> stats
        |> Dict.get "BA"
        => shouldEqual (Just { correct = 2, incorrect = 0 })
        |> because "typeLetter should record correct sequences"
    , lesson "BAABA"
        |> doAll (List.map typeLetter [ "B", "X" ])
        |> backspace
        |> doAll (List.map typeLetter [ "A", "A", "B", "A" ])
        |> stats
        |> Dict.get "BA"
        => shouldEqual (Just { correct = 1, incorrect = 1 })
        |> because "typeLetter should record correct sequences"
    ]
