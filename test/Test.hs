module Main where

import BattleShips
import Test.HUnit
import Data.Monoid
import Control.Monad
import System.Exit (exitFailure)

test1Message :: String
test1Message = "d5:coordle4:prevd5:coordl1:J1:5e4:prevd5:coordl1:J1:5e4:prevd5:coordl1:J1:2e4:prevd5:coordl1:J2:10e4:prevd5:coordl1:J1:4e4:prevd5:coordl1:D1:7e4:prevd5:coordl1:J1:3e4:prevd5:coordl1:H1:5e4:prevd5:coordl1:H1:2e4:prevd5:coordl1:J1:6e4:prevd5:coordl1:A1:2e4:prevd5:coordl1:E2:10e4:prevd5:coordl1:J1:9e4:prevd5:coordl1:C1:6e4:prevd5:coordl1:J1:8e4:prevd5:coordl1:I1:4e4:prevd5:coordl1:B1:4e4:prevd5:coordl1:J1:9e4:prevd5:coordl1:I1:4e4:prevd5:coordl1:H1:6e4:prevd5:coordl1:G1:9e4:prevd5:coordl1:G1:9e4:prevd5:coordl1:F1:8e4:prevd5:coordl1:H1:8e4:prevd5:coordl1:H1:7e4:prevd5:coordl1:F1:7e4:prevd5:coordl1:H1:9e4:prevd5:coordl1:F1:9e4:prevd5:coordl1:G1:8e4:prevd5:coordl1:E1:8e4:prevd5:coordl1:I1:8e4:prevd5:coordl1:G1:8e4:prevd5:coordl1:H1:8e4:prevd5:coordl1:F1:8e4:prevd5:coordl1:D1:7e4:prevd5:coordl1:I2:10e4:prevd5:coordl1:A1:8e4:prevd5:coordl1:I1:6e4:prevd5:coordl1:C1:8e4:prevd5:coordl1:E1:1e4:prevd5:coordl1:C2:10e4:prevd5:coordl1:D1:1e4:prevd5:coordl1:D1:9e4:prevd5:coordl1:D1:3e4:prevd5:coordl1:B1:8e4:prevd5:coordl1:E1:2e4:prevd5:coordl1:B2:10e4:prevd5:coordl1:C1:1e4:prevd5:coordl1:C1:9e4:prevd5:coordl1:C1:3e4:prevd5:coordl1:B1:9e4:prevd5:coordl1:B1:2e4:prevd5:coordl1:I1:9e4:prevd5:coordl1:D1:2e4:prevd5:coordl1:A1:6e4:prevd5:coordl1:C1:2e4:prevd5:coordl1:H2:10e4:prevd5:coordl1:H1:7e4:prevd5:coordl1:I1:3e4:prevd5:coordl1:D1:4e4:prevd5:coordl1:A1:9e4:prevd5:coordl1:F1:3e4:prevd5:coordl1:A2:10e4:prevd5:coordl1:F1:5e4:prevd5:coordl1:G1:2e4:prevd5:coordl1:E1:4e4:prevd5:coordl1:H1:3e4:prevd5:coordl1:G1:4e4:prevd5:coordl1:H1:4e4:prevd5:coordl1:F1:4e4:prevd5:coordl1:D1:4e4:prevd5:coordl1:E1:9e4:prevd5:coordl1:F1:3e4:prevd5:coordl1:F1:2e4:prevd5:coordl1:F1:5e4:prevd5:coordl1:A1:8e4:prevd5:coordl1:E1:4e4:prevd5:coordl1:B1:8e4:prevd5:coordl1:G1:4e4:prevd5:coordl1:A1:9e4:prevd5:coordl1:F1:4e4:prevd5:coordl1:C1:8e4:prevd5:coordl1:E1:1e4:prevd5:coordl1:C2:10e4:prevd5:coordl1:C1:1e4:prevd5:coordl1:B1:9e4:prevd5:coordl1:C1:3e4:prevd5:coordl1:D1:9e4:prevd5:coordl1:B1:2e4:prevd5:coordl1:C1:9e4:prevd5:coordl1:D1:1e4:prevd5:coordl1:I1:5e4:prevd5:coordl1:D1:3e4:prevd5:coordl1:B2:10e4:prevd5:coordl1:C1:2e4:prevd5:coordl1:E1:3e4:prevd5:coordl1:E1:2e4:prevd5:coordl1:B1:7e4:prevd5:coordl1:D1:2e4:prevd5:coordl1:E1:7ee6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result3:HITe6:result3:HITe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result3:HITe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result3:HITe6:result3:HITe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result3:HITe6:result3:HITe6:result3:HITe"

test3 = TestCase $ (Left "won") @=? (move test1Message "A" ('K', 5))

test4 = TestCase $ (Left "on") @=? (move test1Message "A" ('K', 5))

testSum = TestCase $ assertEqual "10 + 5 = 15" 5 (10 + 5)

--test1 = TestCase $ assertEqual ("result should be won")  "won" $ move test1Message "A" ('K', 5)

--test2 = TestCase $ assertEqual ("result should be won")  "wn" $ move test1Message "A" ('K', 5)

main :: IO ()
main = do 
  runTestTT tests
  return()

tests = TestList [TestLabel "test1" test3, TestLabel "test2" test4, TestLabel "testSum" testSum]
