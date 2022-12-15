(import hyrule)
(require hyrule [->])

(defn read-input [[filename "input"]]
  (with [f (open filename "r")]
    (.split (.read f) "\n\n")))

; parse whole input
(defn parse-input
  [pairs]
  (list (map parse-pair pairs)))

; parse each pair in the input
(defn parse-pair
  [pair]
  (list (map parse-packet (.split pair "\n"))))

; parse each packet in the pair
(defn parse-packet
  [packet]
  (parse-list 1 (tokenise packet)))

; convert string into parsable tokens
(defn tokenise
  [packet]
  (-> (.replace packet "[" "[,")
      (.replace "]" ",]")
      (.split ",")))

; parse list of tokens
(defn parse-list
  [pos tokens]
  (lfor
    i (range pos (len tokens))
    (let [token (get tokens i)]
      (cond
        (= token "[") (parse-list (+ i 1) tokens)
        (= token "]") (break)
        True (parse-atom token)))))

; parse an atom (could be other types than int)
(defn parse-atom
  [token]
  (int token))

; TODO
; compare according to the rules return true if right so far, else false
(defn compare
  [left right])

; TODO figure out logic for this
(defn compare-packet
  [left right]
  (let [[left-head #* left-tail] left
        [right-head #* right-tail] right]
    (cond
      (= (len left-tail) 0) 1)
    (if (compare left-head right-head))))


; returns 0 or 1 depending on if right order or not
(defn handle-pair
  [pair]
  (let [[left right] pair]
    (if (compare left right)
      ()))) ; TODO

; sum results of each pair
(defn part1
  []
  (sum (map handle-pair
            (parse-input (read-input)))))
