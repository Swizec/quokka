
--import Network.HTTP
--import Network.HTTP.Conduit
import Network.URI
import Data.Maybe
import Network.Shpider

import Secrets

login750 :: IO (Maybe String)
login750 = runShpider $ do
    download "https://750words.com/auth"
    theForm : _ <- getFormsByAction "/auth/signin"
    page <- sendForm $ fillOutForm theForm $ pairs $ do
          "person[email_address]" =: Secrets.username
          "person[password]" =: Secrets.password

    case page of
      (Ok, page) -> return $ Just $ source page
      (_, page) -> return Nothing

main = do
  page <- login750
  print $ fromJust page
