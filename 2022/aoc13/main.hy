(import hyrule)
(require hyrule [->])

(defn read-input [[filename "input"]]
  (with [f (open filename "r")]
      (map (fn [pair] (.split pair "\n"))
           (.split (.read f) "\n\n"))))

;; (get (get (list (read-input)) 0) 0)
;; (. (list (read-input)) [0] [0])

(defn parse
  [[token]]
  (cond
    (= head "[") True
    (= head "]") False
    True (int head)))

; parse string list representation
(defn read-list
  [tokens]
  (lfor
    token tokens
    (parse token)))

(defn tokenise
  [packet]
  (-> (.replace packet "[" "[,")
      (.replace "]" ",]")
      (.split ",")))



; returns 0 or 1 depending on if right order or not
(defn handle-pair
  [pair]
  (let [[left right] pair]
    (print (tokenise left))))

(handle-pair (get (list (read-input)) 0))

; sum results of each pair
(defn part1
  [pairs]
  (map handle-pair pairs))
