(ns students.pages.index
  (:require [students.pages.base :refer [base]]))

(defn render []
  (str (base [:h1 "Главная"])))
