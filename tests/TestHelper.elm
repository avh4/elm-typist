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
          List.foldr (\i acc -> if String.contains i result then acc else i::acc) [] items
    in
        case notMatched of
          [] -> ElmTest.assert True
          _ -> ElmTest.assertEqual ("a String containing " ++ (toString notMatched))
            result


infixl 0 =>
(=>) =
    (|>)
