;;; generic-key-custom.scm: Customization variables for generic key bindings
;;;
;;; Copyright (c) 2003-2005 uim Project http://uim.freedesktop.org/
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
;;; THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
;;; ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
;;; FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
;;; OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
;;; HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
;;; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
;;; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
;;; SUCH DAMAGE.
;;;;

(require "i18n.scm")


(define-custom-group 'global-keys
		     (_ "Global key bindings")
		     (_ "long description will be here."))

(define-custom 'generic-on-key '("zenkaku-hankaku" "<Shift> ")
               '(global-keys)
	       '(key)
	       (_ "[Global] on")
	       (_ "long description will be here"))

(define-custom 'generic-off-key '("zenkaku-hankaku" "<Shift> ")
               '(global-keys)
	       '(key)
	       (_ "[Global] off")
	       (_ "long description will be here"))

(define-custom 'generic-begin-conv-key '(" ")
               '(global-keys)
	       '(key)
	       (_ "[Global] begin conversion")
	       (_ "long description will be here"))

(define-custom 'generic-commit-key '("<IgnoreCase><Control>j" generic-return-key)
               '(global-keys)
	       '(key)
	       (_ "[Global] commit")
	       (_ "long description will be here"))

(define-custom 'generic-cancel-key '("escape" "<IgnoreCase><Control>g")
               '(global-keys)
	       '(key)
	       (_ "[Global] cancel")
	       (_ "long description will be here"))

(define-custom 'generic-next-candidate-key '(" " "down" "<IgnoreCase><Control>n")
               '(global-keys)
	       '(key)
	       (_ "[Global] next candidate")
	       (_ "long description will be here"))

(define-custom 'generic-prev-candidate-key '("up" "<IgnoreCase><Control>p")
               '(global-keys)
	       '(key)
	       (_ "[Global] previous candidate")
	       (_ "long description will be here"))

(define-custom 'generic-next-page-key '("next")
               '(global-keys)
	       '(key)
	       (_ "[Global] next page of candidate window")
	       (_ "long description will be here"))

(define-custom 'generic-prev-page-key '("prior")
               '(global-keys)
	       '(key)
	       (_ "[Global] previous page of candidate window")
	       (_ "long description will be here"))

(define-custom 'generic-beginning-of-preedit-key '("home" "<IgnoreCase><Control>a")
               '(global-keys)
	       '(key)
	       (_ "[Global] beginning of preedit")
	       (_ "long description will be here"))

(define-custom 'generic-end-of-preedit-key '("end" "<IgnoreCase><Control>e")
               '(global-keys)
	       '(key)
	       (_ "[Global] end of preedit")
	       (_ "long description will be here"))

(define-custom 'generic-kill-key '("<IgnoreCase><Control>k")
               '(global-keys advanced)
	       '(key)
	       (_ "[Global] erase after cursor")
	       (_ "long description will be here"))

(define-custom 'generic-kill-backward-key '("<IgnoreCase><Control>u")
               '(global-keys advanced)
	       '(key)
	       (_ "[Global] erase before cursor")
	       (_ "long description will be here"))

(define-custom 'generic-backspace-key '("backspace" "<IgnoreCase><Control>h")
               '(global-keys advanced)
	       '(key)
	       (_ "[Global] backspace")
	       (_ "long description will be here"))

(define-custom 'generic-delete-key '("delete" "<IgnoreCase><Control>d")
               '(global-keys advanced)
	       '(key)
	       (_ "[Global] delete")
	       (_ "long description will be here"))

(define-custom 'generic-go-left-key '("left" "<IgnoreCase><Control>b")
               '(global-keys advanced)
	       '(key)
	       (_ "[Global] left")
	       (_ "long description will be here"))

(define-custom 'generic-go-right-key '("right" "<IgnoreCase><Control>f")
               '(global-keys advanced)
	       '(key)
	       (_ "[Global] right")
	       (_ "long description will be here"))

(define-custom 'generic-return-key '("return" "<IgnoreCase><Control>m")
               '(global-keys advanced)
	       '(key)
	       (_ "[Global] return")
	       (_ "long description will be here"))
