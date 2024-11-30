(ns students.routes.groups
  (:require
   [compojure.coercions :refer [as-int]]
   [compojure.core :refer [context defroutes GET POST]]
   [ring.util.response :refer [redirect]]
   [students.db.core :refer [db]]
   [students.db.groups :as db-groups]
   [students.pages.groups :as html]))

(defn- handle-get []
  (let [groups (db-groups/get-all db)]
    (html/render groups)))

(defn- handle-new-get []
    (html/render-new))

(defn- handle-new-post [name year-formed program-id]
  (db-groups/insert db {:name name :year-formed year-formed :program-id program-id})
  (redirect "/groups"))

(defn- handle-id-get [id]
  (let [group (db-groups/get-by-id db {:id id})]
    (html/render-single group)))

(defn- handle-id-edit-get [id]
  (let [group (db-groups/get-by-id db {:id id})]
    (html/render-edit group)))

(defn- handle-id-edit-post [id name year-formed program-id]
  (db-groups/update-group db {:id id
                              :name name
                              :year-formed year-formed
                              :program-id program-id})
  (redirect (str "/groups/" id)))

(defn- handle-delete [id]
  (db-groups/delete-by-id db {:id id})
  (redirect "/groups"))

(defroutes groups-routes
  (context
    "/groups" []
    (GET "/" [] (handle-get))
    (GET "/new" [] (handle-new-get))
    (POST "/new" [name
                  year-formed :<< as-int
                  program-id :<< as-int]
          (handle-new-post name year-formed program-id))
    (GET "/:id" [id :<< as-int] (handle-id-get id))
    (GET "/:id/edit" [id :<< as-int] (handle-id-edit-get id))
    (POST "/:id/edit" [id :<< as-int
                       name
                       year-formed :<< as-int
                       program-id :<< as-int]
          (handle-id-edit-post id name year-formed program-id))
    (POST "/:id/delete" [id :<< as-int] (handle-delete id))))
