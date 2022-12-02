
(setv elves
      (list (map
              (fn [elf]
                (sum (map int
                          (.split (.strip elf) "\n"))))
              (.split (with [f (open "input" "r")]
                        (.read f))
                      "\n\n"))))


(.sort elves)

(print (get elves -1))

(print (sum (cut elves -3 None)))

(list
  (map
    (fn
      [x]
      (+ "hello " x))
    ["world" "people"]))
