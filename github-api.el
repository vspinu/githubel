;; github-api.el --- emacs lisp github api
;;
;; Filename: github-api.el
;; Author: Vitalie Spinu
;; Maintainer: Vitalie Spinu
;; Copyright (C) 2012, Vitalie Spinu, all rights reserved.
;; Created: 19-03-2012
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;

;; This file is *NOT* part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, any later version.
;;
;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
;; FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
;; details.
;;
;; You should have received a copy of the GNU General Public License along with
;; this program; see the file COPYING.  If not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301,
;; USA.
;;
;; Features that might be required by this library:
;;
;;   url - required
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:

;; (loop for pos=(match-end 0 request)
;;       while (string-match ":\\(\\w\\)" request pos)
;;       collect (match-string 1 request))

(defmacro gh-api-build-request (fname-sufix request doc &optional args)
  (let* ((req-type (when (string-match "^\\(\\w+\\) +" request)
		     (match-string 1 request)))
	 (request (substring request (match-end 0)))
	 (infargs (loop for pos = 0 then (match-end 0)
			 while (string-match ":\\(\\w+\\)" request pos)
			 collect (intern (match-string 1 request))))
	 (ARG (loop for a in args
		    collect `(cons (quote ,a) ,a)))
	 (ftrequest (replace-regexp-in-string ":\\w+" "%s" request))
	 (fname   (intern (format "github-%s" fname-sufix)))
	 (reqfun  (intern (format "github-%s" req-type))))
    `(defun ,fname (,@infargs ,@(if args '(&optional)) ,@args)
       ,doc
       (,reqfun (format ,ftrequest ,@infargs) (list ,@ARG)))
    ))

;; (build "repo-get-user" "GET /repos/:user/:repo" "blablabla" (a b c))
