(require '[clojure.string :as str])

(def lines 
    (map (partial map #(Character/getNumericValue %))
    (str/split (slurp "../inputs/day08.txt") #"\r\n")))

(def cols (count (first lines)))
(def rows (count lines))

(defn f [[highest l] cur]
    [(max highest cur) 
    (if (> cur highest) 1 0)])

(defn visibleFromEdgeLine [line]
    (reductions f [-1 0] line))

(defn transpose [m]
  (apply mapv list m))

(defn list-update-nth
    [l n val]
    (concat 
    (take n l)
    (list val)
    (drop (inc n) l)))

(defn visibleFromEdge [lines]
    (map 
        (comp (partial map second)
        (comp rest visibleFromEdgeLine)) lines))

(defn g [[val others] [i, cur]] 
    (let [indexes  (filter (partial not= -1) (drop (dec cur) others))]
    [(- i (if (empty? indexes) 0 (apply max indexes)))
    (list-update-nth others (dec cur) i)]))

(defn visibleFromTreeLine [line]
    (reductions g [0 (replicate 9 -1)] (map-indexed list line)))

(defn visibleFromTree [lines]
    (map
        (comp (partial map first)
        (comp rest visibleFromTreeLine)) lines))


(defn reverseGrid [lines]
    (map reverse lines))

(defn multLines [a b]
    (map * a b))

(defn multGrid [a b]
    (map multLines a b))

(defn addLines [a b]
    (map + a b))

(defn addGrid [a b]
    (map addLines a b))

(defn part_1 [lines]
    (let [a (visibleFromEdge lines)
        b (reverseGrid (visibleFromEdge (reverseGrid lines)))
        c (transpose (visibleFromEdge (transpose lines)))
        d (transpose (reverseGrid (visibleFromEdge (reverseGrid (transpose lines)))))
        added (addGrid d (addGrid c (addGrid a b)))]
        (apply + (map 
        (comp count
        (partial filter (partial not= 0))) added))))

(defn part_2 [lines]
    (let [a (visibleFromTree lines)
        b (reverseGrid (visibleFromTree (reverseGrid lines)))
        c (transpose (visibleFromTree (transpose lines)))
        d (transpose (reverseGrid (visibleFromTree (reverseGrid (transpose lines)))))
        mult (multGrid d (multGrid c (multGrid a b)))]
    (reduce max (map (partial reduce max) mult))))

(println "Part 1:" (part_1 lines))
(println "Part 2:" (part_2 lines))

