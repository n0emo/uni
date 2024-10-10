(ns csv.parse
  (:require [clojure.string :as str]))

(defn parse-line [line]
  (->> line
       (#(str/split % #","))
       (map str/trim)))

(defn parse-csv [lines]
  (map parse-line lines))

(defn csv-row-to-doubles [row]
  (map parse-double row))

(defn csv-cells-to-doubles [csv]
  (map csv-row-to-doubles csv))

