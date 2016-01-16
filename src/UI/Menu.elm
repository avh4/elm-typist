module UI.Menu where

import Layout exposing (Layout)
import Color


view : Signal.Address action -> (choice -> String) -> (choice -> action) -> List choice -> Layout
view address name action choices =
  choices
    |> List.map
        (\choice ->
          Layout.text { size = 24, color = Color.darkCharcoal } (name choice)
            |> Layout.onClick (Signal.message address (action choice))
        )
    |> Layout.list 48
    |> Layout.center (\{ w, h } -> { w = min 400 w, h = h })
    |> Layout.inset 48
