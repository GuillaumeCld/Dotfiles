;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
onfiguration, email
;; clients, file templates and snippets. It is optional
(setq user-full-name ""
      user-mail-address "")


;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


(after! org-roam
    :ensure t
    :init
    (setq org-roam-v2-ack t)
    :custom
    (setq org-roam-directory "~/Documents/MySite/content-org")
    (setq org-roam-complete-everywhere t)
    (setq org-roam-capture-templates
        '(
            ("d" "default" plain "%?"
            :target (file+head "${slug}.org"
                               "#+title: ${title}\n") :unnarrowed t)
            ("n" "note" plain "%?"
            :target (file+head "Notes/${slug}.org"
                               "#+title: ${title}\n#+hugo_base_dir: ~/Documents/MySite \n#+hugo_section: notes \n"
                               ) :unnarrowed t)
            ("p" "posts" plain "%?"
            :target (file+head "Posts/${slug}.org"
                               "#+title: ${title}\n#+hugo_base_dir: ~/Documents/MySite \n#+hugo_section: posts \n"
                               ) :unnarrowed t)

        )
    )
    :config
    (org-roam-db-autosync-enable)
)
(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use;;
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))



(setq  bibtex-completion-bibliography  (concat (getenv "HOME") "/Documents/MySite/content-org/Notes/Physics_Neural_Networks.bib")
       bibtex-completion-notes-path    (concat (getenv "HOME") "/Documents/MySite/content-org/Notes/")
       bibtex-completion-pdf-field "file"
       bibtex-completion-notes-template-multiple-files
       (concat
        ":PROPERTIES:\n"
        ":ID: ${=key=}\n"
        ":END:\n"
        "#+title: ${title}\n"
        "#+filetags: :${=type=}:zotero:\n"
        "#+hugo_base_dir: ~/Documents/MySite \n"
        "#+hugo_section: notes \n\n"
        "# Document:  cite:${=key=}\n"
        "# Author: ${author-abbrev}\n"
        "# Journal: ${journaltitle}\n"
        "# Date: ${date}\n"
        "# Year: ${year}\n"
        "# Doi: ${doi}\n"
        "# Url: ${url}\n"
        "\n\n"
        "Notes on ${title} (${=type=}) by ${author}.\n\n"
        "${abstract}"
       )
       bibtex-completion-pdf-open-function
       (lambda (fpath)
         (start-process "evince" "*helm-bibtex-evince*" "/usr/bin/evince" fpath))
       )




(defun ox-hugo/export-all (&optional org-files-root-dir dont-recurse)
  "Export all Org files (including nested) under ORG-FILES-ROOT-DIR.

All valid post subtrees in all Org files are exported using
`org-hugo-export-wim-to-md'.

If optional arg ORG-FILES-ROOT-DIR is nil, all Org files in
current buffer's directory are exported.

If optional arg DONT-RECURSE is nil, all Org files in
ORG-FILES-ROOT-DIR in all subdirectories are exported. Else, only
the Org files directly present in the current directory are
exported.  If this function is called interactively with
\\[universal-argument] prefix, DONT-RECURSE is set to non-nil.

Example usage in Emacs Lisp: (ox-hugo/export-all \"~/org\")."
  (interactive)
  (let* ((org-files-root-dir (or org-files-root-dir default-directory))
         (dont-recurse (or dont-recurse (and current-prefix-arg t)))
         (search-path (file-name-as-directory (expand-file-name org-files-root-dir)))
         (org-files (if dont-recurse
                        (directory-files search-path :full "\.org$")
                      (directory-files-recursively search-path "\.org$")))
         (num-files (length org-files))
         (cnt 1))
    (if (= 0 num-files)
        (message (format "No Org files found in %s" search-path))
      (progn
        (message (format (if dont-recurse
                             "[ox-hugo/export-all] Exporting %d files from %S .."
                           "[ox-hugo/export-all] Exporting %d files recursively from %S ..")
                         num-files search-path))
        (dolist (org-file org-files)
          (with-current-buffer (find-file-noselect org-file)
            (message (format "[ox-hugo/export-all file %d/%d] Exporting %s" cnt num-files org-file))
            (org-hugo-export-wim-to-md :all-subtrees)
            (setq cnt (1+ cnt))))
        (message "Done!")))))
