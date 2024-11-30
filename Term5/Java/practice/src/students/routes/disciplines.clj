(ns students.routes.disciplines
  (:require
   [compojure.coercions :refer [as-int]]
   [compojure.core :refer [context defroutes GET POST]]
   [ring.util.response :refer [redirect]]
   [students.db.core :refer [db]]
   [students.db.disciplines :as db-disciplines]
   [students.db.faculties :as db-faculties]
   [students.pages.disciplines :as html]))

(defn- handle-get []
  (let [disciplines (db-disciplines/get-all db)]
    (html/render disciplines)))

(defn- handle-new-get []
  (let [faculties (db-faculties/get-all db)]
    (html/render-new faculties)))

(defn- handle-new-post [name faculty-id]
  (db-disciplines/insert db {:name name :faculty-id faculty-id})
  (redirect "/disciplines"))

(defn- handle-delete [id]
  (db-disciplines/delete-by-id db {:id id})
  (redirect "/disciplines"))

(defn- handle-edit-get [id]
  (let [discipline (db-disciplines/get-by-id db {:id id})
        faculties (db-faculties/get-all db)]
    (html/render-edit discipline faculties)))

(defn- handle-edit-post [id name faculty-id]
  (db-disciplines/update db {:id id :name name :faculty-id faculty-id})
  (redirect "/disciplines"))

(defroutes disciplines-routes
  (context
    "/disciplines" []
    (GET "/" [] (handle-get))
    (GET "/new" [] (handle-new-get))
    (POST "/new" [name faculty-id :<< as-int]
          (handle-new-post name faculty-id))
    (POST "/:id/delete" [id :<< as-int]
         (handle-delete id))
    (GET "/:id/edit" [id :<< as-int]
         (handle-edit-get id))
    (POST "/:id/edit" [id :<< as-int
                       name
                       faculty-id :<< as-int]
          (handle-edit-post id name faculty-id))))


