#! /usr/bin/env racket

#lang racket

(define (inc value) (+ value 1))

; Multiple arity function using match
(define (read . arg)
  (match arg
    [(list in hpos depth)
     (let ([line (read-line in)])
       (if (eof-object? line)
          (display (* hpos depth))
          (let ([split (string-split line)])
            (let ([direction (car split)] ; caar is equivilent to (car (car `((1 2) 3 4))) i.e. 1
                  [value (string->number (cadr split))]) ; cadr is equivilent to (car (cdr `((1 2) 3 4))) i.e. 2
              (match direction
                ["forward" (read in (+ hpos value) depth)]
                ["down" (read in hpos (+ depth value))]
                ["up" (read in hpos (- depth value))])))))]
    [(list in)
     (read in 0 0)]))

(call-with-input-file "2021/2/input.txt"
  read)
