
; read file, return list of lines
(defn read-input []
  (with [f (open "input" "r")]
      (.readlines f)))

; read line, return your score based on function
(defn apply-to-line
  [f line]
  (let [length (/ (len line) 2)
        codes (.split line)
        elf-code (get codes 0)
        my-code (get codes 1)]
    (f elf-code my-code)))

; complete partx given a function for x
(defn partx [f lines]
  (sum (map
         (fn [line] (apply-to-line f line))
         lines)))
