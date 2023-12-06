
; TODO
; This implementation checks digits that have adjectent symbols.
; Need to check full numbers with adjacent symbols, so the fixed idxs list must
; be dynamic based on the size of the number.

(local idxs
  [[-1 -1]
   [-1 0]
   [-1 1]
   [0 -1]
   [0 1]
   [1 -1]
   [1 0]
   [1 1]])

(unpack (. idxs 1))



(local count-part-numbers
       (lambda [grid]
         (let [col-len (length grid)
               row-len (length (. grid 1))]
           (var res 0)
           (for [i 1 col-len]
             (for [j 1 row-len]
               (var s "")
               (when (tonumber (. grid i j))
                 (each [_ [di dj] (ipairs idxs)]
                   (let [i (+ i di)
                         j (+ j dj)]
                     (when (and (>= i 1) (>= j 1) (<= i col-len) (<= j row-len))
                       (set s (.. s (. grid i j)))))))
               (when (s:match "[^%d%.]")
                   (set res (+ res (. grid i j))))))
           res)))



(local str2table
  (lambda [str]
    (let [tbl []]
      (str:gsub "." (fn [c] (table.insert tbl c)))
      tbl)))

(let [grid []]
  (with-open [f (io.open :input)]
    (each [line (f:lines)]
      (table.insert grid (str2table line))))
  (count-part-numbers grid))

