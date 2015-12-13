module Main (..) where

import Lessons.TwoLetter
import Html exposing (Html)
import Lesson exposing (Lesson)
import Keys
import UI.Lesson


type Model
    = Learning Lesson
    | Celebrating


init : Model
init =
    -- Lessons.Letters.lesson [ "a", "s", "e" ]
    Lessons.TwoLetter.lesson "e" "i"
        |> UI.Lesson.init
        |> Learning


type Action
    = Key Keys.KeyCombo


update : Action -> Model -> Model
update action model =
    case ( model, Debug.log "Action" action ) of
        ( Learning lesson, Key k ) ->
            case UI.Lesson.key k lesson of
                ( _, Just (UI.Lesson.Completed) ) ->
                    Celebrating

                ( lesson', Nothing ) ->
                    Learning lesson'

        ( Celebrating, _ ) ->
            Celebrating


view : Model -> Html
view model =
    case model of
        Learning lesson ->
            UI.Lesson.render lesson

        Celebrating ->
            Html.text "Good job"


signals : Signal Action
signals =
    Signal.mergeMany
        [ Keys.lastPressed |> Signal.map Key ]


main : Signal Html
main =
    Signal.foldp update init signals
        |> Signal.map view
