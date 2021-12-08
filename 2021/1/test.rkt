#! /usr/bin/env racket

#lang racket

(define (extract str)
  (substring str 4 7))

(define (add arg1 arg2)
  (+ arg1 arg2))

(define (inc i)
  (+ i 1))

(define (bake flavor)
  (printf "preheating oven... \n")
  (string-append flavor " pie"))

(define (function arg1 arg2)
  (printf (string-append "hello " arg1 " " arg2 "\n")))

(define (greater-than arg1 arg2)
  (if (> arg1 arg2)
     "true"
     "false"))

(greater-than 5 3)

(define (reply-only-enthusiastic s)
  (if (and (string? s)
          (string-prefix? s "hello ")
          (string-suffix? s "!"))
     "hi!"
     "huh?"))

(define (reply-more s)
  (cond
    [(string-prefix? s "hello ")
     "hi!"]
    [(string-prefix? s "goodbye ")
     "bye!"]
    [(string-suffix? s "?")
     "I don't know"]
    [else "huh?"]))

