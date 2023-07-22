module HaskellAssignment where

------------------------------------------------
-- findFirst
------------------------------------------------
data Found = Match Int | NoMatch deriving Eq
instance Show Found where
  show (Match index) = "Found match at " ++ show index
  show NoMatch = "No match found!"
findFirst :: Eq a => (a -> Bool) -> [a] -> Found
findHelper :: Eq a => (a -> Bool) -> [a] -> Int -> Found

findFirst cond list = findHelper cond list 0
findHelper cond [] _ = NoMatch
findHelper cond (x:xs) i = if cond x then Match i else findHelper cond xs (i + 1)

------------------------------------------------
-- runLengthEncode
------------------------------------------------
data RunLength = Span Integer Char deriving Eq
instance Show RunLength where
  show (Span length c) = "Length: " ++ show length ++ ": " ++ show c
runLengthEncode :: [Char] -> [RunLength]
encodeHelper :: [Char] -> RunLength -> [RunLength] -> [RunLength]

runLengthEncode "" = []
runLengthEncode (c:cs) = encodeHelper cs (Span 1 c) []
encodeHelper "" runLen list = list ++ [runLen]
encodeHelper (c:cs) (Span count oldC) list = if c == oldC
  then encodeHelper cs (Span (count + 1) oldC) list
  else encodeHelper cs (Span 1 c) (list ++ [(Span count oldC)])

------------------------------------------------
-- palindrome
------------------------------------------------
palindrome :: [Char] -> Bool

palindrome [] = True
palindrome [x] = True
palindrome (x:xs) = if x /= last xs then False else palindrome (init xs)

------------------------------------------------
-- mergesort
------------------------------------------------
mergesort :: (Ord a) => (a -> a -> Bool) -> [a] -> [a]
splitA :: (Ord a) => [a] -> [a] -> [a]
splitB :: (Ord a) => [a] -> [a] -> [a]
merge :: (Ord a) => (a -> a -> Bool) -> [a] -> [a] -> [a] -> [a]

mergesort comp [] = []
mergesort comp [x] = [x]
mergesort comp list = merge comp (mergesort comp (splitA list [])) (mergesort comp (splitB list [])) []

splitA [] a = a
splitA (x:xs) a = if length xs `mod` 2 == 0
  then splitA xs a ++ [x]
  else splitA xs a

splitB [] b = b
splitB (x:xs) b = if length xs `mod` 2 == 1
  then splitB xs b ++ [x]
  else splitB xs b

merge comp [] [] result = result
merge comp xs [] result = result ++ xs
merge comp [] ys result = result ++ ys
merge comp (x:xs) (y:ys) result = if comp x y
  then merge comp xs (y:ys) (result ++ [x])
  else merge comp (x:xs) ys (result ++ [y])