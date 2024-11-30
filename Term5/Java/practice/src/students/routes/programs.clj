(ns students.routes.programs
  (:require
   [compojure.coercions :refer [as-int]]
   [compojure.core :refer [context defroutes GET POST]]
   [ring.util.response :refer [redirect]]
   [students.db.core :refer [db]]
   [students.db.faculties :as db-faculties]
   [students.db.programs :as db-programs]
   [students.pages.programs :as html]))

(defn- handle-get []
  (let [programs (db-programs/get-all db)]
    (html/render programs)))

(defn- handle-new-get []
  (let [kinds (db-programs/get-kinds db)
        faculties (db-faculties/get-all db)]
    (html/render-new kinds faculties)))

(defn- handle-new-post [name faculty-id kind-id]
  (db-programs/insert db {:name name :faculty-id faculty-id :kind-id kind-id})
  (redirect "/programs"))

(defn- handle-delete [id]
  (db-programs/delete-by-id db {:id id})
  (redirect "/programs"))

(defn- handle-edit-get [id]
  (let [program (db-programs/get-by-id db {:id id})
        kinds (db-programs/get-kinds db)
        faculties (db-faculties/get-all db)]
    (html/render-edit program kinds faculties)))

(defn- handle-edit-post [id name kind-id faculty-id]
  (db-programs/update-program db {:id id :name name :faculty-id faculty-id :kind-id kind-id})
  (redirect "/programs"))

(defroutes programs-routes
  (context
    "/programs" []
    (GET "/" [] (handle-get))
    (GET "/new" [] (handle-new-get))
    (POST "/new" [name
                  faculty-id :<< as-int
                  kind-id :<< as-int]
          (handle-new-post name faculty-id kind-id))
    (POST "/:id/delete" [id :<< as-int]
         (handle-delete id))
    (GET "/:id/edit" [id :<< as-int]
         (handle-edit-get id))
    (POST "/:id/edit" [id :<< as-int
                       name
                       kind-id :<< as-int
                       faculty-id :<< as-int]
          (handle-edit-post id name kind-id faculty-id))))


