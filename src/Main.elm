module Main (..) where

import Html exposing (Html)
import LessonState exposing (LessonState)
import Keys
import UI.Lesson
import UI.Menu
import Layout exposing (Layout)
import Keyboards.Keyboard exposing (Keyboard)
import Keyboards.Alphagrip
import Keyboards.Qwerty
import Storage.Local as Storage
import Stats exposing (Stats)
import Lesson exposing (Lesson)


typingStats =
  Storage.object "typingStats" Stats.encode Stats.decoder


type Screen
  = Learning Keyboard LessonState
  | Celebrating Keyboard
  | ChoosingLesson Keyboard
  | ChoosingKeyboard (List Keyboard)


type alias Model =
  { screen : Screen
  , stats : Stats
  }


init : Model
init =
  { screen =
      ChoosingKeyboard
        [ Keyboard "Alphagrip" Keyboards.Alphagrip.lessons
        , Keyboard "QWERTY" Keyboards.Qwerty.lessons
        ]
  , stats =
      typingStats.get ()
        |> Result.toMaybe
        |> Maybe.withDefault Stats.init
  }


type Action
  = Key Keys.KeyCombo
  | Start
  | ChooseLesson Lesson
  | ChooseKeyboard Keyboard


update : Action -> Model -> Model
update action model =
  case ( model.screen, Debug.log "Action" action ) of
    ( Learning keyboard lesson, Key k ) ->
      case UI.Lesson.key k lesson of
        ( _, Just (UI.Lesson.Completed stats) ) ->
          let
            stats' =
              Stats.add stats model.stats
          in
            { model
              | screen = Celebrating keyboard
              , stats =
                  typingStats.put stats'
                    |> Result.toMaybe
                    |> Maybe.withDefault stats'
            }

        ( lesson', Nothing ) ->
          { model | screen = Learning keyboard lesson' }

    ( Learning _ _, _ ) ->
      model

    ( Celebrating keyboard, Key (Keys.Single (Keys.Enter))) ->
      { model | screen = ChoosingLesson keyboard }

    ( Celebrating _, _ ) ->
      model

    ( ChoosingLesson keyboard, ChooseLesson lesson ) ->
      { model
        | screen =
            Learning keyboard (UI.Lesson.init lesson)
      }

    ( ChoosingLesson _, _ ) ->
      model

    ( ChoosingKeyboard _, ChooseKeyboard keyboard ) ->
      { model | screen = ChoosingLesson keyboard }

    ( ChoosingKeyboard _, _ ) ->
      model


view : Signal.Address Action -> Model -> Layout
view address model =
  case model.screen of
    Learning _ lesson ->
      UI.Lesson.render lesson

    ChoosingLesson keyboard ->
      UI.Menu.percent
        address
        Lesson.name
        ChooseLesson
        (Lesson.score model.stats)
        keyboard.lessons

    ChoosingKeyboard keyboards ->
      UI.Menu.view address .name ChooseKeyboard keyboards

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
