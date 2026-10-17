(ns students.core
  (:gen-class)
  (:require
   [ring.adapter.jetty :as jetty]
   [students.handler :refer [app]]))

(defn -main []
  (jetty/run-jetty app {:port (Integer/parseInt (or (System/getenv "PORT") "3000"))
                        :join? false}))
