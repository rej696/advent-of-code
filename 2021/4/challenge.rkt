#! /usr/bin/env racket

;; TODO This challenge is not complete

#lang racket

(define-syntax dbg
  (syntax-rules ()
    ((_ . rest)
     (let ([expr 'rest]
           [res rest])
       (displayln (list expr '=> res))
       res))))

(define (inc value) (+ value 1))

(struct cell-t (value circled))

(define (num->cell num)
  (cell-t (string->number num) #f))

(define (line->cells line)
  (map num->cell (string-split line)))

(define (insert-row line rows)
  (cons (line->cells line) rows))

(define (update-map line bingo-map idx)
  (hash-set bingo-map idx
           (insert-row line
                      (if (hash-has-key? bingo-map idx)
                         (hash-ref bingo-map idx)
                         empty))))

;; TODO Incomplete Functions, check the win condition for an individual board

; (define (check-row row)
; (if (null? row)
;   #true
;   (if (cell-t-circled (first row))
;     (check-row (rest row))))) ; check all in single row list are true

; (define (check-cols)) ; take first from each list and check are all true else return false

; ;; TODO finish checking board for win condition
; (define (check-board . args)
;   (match args
;     [(list old-board new-board)
;      (if (null? old-board)
;         #false
;         (if (check-row (first old-board)))
;         (let ([winner ((process-board num
;                       (rest old-board)
;                       (cons (process-row num (first old-board))
;                            new-board)))]
;     [(list old-board)
;      (check-board num old-board empty)]))

; (define (win? . args)
; (match args
; [(list bingo-map)
; (win? bingo-map 0)]
; [(list bingo-map idx)
;   (if (hash-has-key? bingo-map idx)
;      (let ([winner (check-board (hash-ref bingo-map idx))])
;        (if (not winner)
;           (win? bingo-map (inc idx))
;           idx))
;      #false)]))

;; TODO Stub win? function
(define (win? bingo-map)
  #f)

(define (process-cell num cell)
  (if (= num (cell-t-value cell))
     (cell-t num #t)
     cell))

(define (process-row . args)
  (match args
    [(list num old-row)
     (process-row num old-row empty)]
    [(list num old-row new-row)
     (if (null? old-row)
        new-row
        (process-row num
                    (rest old-row)
                    (cons (process-cell num (first old-row)) new-row)))]))

(define (process-board . args)
  (match args
    [(list num old-board new-board)
     (if (null? old-board)
        new-board
        (process-board num
                      (rest old-board)
                      (cons (process-row num (first old-board))
                           new-board)))]
    [(list num old-board)
     (process-board num old-board empty)]))

(define (circle-number num bingo-map idx)
  (if (hash-has-key? bingo-map idx)
     (circle-number num
                   (hash-set bingo-map idx
                            (process-board num
                                          (hash-ref bingo-map idx)))
                   (inc idx))
     bingo-map))

(define (handle-instruction instruction bingo-map)
  (find-winner (rest instruction)
              (dbg circle-number (first instruction) bingo-map 0)))

(define (find-winner instruction bingo-map)
  (let ([winner (win? bingo-map)])
    (if (or (null? instruction) (not winner))
       (displayln winner)
       (handle-instruction instruction bingo-map))))

(define (line->map in instruction bingo-map idx)
  (let ([line (read-line in)])
    (if (eof-object? line)
       (find-winner instruction bingo-map); todo
       (if (string=? line "")
          (line->map in instruction bingo-map (inc idx))
          (line->map in instruction (update-map line bingo-map idx) idx)))))

(define (line->instruction line)
  (map string->number (string-split line ",")))

; Multiple arity function using match
(define (read . arg)
  (match arg
    [(list in instruction bingo-map)
     (line->map in instruction bingo-map -1)]
    [(list in)
     (read in (line->instruction (read-line in)) (hash))]))

(call-with-input-file "2021/4/input.txt"
  read)