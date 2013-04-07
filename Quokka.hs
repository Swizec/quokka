
import Network.HTTP
import Network.URI
import Data.Maybe

import Secrets

downloadURI :: String -> IO (Either String String)
downloadURI uri =
  do resp <- simpleHTTP request
     case resp of
       Left x -> return $ Left ("Error connecting: " ++ show x)
       Right r -> return $ Right (rspBody r)
  where request = Request {rqURI = uri',
                           rqMethod = GET,
                           rqHeaders = [],
                           rqBody = ""}
        uri' = fromJust $ parseURI uri

login750 :: String -> String -> IO (Either String String)
login750 username password =
  do resp <- simpleHTTP request
     case resp of
       Left x -> return $ Left ("Error logging in: " ++ show x)
       Right r -> return $ Right (rspBody r)
  where request = Request {rqURI = fromJust $ parseURI "https://750words.com/auth/signin",
                           rqMethod = POST,
                           rqHeaders = [],
                           rqBody = "person[email_address]="++username++"&person[password]="++password}


main = do
--  doc <- downloadURI "http://750words.com/export/2013/4"
--  doc <- openURI "http://google.com"
  cookie <- login750 Secrets.username Secrets.password
  print cookie
