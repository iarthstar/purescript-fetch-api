module Options where

import Types (Header, Method, Option(..))
import Prelude (($), (<<<))

import Foreign.Generic (class Encode, encode)

method :: Method -> Option
method = Option "method" <<< encode 

url :: String -> Option
url = Option "url" <<< encode

timeout :: Int -> Option
timeout = Option "timeout" <<< encode

body :: forall req. Encode req => req -> Option
body = Option "body" <<< encode

auth :: String -> String -> Option
auth username password = Option "auth" $ encode { username, password }

headers :: Array Header -> Option
headers = Option "headers" <<< encode
