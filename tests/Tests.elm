module Tests (..) where

import ElmTest exposing (..)
import String
import LessonTests
import Lessons.LettersTests
import Lessons.TwoLetterTests


all : Test
all =
    suite
        "elm-typist"
        [ LessonTests.all
        , Lessons.LettersTests.all
        , Lessons.TwoLetterTests.all
        ]
