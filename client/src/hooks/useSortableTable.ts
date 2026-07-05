import { useMemo, useState } from "react";

export type SortDirection = "asc" | "desc";

type SortValue = string | number | null;

// Tri générique pour un tableau : accessor plutôt que clé brute pour pouvoir
// trier sur une valeur dérivée (ex: recipe.nutrition.proteines, ou un libellé
// de catégorie calculé) et pas seulement une propriété directe de l'objet.
export function useSortableTable<T, K extends string>(
  items: T[],
  getValue: (item: T, key: K) => SortValue
) {
  const [sortKey, setSortKey] = useState<K | null>(null);
  const [direction, setDirection] = useState<SortDirection>("asc");

  function toggleSort(key: K) {
    if (sortKey === key) {
      setDirection((d) => (d === "asc" ? "desc" : "asc"));
    } else {
      setSortKey(key);
      setDirection("asc");
    }
  }

  const sorted = useMemo(() => {
    if (!sortKey) return items;
    const factor = direction === "asc" ? 1 : -1;
    return [...items].sort((a, b) => {
      const va = getValue(a, sortKey);
      const vb = getValue(b, sortKey);
      if (va == null && vb == null) return 0;
      if (va == null) return 1;
      if (vb == null) return -1;
      if (typeof va === "string" && typeof vb === "string") {
        return va.localeCompare(vb, "fr") * factor;
      }
      if (va < vb) return -1 * factor;
      if (va > vb) return 1 * factor;
      return 0;
    });
  }, [items, sortKey, direction, getValue]);

  return { sorted, sortKey, direction, toggleSort };
}
