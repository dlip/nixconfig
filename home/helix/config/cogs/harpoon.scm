(require-builtin helix/core/typable as helix.)
(require-builtin helix/core/static as helix.static.)
(require-builtin helix/core/editor)

(provide harpoon-add)

(define HARPOON-FILE ".helix/harpoon.txt")

(define (editor-get-doc-if-exists editor doc-id)
  (if (editor-doc-exists? editor doc-id) (editor->get-document editor doc-id) #f))

(define (current-path cx)
  (let* ([editor (cx-editor! cx)]
         [focus (editor-focus editor)]
         [focus-doc-id (editor->doc-id editor focus)]
         [document (editor-get-doc-if-exists editor focus-doc-id)])

    (if document (Document-path document) #f)))

(define (harpoon-add cx)
  (let ([current-file (current-path cx)])
    (if current-file (write-line! (open-output-file HARPOON-FILE) (current-path cx)) '())))
