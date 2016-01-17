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
import Storage.Local as Storage
import Stats exposing (Stats)


typingStats =
  Storage.object "typingStats" Stats.encode Stats.decoder


type Screen
  = Learning Lesson
  | Celebrating
  | ChoosingLesson (List ( String, Lazy String ))
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
  | ChooseLesson (Lazy String)
  | ChooseKeyboard Keyboard


update : Action -> Model -> Model
update action model =
  case ( model.screen, Debug.log "Action" action ) of
    ( Learning lesson, Key k ) ->
      case UI.Lesson.key k lesson of
        ( _, Just (UI.Lesson.Completed stats) ) ->
          let
            stats' =
              Stats.add stats model.stats
          in
            { model
              | screen = Celebrating
              , stats =
                  typingStats.put stats'
                    |> Result.toMaybe
                    |> Maybe.withDefault stats'
            }

        ( lesson', Nothing ) ->
          { model | screen = Learning lesson' }

    ( Learning _, _ ) ->
      model

    ( Celebrating, _ ) ->
      { model | screen = Celebrating }

    ( ChoosingLesson _, ChooseLesson l ) ->
      { model
        | screen =
            Learning (UI.Lesson.init <| Lazy.force l)
      }

    ( ChoosingLesson _, _ ) ->
      model

    ( ChoosingKeyboard _, ChooseKeyboard keyboard ) ->
      { model | screen = ChoosingLesson keyboard.lessons }

    ( ChoosingKeyboard _, _ ) ->
      model


view : Signal.Address Action -> Model -> Layout
view address model =
  case model.screen of
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
