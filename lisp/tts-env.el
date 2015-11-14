;;; tts-env.el --- Engine-specific TTS Environment 
;;; $Author: tv.raman.tv $
;;; Description:  Engine-Specific TTS Environment setup.
;;; Keywords: Emacspeak,  Audio Desktop tts-env
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
;;;Copyright (C) 1995 -- 2007, 2011, T. V. Raman
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
;;; MERCHANTABILITY or FITNTTS-ENV FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Emacs; see the file COPYING.  If not, write to
;;; the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

;;}}}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;{{{  introduction

;;; Commentary:

;;; Define data structure and API for setting up, accessing and manipulating TTS environment.
;;; When complete, this will  be used by the various engine configuration functions to set everything in one structure.


;;; Code:

;;}}}
;;{{{  Required modules

(require 'cl)
(declaim  (optimize  (safety 0) (speed 3)))

;;}}}
;;{{{ Structure Definition 

(defstruct tts-env
  name process                               
  default-voice default-speech-rate
  speech-rate-step speech-rate-base 
  list-voices voice-defined-p                       
  get-voice-command define-voice-from-acss                
  )

;;}}}
;;{{{ TTS Env Table:

;;; Store TTS Env structures, keyed by engine name.

(defvar tts-env-table (make-hash-table :test #'eq)
  "TTS environment table keyed by engine name.")

(defsubst tts-env-get (engine-name)
  "Return tts-env structure for specified engine."
  (declare (special tts-env-table))
  (or (gethash  engine-name tts-env-table)
      (gethash  :plain tts-env-table)))


(defsubst tts-env-set (engine-name env)
  "Set up engine-name->env mapping."
  (puthash engine-name  env tts-env-table))

;;; Engine specific tts-env constructur will move to engine-specific modules.
(defun dectalk-make-tts-env  ()
  "Constructs a TTS environment for Dectalk."
  (declare (special tts-default-speech-rate tts-default-voice ))
  (make-tts-env
   :name :dectalk
   :default-voice 'paul
   :default-speech-rate dectalk-default-speech-rate
   :list-voices #'dectalk-list-voices
   :voice-defined-p #'dectalk-voice-defined-p
   :get-voice-command #'dectalk-get-voice-command
   :define-voice-from-acss #'dectalk-define-voice-from-speech-style
   :speech-rate-base 150
   :speech-rate-step 50))

(tts-env-set :dectalk  (dectalk-make-tts-env))
(tts-env-set :outloud  (outloud-make-tts-env))
(tts-env-set :plain  (plain-make-tts-env))
  
        
  
;;}}}
(provide 'tts-env)
;;{{{ end of file

;;; local variables:
;;; folded-file: t
;;; byte-compile-dynamic: t
;;; end:

;;}}}
