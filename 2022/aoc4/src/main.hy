
; read file, return nested list of elements
(defn read-input []
  (with [f (open "input" "r")]
      (.readlines f)))

(defn is-enveloped? [line]
  (let [range1 (.split (get (.split line ",") 0) "-")
        range2 (.split (get (.split line ",") 1) "-")
        start1 (int (get range1 0))
        start2 (int (get range2 0))
        end1 (int (get range1 1))
        end2 (int (get range2 1))]
    (any [(and (>= start1 start2)
               (<= end1 end2))
          (and (>= start2 start1)
               (<= end2 end1))])))

(defn get-value
  [line]
  (if (is-enveloped? line)
      1
      0))

(print (sum (map get-value (read-input))))

