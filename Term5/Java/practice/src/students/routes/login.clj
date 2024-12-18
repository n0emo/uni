(ns students.routes.login 
  (:require
   [compojure.core :refer [context defroutes GET POST]]
   [ring.util.response :refer [redirect]]
   [students.pages.login :as html]))

(defn wrap-protected [handler]
  (fn [request]
    (let [user (-> request :session :user)]
      (if (nil? user)
        (redirect "/login")
        (handler (assoc request :user user))))))

(defn- handle-get []
  (html/render))

(defn- handle-post [login password]
  (if (and (= login "admin") (= password "admin"))
    (let [session {:user login}]
      (-> (redirect "/")
          (assoc :session session)))
    (redirect "/login")))

(defroutes login-routes
  (context
    "/" []
    (GET  "/login" [] (handle-get))
    (POST "/login" [login password] (handle-post login password))))
