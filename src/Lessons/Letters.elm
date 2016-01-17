module Lessons.Letters (lesson) where

import String
import Lesson exposing (Lesson)


{-| From http://stackoverflow.com/q/24484348/308930
-}
permutations : List x -> List (List x)
permutations xs0 =
  let
    perms ts0 is =
      case ts0 of
        [] ->
          []

        t :: ts ->
          let
            interleave xs r =
              interleave' identity xs r
                |> snd

            interleave' f ys0 r =
              case ys0 of
                [] ->
                  ( ts, r )

                y :: ys ->
                  let
                    ( us, zs ) =
                      interleave' (f >> (\x -> y :: x)) ys r
                  in
                    ( y :: us, f (t :: y :: us) :: zs )
          in
            List.foldr interleave (perms ts (t :: is)) (permutations is)
  in
    xs0 :: perms xs0 []


lesson : List String -> Lesson
lesson letters =
  Lesson.lesson
    ("Lesson: " ++ String.join "" letters)
    (\_ ->
      permutations letters
        |> List.map (String.join "")
        |> String.join " "
    )
    letters
