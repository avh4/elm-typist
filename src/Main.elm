module Main (..) where

import Lessons.TwoLetter
import Lessons.Letters
import Html exposing (Html)
import Html.Events as Html
import Lesson exposing (Lesson)
import Keys
import UI.Lesson
import String


type alias Lazy a =
    () -> a


type Model
    = Learning Lesson
    | Celebrating
    | Choosing (List ( String, Lazy String ))


alphagripLessons : List ( String, Lazy String )
alphagripLessons =
    let
        pairedLesson s =
            let
                a = String.slice 0 1 s

                b = String.slice 1 2 s
            in
                ( a ++ b, \() -> Lessons.TwoLetter.lesson a b )

        letterLessons =
            [ "tn", "fu", "ei", "so", "ap", "d,", "w.", "qb", "gm", "rh", "vx", "jz" ]
                |> List.map pairedLesson

        redLessons =
            [ "12", "34", "56", "78", "90", "++", "-*", "=/", "#$", ".," ]
                |> List.map pairedLesson

        greenLessons =
            [ "()", "&|", "{}", "<>", "[]", "`\\", "'?", "%_", "~^", "\"!" ]
                |> List.map pairedLesson

        topLeftLesson = ( "cykl", \() -> Lessons.Letters.lesson [ "c", "y", "k", "l" ] )
    in
        letterLessons ++ [ topLeftLesson ] ++ redLessons ++ greenLessons


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
