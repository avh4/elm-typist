module Lesson (Lesson, lesson, typeLetter, backspace, remaining, completed, wrong) where

import String


type Lesson
    = Lesson { text : String, completed : String, wrong : String }



-- INIT


lesson : String -> Lesson
lesson text =
    let
        lines = String.lines text

        first = List.head lines |> Maybe.withDefault ""

        rest = List.tail lines
    in
        Lesson
            { text = first
            , completed = ""
            , wrong = ""
            }



-- UPDATE


typeLetter : String -> Lesson -> Lesson
typeLetter input (Lesson l) =
    if l.wrong == "" && String.startsWith input l.text then
        Lesson
            { l
                | text = String.dropLeft (String.length input) l.text
                , completed = l.completed ++ input
            }
    else
        Lesson
            { l | wrong = l.wrong ++ input }


backspace : Lesson -> Lesson
backspace (Lesson l) =
    if String.isEmpty l.wrong then
        Lesson
            { l
                | completed = String.dropRight 1 l.completed
                , text = String.right 1 l.completed ++ l.text
            }
    else
        Lesson
            { l
                | wrong = String.dropRight 1 l.wrong
            }



-- VIEW


remaining : Lesson -> String
remaining (Lesson { text }) =
    text


completed : Lesson -> String
completed (Lesson { completed }) =
    completed


wrong : Lesson -> String
wrong (Lesson { wrong }) =
    wrong
