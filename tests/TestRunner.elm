module Main (..) where

import Signal exposing (Signal)
import ElmTest
import Console exposing (IO, run)
import Task
import Tests


console : IO ()
console =
  ElmTest.consoleRunner Tests.all


port runner : Signal (Task.Task x ())
port runner =
  run console
