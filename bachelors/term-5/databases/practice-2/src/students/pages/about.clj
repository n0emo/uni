(ns students.pages.about 
  (:require
   [students.pages.base :refer [base]]))

(defn render []
  (str
    (base
      [:h1 "О цифровом деканате"]
      [:p
       (str
         "Данный проект создан в рамках обучения на курсе "
         "\"Программирование на JAVA\" Петербургского государственного "
         "университета путей сообщения."
         ) ])))
