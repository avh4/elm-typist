module Main (..) where

import Html exposing (Html)
import Lesson exposing (Lesson)
import Keys
import UI.Lesson
import UI.Menu
import Layout exposing (Layout)
import Keyboards.Keyboard exposing (Keyboard)
import Keyboards.Alphagrip
import Keyboards.Qwerty
import Lazy exposing (Lazy)


type Model
  = Learning Lesson
  | Celebrating
  | ChoosingLesson (List ( String, Lazy String ))
  | ChoosingKeyboard (List Keyboard)


init : Model
init =
  ChoosingKeyboard
    [ Keyboard "Alphagrip" Keyboards.Alphagrip.lessons
    , Keyboard "QWERTY" Keyboards.Qwerty.lessons
    ]


type Action
  = Key Keys.KeyCombo
  | Start
  | ChooseLesson (Lazy String)
  | ChooseKeyboard Keyboard


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

    ( ChoosingLesson _, ChooseLesson l ) ->
      Learning (UI.Lesson.init <| Lazy.force l)

    ( ChoosingLesson _, _ ) ->
      model

    ( ChoosingKeyboard _, ChooseKeyboard keyboard ) ->
      ChoosingLesson keyboard.lessons

    ( ChoosingKeyboard _, _ ) ->
      model


view : Signal.Address Action -> Model -> Layout
view address model =
  case model of
    Learning lesson ->
      UI.Lesson.render lesson

    ChoosingLesson lessons ->
      UI.Menu.view
        address
        (fst >> (++) "Lesson: ")
        (snd >> ChooseLesson)
        lessons

    ChoosingKeyboard keyboards ->
      UI.Menu.view
        address
        .name
        ChooseKeyboard
        keyboards

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
    mbox =
      Signal.mailbox Start
  in
    Signal.foldp update init (signals mbox)
      |> Signal.map (view mbox.address)
      |> Layout.toFullWindow
