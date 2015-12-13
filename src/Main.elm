module Main (..) where

import Lessons.Letters
import Lessons.TwoLetter
import Html exposing (Html)
import Html.Attributes as Html
import Lesson exposing (Lesson)
import Keys


type alias Model =
    Lesson


init : Model
init =
    -- Lessons.Letters.lesson [ "a", "s", "e" ]
    Lessons.TwoLetter.lesson "e" "i"
        |> Lesson.lesson


type Action
    = Key Keys.KeyCombo


update : Action -> Model -> Model
update action model =
    case Debug.log "Action" action of
        Key (Keys.Character c) ->
            model |> Lesson.typeLetter c

        Key (Keys.Single (Keys.Backspace)) ->
            model |> Lesson.backspace

        Key k ->
            Debug.log ("Unknown key: " ++ toString k) model


view : Model -> Html
view l =
    let
        black = "#111"

        red = "#c33"

        grey = "#999"

        spacer = Html.span [] [ Html.text "\x202F" ]

        text c t = Html.span [ Html.style [ ( "color", c ) ] ] [ Html.text t ]

        textStrike c t =
            Html.span
                [ Html.style
                    [ ( "color", c )
                    , ( "text-decoration", "line-through" )
                    ]
                ]
                [ Html.text t ]
    in
        Html.div
            [ Html.style
                [ ( "width", "100%" )
                , ( "text-align", "center" )
                , ( "margin", "24px" )
                , ( "font-size", "24px" )
                , ( "white-space", "pre" )
                ]
            ]
            [ Lesson.completed l |> text black
            , Lesson.wrong l |> textStrike red
            , spacer
            , Lesson.remaining l |> text grey
            ]


signals : Signal Action
signals =
    Signal.mergeMany
        [ Keys.lastPressed |> Signal.map Key ]


main : Signal Html
main =
    Signal.foldp update init signals
        |> Signal.map view
