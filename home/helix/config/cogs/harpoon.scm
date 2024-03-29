(require-builtin helix/core/typable as helix.)
(require-builtin helix/core/static as helix.static.)
(require-builtin helix/core/editor)

(provide harpoon-add
         harpoon-del
         harpoon-next
         harpoon-prev
         harpoon-picker
         harpoon-edit
         harpoon-refresh
         harpoon-debug
         harpoon-goto-0
         harpoon-goto-1
         harpoon-goto-2
         harpoon-goto-3
         harpoon-goto-4
         harpoon-goto-5
         harpoon-goto-6
         harpoon-goto-7
         harpoon-goto-8
         harpoon-goto-9)

(define HARPOON-FILE ".helix/harpoon.txt")
(define (show-msg cx str)
  (helix.run-shell-command cx (list "echo" str) helix.PromptEvent::Validate))

(define (harpoon-debug cx)
  (show-msg cx "hi"))

(define (read-harpoon-file)
  (unless (path-exists? ".helix")
    (create-directory! ".helix"))

  (cond
    [(path-exists? HARPOON-FILE) (~> (open-input-file HARPOON-FILE) (read-port-to-string) (read!))]
    [else '()]))

(define *harpoons* (read-harpoon-file))

(define (flush-harpoons)
  (let ([output-file (open-output-file HARPOON-FILE)])
    (map (lambda (line)
           (when (string? line)
             (write-line! output-file line)))
         *harpoons*)))

(define (harpoon-refresh cx)
  (set! *harpoons* (read-harpoon-file)))

(define (harpoon-edit cx)
  (helix.open cx (list HARPOON-FILE) helix.PromptEvent::Validate))

(define (editor-get-doc-if-exists editor doc-id)
  (if (editor-doc-exists? editor doc-id) (editor->get-document editor doc-id) #f))

(define (current-path cx)
  (let* ([editor (cx-editor! cx)]
         [focus (editor-focus editor)]
         [focus-doc-id (editor->doc-id editor focus)]
         [document (editor-get-doc-if-exists editor focus-doc-id)])

    (if document (Document-path document) #f)))

(define (harpoon-add cx)
  (set! *harpoons* (remove-duplicates (append *harpoons* (list (current-path cx)))))
  (flush-harpoons))

(define (harpoon-del cx)
  (let ([index (find-index *harpoons* (current-path cx))])
    (if index
        ((set! *harpoons* (append (take *harpoons* index) (drop *harpoons* (+ index 1))))
         (flush-harpoons))
        (show-msg cx "Error: not found"))))

(define (harpoon-goto cx index)
  (let ([next-index (cond
                      [(>= index (length *harpoons*)) 0]
                      [(< index 0) (- (length *harpoons*) 1)]
                      [else index])])
    (helix.open cx (list (list-ref *harpoons* next-index)) helix.PromptEvent::Validate)))

(define (find-index list val)
  (define (find l i)
    (cond
      [(empty? l) #f]
      [(equal? (first l) val) i]
      [else (find (rest l) (+ i 1))]))
  (find list 0))

(define (harpoon-inc cx inc)
  (let ([index (find-index *harpoons* (current-path cx))])
    (if index (harpoon-goto cx (+ index inc)) (harpoon-goto cx 0))))

(define (harpoon-next cx)
  (harpoon-inc cx 1))
(define (harpoon-prev cx)
  (harpoon-inc cx -1))

(define (harpoon-goto-0 cx)
  (harpoon-goto cx 0))
(define (harpoon-goto-1 cx)
  (harpoon-goto cx 1))
(define (harpoon-goto-2 cx)
  (harpoon-goto cx 2))
(define (harpoon-goto-3 cx)
  (harpoon-goto cx 3))
(define (harpoon-goto-4 cx)
  (harpoon-goto cx 4))
(define (harpoon-goto-5 cx)
  (harpoon-goto cx 5))
(define (harpoon-goto-6 cx)
  (harpoon-goto cx 6))
(define (harpoon-goto-7 cx)
  (harpoon-goto cx 7))
(define (harpoon-goto-8 cx)
  (harpoon-goto cx 8))
(define (harpoon-goto-9 cx)
  (harpoon-goto cx 9))

(define (harpoon-picker cx)
  (push-component! cx (Picker::new *harpoons*)))

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
