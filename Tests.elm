module Tests where

import ElmTest.Test (..)
import ElmTest.Assertion (..)

all = suite "Test"
  [ 5 `equals` 5
  , test "Addition" (assertEqual (3 + 7) 10)
  ]
