(ns csv.core
  (:gen-class)
  (:require [clojure.java.io :as io])

  (:require [csv.calculate :as calculate])
  (:require [csv.parse :as parse])
  (:require [csv.print :as csv-print]))

(defn usage []
  (println (str
            "Usage: program [subcommand] <file>\n"
            "Default sabcommand: print\n"
            "Available subcommands:\n"
            "    print       pretty print CSV as table\n"
            "    calculate   calculate average for each CSV row\n"
            "    help        print this message")))

(defn get-lines [file]
  (with-open [reader (io/reader file)]
    (doall (line-seq reader))))

(defn command-print [file]
  (->> file
       (get-lines)
       (parse/parse-csv)
       (csv-print/print-csv)))

(defn command-calculate [file]
  (->> file
       (get-lines)
       (parse/parse-csv)
       (parse/csv-cells-to-doubles)
       (calculate/calculate-csv-averages)
       (csv-print/print-rows)))

(defn run [subcommand file]
  (try
    (case subcommand
      "print"     (command-print     file)
      "calculate" (command-calculate file)
      (do
        (usage)
        (System/exit 1)))
    (catch Exception e
      (do
        (println "Error:" (.toString e))
        (System/exit 1)))))

(defn -main
  [& args]
  (case (count args)
    1 (if (= (first args) "help")
        (usage)
        (run "print" (first args)))
    2 (run (first args) (second args))
    (do
      (usage)
      (System/exit 1))))
