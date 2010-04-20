;;; socket.scm: socket library for uim.
;;;
;;; Copyright (c) 2009-2010 uim Project http://code.google.com/p/uim/
;;;
;;; All rights reserved.
;;;
;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:
;;; 1. Redistributions of source code must retain the above copyright
;;;    notice, this list of conditions and the following disclaimer.
;;; 2. Redistributions in binary form must reproduce the above copyright
;;;    notice, this list of conditions and the following disclaimer in the
;;;    documentation and/or other materials provided with the distribution.
;;; 3. Neither the name of authors nor the names of its contributors
;;;    may be used to endorse or promote products derived from this software
;;;    without specific prior written permission.
;;;
;;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
;;; ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE
;;; FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
;;; OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
;;; HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
;;; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
;;; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
;;; SUCH DAMAGE.
;;;;

(require-extension (srfi 1 2 9))
(use util)
(require "fileio.scm")
(and (not (provided? "socket"))
     (module-load "socket")
     (provide "socket"))

(define addrinfo-ai-flags-alist (addrinfo-ai-flags-alist?))
(define addrinfo-ai-family-alist (addrinfo-ai-family-alist?))
(define addrinfo-ai-socktype-alist (addrinfo-ai-socktype-alist?))
(define addrinfo-ai-protocol-alist (addrinfo-ai-protocol-alist?))

(define (addrinfo-ai-flags-number l)
  (apply logior
         (map (lambda (s)
                (assq-cdr s addrinfo-ai-flags-alist))
              l)))
(define (addrinfo-ai-family-number s)
  (assq-cdr s addrinfo-ai-family-alist))
(define (addrinfo-ai-socktype-number s)
  (assq-cdr s addrinfo-ai-socktype-alist))
(define (addrinfo-ai-protocol-number s)
  (assq-cdr s addrinfo-ai-protocol-alist))

(define (call-with-getaddrinfo-hints flags family socktype protocol thunk)
  (let* ((hints (make-addrinfo)))
    (and flags    (addrinfo-set-ai-flags!    hints (addrinfo-ai-flags-number flags)))
    (and family   (addrinfo-set-ai-family!   hints (addrinfo-ai-family-number   family)))
    (and socktype (addrinfo-set-ai-socktype! hints (addrinfo-ai-socktype-number socktype)))
    (and protocol (addrinfo-set-ai-protocol! hints (addrinfo-ai-protocol-number protocol)))
    (let ((ret (thunk hints)))
      (delete-addrinfo hints)
      ret)))

(define (call-with-getaddrinfo hostname servname hints thunk)
  (let* ((res (getaddrinfo hostname servname hints))
         (ret (if res (thunk res) '())))
    (if res
        (freeaddrinfo (car res)))
    ret))

(define (call-with-sockaddr-un family path thunk)
  (let* ((sun (make-sockaddr-un)))
    (sockaddr-set-un-sun-family! sun family)
    (sockaddr-set-un-sun-path! sun path)
    (let ((ret (thunk sun)))
      (delete-sockaddr-un sun)
      ret)))

(define (call-with-sockaddr-storage thunk)
  (let* ((ss (make-sockaddr-storage))
         (ret (thunk ss)))
    (delete-sockaddr-storage ss)
    ret))

(define shutdown-how-alist (shutdown-how-alist?))

(define (tcp-connect hostname servname)
  (call-with-getaddrinfo-hints
   '($AI_PASSIVE) '$PF_UNSPEC '$SOCK_STREAM #f
   (lambda (hints)
     (call-with-getaddrinfo
      hostname servname hints
      (lambda (res)
        (call/cc
         (lambda (fd)
           (map (lambda (res0)
                  (let ((s (socket (addrinfo-ai-family? res0)
                                   (addrinfo-ai-socktype? res0)
                                   (addrinfo-ai-protocol? res0))))
                    (if (< s 0)
                        #f
                        (if (< (connect s
                                        (addrinfo-ai-addr? res0)
                                        (addrinfo-ai-addrlen? res0))
                               0)
                            (begin
                              (file-close s)
                              #f)
                            (fd s)))))
                res))))))))

(define (unix-domain-socket-connect socket-path)
  (let ((s (socket (addrinfo-ai-family-number '$PF_LOCAL)
                   (addrinfo-ai-socktype-number '$SOCK_STREAM)
                   0)))
    (if (< s 0)
        #f
        (call-with-sockaddr-un
         (addrinfo-ai-family-number '$PF_LOCAL)
         socket-path
         (lambda (sun)
           (if (< (connect s sun (sun-len sun))
                  0)
               (begin
                 (file-close s)
                 #f)
               s))))))

(define *tcp-listen:backlog-length* 5)

(define (tcp-listen hostname servname)
  (filter
   integer?
   (call-with-getaddrinfo-hints
    '($AI_PASSIVE) '$PF_UNSPEC '$SOCK_STREAM #f
    (lambda (hints)
      (call-with-getaddrinfo
       hostname servname hints
       (lambda (res)
         (map (lambda (res0)
                (let ((s (socket (addrinfo-ai-family? res0)
                                 (addrinfo-ai-socktype? res0)
                                 (addrinfo-ai-protocol? res0))))
                  (if (< s 0)
                      #f
                      (if (< (bind s
                                   (addrinfo-ai-addr? res0)
                                   (addrinfo-ai-addrlen? res0))
                             0)
                          (begin
                            (file-close s)
                            #f)
                          (begin
                            (listen s *tcp-listen:backlog-length*)
                            s)))))
              res)))))))

(define (tcp-accept sockets)
  (let ((fds (file-ready? sockets -1)))
    (map (lambda (pfd)
           (call-with-sockaddr-storage
            (lambda (ss)
              (accept (car pfd) ss))))
         fds)))

(define (make-tcp-server thunk)
  (lambda (sockets)
    (let loop ()
      (let ((fds (file-ready? sockets -1)))
        (for-each (lambda (pfd)
                    (call-with-sockaddr-storage
                     (lambda (ss)
                       (let ((socket (accept (car pfd) ss)))
                         (thunk socket)))))
                  fds)
        (loop)))))
