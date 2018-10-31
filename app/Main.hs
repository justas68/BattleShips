{-# LANGUAGE OverloadedStrings #-}
module Main where

import BattleShips

import Network.Wreq
import Control.Lens
import System.Random
import qualified Data.ByteString.Lazy.Char8 as B

main :: IO ()
main = do
  putStrLn "Enter game Id"
  gameId <- getLine
  putStrLn "attack or defence?"
  v <- getLine
  case v of
    "attack" -> attack gameId
    "defence" -> defence gameId "B"
    _ -> putStrLn "wrong choice"

attack :: String -> IO ()
attack gameId = do
  let s :: String
      s = "d5:coordl1:E1:7ee"
  let opts = defaults & header "Content-type" .~ ["application/bencoding"]
  postWith opts  ("http://battleship.haskell.lt/game/" ++ gameId ++ "/player/A") $ B.pack s
  defence gameId "A"

defence :: String ->  String ->IO ()
defence gameId player = do
  let opts = defaults & header "Accept" .~ ["application/bencoding"]
  r <- getWith opts  ("http://battleship.haskell.lt/game/" ++ gameId ++ "/player/" ++ player)
  case r ^. responseStatus . statusCode of
    200 -> do
      let mov :: String
          mov = B.unpack (r ^. responseBody)
      coord1 <- randomRIO ('A', 'I' :: Char)
      coord2 <- randomRIO (1, 10 :: Int)
      case move mov player (coord1, coord2) of
        Left mess ->
          case mess of
            "won" -> putStrLn "Gratz, you have won this battle"
            'l' : 'o' : 's' : 't' : rest -> do
              let opts = defaults & header "Content-type" .~ ["application/bencoding"]
              postWith opts ("http://battleship.haskell.lt/game/" ++ gameId ++ "/player/" ++ player) $ B.pack rest
              putStrLn "You lost :("
            error -> putStrLn error
        Right mess -> do
          let opts = defaults & header "Content-type" .~ ["application/bencoding"]
          postWith opts ("http://battleship.haskell.lt/game/" ++ gameId ++ "/player/" ++ player) $ B.pack mess
          defence gameId player
    _ -> putStrLn $ "http request failed (return code " ++ show (r ^. responseStatus . statusCode) ++ ")"



