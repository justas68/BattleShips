module BattleShips where

import Entities
import Parser
import Encoder
import Lib
import Control.Applicative
import Data.List

shipsOnBoard :: [(String, String)]
shipsOnBoard = [("D", "1"), ("E", "1"), ("C", "2"), ("D", "2"), ("J", "2"), ("J", "3"), ("D", "4"), ("E", "4"), ("F", "4"),("J", "4"), ("F", "5"), ("J", "5"), ("A", "8"), ("B", "8"), ("F", "8"), ("G", "8"), ("H", "8"), ("B", "9"), ("C", "9"), ("G", "9")]

move :: String -> String -> (Char, Int) -> Either String String
move message player coordGuess =
    case createMessage message of
      Left e -> Left e
      Right (msg, _) ->
        case coord msg of
          ("0", "0") -> Left "won"
          _ ->
            case addResult msg of
              Left finalMessage -> Left finalMessage
              Right message -> makeMove message player coordGuess

addResult :: Msg -> Either String Msg
addResult message =
  if coord message `elem` shipsOnBoard
    then
      case score (Msg ("0", "0") "HIT" message) of
        Left e -> Left e
        Right (20, _) ->  Left $ "lost" ++ encode (Msg ("0", "0") "HIT" message)
        Right (_, 20) -> Left $ "lost" ++ encode (Msg ("0", "0") "HIT" message)
        Right (_, _) ->  Right $ Msg ("0", "0") "HIT" message
    else Right $ Msg ("0", "0") "MISS" message

makeMove :: Msg -> String -> (Char, Int) -> Either String String
makeMove (Msg coord result prev) player (coord1, coord2) =
    case getMove (Msg coord result prev) player (coord1, coord2) of
      Left error -> Left error
      Right coords -> Right $ encode $ Msg coords result prev

getMove :: Msg -> String -> (Char, Int) -> Either String (String, String)
getMove message player (coord1, coord2) =
  case findPossibleMove message player of
    Just move -> Right move
    Nothing -> useRandomMove message player (coord1, coord2)
      where
        useRandomMove :: Msg -> String -> (Char, Int) -> Either String (String, String)
        useRandomMove message player (coord1, coord2) =
          if checkIfMoveValid message player (coord1, coord2)
          then Right ([coord1], show coord2)
          else if coord1 < 'J'
            then useRandomMove message player (succ coord1, coord2)
            else if coord2 < 10
              then useRandomMove message player ('A', succ coord2)
              else useRandomMove message player ('A', 1)

findPossibleMove :: Msg -> String -> Maybe (String, String)    
findPossibleMove message player =
  let 
    (playerA, playerB) = splitMoves message [] []
    (playerAHit, playerBHit) = hittedFields message
    playerAHitAcc = map (\(coord1, coord2) -> (head coord1, read coord2 :: Int)) playerAHit
    playerBHitAcc = map (\(coord1, coord2) -> (head coord1, read coord2 :: Int)) playerBHit
    playerAAcc = map (\(coord1, coord2) -> (head coord1, read coord2 :: Int)) playerA
    playerBAcc = map (\(coord1, coord2) -> (head coord1, read coord2 :: Int)) playerB

    findPossibleMoveAcc :: [(Char, Int)] -> [(String, String)] -> [(Char, Int)] -> Maybe (String, String) 
    findPossibleMoveAcc tries _ [] = Nothing
    findPossibleMoveAcc tries hits ((coord1, coord2):hitsAcc) =
      if (((mySucc 'J' coord1), coord2) `notElem` tries) && (not (checkIfNoSunkedShipsNear (coord1, coord2) hits))
        then Just ([(mySucc 'J' coord1)], show coord2)
        else if (((myPred 'A' coord1), coord2) `notElem` tries) && (not (checkIfNoSunkedShipsNear (coord1, coord2) hits))
          then Just ([(myPred 'A' coord1)], show coord2)
          else if ((coord1, (mySucc 10 coord2)) `notElem` tries) && (not (checkIfNoSunkedShipsNear (coord1, coord2) hits))
            then Just ([coord1], show (mySucc 10 coord2))
            else if ((coord1, myPred 1 coord2) `notElem` tries) && (not (checkIfNoSunkedShipsNear (coord1, coord2) hits))
              then Just ([coord1], show (myPred 1 coord2))
              else findPossibleMoveAcc tries hits hitsAcc
  in 
    case player of
      "A" ->
        findPossibleMoveAcc playerAAcc playerAHit playerAHitAcc
      "B" ->
        findPossibleMoveAcc playerBAcc playerBHit playerBHitAcc
        

checkIfMoveValid :: Msg -> String -> (Char, Int) -> Bool
checkIfMoveValid message player (coord1, coord2) =
  let
    (playerA, playerB) = splitMoves message [] []
    (playerAHit, playerBHit) = hittedFields message
  in
    case player of
      "A" ->
        (([coord1], show coord2) `notElem` playerA) &&
        not (checkIfNoSunkedShipsNear (coord1, coord2) playerAHit)

      "B" ->
        (([coord1], show coord2) `notElem` playerB) &&
        not (checkIfNoSunkedShipsNear (coord1, coord2) playerBHit)

checkIfNoSunkedShipsNear :: (Char, Int) -> [(String, String)] -> Bool
checkIfNoSunkedShipsNear coords [] = False
checkIfNoSunkedShipsNear (coord1, coord2) hits =
  isItWholeShipUnderTheSea (succ coord1, coord2+1) hits ||
  isItWholeShipUnderTheSea (pred coord1, coord2+1) hits ||
  isItWholeShipUnderTheSea (coord1, coord2+1) hits ||
  isItWholeShipUnderTheSea (succ coord1, coord2-1) hits ||
  isItWholeShipUnderTheSea (pred coord1, coord2-1) hits ||
  isItWholeShipUnderTheSea (coord1, coord2-1) hits ||
  isItWholeShipUnderTheSea (succ coord1, coord2) hits ||
  isItWholeShipUnderTheSea (pred coord1, coord2) hits

isItWholeShipUnderTheSea :: (Char, Int) -> [(String, String)] -> Bool
isItWholeShipUnderTheSea (coord1, coord2) hits =
  isCoordInBoard (coord1, coord2) && ([coord1], show coord2) `elem` hits && checkIt (coord1, coord2) hits [(coord1, coord2)]
      where
        checkIt :: (Char, Int) -> [(String, String)] -> [(Char, Int)] -> Bool
        checkIt coords hits counted =
          let
            x = findChain [coords] (map (\(coord1, coord2) -> (head coord1, read coord2 :: Int)) hits) []
          in
            (length x == 4)

isCoordInBoard :: (Char, Int) -> Bool
isCoordInBoard (coord1, coord2) = not (coord1 > 'I' || coord1 < 'A' || coord2 > 10 || coord2 < 1)

connected p = map fst . filter ((<=1).snd) . map (liftA2 (,) id (dist p))
          where dist (a,x) (b,y) = (abs (fromEnum a - fromEnum b)) + (abs (y-x))

findChain :: [(Char, Int)]-> [(Char, Int)] -> [(Char, Int)] -> [(Char, Int)]
findChain coords hits chain =
    let
      x = connectedForEach coords [] hits
    in
      if ((sort x) == (sort chain))
        then chain
        else findChain x hits x

connectedForEach :: [(Char, Int)] -> [(Char, Int)] -> [(Char, Int)]-> [(Char, Int)]
connectedForEach (t:h) res hits = connectedForEach h ((connected t hits) ++ res) hits
connectedForEach [] res hits =  (removeDuplicates res)

available :: String -> Either String (Int, Int)
available message =
  case createMessage message of
    Left error -> Left error
    Right (msg, trash) ->
      if checkIfMovesValid msg
        then calculate msg 100 100
        else Left "Same move occured multiple times"
        where
          calculate :: Msg -> Int -> Int -> Either String (Int, Int)
          calculate (Msg ('0':_, '0':_) _ Empty) playerA playerB = Right (playerA, playerB)
          calculate (Msg ('0':_, '0':_) _ prev) playerA playerB = calculate prev playerB playerA
          calculate (Msg _ _ Empty) playerA playerB = Right (playerA - 1, playerB)
          calculate (Msg _ _ prev) playerA playerB = calculate prev playerB (playerA-1)

checkIfMovesValid :: Msg -> Bool
checkIfMovesValid message = not(checkIfExist playerA || checkIfExist playerB)
  where
    (playerA, playerB) = splitMoves message [] []
    checkIfExist :: [(String, String)] -> Bool
    checkIfExist [] = False
    checkIfExist (x:coords) =
      (x `elem` coords) || checkIfExist coords

score :: Msg -> Either String (Int, Int)
score msg =
  if checkIfMovesValid msg
    then calculate msg 0 0 ""
    else Left "Same move occured multiple times"
    where
      calculate :: Msg -> Int -> Int -> String -> Either String (Int, Int)
      calculate (Msg coords "" Empty) _ _ "" = Right (0, 0)
      calculate (Msg coords result prev) playerB playerA "" = calculate prev 0 0 result
      calculate (Msg ('0':_, '0':_) res Empty) playerB playerA result =
        if result /= "HIT"
          then Right (playerB, playerA)
          else Right (playerB, playerA + 1)
      calculate (Msg ('0':_, '0':_) res prev) playerB playerA result =
        if result /= "HIT"
          then calculate prev playerA playerB res
          else calculate prev playerA (playerB + 1) res
      calculate (Msg _ res Empty) playerB playerA result =
        if result /= "HIT"
          then Right (playerB, playerA)
          else Right (playerB, playerA + 1)
      calculate (Msg _ res prev) playerB playerA result =
        if result /= "HIT"
          then calculate prev playerA playerB res
          else calculate prev playerA (playerB + 1) res

splitMoves :: Msg -> [(String, String)] -> [(String, String)] -> ([(String, String)], [(String, String)])
splitMoves (Msg ('0':_, '0':_) _ Empty) playerA playerB = (playerA, playerB)
splitMoves (Msg ('0':_, '0':_) _ prev) playerA playerB = splitMoves prev playerB playerA
splitMoves (Msg coords _ Empty) playerA playerB = (coords : playerA, playerB)
splitMoves (Msg coords _ prev) playerA playerB = splitMoves prev playerB (coords:playerA)

hittedFields :: Msg -> ([(String, String)], [(String, String)])
hittedFields msg =
  calculate msg [] [] ""
    where
      calculate :: Msg -> [(String, String)] -> [(String, String)] -> String -> ([(String, String)], [(String, String)])
      calculate (Msg coords "" Empty) _ _ "" = ([], [])
      calculate (Msg coords result prev) playerB playerA "" = calculate prev [] [] result
      calculate (Msg ('0':_, '0':_) res prev) playerB playerA result = calculate prev playerA playerB res
      calculate (Msg coords res Empty) playerB playerA result =
        if result /= "HIT"
          then (playerB, playerA)
          else (playerB, coords:playerA)
      calculate (Msg coords res prev) playerB playerA result =
        if result /= "HIT"
          then calculate prev playerA playerB res
          else calculate prev playerA (coords:playerB) res




