(ns sort.core
  (:gen-class)
  (:require [clojure.string :as str]))

(defn quick-sort
  ([elements] (quick-sort > elements))
  ([cmp [pivot & elements]]
   (let [greater? #(cmp % pivot)]
     (when pivot
       (lazy-cat
        (quick-sort cmp (remove greater? elements))
        [pivot]
        (quick-sort cmp (filter greater? elements)))))))

(defn -main
  [& args]
  (try (->> args
            (map #(. Float parseFloat %))
            (quick-sort)
            (str/join " ")
            (println))
       (catch Exception e
         (do
           (println "Error:" (.toString e))
           (System/exit 1)))))
