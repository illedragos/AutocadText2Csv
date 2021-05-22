;; Text 2 CSV  -  Dragos
;; Writes all Text, MText & Attribute content from all layouts and within
;; all blocks and nested blocks to a selected CSV file.
;; comand text2csv

(defun c:txt2csv ( / data file )
    (cond
        (   (not
                (progn
                    (vlax-for block (vla-get-blocks (vla-get-activedocument (vlax-get-acad-object)))
                        (if (eq :vlax-false (vla-get-isxref block))
                            (vlax-for obj block
                                (cond
                                    (   (wcmatch (vla-get-objectname obj) "AcDb*Text")
                                        (setq data (cons (vla-get-textstring obj) data))
                                    )
                                    (   (and
                                            (eq "AcDbBlockReference" (vla-get-objectname obj))
                                            (eq :vlax-true (vla-get-hasattributes obj))
                                        )
                                        (foreach att (vlax-invoke obj 'getattributes)
                                            (setq data (cons (vla-get-textstring att) data))
                                        )
                                    )
                                )
                            )
                        )
                    )
                    data
                )
            )
            (princ "\nNo Text, MText or Attributes found.")
        )
        (   (not (setq file (getfiled "Create CSV file" "" "csv" 1)))
            (princ "\n*Cancel*")
        )
        (   (setq file (open file "w"))
            (foreach x data (write-line x file))
            (setq file (close file))
            (princ (strcat "\n" (itoa (length data)) " strings written to file."))
        )
        (   (princ "\nUnable to open CSV file for writing."))
    )
    (princ)
)
(vl-load-com) (princ)