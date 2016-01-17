module UI.Lesson (init, key, render, Result(..)) where

import Html exposing (Html)
import Html.Attributes as Html
import LessonState exposing (LessonState)
import Keys
import Layout exposing (Layout)
import Layout.Custom
import Stats exposing (Stats)


type alias Model =
  LessonState


type Result
  = Completed Stats


init : String -> Model
init lesson =
  lesson
    |> LessonState.init


key : Keys.KeyCombo -> Model -> ( Model, Maybe Result )
key key model =
  case key of
    Keys.Character c ->
      let
        model' =
          model |> LessonState.typeLetter c
      in
        if LessonState.remaining model' == "" then
          ( model', Just <| Completed <| LessonState.stats model')
        else
          ( model', Nothing )

    Keys.Single (Keys.Backspace) ->
      model
        |> LessonState.backspace
        |> \x -> ( x, Nothing )

    _ ->
      Debug.log ("Unknown key: " ++ toString key) model
        |> \x -> ( x, Nothing )


render : Model -> Layout
render l =
  let
    black =
      "#111"

    red =
      "#c33"

    grey =
      "#999"

    spacer =
      Html.span [] [ Html.text "\x202F" ]

    text c t =
      Html.span [ Html.style [ ( "color", c ) ] ] [ Html.text t ]

    textStrike c t =
      Html.span
        [ Html.style
            [ ( "color", c )
            , ( "text-decoration", "line-through" )
            ]
        ]
        [ Html.text t ]
  in
    Layout.bottom 100 (Layout.placeholder <| LessonState.stats l)
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
            [ LessonState.completed l |> text black
            , LessonState.wrong l |> textStrike red
            , spacer
            , LessonState.remaining l |> text grey
            ]
