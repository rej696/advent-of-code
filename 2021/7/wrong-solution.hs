import Data.List
-- Parse input of Crabs
-- Sort list of crabs and group into number of crabs in each position
-- apply some statistics (normal distribution?) to find the location with the
-- average population density
-- calculate the fuel cost at each location and multiply by number of crabs at
-- that location


str2int :: String -> Int
str2int s = read s :: Int

isComma :: Char -> Bool
isComma c = c == ','

inc :: Int -> Int
inc x = x + 1

split :: String -> [Int]
split s = case dropWhile isComma s of
  "" -> []
  s' -> str2int w : split s''
    where
      (w, s'') = break isComma s'

groupCrabs :: [Int] -> [[Int]]
groupCrabs xs = group $ sort xs

totalCrabs :: [[Int]] -> Int
totalCrabs xs = sum $ map length xs

singleAverage x t = div (length x) t * head x

intToFloat :: Int -> Float
intToFloat x = fromIntegral x :: Float

intDivide :: Int -> Int -> Float
intDivide x y = a / b
  where a = fromIntegral x :: Float
        b = fromIntegral y :: Float

weightedAverage :: Int -> [[Int]] -> Float
weightedAverage t = foldr
      (\ x -> (+) (intDivide (length x) t * intToFloat (head x))) 0
-- weightedAverage t = foldr (\ x -> (+) (intDivide (length x) t) * intToFloat $ head x) 0

calculateFuel :: Int -> Int -> [[Int]] -> Int
calculateFuel loc t [] = t
calculateFuel loc t (x : xs) = calculateFuel loc (t + (length x * abs (head x - loc))) xs

main = do
  contents <- getContents
  let groupCrabs' = groupCrabs $ split contents
    in print $ calculateFuel (floor (weightedAverage (totalCrabs groupCrabs') groupCrabs' + 0.5)) 0 groupCrabs'