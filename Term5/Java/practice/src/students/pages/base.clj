(ns students.pages.base
  (:require
   [hiccup.form :refer [submit-button]]
   [hiccup.page :refer [include-css]]
   [hiccup2.core :as h]
   [ring.middleware.anti-forgery :refer [*anti-forgery-token*]]))

(defn anti-forgery-input []
  [:input {:type "hidden" :name "__anti-forgery-token" :value *anti-forgery-token*}])

(defn- nav-link [title destination]
  [:li [:a {:href destination :class "button"} title]])

(defn- nav-sidebar []
  [:nav
   [:ul
    (nav-link "На главную" "/")
    (nav-link "Факультеты" "/faculties")
    (nav-link "Дисциплины" "/disciplines")
    (nav-link "Программы" "/programs")
    (nav-link "Группы" "/groups")
    (nav-link "О цифровом деканате" "/about")
    [:li
     [:form {:action "/logout" :method "post"
             :class "nav-button"}
      (submit-button "Выйти")
      (anti-forgery-input)]]]])

(defn base [& content]
  (h/html
    (h/raw "<!DOCTYPE html>")
    [:html
     [:head
      [:meta {:charset "UTF-8"}]]
      (include-css "/css/base.css")
     [:body
      (nav-sidebar)
      content]]))
