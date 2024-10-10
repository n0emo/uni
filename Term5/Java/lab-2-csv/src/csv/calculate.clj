(ns csv.calculate)

(defn calculate-row-average [row]
  (/ (apply + row) (count row)))

(defn calculate-csv-averages [csv]
  (map calculate-row-average csv))
