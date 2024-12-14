(ns students.core
  (:gen-class)
  (:require
   [ring.adapter.jetty :as jetty]
   [students.handler :refer [app]]))

(defn -main []
  (jetty/run-jetty app {:port 3000
                        :join? false}))
