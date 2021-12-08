#! /usr/bin/env racket

#lang racket

(define (inc value) (+ value 1))


; Multiple arity function using match
(define (read . arg)
  (match arg
    [(list in value prev)
     (let ([line (read-line in)])
       (if (eof-object? line)
          (display value)
          (let ([cur (string->number line)])
            (read in
                 (if (> cur prev)
                    (inc value)
                    value)
                 cur))))]
    [(list in)
     (read in -1 0)]))



(call-with-input-file "2021/1/input.txt"
  read)
