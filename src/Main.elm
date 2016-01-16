module Main (..) where

import Html exposing (Html)
import Lesson exposing (Lesson)
import Keys
import UI.Lesson
import Layout exposing (Layout)
import Color
import Keyboards.Alphagrip
import Lazy exposing (Lazy)


type Model
    = Learning Lesson
    | Celebrating
    | Choosing (List ( String, Lazy String ))


init : Model
init =
    Choosing Keyboards.Alphagrip.lessons


type Action
    = Key Keys.KeyCombo
    | Start
    | ChooseLesson (Lazy String)


update : Action -> Model -> Model
update action model =
    case ( model, Debug.log "Action" action ) of
        ( Learning lesson, Key k ) ->
            case UI.Lesson.key k lesson of
                ( _, Just (UI.Lesson.Completed) ) ->
                    Celebrating

                ( lesson', Nothing ) ->
                    Learning lesson'

        ( Learning _, _ ) ->
            model

        ( Celebrating, _ ) ->
            Celebrating

        ( Choosing _, ChooseLesson l ) ->
            Learning (UI.Lesson.init <| Lazy.force l)

        ( Choosing _, _ ) ->
            model


view : Signal.Address Action -> Model -> Layout
view address model =
    case model of
        Learning lesson ->
            UI.Lesson.render lesson

        Choosing lessons ->
            lessons
                |> List.map
                    (\( name, lesson ) ->
                        Layout.text { size = 24, color = Color.darkCharcoal } ("Lesson: " ++ name)
                            |> Layout.onClick (Signal.message address (ChooseLesson lesson))
                    )
                |> Layout.list 48
                |> Layout.center (\{ w, h } -> { w = min 400 w, h = h })
                |> Layout.inset 48

        _ ->
            Layout.placeholder (toString model)


signals : Signal.Mailbox Action -> Signal Action
signals mbox =
    Signal.mergeMany
        [ Keys.lastPressed |> Signal.map Key
        , mbox.signal
        ]


main : Signal Html
main =
    let
        mbox = Signal.mailbox Start
    in
        Signal.foldp update init (signals mbox)
            |> Signal.map (view mbox.address)
            |> Layout.toFullWindow
