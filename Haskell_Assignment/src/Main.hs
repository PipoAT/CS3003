module Main where

import HaskellAssignment

unit_test :: Eq a => a -> a -> [Char]
unit_test expected actual | expected == actual = "Pass"
                          | otherwise = "Fail"

main :: IO ()
main = do
  -- Test findFirst
  putStrLn $ unit_test (NoMatch) $ findFirst ((==) 1) []
  putStrLn $ unit_test (Match 0) $ findFirst ((/=) 1) [10, 1, 9, 2, 8, 3, 7, 4, 6, 5]
  putStrLn $ unit_test (Match 9) $ findFirst ((==) 5) [10, 1, 9, 2, 8, 3, 7, 4, 6, 5]
  putStrLn $ unit_test (Match 0) $ findFirst (11 >) [10, 1, 9, 2, 8, 3, 7, 4, 6, 5]
  putStrLn $ unit_test (NoMatch) $ findFirst (const False) [10, 1, 9, 2, 8, 3, 7, 4, 6, 5]
  putStrLn $ unit_test (NoMatch) $ findFirst ((==) 11) [10, 1, 9, 2, 8, 3, 7, 4, 6, 5]
  -- Test mergesort
  putStrLn $ unit_test [] $ mergesort ((>)::Integer->Integer->Bool) []
  putStrLn $ unit_test [1] $ mergesort (>) [1]
  putStrLn $ unit_test [1, 2] $ mergesort (<) [2,1]
  putStrLn $ unit_test [3, 2, 1] $ mergesort (>) [1, 2, 3]
  putStrLn $ unit_test [1,2,3,4,5,6,7,8,9,10] $ mergesort (<) [10, 1, 9, 2, 8, 3, 7, 4, 6, 5]
  putStrLn $ unit_test [10,9,8,7,6,5,4,3,2,1] $ mergesort (>) [10, 1, 9, 2, 8, 3, 7, 4, 6, 5]
  -- Test palindrome
  putStrLn $ unit_test True $ palindrome ""
  putStrLn $ unit_test True $ palindrome "a"
  putStrLn $ unit_test True $ palindrome "aa"
  putStrLn $ unit_test False $ palindrome "ab"
  putStrLn $ unit_test True $ palindrome "aba"
  putStrLn $ unit_test True $ palindrome "abba"
  putStrLn $ unit_test True $ palindrome "amanaplanacanalpanama"
  putStrLn $ unit_test True $ palindrome "madamimadam"
  putStrLn $ unit_test True $ palindrome "neveroddoreven"
  -- Test runLengthEncode
  putStrLn $ unit_test [ ] $ runLengthEncode ""
  putStrLn $ unit_test [ (Span 1 'a') ] $ runLengthEncode "a"
  putStrLn $ unit_test [ (Span 1 'a'), (Span 1 'b') ] $ runLengthEncode "ab"
  putStrLn $ unit_test [ (Span 2 'a'), (Span 3 'd') ] $ runLengthEncode "aaddd"
  putStrLn $ unit_test [ (Span 2 '1'), (Span 2 '9') ] $ runLengthEncode "1199"
  putStrLn $ unit_test [ (Span 1 '1'), (Span 1 '2'), (Span 1 '3'), (Span 1 '4') ] $ runLengthEncode "1234"
