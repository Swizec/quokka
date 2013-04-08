
import Network.URI
import Data.Maybe
import Network.Shpider

import Secrets

login750 :: IO (ShpiderCode)
login750 = runShpider $ do
    download "https://750words.com/auth"
    forms <- getFormsByAction "/auth/signin"

    (loggedin, _) <- case forms of
      theForm : _ -> sendForm $ fillOutForm theForm $ pairs $ do
          "person[mail_address]" =: Secrets.username
          "person[password]" =: Secrets.password
      _ -> download "https://750words.com" -- no login form means we're logged in already

    return loggedin

fetch :: Int -> Int -> IO (Maybe String)
fetch year month = runShpider $ do
  (status, page) <- download "http://750words.com/export/2013/4"

  case status of
    Ok -> return $ Just $ source page
    _ -> return Nothing

main = do
  loggedin <- login750
  content <- fetch 2013 4

  print content
--  case loggedin of
--    Ok -> print $ fromJust $ fetch 2013 4
--    _ -> print "Error"
