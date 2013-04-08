
--import Network.HTTP
--import Network.HTTP.Conduit
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

main = do
  loggedin <- login750
  print $ page
