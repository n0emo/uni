(ns students.routes.api 
  (:require
   [compojure.core :refer [context defroutes GET]]
   [ring.middleware.json :refer [wrap-json-response]]
   [students.db.core :refer [db]]
   [students.db.disciplines :as db-disciplines]))

(defn- handle-disciplines-get []
   (db-disciplines/get-all db))

(defroutes api-routes
  (wrap-json-response
    (context
      "/api" []
      (GET "/disciplines" [] (handle-disciplines-get)))))
