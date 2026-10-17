(ns students.pages.not-found
  (:require [students.pages.base :refer [base]]))

(defn render []
  (str (base [:h1 "По этому адресу ничего нет"])))
