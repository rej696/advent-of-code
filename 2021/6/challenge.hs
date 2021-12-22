import Data.List
-- Parse input of Laternfish
-- Sort list of fish and group into number of fish in each age group
-- Loop for 80 iterations {
--   remove length at index 0 and add to index 7 and index 9
--   shift lengths in array to the left
-- }
-- output the sum of all the lengths in the list

str2int :: String -> Int
str2int s = read s :: Int

isComma :: Char -> Bool
isComma c = c == ','

dec :: Int -> Int
dec x = x - 1

groupFishes :: [Int] -> [Int]
groupFishes xs = map length (group (sort xs))

split :: String -> [Int]
split s = case dropWhile isComma s of
  "" -> []
  s' -> str2int w : split s''
    where
      (w, s'') = break isComma s'

appendZeros :: Int -> [Int] -> [Int]
appendZeros n xs = xs ++ replicate (n - length xs) 0

breed :: [Int] -> [Int]
breed [] = []
breed xs = breed' (appendZeros 9 xs)

breed' :: [Int] -> [Int]
breed' [] = []
breed' [p0, p1, p2, p3, p4, p5, p6, p7, p8] =
  [p1, p2, p3, p4, p5, p6, p7 + p0, p8, p0]
breed' xs = xs

processDays :: Int -> [Int] -> [Int]
processDays n xs
  | n > 0 = processDays (dec n) (breed xs)
  | otherwise = xs

main :: IO ()
main = do
  contents <- getContents
  print (sum (processDays 255 (groupFishes (split contents))))