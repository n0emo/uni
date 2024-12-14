(ns concurrency.core
  (:gen-class)
  (:require
   [clojure.math :as math]
   [clojure.string :as str]))

(defn- read-words [file]
  (->> file
       (slurp)
       (#(str/split % #"\s+"))))

(defn- compute-single-threaded [words]
  (->> words
       (map (comp math/sqrt bigdec))
       (reduce +)))

(defn- compute-parallel [words]
  (->> words
       (partition-all (/ (count words) 4))
       (pmap #(reduce + (map (comp math/sqrt bigdec) %)))
       (reduce +)))

(defn -main
  ([file]
   (-main "-m" file))
  ([option file]
   (let [words (read-words file)
         compute (case option
                   "-s" compute-single-threaded
                   "-p" compute-parallel)
         result (compute words)]
     (println result)
     (shutdown-agents))))
