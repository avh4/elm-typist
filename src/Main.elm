module Main (..) where

import Lessons.TwoLetter
import Html exposing (Html)
import Lesson exposing (Lesson)
import Keys
import UI.Lesson


type alias Model =
    Lesson


init : Model
init =
    -- Lessons.Letters.lesson [ "a", "s", "e" ]
    Lessons.TwoLetter.lesson "e" "i"
        |> UI.Lesson.init


type Action
    = Key Keys.KeyCombo


update : Action -> Model -> Model
update action model =
    case Debug.log "Action" action of
        Key k ->
            UI.Lesson.key k model


view : Model -> Html
view l =
    UI.Lesson.render l


signals : Signal Action
signals =
    Signal.mergeMany
        [ Keys.lastPressed |> Signal.map Key ]


main : Signal Html
main =
    Signal.foldp update init signals
        |> Signal.map view
