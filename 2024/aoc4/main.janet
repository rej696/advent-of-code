(def hf-peg
  (peg/compile
    ~{:main (* (any (+ :match :garbage)))
      :match (* "XMAS" ($))
      :garbage (any (if-not :match 1))}))

(defn filter-mults
  [a]
  (var valid true)
  (seq [v :in a] # loop that returns array
    (if (array? v)
      (if valid
        (+ v)
        0)
      (do (set valid v) 0))))


# (defn cols
#   [lines]
#   (for))
# col
# for line in lines
#     for i in range(len(line)):
#         col[i].append(line[i])
#
# [line[i] for]
#
# (apply mapcat)

(defn main [&]
  (def input (string/trim (file/read stdin :all)))
  (def lines (string/split "\n" input))
  (def col-len (length lines))
  (pp (map string/join (apply map array lines)))
  (pp (seq [line :in lines] (+ (length (peg/match hf-peg line))
                               (length (peg/match hf-peg (reverse line)))))))
#  (pp (seq [column :in (do
#                          (var result array)
#                          (each x lines
#                            (set result))
#
#         (+ (length (peg/match hf-peg column))
#            (length (peg/match hf-peg (reverse column)))))))
  # (pp (length (peg/match horizontal-peg input))))
