

; read file, return list of lines
(defn read-input []
  (with [f (open "input" "r")]
      (.readlines f)))

; read line, return your score based on function
(defn apply-to-line
  [f line]
  (let [codes (.split line)
        elf-code (get codes 0)
        my-code (get codes 1)]
    (f elf-code my-code)))

; complete partx given a function for x
(defn partx [f lines]
  (sum (map
         (fn [line] (apply-to-line f line))
         lines)))

(setv elf-map {"A" 0 "B" 1 "C" 2})
(setv me-map {"X" 0 "Y" 1 "Z" 2})

; convert elf code to index
(defn elf2idx
  [elf]
  (get elf-map elf))

(defn me2idx
  [me]
  (get me-map me))

; part1
(defn part1
  [elf me]
  (let [elf-idx (elf2idx elf)
        me-idx (me2idx me)]
    (if (= me-idx elf-idx)
      (+ me-idx 4) ; draw
      (if (= me-idx (% (+ elf-idx 1) 3))
        (+ me-idx 7) ; I win
        (+ me-idx 1))))) ; I lose

(setv res-map {"X" -1 "Y" 0 "Z" +1})

(defn res2idx
  [res]
  (get res-map res))

(defn res2score
  [res]
  (get {"X" 0 "Y" 3 "Z" 6} res))

(defn part2
  [elf result]
  (let [elf-idx (elf2idx elf)
        res-idx (res2idx result)
        me-idx (% (+ elf-idx res-idx) 3)
        res-score (res2score result)]
    (+ me-idx res-score 1)))

(print (partx part1 ["A Y" "B X" "C Z"])) ; Test
(print (partx part1 (read-input))) ; Part1
(print (partx part2 (read-input))) ; Part2

