module TestHelper (..) where

import ElmTest
import String


suite =
  ElmTest.suite


because =
  ElmTest.test


shouldEqual =
  ElmTest.assertEqual


shouldContainAll items result =
  let
    notMatched =
      List.foldr
        (\i acc ->
          if String.contains i result then
            acc
          else
            i :: acc
        )
        []
        items
  in
    case notMatched of
      [] ->
        ElmTest.assert True

      _ ->
        ElmTest.assertEqual
          ("a String containing " ++ (toString notMatched))
          result


shouldContainTimes n string actual =
  let
    step ( s, n ) =
      case s of
        "" ->
          ( s, n )

        _ ->
          if String.startsWith string s then
            step ( String.dropLeft 1 s, n + 1 )
          else
            step ( String.dropLeft 1 s, n )

    found =
      step ( actual, 0 ) |> snd
  in
    if found >= n then
      ElmTest.assert True
    else
      ElmTest.assertEqual
        ("a String containing " ++ (toString string) ++ " " ++ (toString n) ++ " times")
        actual


infixl 0 =>
(=>) =
  (|>)


doAll : List (a -> a) -> a -> a
doAll fns input =
  List.foldl (<|) input fns
