;;; emacspeak-ein.el --- Speech-enable EIN For IPython Notebooks   -*- lexical-binding: t; -*-
;;; $Id: emacspeak-ein.el 4797 2007-07-16 23:31:22Z tv.raman.tv $
;;; $Author: tv.raman.tv $
;;; Description:  Speech-enable EIN An Emacs Interface to IPython Notebooks
;;; Keywords: Emacspeak,  Audio Desktop IPython, Jupyter, Notebooks
;;{{{  LCD Archive entry:

;;; LCD Archive Entry:
;;; emacspeak| T. V. Raman |raman@cs.cornell.edu
;;; A speech interface to Emacs |
;;; $Date: 2007-05-03 18:13:44 -0700 (Thu, 03 May 2007) $ |
;;;  $Revision: 4532 $ |
;;; Location undetermined
;;;

;;}}}
;;{{{  Copyright:
;;;Copyright (C) 1995 -- 2018, T. V. Raman
;;; Copyright (c) 1994, 1995 by Digital Equipment Corporation.
;;; All Rights Reserved.
;;;
;;; This file is not part of GNU Emacs, but the same permissions apply.
;;;
;;; GNU Emacs is free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 2, or (at your option)
;;; any later version.
;;;
;;; GNU Emacs is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNEIN FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Emacs; see the file COPYING.  If not, write to
;;; the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

;;}}}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;{{{  introduction

;;; Commentary:
;;; EIN ==  Emacs IPython Notebook
;;; You can install package EIN via mELPA
;;; This module speech-enables EIN

;;}}}
;;{{{  Required modules

(require 'cl-lib)
(cl-declaim  (optimize  (safety 0) (speed 3)))
(require 'emacspeak-preamble)

;;}}}
;;{{{  Face->Voice mappings

(voice-setup-add-map
 '(
   (ein:cell-input-area voice-lighten)
   (ein:cell-input-prompt voice-animate)
   (ein:cell-output-area voice-smoothen)
   (ein:cell-output-area-error voice-monotone)
   (ein:cell-output-prompt voice-monotone voice-highlight)
   (ein:cell-output-stderr voice-monotone)
   (ein:markdown-blockquote-face voice-monotone)
   (ein:markdown-bold-face voice-bolden)
   (ein:markdown-code-face voice-lighten)
   (ein:markdown-comment-face voice-monotone)
   (ein:markdown-footnote-marker-face voice-smoothen)
   (ein:markdown-footnote-text-face voice-annotate)
   (ein:markdown-header-delimiter-face voice-monotone)
   (ein:markdown-header-face voice-bolden)
   (ein:markdown-header-face-1 voice-lighten)
   (ein:markdown-header-face-2 voice-smoothen)
   (ein:markdown-header-face-3 voice-annotate)
   (ein:markdown-header-face-4 voice-monotone)
   (ein:markdown-header-face-5 voice-monotone-light)
   (ein:markdown-header-face-6 voice-monotone-medium)
   (ein:markdown-header-rule-face voice-monotone-light)
   (ein:markdown-highlight-face voice-highlight)
   (ein:markdown-hr-face voice-monotone-light)
   (ein:markdown-html-attr-name-face voice-lighten)
   (ein:markdown-html-attr-value-face voice-monotone-light)
   (ein:markdown-html-entity-face voice-smoothen)
   (ein:markdown-html-tag-delimiter-face voice-monotone)
   (ein:markdown-html-tag-name-face voice-smoothen-extra)
   (ein:markdown-inline-code-face voice-monotone)
   (ein:markdown-italic-face voice-animate)
   (ein:markdown-language-info-face voice-monotone)
   (ein:markdown-language-keyword-face voice-annotate)
   (ein:markdown-line-break-face voice-monotone)
   (ein:markdown-link-face voice-animate)
   (ein:markdown-link-title-face voice-bolden)
   (ein:markdown-list-face voice-indent)
   (ein:markdown-markup-face voice-monotone)
   (ein:markdown-math-face voice-annotate)
   (ein:markdown-metadata-key-face voice-smoothen)
   (ein:markdown-metadata-value-face voice-animate)
   (ein:markdown-missing-link-face voice-lighten)
   (ein:markdown-plain-url-face voice-annotate)
   (ein:markdown-pre-face voice-monotone)
   (ein:markdown-reference-face voice-highlight)
   (ein:markdown-strike-through-face voice-lighten)
   (ein:markdown-table-face voice-lighten)
   (ein:markdown-url-face voice-smoothen-extra)
   (ein:notification-tab-normal voice-smoothen-extra)
   (ein:notification-tab-selected voice-animate)
   (ein:pos-tip-face voice-annotate)))

;;}}}
;;{{{ Additional Interactive Commands:

(defun emacspeak-ein-speak-current-cell ()
  "Speak current cell."
  (interactive)
  (emacspeak-auditory-icon 'select-object)
  (let ( (start  (previous-overlay-change (point)))
        (end  (next-overlay-change (point))))
    
    (emacspeak-speak-region start end)))

;;}}}
;;{{{Modules To Enable:

'(ein:debug
  ein:dev
  ein:file
  ein:header
  ein:ipdb
  ein:ipynb
  ein:jupyter
  ein:jupyterhub
  ein:log
  ein:login
  ein:markdown
  ein:notebook
  ein:notebooklist
  ein:pager
  ein:process
  ein:python
  ein:pytools
  ein:run
  ein:shared
  ein:stop
  ein:tb
  ein:traceback
  ein:version
  ein:worksheet
  )

;;}}}
;;{{{ Worksheets:

(cl-loop
 for f in
 '(
   ein:worksheet-clear-all-output-km ein:worksheet-delete-cell
   ein:worksheet-clear-output-km ein:worksheet-kill-cell-km) do
 (eval
  `(defadvice ,f (after emacspeak pre act comp)
     "Provide auditory feedback."
     (when (ems-interactive-p)
       (emacspeak-speak-line)
       (emacspeak-auditory-icon 'delete-object)))))

(cl-loop
 for f in
 '(
   ein:worksheet-execute-all-cell ein:worksheet-execute-cell-and-insert-below
   ein:worksheet-execute-cell-and-goto-next-km ein:worksheet-execute-cell-km) do
 (eval
  `(defadvice ,f (after emacspeak pre act comp)
     "Provide auditory feedback."
     (when (ems-interactive-p)
       (emacspeak-auditory-icon 'task-done)
       (emacspeak-speak-line)))))

(cl-loop
 for f in
 '(
   ein:worksheet-goto-next-input-km ein:worksheet-goto-prev-input-km)
 do
 (eval
  `(defadvice ,f (after emacspeak pre act comp)
     "Provide auditory feedback."
     (when (ems-interactive-p)
       (emacspeak-auditory-icon 'large-movement)
       (emacspeak-ein-speak-current-cell)))))

(cl-loop for f in
         '(
           ein:worksheet-yank-cell
           ein:worksheet-insert-cell-above
           ein:worksheet-insert-cell-below)
         do
         (eval
          `(defadvice ,f (after emacspeak pre act comp)
             "Provide auditory feedback."
             (when (ems-interactive-p)
               (emacspeak-auditory-icon 'yank-object)
               (emacspeak-speak-line)))))


'(  ein:worksheet-change-cell-type-km
  ein:worksheet-copy-cell-km
  ein:worksheet-execute-cell-and-insert-below-km
  ein:worksheet-insert-cell-above-km
  ein:worksheet-insert-cell-below-km
  ein:worksheet-merge-cell-km
  ein:worksheet-move-cell-down-km
  ein:worksheet-move-cell-up-km
  ein:worksheet-rename-sheet-km
  ein:worksheet-set-output-visibility-all-km
  ein:worksheet-split-cell-at-point-km
  ein:worksheet-toggle-cell-type-km
  ein:worksheet-toggle-output-km
  ein:worksheet-yank-cell-km)

;;}}}
;;{{{ Bind additional interactive commands
(when (boundp 'ein:notebook-mode-map)
  (cl-loop for k in
           '(
             ("\C-c." emacspeak-ein-speak-current-cell)
             )
           do
           (emacspeak-keymap-update ein:notebook-mode-map k)))

;;}}}
(provide 'emacspeak-ein)
;;{{{ end of file

;;; local variables:
;;; folded-file: t
;;; end:

;;}}}
