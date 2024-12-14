(ns reflections.core
  (:gen-class)
  (:require
   [clojure.reflect :as cr]
   [clojure.string :as str]))

(defn- print-sorted [fields]
  (if (empty? fields)
    (println "  none")
    (doseq [f (sort fields)]
      (println " " f))))

(defn- print-members [members msg to-str predicate]
  (println msg)
  (print-sorted (-> [f (filter predicate members)]
                    (for (to-str f)))))

(defn- static? [member]
  (contains? (get member :flags) :static))

(defn- field? [m]
  (contains? m :type))

(defn- method? [m]
  (contains? m :return-type))

(defn- field-to-str [f]
  (format "%s %s %s"
          (str/join " " (map name (into [] (get f :flags))))
          (get f :type)
          (get f :name)))

(defn- method-to-str [f]
  (format "%s %s %s(%s)"
          (str/join " " (map name (into [] (get f :flags))))
          (get f :return-type)
          (get f :name)
          (str/join ", " (get f :parameter-types))))

(defn- print-all-members [members]
  (print-members members "Static fields" field-to-str
                 (every-pred field? static?))
  (print-members members "Static methods" method-to-str
                 (every-pred method? static?))
  (println)
  (print-members members "Instance fields" field-to-str
                 (every-pred field? (complement static?)))
  (print-members members "Instance methods" method-to-str
                 (every-pred method? (complement static?))))

(defn -main
  [cls & _]
  (try
    (->> cls
         (Class/forName)
         (cr/reflect)
         (:members)
         (print-all-members))
    (catch Exception e
      (println
        (str/join ""
                  ["Error: "
                   (->> e (.getClass) (.getName))
                   ": "
                   (.getMessage e)])))))
