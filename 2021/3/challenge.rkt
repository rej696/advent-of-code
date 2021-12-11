#! /usr/bin/env racket

#lang racket

(define (inc value) (+ value 1))

(define (bit->value bit pos)
  (if (zero? bit)
     bit
     (expt 2 pos)))

(define (from-binary . args)
  (match args
    [(list bit-list)
     (let ([binary (reverse bit-list)])
       (from-binary (cdr binary) (bit->value (car binary) 0) 1))] ; 0 is initial position, 1 is incremented position
    [(list binary value pos)
     (if (null? binary)
        value
        (from-binary (cdr binary) (+ value (bit->value (car binary) pos)) (inc pos)))]))

(define (get-epsilon total bit-count)
  (from-binary (map (lambda (n) (if (> (* n 2) total) 1 0)) bit-count))) ;; todo

(define (get-gamma total bit-count)
  (from-binary (map (lambda (n) (if (< (* n 2) total) 1 0)) bit-count))) ;; todo

(define (calculate-power total bit-count)
  (* (get-gamma total bit-count) (get-epsilon total bit-count)))

(define (get-tail full-list)
  (let ([tail (cdr full-list)])
    (if (pair? tail)
       tail
       (list tail))))

(define (add-lists list1 list2)
  (if (and (null? list1) (null? list2))
     '()
     (cons
      (+ (car list1) (car list2))
      (add-lists (cdr list1) (cdr list2)))))

(define (line->bitlist line)
  (map string->number (map string (string->list line))))

; Multiple arity function using match
(define (read . arg)
  (match arg
    [(list in total bit-count)
     (let ([line (read-line in)])
       (if (eof-object? line)
          (display (calculate-power total bit-count))
            (read in (inc total) (add-lists bit-count (line->bitlist line)))))]
    [(list in total)
       (read in (inc total) (line->bitlist (read-line in)))]
    [(list in)
     (read in 0)]))

(call-with-input-file "2021/3/input.txt"
  read)