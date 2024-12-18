(ns students.pages.login 
  (:require
   [hiccup.form :refer [form-to label submit-button text-field]]
   [hiccup.page :refer [include-css]]
   [hiccup2.core :as h]
   [students.pages.base :refer [anti-forgery-input]]))

(defn render []
  (str
  (h/html
    (h/raw "<!DOCTYPE html>")
    [:html
     [:head
      [:meta {:charset "UTF-8"}]]
      (include-css "/css/base.css")
     [:body
      (form-to
        [:post "/login"]
        [:h1 "Авторизация"]
        (label "login" "Логин")
        (text-field "login")
        (label "password" "Пароль")
        (text-field "password")
        (submit-button "Войти")
        (anti-forgery-input))]])))
