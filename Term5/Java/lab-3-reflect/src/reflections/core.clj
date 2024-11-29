(ns reflections.core
  (:gen-class)
  (:require [clojure.reflect :as cr]
            [clojure.pprint :as pprint])
  (:import [org.reflections Reflections]
           [org.reflections ConfigurationBuilder]))

(defn get-classes [package-name]
  (let [config (-> (ConfigurationBuilder.)
                   (.setUrls (java.util.Collections/singleton (java.net.URL. (str "file:./target/classes/"))))
                   (.setScanners (into-array org.reflections.scanners.Scanner [org.reflections.scanners.SubTypesScanner.])))]
    (let [reflect (Reflections. config)]
      ; Here you can return the classes or do something with them
      (.getSubTypesOf reflect Object))) ; Example: get all subclasses of Object
  )

(defn -main
  [& args]
  (pprint/write (get-classes "java.lang")))
