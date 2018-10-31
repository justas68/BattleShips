module Lib where
import Data.List

myPred :: (Enum a, Ord a) => a -> a -> a
myPred bound val = if pred val >= bound then pred val else val

mySucc :: (Enum a, Ord a) => a -> a -> a 
mySucc bound val = if succ val <= bound then succ val else val

removeDuplicates :: (Eq a) => [a] -> [a]
removeDuplicates = foldr (\x seen -> if x `elem` seen then seen else x : seen) []