module Fetch 
  ( fetch
  , class Fetch
  , genericFetch
  , defaultFetch
  , defaultFetch'
  ) where

import Prelude

import Control.Monad.Except (runExcept)
import Data.Either (Either(..))
import Effect.Aff (Aff, Error, attempt, error)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)
import Foreign (Foreign)
import Foreign.Generic (class Decode, class Encode, decode, encode)
import Options (headers, method)
import Types (Header, Method, Option, Response(..))

foreign import _fetch :: String -> Foreign -> Foreign -> EffectFnAff Response

class Fetch req res | req -> res where
  fetch :: req -> Aff (Either Error res)

genericFetch :: forall req res. Decode res => Encode req => String -> Array Option -> req -> Aff (Either Error res)
genericFetch url options req = do
  attempt (fromEffectFnAff $ _fetch url (encode options) (encode req)) <#> responseToNewtype

defaultFetch :: forall req res. Decode res => Encode req => String -> Method -> req -> Aff (Either Error res)
defaultFetch url methodType req = do
  let optionsF = encode [ method methodType ]
  attempt (fromEffectFnAff $ _fetch url optionsF (encode req)) <#> responseToNewtype

defaultFetch' :: forall req res. Decode res => Encode req => String -> Method -> Array Header -> req -> Aff (Either Error res)
defaultFetch' url methodType headersArr req = do
  let optionsF = encode [ method methodType, headers headersArr ]
  attempt (fromEffectFnAff $ _fetch url optionsF (encode req)) <#> responseToNewtype

responseToNewtype :: forall res. Decode res => Either Error Response -> Either Error res
responseToNewtype = case _ of
  Right (Response a) -> case runExcept $ decode a.body of
    Right x -> Right x
    Left err -> Left $ error $ show err
  Left err ->  Left err