#! /usr/bin/env racket

#lang racket

(define-syntax dbg
  (syntax-rules ()
    ((_ . rest)
     (let ([expr 'rest]
           [res rest])
       (displayln (list expr '=> res))
       res))))

(define (inc value) (+ value 1))

(define (bit->value bit pos)
  (if (zero? bit)
     bit
     (expt 2 pos)))

(define (from-binary . args)
  (match args
    [(list bit-list)
     (let ([binary (reverse bit-list)])
       (from-binary (rest binary) (bit->value (first binary) 0) 1))] ; 0 is initial position, 1 is incremented position
    [(list binary value pos)
     (if (null? binary)
        value
        (from-binary (rest binary) (+ value (bit->value (first binary) pos)) (inc pos)))]))

(define (get-common-bit . args)
  (match args
    [(list conditional bit-lists pos)
     (get-common-bit conditional bit-lists pos (length bit-lists) 0)]
    [(list conditional bit-lists pos list-length total)
     (if (null? bit-lists)
        (if (conditional (* total 2) list-length) 1 0) ; evaluate the common-bit
        (get-common-bit
         conditional
         (rest bit-lists) pos list-length
         (+ total (list-ref (first bit-lists) pos))))]))

(define (trim-invalid-lists bit-lists common-bit pos new-list)
  (if (null? bit-lists)
     new-list
     (trim-invalid-lists
      (rest bit-lists) common-bit pos
      (let ([bit-list (first bit-lists)])
        (if (= common-bit (list-ref bit-list pos))
           (cons bit-list new-list)
           new-list)))))

(define (get-common-list . args)
  (match args
    [(list conditional bit-lists pos)
     (if (= 1 (length bit-lists))
        (first bit-lists)
        (get-common-list
         conditional
         (trim-invalid-lists
          bit-lists
          (get-common-bit conditional bit-lists pos)
          pos
          empty)
         (inc pos)))]
    [(list conditional bit-lists)
     (get-common-list conditional bit-lists 0)]))

(define (calculate-oxygen bit-lists)
  (dbg from-binary (dbg get-common-list >= bit-lists)))

(define (calculate-co2 bit-lists)
  (dbg from-binary (dbg get-common-list < bit-lists)))

(define (calculate-lifesupport bit-lists)
  (dbg * (calculate-oxygen bit-lists) (calculate-co2 bit-lists)))

(define (line->bitlist line)
  (map string->number (map string (string->list line))))

; Multiple arity function using match
(define (read . arg)
  (match arg
    [(list in bit-lists)
     (let ([line (read-line in)])
       (if (eof-object? line)
          (displayln (calculate-lifesupport bit-lists))
          (read in (cons (line->bitlist line) bit-lists))))]
    [(list in)
     (read in (cons (line->bitlist (read-line in)) empty))]))

(call-with-input-file "2021/3/input.txt"
  read)