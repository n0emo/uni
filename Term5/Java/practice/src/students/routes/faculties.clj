(ns students.routes.faculties 
  (:require
   [compojure.coercions :refer [as-int]]
   [compojure.core :refer [context defroutes GET POST]]
   [ring.util.response :refer [redirect]]
   [students.db.core :refer [db]]
   [students.db.faculties :as db-faculties]
   [students.pages.faculties :as html]))

(defn- handle-get []
  (let [faculties (db-faculties/get-all db)]
    (html/render faculties)))

(defn- handle-post [name]
  (db-faculties/insert db {:name name})
  (redirect "/faculties"))

(defn- handle-delete [id]
  (db-faculties/delete-by-id db {:id id})
  (redirect "/faculties"))

(defroutes faculties-routes
  (context
    "/faculties" []
    (GET    "/" [] (handle-get))
    (POST   "/" [name] (handle-post name))
    (POST "/:id/delete" [id :<< as-int] (handle-delete id))))
