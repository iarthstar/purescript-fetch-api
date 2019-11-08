module Test.Main where

import Prelude (Unit, show, ($), (<>), (>>=))
import Test.Types (CreateUserReq(..), CreateUserRes(..))

import Fetch (fetch)
import Data.Either (Either(..))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class.Console (log, logShow)

main :: Effect Unit
main = launchAff_ do
  let createUserReq = CreateUserReq { name : "Arth K. Gajjar", job : "Developer" }
  fetch createUserReq >>= case _ of
    Right (CreateUserRes a) -> log $ "POST : " <> show a
    Left err -> logShow err

