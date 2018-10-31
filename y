main :: IO ()
main = runReq def $ do
  let n :: Int
      n = 0
  bs <- req GET (http (pack "battleship.haskell.lt") /: (pack "game") /: pack "a" /~ n) NoReqBody bsResponse (header (B.pack "Accept") (B.pack "application/json"))
  liftIO $ B.putStrLn (responseBody bs)



  module Main where

import BattleShips
import Control.Monad
import Control.Monad.IO.Class
import Data.Aeson
import Data.Default.Class
import Data.Maybe
import Data.Monoid
import Data.Text
import GHC.Generics
import Network.HTTP.Req
import Data.Either
import qualified Data.ByteString.Char8 as B

main :: IO ()
main = do
  putStrLn "attack or defence?"
  v <- getLine
  case v of
    "attack" -> attack
    "defence" -> defence "B"
    _ -> putStrLn "wrong choice"

attack :: IO ()
attack = runReq def $ do
  let s :: String
      s = "d5:coordl1:E1:5ee"
  _ <- req POST (http (pack "battleship.haskell.lt") /: pack "game" /: pack "myPersonalGame" /: pack "player" /: pack "A") (ReqBodyBs (B.pack s)) bsResponse (header (B.pack "Content-Type") (B.pack "application/bencoding"))
  liftIO $ defence "A"

defence :: String -> IO ()
defence player = runReq def $ do

  bs <- req GET (http (pack "battleship.haskell.lt") /: (pack "game") /: pack "myPersonalGame" /: pack "player" /: pack player) NoReqBody bsResponse (header (B.pack "Accept") (B.pack "application/bencoding"))
  let message :: String
      message = B.unpack (responseBody bs)
  let mess :: Either String String
      mess = move message
  when (isLeft mess) $ liftIO $ B.putStrLn (B.pack $ fromLeft "" mess)
  liftIO $ putStrLn "Test"
  when (isRight mess) $ do req POST (http (pack "battleship.haskell.lt") /: pack "game" /: pack "myPersonalGame" /: pack "player" /: pack player) (ReqBodyBs (B.pack (fromRight "" mess))) bsResponse (header (B.pack "Content-Type") (B.pack "application/bencoding"))
  liftIO $ defence player