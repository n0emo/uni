(ns students.routes.marks 
  (:require
   [clojure.java.jdbc :as java.jdbc]
   [compojure.coercions :refer [as-int]]
   [compojure.core :refer [context defroutes GET POST]]
   [ring.util.response :refer [redirect]]
   [students.db.core :refer [db]]
   [students.db.disciplines :as db-disciplines]
   [students.db.marks :as db-marks]
   [students.db.students :as db-students]
   [students.pages.marks :as pages]))

(defn- handle-new-get [student-id kind-id]
  (let [student (db-students/get-student-by-id db {:id student-id})
        mark-kinds (db-marks/get-kinds db)
        disciplines (db-disciplines/get-all db)]
    (pages/render-new student mark-kinds kind-id disciplines)))

(defn- handle-new-post [card-id student-id mark-kind study-term params]
  (java.jdbc/with-db-transaction [tx db]
    (let [mark (db-marks/insert-mark tx {:kind mark-kind
                                         :card-id card-id
                                         :study-term study-term})
          mark-id (get mark :id)]
      (case mark-kind
        "credit"  (db-marks/insert-credit tx
                                          {:mark-id mark-id
                                           :discipline-id (Integer/parseInt (get params :discipline-id))})
        "exam"    (db-marks/insert-exam tx
                                        {:mark-id mark-id
                                         :discipline-id (Integer/parseInt (get params :discipline-id))
                                         :value (Integer/parseInt (get params :value))})
        "practice" (db-marks/insert-practice tx
                                             {:mark-id mark-id
                                              :description (get params :description)}))))
  (redirect (str "/students/" student-id)))

(defroutes marks-routes
  (context
    "/marks" []
    (GET "/new" [student-id :<< as-int
                 :as {params :params}]
         (let [kind-id (get params :kind "credit")] (handle-new-get student-id kind-id)))
    (POST "/new" [card-id :<< as-int
                  student-id :<< as-int
                  mark-kind
                  study-term :<< as-int
                  :as {params :params}]
          (handle-new-post card-id student-id mark-kind study-term params))))
