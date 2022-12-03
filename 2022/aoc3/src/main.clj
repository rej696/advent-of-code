(require '[clojure.java.io :as io])

(defn read-input
  []
  (with-open [rdr (io/reader "input")]
    (doall (line-seq rdr))))

(defn apply-part1
  [line]
  (let [line-len (count line)
        half-len (/ line-len 2)
        fst (for [i (range 0 half-len)]
              (get line i))
        snd (for [i (range half-len line-len)]
              (get line i))]
    (part1 fst snd)))

(defn partx [f lines]
  (reduce + (map f lines)))

(defn c2p [c]
  (if (Character/isUpperCase c)
    (+ (- (int c) (int \A)) 27)
    (+ (- (int c) (int \a)) 1)))

(defn part1
  [fst snd]
  (c2p
    (first
      (filter
        (fn [c]
          (some #(= c %) snd))
        fst))))

(println (partx apply-part1 (read-input)))

