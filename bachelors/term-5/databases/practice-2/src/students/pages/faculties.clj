(ns students.pages.faculties
  (:require
   [students.pages.base :refer [anti-forgery-input base]]))

(defn- create-form []
  [:form {:action "/faculties" :method "post"}
   [:input {:type "text" :name "name"}]
   [:input {:type "submit" :value "+"}]
   (anti-forgery-input)])

(defn- faculty-table [faculties]
  [:table
   (for [f faculties]
     (let
       [id (get f :id)
        name (get f :name)]
       [:tr
        [:td
         [:form {:action (str "/faculties/" id "/delete") :method "post"}
          [:input {:type "submit" :value "x"}]
          (anti-forgery-input)]]
        [:td [:a {:href (str "/faculties/" id "/edit")} "✏️"]]
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
    [:form {:action (str "/faculties/" id "/edit") :method "post"}
     [:input {:type "text" :name "name" :value name}]
     [:input {:type "submit" :value "Изменить"}
      (anti-forgery-input)]]))

(defn render-edit [faculty]
  (str
    (base
      [:h1 "Редактировать факультет"]
      (edit-form faculty))))
