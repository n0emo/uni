(ns students.pages.faculties
  (:require
    [students.pages.base :refer [base]]))

(defn- create-form []
  [:form {:action "/faculties" :method "post"}
   [:input {:type "text" :name "name"}]
   [:input {:type "submit" :value "+"}]])

(defn- render-faculty-table [faculties]
  [:table
   (for [f faculties]
     (let
       [id (get f :id)
        name (get f :name)]
       [:tr
        [:td
         [:form {:action (str "/faculties/" id "/delete") :method "post"}
          [:input {:type "submit" :value "x"}]]]
        [:td id]
        [:td name]]))])

(defn render [faculties]
  (str
    (base
      [:h1 "Faculties"]
      (render-faculty-table faculties)
      (create-form))))
