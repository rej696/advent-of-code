
; read file, return list of lines
(defn read-input []
  (with [f (open "input" "r")]
      (.readlines f)))

; read line, return your score based on function
(defn apply-to-line
  [f line]
  (let [line-len (len line)
        half-len (// line-len 2)
        fst (lfor i (range half-len) (get line i))
        snd (.join "" (lfor i (range half-len line-len) (get line i)))]
    (f fst snd)))

; complete partx given a function for x
(defn partx [f lines]
  (sum (map
         (fn [line] (apply-to-line f line))
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

(print (partx part1 (read-input)))
