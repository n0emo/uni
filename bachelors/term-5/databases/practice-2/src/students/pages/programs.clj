(ns students.pages.programs
  (:require
   [students.pages.base :refer [anti-forgery-input base]]))

(defn- program-table [programs]
  [:table
   (for [p programs]
     (let
       [id (get p :id)
        name (get p :name)
        kind (get p :kind)
        faculty (get p :faculty)]
       [:tr
        [:td
         [:form {:action (str "/programs/" id "/delete") :method "post"
                 :class "single-button"}
          [:input {:type "submit" :value "x"}]
          (anti-forgery-input)]]
        [:td [:a {:href (str "/programs/" id "/edit") :class "button"} "✏️"]]
        [:td id]
        [:td name]
        [:td kind]
        [:td faculty]]))])

(defn render [programs]
  (str
    (base
      [:h1 "Редактировать программы обучения"]
      (program-table programs)
      [:a {:href "/programs/new" :class "button"} "Добавить программу"])))

(defn- create-form [kinds faculties]
  [:form {:action "/programs/new" :method "post"
          :class "primary"}
   [:label {:for "name"} "Название"]
   [:input {:type "text" :name "name" :id "name"}]

   [:label {:for "kind"} "Вид программы"]
   [:select {:name "kind-id" :id "kind"}
    (for [k kinds]
      [:option {:value (get k :id)} (get k :name)])]

   [:label {:for "faculty"} "Факультет"]
   [:select {:name "faculty-id" :id "faculty"}
    (for [f faculties]
      [:option {:value (get f :id)} (get f :name)])]

   [:input {:type "submit" :value "Создать"}]
   (anti-forgery-input)])

(defn render-new [kinds faculties]
  (str
    (base
      (create-form kinds faculties))))

(defn- edit-form [program kinds faculties]
  (let [id (get program :id)
        name (get program :name)
        kind-id (get program :kind-id)
        faculty-id (get program :faculty-id)]
  [:form {:action (str "/programs/" id "/edit") :method "post"
          :class "primary"}
   [:label {:for "name"} "Название"]
   [:input {:type "text" :name "name" :id "name" :value name}]

   [:label {:for "kind"} "Вид программы"]
   [:select {:name "kind-id" :id "kind"}
    (for [k kinds]
      (let [k-id (get k :id)
            k-name (get k :name)]
        [:option {:value k-id :selected (= k-id kind-id) } k-name]))]

   [:label {:for "faculty"} "Факультет"]
   [:select {:name "faculty-id" :id "faculty"}
    (for [f faculties]
      (let [f-id (get f :id)
            f-name (get f :name)]
        [:option {:value f-id :selected (= f-id faculty-id) } f-name]))]

   [:input {:type "submit" :value "Изменить"}]
   (anti-forgery-input)]))

(defn render-edit [program kinds faculties]
  (str
    (base
      [:h1 "Редактировать дисциплину"]
      (edit-form program kinds faculties))))
