module Encoder where

import Data.List
import Entities

encode :: Msg -> String 
encode (Msg (coord1, coord2) res Empty) = coords ++ "e"
  where 
    coords = "d5:coordl1:" ++ coord1 ++ show (length coord2) ++ ":" ++ coord2 ++ "e"
encode (Msg ('0' : _, '0' : _) res prev) = coords ++ encode prev ++ result
  where
    coords = "d5:coordle4:prev"
    result = "6:result" ++ show (length res) ++ ":" ++ res ++ "e"
encode (Msg (coord1, coord2) res prev) = coords ++ encode prev ++ result
  where
    coords = "d5:coordl1:" ++ coord1 ++ show (length coord2) ++ ":" ++ coord2 ++ "e4:prev"
    result = "6:result" ++ show (length res) ++ ":" ++ res ++ "e"

