(ns students.pages.base
  (:require
    [hiccup2.core :as h]))

(defn- nav-link [title destination]
  [:li [:a {:href destination} title]])

(defn- nav-sidebar []
  [:nav
   [:ul
    (nav-link "На главную" "/")
    (nav-link "Факультеты" "/faculties")
    (nav-link "Дисциплины" "/")
    (nav-link "Группы" "/")
    (nav-link "Студенты" "/")
    (nav-link "О цифровом деканате" "/")]])

(defn base [& content]
  (h/html
    (h/raw "<!DOCTYPE html>")
    [:html
     [:head
      [:meta {:charset "UTF-8"}]]
     [:body
      (nav-sidebar)
      content]]))
