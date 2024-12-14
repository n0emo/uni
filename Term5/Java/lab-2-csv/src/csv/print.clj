(ns csv.print
  (:require [clojure.string :as str]))

(defn transpose
  ([] (vector))
  ([m] (apply mapv vector m)))

(defn print-element
  [width element]
  (let
   [space (- width (count element))
    left (+ (/ space 2) (mod space 2) 1)
    right (+ (/ space 2) 1)
    print-spaces #(print (str/join "" (repeat % " ")))]
    (print-spaces left)
    (print element)
    (print-spaces right)))

(defn print-csv [csv]
  (let
   [max-row (apply max (map count csv))
    table (map #(map str %) csv)
    matrix (map #(concat % (repeat (- max-row (count %)) " ")) table)
    max-cols (map #(apply max (map count %)) (transpose matrix))
    rows (map #(zipmap max-cols %) matrix)
    delimeter-width (+ (apply + max-cols) (* (count max-cols) 3) 1)
    delimeter (str/join "" (repeat delimeter-width "-"))]
   (println delimeter)
    (doseq [row rows]
      (doseq [element row]
        (print "|")
        (print-element (first element) (second element)))
      (println "|")
      (println delimeter))))

(defn print-rows [rows]
  (println "Result:")
  (doseq [[i row] (map-indexed vector rows)]
    (println (format "  %d: %f" (inc i) row))))
