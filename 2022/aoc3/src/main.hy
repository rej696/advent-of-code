
; read file, return list of lines
(defn read-input []
  (with [f (open "input" "r")]
      (.readlines f)))

; read line, return your score based on function
(defn apply-part1
  [line]
  (let [line-len (len line)
        half-len (// line-len 2)
        fst (lfor i (range half-len) (get line i))
        snd (.join "" (lfor i (range half-len line-len) (get line i)))]
    (part1 fst snd)))

; complete partx given a function for x
(defn partx [f lines]
  (sum (map
         f
         lines)))

; get priority of shared item
(defn c2p [c]
  (if (.isupper c)
    (+ (- (ord c) (ord "A")) 27)
    (+ (- (ord c) (ord "a")) 1)))

(defn part1
  [fst snd]
  (c2p (get
         (lfor
           c fst
           :if (in c snd)
           c)
         0)))

(print (partx apply-part1 (read-input)))

(defn get-groups
  [lines]
  (lfor
     i (range 0 (len lines) 3)
     (lfor
       j (range 3)
       (get lines (+ i j)))))

(defn part2
  [group]
  (c2p (get
         (lfor
           c (get group 0)
           :if (and
                 (in c (get group 1))
                 (in c (get group 2)))
           c)
         0)))


(print (partx part2 (get-groups (read-input))))
