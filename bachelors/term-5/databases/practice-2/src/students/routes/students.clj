(ns students.routes.students
  (:require
   [clojure.java.jdbc :as java.jdbc]
   [clojure.string :as str]
   [compojure.coercions :refer [as-int]]
   [compojure.core :refer [context defroutes GET POST]]
   [ring.util.response :refer [redirect]]
   [students.db.core :refer [db]]
   [students.db.marks :as db-marks]
   [students.db.students :as db-students]
   [students.pages.students :as html]))

(defn- handle-new-get [group-id]
  (html/render-new group-id))

(defn- handle-new-post [group-id
                        name
                        surname
                        fathersname
                        year-of-birth]
  (java.jdbc/with-db-transaction [tx db]
    (let [fathersname (if (str/blank? fathersname) nil fathersname)
          card (db-students/insert-card tx {:group-id group-id})
          card-id (get card :id)]
      (db-students/insert-student tx
                                  {:name name
                                   :surname surname
                                   :fathersname fathersname
                                   :year-of-birth year-of-birth
                                   :card-id card-id})
      (redirect (str "/groups/" group-id)))))

(defn- handle-get [id]
  (let [student (db-students/get-student-by-id db {:id id})
        marks (db-marks/get-all db {:card-id (get student :card-id)})]
    (html/render-single student marks)))

(defn- handle-edit-get [id]
  (let [student (db-students/get-student-by-id db {:id id})]
    (html/render-edit student)))

(defn- handle-edit-post [id
                         group-id
                         name
                         surname
                         fathersname
                         year-of-birth]
  (java.jdbc/with-db-transaction [tx db]
    (let [student (db-students/update-student tx {:id id
                                                  :name name
                                                  :surname surname
                                                  :fathersname fathersname
                                                  :year-of-birth year-of-birth})
          card-id (get student :card-id)]
      (db-students/update-card tx {:id card-id :group-id group-id})
      (redirect (str "/students/" id)))))

(defroutes students-routes
  (context
    "/students" []
    (GET "/new" [group-id :<< as-int]
         (handle-new-get group-id))
    (POST "/new" [group-id :<< as-int
                  name
                  surname
                  fathersname
                  year-of-birth :<< as-int]
          (handle-new-post group-id
                           name
                           surname
                           fathersname
                           year-of-birth))
    (context
      "/:id" [id :<< as-int]
      (GET "/" [] (handle-get id))
      (GET "/edit" [] (handle-edit-get id))
      (POST "/edit" [group-id :<< as-int
                     name
                     surname
                     fathersname
                     year-of-birth :<< as-int]
            (handle-edit-post id
                              group-id
                              name
                              surname
                              fathersname
                              year-of-birth)))))
