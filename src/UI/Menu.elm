module UI.Menu (..) where

import Layout exposing (Layout)
import Color


bodyText : String -> Layout
bodyText =
  Layout.text { size = 24, color = Color.darkCharcoal }


view : Signal.Address action -> (choice -> String) -> (choice -> action) -> List choice -> Layout
view address name action choices =
  choices
    |> List.map
        (\choice ->
          bodyText (name choice)
            |> Layout.onClick (Signal.message address (action choice))
        )
    |> Layout.list 48
    |> Layout.center (\{ w, h } -> { w = min 400 w, h = h })
    |> Layout.inset 48


percent : Signal.Address action -> (choice -> String) -> (choice -> action) -> (choice -> Float) -> List choice -> Layout
percent address name action pct choices =
  choices
    |> List.map
        (\choice ->
          bodyText (name choice)
            |> Layout.right 50 (bodyText <| toString <| pct choice)
            |> (if pct choice > 0.8 then
                  (\x -> Layout.stack [ Layout.fill Color.lightGreen, x ])
                else
                  identity
               )
            |> Layout.onClick (Signal.message address (action choice))
        )
    |> Layout.list 48
    |> Layout.center (\{ w, h } -> { w = min 400 w, h = h })
    |> Layout.inset 48
