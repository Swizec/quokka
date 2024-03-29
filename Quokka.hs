
import Network.URI
import Data.Maybe
import Network.Shpider
import qualified Data.Map as M

import Secrets

csrftoken :: Form -> String
csrftoken form = fromJust $ M.lookup "authenticity_token" (inputs form)

--login750 :: ShpiderCode
login750 = do
    download "https://750words.com/auth"
    forms <- getFormsByAction "/auth/signin"

    (loggedin, page) <- case forms of
      theForm : _ -> sendForm $ fillOutForm theForm $ pairs $ do
          "person[mail_address]" =: Secrets.username
          "person[password]" =: Secrets.password
          "authenticity_token" =: csrftoken theForm

    return page

--fetch :: Int -> Int -> Maybe String
fetch year month = do
--  (status, page) <- download "http://750words.com/export/2013/4"
  (status, page) <- download "https://750words.com/export/2013/4"


  case status of
    Ok -> return $ Just $ source page
    _ -> return Nothing

main = do
  content <- runShpider $ do
    loggedin <- login750
    --content <- fetch 2013 4

    return loggedin

  print content
--  case loggedin of
--    Ok -> print $ fromJust $ fetch 2013 4
--    _ -> print "Error"
