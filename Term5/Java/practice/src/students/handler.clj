(ns students.handler
  (:require
   [compojure.core :refer [defroutes GET routes wrap-routes]]
   [compojure.route :as route]
   [ring.middleware.defaults :refer [site-defaults wrap-defaults]]
   [ring.middleware.session.cookie :refer [cookie-store]]
   [students.pages.index :as index]
   [students.pages.not-found :as not-found]
   [students.routes.disciplines :refer [disciplines-routes]]
   [students.routes.faculties :refer [faculties-routes]]
   [students.routes.groups :refer [groups-routes]]
   [students.routes.login :refer [login-routes wrap-protected]]
   [students.routes.marks :refer [marks-routes]]
   [students.routes.programs :refer [programs-routes]]
   [students.routes.students :refer [students-routes]]))

(defroutes app-routes
  login-routes
  (-> (routes
        faculties-routes
        disciplines-routes
        programs-routes
        groups-routes
        students-routes
        marks-routes
        (GET "/" [] (index/render)))
      (wrap-routes wrap-protected))
  (route/resources "/")
  (route/not-found (not-found/render)))

(def app
  (wrap-defaults
   app-routes
   (-> site-defaults
       (assoc-in [:session :store] (cookie-store))
       (assoc-in [:session :cookie-attrs] {:max-age 3600}))))
