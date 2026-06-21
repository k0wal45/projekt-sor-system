# --- 1. STRUKTURA WĘZŁA DRZEWA ---
class DecisionNode:

    def __init__(
        self,
        feature=None,
        threshold=None,
        left=None,
        right=None,
        value=None,
    ):
        self.feature = feature  # Indeks cechy, według której dzielimy
        self.threshold = threshold  # Wartość progowa podziału
        self.left = left  # Lewe poddrzewo (spełnia warunek <= threshold)
        self.right = right  # Prawe poddrzewo (warunek > threshold)
        self.value = value  # Klasa (tylko dla liścia)

    def is_leaf(self):
        return self.value is not None


# --- 2. KLASYFIKATOR DRZEWA DECYZYJNEGO ---
class DecisionTreeClassifierRaw:

    def __init__(self, max_depth=5, min_samples_split=2):
        self.max_depth = max_depth
        self.min_samples_split = min_samples_split
        self.root = None

    def _gini(self, y):
        # Oblicza indeks Giniego dla danego podziału.
        if not y:
            return 0
        counts = {}
        for val in y:
            counts[val] = counts.get(val, 0) + 1
        impurity = 1.0
        total = len(y)
        for val in counts:
            prob = counts[val] / total
            impurity -= prob**2
        return impurity

    def _best_split(self, X, y):
        # Znajduje najlepszą cechę i próg do podziału.
        best_gain = -1
        split_idx, split_thresh = None, None
        current_gini = self._gini(y)

        num_features = len(X[0]) if X else 0

        for feat_idx in range(num_features):
            # Pobieramy unikalne wartości cechy jako potencjalne progi
            thresholds = set(row[feat_idx] for row in X)
            for thresh in thresholds:
                # Podział danych
                left_y = [
                    y[i] for i, row in enumerate(X) if row[feat_idx] <= thresh
                ]
                right_y = [
                    y[i] for i, row in enumerate(X) if row[feat_idx] > thresh
                ]

                if not left_y or not right_y:
                    continue

                # Obliczenie zysku informacyjnego (Gini gain)
                n = len(y)
                n_l, n_r = len(left_y), len(right_y)
                gini_split = (n_l / n) * self._gini(left_y) + (
                    n_r / n
                ) * self._gini(right_y)
                gain = current_gini - gini_split

                if gain > best_gain:
                    best_gain = gain
                    split_idx = feat_idx
                    split_thresh = thresh

        return split_idx, split_thresh

    def _most_common_label(self, y):
        # Zwraca najczęściej występującą klasę w liściu.
        if not y:
            return None
        counts = {}
        for val in y:
            counts[val] = counts.get(val, 0) + 1
        return max(counts, key=counts.get)

    def _build_tree(self, X, y, depth=0):
        num_samples = len(X)
        num_labels = len(set(y))

        # Warunki zatrzymania
        if (
            depth >= self.max_depth
            or num_samples < self.min_samples_split
            or num_labels == 1
        ):
            leaf_value = self._most_common_label(y)
            return DecisionNode(value=leaf_value)

        # Znajdź najlepszy podział
        feat_idx, thresh = self._best_split(X, y)

        if feat_idx is None:
            return DecisionNode(value=self._most_common_label(y))

        # Podział na lewą i prawą gałąź
        left_X, left_y = [], []
        right_X, right_y = [], []

        for i, row in enumerate(X):
            if row[feat_idx] <= thresh:
                left_X.append(row)
                left_y.append(y[i])
            else:
                right_X.append(row)
                right_y.append(y[i])

        # Rekurencyjne budowanie poddrzew
        left_child = self._build_tree(left_X, left_y, depth + 1)
        right_child = self._build_tree(right_X, right_y, depth + 1)

        return DecisionNode(
            feature=feat_idx, threshold=thresh, left=left_child, right=right_child
        )

    def fit(self, X, y):
        self.root = self._build_tree(X, y)

    def _predict_row(self, node, row):
        if node.is_leaf():
            return node.value
        if row[node.feature] <= node.threshold:
            return self._predict_row(node.left, row)
        return self._predict_row(node.right, row)

    def predict(self, X):
        return [self._predict_row(self.root, row) for row in X]