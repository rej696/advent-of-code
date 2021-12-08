#! /usr/bin/env racket

#lang racket

(define (inc value) (+ value 1))

(define (read in value prev)
  (let ([line (read-line in)])
    (if (eof-object? line)
       (display value)
       (let ([cur (string->number line)])
         (read in
              (if (> cur prev)
                 (inc value)
                 value)
              cur)))))


(call-with-input-file "1/input.txt"
  (lambda (in) (read in -1 0)))
