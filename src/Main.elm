module Main (..) where

import Lessons.TwoLetter
import Html exposing (Html)
import Html.Events as Html
import Lesson exposing (Lesson)
import Keys
import UI.Lesson


type alias Lazy a =
    () -> a


type Model
    = Learning Lesson
    | Celebrating
    | Choosing (List ( String, Lazy String ))


alphagripLessons : List ( String, Lazy String )
alphagripLessons =
    [ ( "EI", \() -> Lessons.TwoLetter.lesson "e" "i" )
    , ( "SO", \() -> Lessons.TwoLetter.lesson "s" "o" )
    , ( "AP", \() -> Lessons.TwoLetter.lesson "a" "p" )
    ]


init : Model
init =
    Choosing alphagripLessons


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
            Learning (UI.Lesson.init (l ()))

        ( Choosing _, _ ) ->
            model


view : Signal.Address Action -> Model -> Html
view address model =
    case model of
        Learning lesson ->
            UI.Lesson.render lesson

        Celebrating ->
            Html.text "Good job"

        Choosing lessons ->
            lessons
                |> List.map (\( name, l ) -> Html.button [ Html.onClick address (ChooseLesson l) ] [ Html.text name ])
                |> Html.div []


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
