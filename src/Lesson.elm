module Lesson (Lesson, lesson, typeLetter, backspace, remaining, completed, wrong, stats) where

import String
import Dict exposing (Dict)


type Lesson
  = Lesson
      { text : String
      , completed : String
      , wrong : String
      , stats : Dict String Stats
      }


type alias Stats =
  { correct : Int
  , incorrect : Int
  }



-- INIT


lesson : String -> Lesson
lesson text =
  let
    lines =
      String.lines text

    first =
      List.head lines |> Maybe.withDefault ""

    rest =
      List.tail lines
  in
    Lesson
      { text = first
      , completed = ""
      , wrong = ""
      , stats = Dict.empty
      }



-- UPDATE


typeLetter : String -> Lesson -> Lesson
typeLetter input (Lesson l) =
  let
    correct { correct, incorrect } =
      { correct = correct + 1
      , incorrect = incorrect
      }

    incorrect { correct, incorrect } =
      { correct = correct - 1
      , incorrect = incorrect + 1
      }

    track fn s =
      Dict.update s (Maybe.withDefault { correct = 0, incorrect = 0 } >> fn >> Just)
  in
    if l.wrong == "" && String.startsWith input l.text then
      Lesson
        { l
          | text = String.dropLeft (String.length input) l.text
          , completed = l.completed ++ input
          , stats =
              l.stats
                |> track correct input
                |> if String.length l.completed > 0 then
                    track correct (String.right 1 l.completed ++ input)
                   else
                    identity
        }
    else
      Lesson
        { l
          | wrong = l.wrong ++ input
          , stats =
              l.stats
                |> track incorrect (String.left 1 l.text)
                |> if String.length l.completed > 0 then
                    track incorrect (String.right 1 l.completed ++ (String.left 1 l.text))
                   else
                    identity
        }


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


stats : Lesson -> Dict String Stats
stats (Lesson { stats }) =
  stats
