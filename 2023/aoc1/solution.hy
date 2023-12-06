; read file, return list of lines
(defn read-input []
  (with [f (open "input" "r")]
      (.readlines f)))

; complete partx given a function for x
(defn partx [f lines]
  (sum (map f lines)))

(setv
  DIGITS
  {"one" "1"
   "two" "2"
   "three" "3"
   "four" "4"
   "five" "5"
   "six" "6"
   "seven" "7"
   "eight" "8"
   "nine" "9"})


(defn get-digits
  [line]
  (lfor
    char line
    :if (.isdigit char)
    char))

(defn word2digit
  [line]
  (do
    (for [i (.keys DIGITS)]
      (setv line (.replace line i (get DIGITS i))))
    line))

; part1
(defn part1
  [line]
  (let [line (.strip line)
        digits (get-digits line)
        first (get digits 0)
        last (get digits -1)]
    (if (and (.isdigit first) (.isdigit last))
      (int (+ first last))
      0)))

(defn part2
  [line]
  (let [line (.strip line)
        digits (get-digits (word2digit line))
        first (get digits 0)
        last (get digits -1)]
    (if (and (.isdigit first) (.isdigit last))
      (int (+ first last))
      0)))

(print (partx part1 ["123" "45z" "z67"])) ; Test
(print (partx part1 (read-input))) ; Part1
(print (partx part2 (read-input))) ; Part2

