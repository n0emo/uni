(ns students.handler
  (:require
   [compojure.core :refer [defroutes GET]]
   [compojure.route :as route]
   [ring.middleware.defaults :refer [site-defaults wrap-defaults]]
   [students.pages.index :as index]
   [students.pages.not-found :as not-found]
   [students.routes.api :refer [api-routes]]
   [students.routes.disciplines :refer [disciplines-routes]]
   [students.routes.faculties :refer [faculties-routes]]
   [students.routes.groups :refer [groups-routes]]
   [students.routes.marks :refer [marks-routes]]
   [students.routes.programs :refer [programs-routes]]
   [students.routes.students :refer [students-routes]]))

(defroutes app-routes
  faculties-routes
  disciplines-routes
  programs-routes
  groups-routes
  students-routes
  marks-routes
  api-routes
  (GET "/" [] (index/render))
  (route/resources "/")
  (route/not-found (not-found/render)))

#_{:clj-kondo/ignore [:clojure-lsp/unused-public-var]}
(def app
  (wrap-defaults
   app-routes
   site-defaults))
