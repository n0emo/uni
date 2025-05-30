(ns students.pages.faculties
  (:require
   [hiccup.form :refer [label submit-button text-field]]
   [students.pages.base :refer [anti-forgery-input base]]))

(defn- create-form []
  [:form {:action "/faculties" :method "post" :class "simple"}
   (text-field "name")
   (submit-button "+")
   (anti-forgery-input)])

(defn- faculty-table [faculties]
  [:table
   (for [f faculties]
     (let
       [id (get f :id)
        name (get f :name)]
       [:tr
        [:td
         [:form {:action (str "/faculties/" id "/delete")
                 :method "post" :class "single-button"}
          (submit-button "x")
          (anti-forgery-input)]]
        [:td [:a {:href (str "/faculties/" id "/edit") :class "button"} "✏️"]]
        [:td name]]))])

(defn render [faculties]
  (str
    (base
      [:h1 "Редактировать факультеты"]
      (faculty-table faculties)
      (create-form))))

(defn- edit-form [faculty]
  (let [id (get faculty :id)
        name (get faculty :name)]
    [:form {:action (str "/faculties/" id "/edit")
            :method "post" :class "primary"}
     (label "name" "Название")
     (text-field "name" name)
     (submit-button "Изменить")
     (anti-forgery-input)]))

(defn render-edit [faculty]
  (str
    (base
      [:h1 "Редактировать факультет"]
      (edit-form faculty))))
