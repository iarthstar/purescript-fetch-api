module Types where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Newtype (class Newtype)
import Foreign (Foreign)
import Foreign.Generic (class Decode, class Encode, defaultOptions, genericDecode, genericEncode)
import Foreign.Generic.EnumEncoding (genericEncodeEnum)

data Option = Option String Foreign
derive instance genericOption :: Generic Option _
instance encodeOption :: Encode Option where 
  encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })

data Header = Header String String
derive instance genericHeader :: Generic Header _
instance encodeHeader :: Encode Header where 
  encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })

data Method = GET | POST | PUT | PATCH | DELETE
derive instance genericMethod :: Generic Method _
instance encodeMethod :: Encode Method where 
  encode = genericEncodeEnum { constructorTagTransform: identity }

newtype Response = Response
  { ok :: Boolean
  , status :: Int
  , statusText :: String
  , body :: Foreign
  }
derive instance newtypeResponse :: Newtype Response _
derive instance genericResponse :: Generic Response _
instance decodeResponse :: Decode Response where decode = genericDecode (defaultOptions { unwrapSingleConstructors = true })
