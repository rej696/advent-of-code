(fn add-one [x] (+ x 1))

(fn my-map [f t]
  (let [tbl {}]
    (each [k v (pairs t)]
      (tset tbl k (f v)))
    tbl))

(fn my-filter [f t]
  (let [tbl []]
    (each [_ v (ipairs t)]
      (if (f v)
          (tset tbl (+ (length tbl) 1) v)))
    tbl))

(my-map add-one [1 2 3])

(my-map add-one {:a 1 :b 2 :c 3})

(my-filter (fn [x] (>= x 2)) [1 2 3])


; map style macro
(fn map [f t]
  (collect [k v (pairs t)]
    k (f v)))

(fn imap [f t]
  (collect [_ v (ipairs t)]
    (f v)))

(fn filter [p t]
  (collect [k v (pairs t)]
    (if (p k v)
        k v)))

(fn ifilter [p t]
  (icollect [_ v (ipairs t)]
    (if (p v)
        v)))

; reduce style macro
(accumulate [sum 0
             k v (ipairs [1 2 3])]
  (+ sum k))

(ifilter (fn [x] (> x 1)) [1 2 3])

