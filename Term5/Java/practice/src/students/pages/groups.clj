(ns students.pages.groups
  (:require
   [students.pages.base :refer [anti-forgery-input base]]))

(defn render [groups]
  (str
    (base
      [:h1 "Список групп"]
      [:table
       (for [g groups]
         (let [id (get g :id)
               name (get g :name)
               program (get g :program)]
           [:tr
            [:td [:a {:href (str "/groups/" id)} name]]
            [:td program]]))]
      [:a {:href "/groups/new"} "Добавить группу"])))

(defn render-new []
  (str
    (base
      [:h1 "Новая группа"]
      [:form {:action "/groups/new" :method "post"}
       [:label {:for "name"} "Название"]
       [:input {:type "text" :name "name" :id "name"}]

       [:label {:for "year"} "Год формирования"]
       [:input {:type "text" :name "year-formed" :id "year"}]

       [:label {:for "program"} "ID программы"]
       [:input {:type "text" :name "program-id" :id "program"}]

       [:input {:type "submit" :value "Создать"}]
       (anti-forgery-input)])))

(defn render-single [group students]
  (str
    (let [id (get group :id)
          name (get group :name)
          year (get group :year-formed)
          program (get group :program)]
      (base
        [:h1 (str "Группа " name)]
        [:p (str "Программа: " program)]
        [:p (str "Год формирования: " year)]
        [:a {:href (str "/groups/" id "/edit")} "Редактировать"]
        [:form {:action (str "/groups/" id "/delete") :method "post"}
         [:input {:type "submit" :value "Удалить"}]
         (anti-forgery-input)]
        [:h2 "Список студентов"]
        [:table
         (for [s students]
           (let [s-id (get s :id)
                 s-name (get s :name)
                 s-surname (get s :surname)
                 s-fathersname (get s :fathersname)
                 s-year (get s :year-of-birth)]
             [:tr
              [:td
               [:a {:href (str "/students/" s-id)}
                (str s-name " " s-surname " " s-fathersname)]]
              [:td s-year]]))]
        [:a {:href (str "/students/new?group-id=" id)} "Добавить студента"]))))

(defn render-edit [group]
  (str
    (let [id (get group :id)
          name (get group :name)
          year (get group :year-formed)
          program-id (get group :program-id)]
      (base
      [:form {:action (str "/groups/" id "/edit") :method "post"}
       [:label {:for "name"} "Название"]
       [:input {:type "text" :name "name" :id "name" :value name}]

       [:label {:for "year"} "Год формирования"]
       [:input {:type "text" :name "year-formed" :id "year" :value year}]

       [:label {:for "program"} "ID программы"]
       [:input {:type "text" :name "program-id" :id "program" :value program-id}]

       [:input {:type "submit" :value "Изменить"}]
       (anti-forgery-input)]))))
