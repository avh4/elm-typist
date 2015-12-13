module UI.Lesson (init, key, render) where

import Html exposing (Html)
import Html.Attributes as Html
import Lesson exposing (Lesson)
import Keys


type alias Model =
    Lesson


init : String -> Model
init lesson =
    lesson
        |> Lesson.lesson


key : Keys.KeyCombo -> Model -> Model
key key model =
    case key of
        Keys.Character c ->
            model |> Lesson.typeLetter c

        Keys.Single (Keys.Backspace) ->
            model |> Lesson.backspace

        _ ->
            Debug.log ("Unknown key: " ++ toString key) model


render : Model -> Html
render l =
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
