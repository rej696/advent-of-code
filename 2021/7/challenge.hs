import Data.List ( group, sort )

-- Parse input of crabs
split :: String -> [Int]
split s = case dropWhile (== ',') s of
  "" -> []
  s' -> (\ s -> read s :: Int) w : split s''
    where
      (w, s'') = break (== ',') s'

-- get a list of tuples of (crabPosition, numOfCrabs)
groupCrabs :: [Int] -> [(Int, Int)]
groupCrabs xs = map (\x -> (head x, length x)) $ group $ sort xs

-- calculate the distance between two positions
distance :: Int -> Int -> Int
distance x y = abs (x - y)

-- calculate the special crab distance (part 2)
crabDistance :: Int -> Int -> Int
crabDistance x y = n * (n + 1) `div` 2
  where n = distance x y

-- calculate the fuel cost for moving the crabs to a given position n
fuelCost :: [(Int, Int)] -> Int -> Int
fuelCost xs n = sum $ map (\(p, l) -> l * crabDistance n p) xs

main = do
  contents <- getContents
  let crabs = split contents
  let start = minimum crabs
  let end = maximum crabs
    in print $ minimum $ map (fuelCost $ groupCrabs crabs) [start .. end]