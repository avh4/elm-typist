module LessonState (LessonState, init, typeLetter, backspace, remaining, completed, wrong, stats) where

import String
import Dict exposing (Dict)


type LessonState
  = LessonState
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


init : String -> LessonState
init text =
  let
    lines =
      String.lines text

    first =
      List.head lines |> Maybe.withDefault ""

    rest =
      List.tail lines
  in
    LessonState
      { text = first
      , completed = ""
      , wrong = ""
      , stats = Dict.empty
      }



-- UPDATE


typeLetter : String -> LessonState -> LessonState
typeLetter input (LessonState l) =
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
      LessonState
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
      LessonState
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


backspace : LessonState -> LessonState
backspace (LessonState l) =
  if String.isEmpty l.wrong then
    LessonState
      { l
        | completed = String.dropRight 1 l.completed
        , text = String.right 1 l.completed ++ l.text
      }
  else
    LessonState
      { l
        | wrong = String.dropRight 1 l.wrong
      }



-- VIEW


remaining : LessonState -> String
remaining (LessonState { text }) =
  text


completed : LessonState -> String
completed (LessonState { completed }) =
  completed


wrong : LessonState -> String
wrong (LessonState { wrong }) =
  wrong


stats : LessonState -> Dict String Stats
stats (LessonState { stats }) =
  stats
