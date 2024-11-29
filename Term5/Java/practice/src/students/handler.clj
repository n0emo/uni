(ns students.handler
  #_{:clj-kondo/ignore [:refer-all]}
  (:require
   [compojure.core :refer :all]
   [compojure.route :as route]
   [ring.middleware.defaults :refer [site-defaults wrap-defaults]]
   [students.pages.index :as index]
   [students.pages.not-found :as not-found]
   [students.routes.faculties :refer [faculties-routes]]))

(defroutes app-routes
  faculties-routes
  (GET "/" [] (index/render))
  (route/not-found (not-found/render)))

(def app
  (wrap-defaults
   app-routes
   (assoc-in site-defaults [:security :anti-forgery] false)))
