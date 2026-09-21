(ns students.pages.disciplines
  (:require
   [students.pages.base :refer [anti-forgery-input base]]))

(defn- discipline-table [disciplines]
  [:table
   (for [d disciplines]
     (let
       [id (get d :id)
        name (get d :name)
        faculty (get d :faculty)]
       [:tr
        [:td
         [:form {:action (str "/disciplines/" id "/delete") :method "post"
                 :class "single-button"}
          [:input {:type "submit" :value "x"}]
          (anti-forgery-input)]]
        [:td [:a {:href (str "/disciplines/" id "/edit") :class "button"} "✏️"]]
        [:td id]
        [:td name]
        [:td faculty]]))])

(defn render [disciplines]
  (str
    (base
      [:h1 "Редактировать дисциплины"]
      (discipline-table disciplines)
      [:a {:href "/disciplines/new" :class "button"} "Добавить дисциплину"])))

(defn- create-form [disciplines]
  [:form {:action "/disciplines/new" :method "post"
          :class "primary"}
   [:label {:for "name"} "Название"]
   [:input {:type "text" :name "name" :id "name"}]
   [:label {:for "faculty"} "Факультет"]
   [:select {:name "faculty-id" :id "faculty"}
    (for [d disciplines]
      [:option {:value (get d :id)} (get d :name)])]
   [:input {:type "submit" :value "Создать"}]
   (anti-forgery-input)])

(defn render-new [faculties]
  (str
    (base
      (create-form faculties))))

(defn- edit-form [discipline faculties]
  (let [id (get discipline :id)
        name (get discipline :name)
        faculty-id (get discipline :faculty-id)]
  [:form {:action (str "/disciplines/" id "/edit") :method "post"
          :class "primary"}
   [:label {:for "name"} "Название"]
   [:input {:type "text" :name "name" :id "name" :value name}]
   [:label {:for "faculty"} "Факультет"]
   [:select {:name "faculty-id" :id "faculty"}
    (for [f faculties]
      (let [f-id (get f :id)
            f-name (get f :name)]
        [:option {:value f-id :selected (= f-id faculty-id)} f-name]))]
   [:input {:type "submit" :value "Изменить"}]
   (anti-forgery-input)]))

(defn render-edit [discipline faculties]
  (str
    (base
      [:h1 "Редактировать дисциплину"]
      (edit-form discipline faculties))))
