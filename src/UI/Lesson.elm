module UI.Lesson (init, key, render, Result(..)) where

import Html exposing (Html)
import Html.Attributes as Html
import Lesson exposing (Lesson)
import Keys
import Layout exposing (Layout)
import Layout.Custom


type alias Model =
    Lesson


type Result
    = Completed


init : String -> Model
init lesson =
    lesson
        |> Lesson.lesson


key : Keys.KeyCombo -> Model -> ( Model, Maybe Result )
key key model =
    case key of
        Keys.Character c ->
            let
                model' = model |> Lesson.typeLetter c
            in
                if Lesson.remaining model' == "" then
                    ( model', Just Completed )
                else
                    ( model', Nothing )

        Keys.Single (Keys.Backspace) ->
            model
                |> Lesson.backspace
                |> \x -> ( x, Nothing )

        _ ->
            Debug.log ("Unknown key: " ++ toString key) model
                |> \x -> ( x, Nothing )


render : Model -> Layout
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
        Layout.bottom 100 (Layout.placeholder <| Lesson.stats l)
            <| Layout.Custom.html
            <| \_ ->
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
