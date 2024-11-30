(ns students.handler
  (:require
   [compojure.core :refer [defroutes GET]]
   [compojure.route :as route]
   [ring.middleware.defaults :refer [site-defaults wrap-defaults]]
   [students.pages.index :as index]
   [students.pages.not-found :as not-found]
   [students.routes.disciplines :refer [disciplines-routes]]
   [students.routes.faculties :refer [faculties-routes]]))

(defroutes app-routes
  faculties-routes
  disciplines-routes
  (GET "/" [] (index/render))
  (route/not-found (not-found/render)))

#_{:clj-kondo/ignore [:clojure-lsp/unused-public-var]}
(def app
  (wrap-defaults
   app-routes
   site-defaults))
