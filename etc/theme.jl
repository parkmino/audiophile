;; theme file, written Mon Apr 23 17:46:22 2001
;; created by sawfish-themer -- DO NOT EDIT!

(require 'make-theme)

(let
    ((patterns-alist
      '(("title"
         (inactive . "#444444")
         (focused . "#444444"))
        ("buttons"
         (inactive . "#444444")
         (focused . "#444444"))
        ("title fore"
         (inactive . "#a1a1a1")
         (focused . "#eeeeee"))
        ("buttons fore"
         (inactive . "#a1a1a1")
         (focused . "#eeeeee"))))

     (frames-alist
      '(("typo"
         ((right-edge . 93)
          (left-edge . 31)
          (top-edge . -24)
          (height . 24)
          (foreground . "title fore")
          (background . "title")
          (x-justify . left)
          (y-justify . center)
          (text . window-name)
          (class . title))
         ((right-edge . 62)
          (width . 31)
          (foreground . "buttons fore")
          (height . 24)
          (background . "buttons")
          (y-justify . center)
          (top-edge . -24)
          (class . iconify-button)
          (x-justify . center)
          (text . "—"))
         ((right-edge . 0)
          (foreground . "buttons fore")
          (background . "buttons")
          (y-justify . center)
          (top-edge . -24)
          (height . 24)
          (x-justify . center)
          (text . "×")
          (width . 31)
          (class . close-button))
         ((right-edge . 31)
          (foreground . "buttons fore")
          (background . "buttons")
          (y-justify . center)
          (height . 24)
          (top-edge . -24)
          (text . "☐")
          (x-justify . center)
          (width . 31)
          (class . maximize-button))
         ((height . 24)
          (left-edge . 0)
          (foreground . "buttons fore")
          (background . "buttons")
          (y-justify . center)
          (x-justify . center)
          (text . "☰")
          (width . 31)
          (top-edge . -24)
          (class . menu-button))
         ((height . 5)
          (right-edge . 0)
          (bottom-edge . 0)
          (foreground . "buttons fore")
          (background . "buttons")
          (width . 5)
          (class . bottom-right-corner)))))

     (mapping-alist
      '((default . "typo")
        (transient . "typo")
        (shaped-transient . "typo")
        (shaped . "typo")))

     (theme-name 'typo))

  (add-frame-style
   theme-name (make-theme patterns-alist frames-alist mapping-alist))
  (when (boundp 'mark-frame-style-editable)
    (mark-frame-style-editable theme-name)))
