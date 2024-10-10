(ns csv.print)

(defn row-to-string [row]
  (map str row))

(defn csv-to-string [csv]
  (map row-to-string csv))

(defn transpose
  ([] (vector))
  ([m] (apply mapv vector m)))

(defn max-str-len-in-row [row]
  (apply max (map count row)))

(defn max-cols [m]
  (map max-str-len-in-row m))

(defn fill-row [element max-len row]
  (concat row (repeat (- max-len (count row)) element)))

(defn csv-to-str-matrix [csv]
  (let [csv (csv-to-string csv)
        max-row (apply max (map count csv))]
    (map #(fill-row "" max-row %) csv)))

(defn print-csv [csv]
  (let [table (csv-to-str-matrix csv)
        max-cols (max-cols table)]
    (println max-cols table)))

(defn print-rows [rows]
  (doseq [[i row] (map-indexed vector rows)]
    (println (format "Row %d: %f" (inc i) row))))
