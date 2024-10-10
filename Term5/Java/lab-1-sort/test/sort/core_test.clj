(ns sort.core-test
  (:require [clojure.test :refer [deftest is testing]]
            [sort.core :refer [quick-sort]]))

(deftest sort-test
  (testing "Quick sort with default cmp"
    (is (= [1 2 3 4 5] (quick-sort [4 1 2 5 3]))))
  (testing "Quick sort with provided cmp"
    (is (= [5 4 3 2 1] (quick-sort < [4 1 2 5 3])))))
