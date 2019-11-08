module Test.Types where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Fetch (class Fetch, defaultFetch')
import Foreign.Generic (class Decode, class Encode, defaultOptions, genericDecode, genericEncode)
import Test.Utils (userUrl)
import Types (Header(..), Method(..))


newtype CreateUserReq = CreateUserReq
  { name :: String
  , job :: String
  }
derive instance genericCreateUserReq :: Generic CreateUserReq _
instance encodeCreateUserReq :: Encode CreateUserReq where 
  encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })

newtype CreateUserRes = CreateUserRes
  { name :: String
  , job :: String
  , id :: String
  , createdAt :: String
  }
derive instance genericCreateUserRes :: Generic CreateUserRes _
instance decodeCreateUserRes :: Decode CreateUserRes where 
  decode = genericDecode (defaultOptions { unwrapSingleConstructors = true })
instance showCreateUserRes :: Show CreateUserRes where 
  show = genericShow

-- | Fetch instance for CreateUser API
instance fetchCreateUser :: Fetch CreateUserReq CreateUserRes where 
  fetch = defaultFetch' userUrl POST [ Header "Content-Type" "application/json" ]