(def mult-peg
  (peg/compile
    ~{:main (* (any :nodes))
      :nodes (+ :expr :garbage)
      :expr (group (* "mul" "(" :num "," :num ")"))
      :num (number (any (range "09")))
      :garbage (any (if-not :expr 1))}))

(def mult-peg-p2
  (peg/compile
    ~{:main (* (any :nodes))
      :nodes (+ :expr :do :dont :garbage)
      :expr (group (* "mul" "(" :num "," :num ")"))
      :num (number (any (range "09")))
      :do (/ "do()" true)
      :dont (/ "don't()" false)
      :garbage (any (if-not (+ :expr :do :dont) 1))}))

(defn mult
  [[x y]]
  (* x y))

(defn filter-mults
  [a]
  (var valid true)
  (seq [v :in a] # loop that returns array
    (if (array? v)
      (if valid
        (mult v)
        0)
      (do (set valid v) 0))))


(defn main [&]
  (def input (string/trim (file/read stdin :all)))
  (pp (reduce + 0 (map mult (peg/match mult-peg input))))
  (def s (peg/match mult-peg-p2 input))
  (pp (reduce + 0 (filter-mults s))))
