(ns students.pages.students
  (:require
   [students.pages.base :refer [anti-forgery-input base]]))

(defn render-new [group-id]
  (str
    (base
      [:h1 "Добавить студента"]
      [:form {:action "/students/new" :method "post"}
       [:label {:for "name"} "Имя"]
       [:input {:type "text" :name "name" :id "name"}]

       [:label {:for "surname"} "Фамилия"]
       [:input {:type "text" :name "surname" :id "surname"}]

       [:label {:for "fathersname"} "Отчество (если есть)"]
       [:input {:type "text" :name "fathersname" :id "fathersname"}]

       [:label {:for "year-of-birth"} "Год рождения"]
       [:input {:type "text" :name "year-of-birth" :id "year-of-birth"}]

       [:input {:type "hidden" :name "group-id" :value group-id}]

       [:input {:type "submit" :value "Добавить"}]
       (anti-forgery-input)])))

(defn render-single [student marks]
  (let [id (get student :id)]
   (str
      (base
        [:h1 "Информация о студенте"]
        [:p (str (get student :name) " " (get student :surname) " " (get student :fathersname))]
        [:p (str "Год рождения: " (get student :year-of-birth))]
        [:p (str "Год поступления: " (get student :year-of-admission))]
        [:p (str "Группа: " (get student :group))]
        [:a {:href (str "/students/" id "/edit")} "Редактировать"]
        [:h2 "Оценки"]
        (for [m marks]
          (let [term (str (get m :study-term) " семестр ")]
           [:p
           (case (get m :kind)
            "credit"   (str term " экзамен "(get m :discipline) " - зачтено")
            "exam"     (str term " зачёт " (get m :discipline) " - " (get m :value))
            "practice" (str term " практика - " (get m :description)))]))
        [:a {:href (str "/marks/new?student-id=" id)} "Добавить"]))))

(defn render-edit [student]
  (str
    (base
      [:h1 "Редактировать студента"]
      [:form {:action (str "/students/" (get student :id) "/edit") :method "post"}
       [:label {:for "name"} "Имя"]
       [:input {:type "text" :name "name" :id "name" :value (get student :name)}]

       [:label {:for "surname"} "Фамилия"]
       [:input {:type "text" :name "surname" :id "surname" :value (get student :surname)}]

       [:label {:for "fathersname"} "Отчество (если есть)"]
       [:input {:type "text" :name "fathersname" :id "fathersname" :value (get student :fathersname)}]

       [:label {:for "year-of-birth"} "Год рождения"]
       [:input {:type "text" :name "year-of-birth" :id "year-of-birth" :value (get student :year-of-birth)}]

       [:label {:for "group-id"} "ID группы"]
       [:input {:type "text" :name "group-id" :id "group-id" :value (get student :group-id)}]

       [:input {:type "submit" :value "Изменить"}]
       (anti-forgery-input)])))
