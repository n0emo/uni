(ns students.pages.marks
  (:require
   [hiccup.form :refer [hidden-field label submit-button text-field]]
   [students.pages.base :refer [anti-forgery-input base]]))

(defn- credit-fields [disciplines]
  [(label "discipline-id" "Дисциплина")
   [:select {:name "discipline-id" :id "discipline-id"}
   (for [d disciplines]
     [:option {:value (get d :id)} (str (get d :name) " " (get d :faculty))])]])

(defn- exam-fields [disciplines]
  [(label "value" "Значение")
   (text-field "value")
   (label "discipline-id" "Дисциплина")
   [:select {:name "discipline-id" :id "discipline-id"}
   (for [d disciplines]
     [:option {:value (get d :id)} (str (get d :name) " " (get d :faculty))])]])

(defn- practice-fields []
  [(label "description" "Описание")
   (text-field "description")])

(defn render-new [student mark-kinds kind disciplines]
  (str
    (base
      [:h1 "Добавить оценку"]
      [:form {:action "/marks/new" :method "post"
              :class "primary"}
        (label "mark-kind" "Тип оценки")
        [:select {:name "mark-kind" :id "mark-kind"}
         (for [k mark-kinds]
           (let [k-name (get k :name)
                 k-title (get k :title)]
            [:option {:value k-name :selected (= k-name kind)} k-title]))]
        (label "study-term" "Семестр")
        (text-field "study-term")
        (for [item (case kind
                     "credit"   (credit-fields disciplines)
                     "exam"     (exam-fields disciplines)
                     "practice" (practice-fields))]
          item)
        (hidden-field "student-id" (get student :id))
        (hidden-field "card-id" (get student :card-id))
        (submit-button "Добавить")
        (anti-forgery-input)]
      [:script {:src "/js/marks.js"}])))
