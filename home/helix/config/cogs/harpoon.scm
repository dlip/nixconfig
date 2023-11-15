(require-builtin helix/core/typable as helix.)
(require-builtin helix/core/static as helix.static.)
(require-builtin helix/core/editor)

(provide harpoon-add)

(define HARPOON-FILE ".helix/harpoon.txt")

(define (read-harpoon-file)
  (unless (path-exists? ".helix")
    (create-directory! ".helix"))

  (cond
    [(path-exists? HARPOON-FILE) (~> (open-input-file HARPOON-FILE) (read-port-to-string) (read!))]
    [else '()]))

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
    (when current-file
      (let ([contents (remove-duplicates (append (read-harpoon-file) (list (current-path cx))))]
            [output-file (open-output-file HARPOON-FILE)])
        (map (lambda (line)
               (when (string? line)
                 (write-line! output-file line)))
             contents)))))

(define (remove-duplicates lst)
  ;; Iterate over, grabbing each value, check if its in the hash, otherwise skip it
  (define (remove-duplicates-via-hash lst accum set)
    (cond
      [(null? lst) accum]
      [else
       (let ([elem (car lst)])
         (if (hashset-contains? set elem)
             (remove-duplicates-via-hash (cdr lst) accum set)
             (remove-duplicates-via-hash (cdr lst) (cons elem accum) (hashset-insert set elem))))]))

  (reverse (remove-duplicates-via-hash lst '() (hashset))))
