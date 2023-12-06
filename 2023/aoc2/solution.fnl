
(local update-colors
  (lambda [s tbl]
    (let [n2z   (fn [v] (if v v 0))
          green (n2z (s:match "(%d+) green"))
          blue  (n2z (s:match "(%d+) blue"))
          red   (n2z (s:match "(%d+) red"))]
      {:red (+ red tbl.red)
       :blue (+ blue tbl.blue)
       :green (+ green tbl.green)})))

(local update-bools
  (lambda [s tbl]
    (let [n2z   (fn [v] (if v v 0))
          green (tonumber (n2z (s:match "(%d+) green")))
          blue  (tonumber (n2z (s:match "(%d+) blue")))
          red   (tonumber (n2z (s:match "(%d+) red")))]
      {:red (and (<= red 12) tbl.red)
       :blue (and (<= blue 14) tbl.blue)
       :green (and (<= green 13) tbl.green)})))

(local get-game-1
  (lambda [line t]
    (let [idx (line:match "^Game (%d*):")
          line (.. ";" (line:gsub "^Game (%d*):" "") ";")
          list (line:gmatch " (.-);")
          {: red : green : blue} (accumulate [total {:red true :blue true :green true}
                                              balls list]
                                   (update-bools balls total))]
      (if (and red green blue)
          (+ idx t)
          t))))

(local get-max
  (lambda [s tbl]
    (let [n2z   (fn [v] (if v v 0))
          max   (fn [x y] (if (> x y) x y))
          green (tonumber (n2z (s:match "(%d+) green")))
          blue  (tonumber (n2z (s:match "(%d+) blue")))
          red   (tonumber (n2z (s:match "(%d+) red")))]
      {:red (max red tbl.red)
       :blue (max blue tbl.blue)
       :green (max green tbl.green)})))

(local get-game-2
  (lambda [line t]
    (let [idx (line:match "^Game (%d*):")
          line (.. ";" (line:gsub "^Game (%d*):" "") ";")
          list (line:gmatch " (.-);")
          {: red : green : blue} (accumulate [max {:red 0 :blue 0 :green 0}
                                              balls list]
                                   (get-max balls max))
          power (* red green blue)]
      (+ power t))))

; (get-game-2 "Game 1: 1 green, 1 blue, 1 red; 1 green, 8 red, 7 blue; 6 blue, 10 red; 4 red, 9 blue, 2 green; 1 green, 3 blue; 4 red, 1 green, 10 blue" 0)

(with-open [f (io.open :input)]
 (accumulate [total 0 line (f:lines)]
   (get-game-1 line total)))


(with-open [f (io.open :input)]
  (accumulate [total 0 line (f:lines)]
    (get-game-2 line total)))
