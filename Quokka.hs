
--import Network.HTTP
--import Network.HTTP.Conduit
import Network.URI
import Data.Maybe
import Network.Shpider

import Secrets

login750 :: IO (Maybe String)
login750 = runShpider $ do
    download "https://750words.com/auth"
    forms <- getFormsByAction "/auth/signin"

    page <- case forms of
      theForm : _ -> sendForm $ fillOutForm theForm $ pairs $ do
          "person[mail_address]" =: Secrets.username
          "person[password]" =: Secrets.password
      _ -> download "https://750words.com"

    case page of
      (Ok, page) -> return $ Just $ source page
      (_, _) -> return Nothing

main = do
  page <- login750
  print $ page
