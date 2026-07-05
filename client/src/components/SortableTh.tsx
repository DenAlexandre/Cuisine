import type { SortDirection } from "../hooks/useSortableTable";

interface SortableThProps<K extends string> {
  label: string;
  sortKey: K;
  activeKey: K | null;
  direction: SortDirection;
  onSort: (key: K) => void;
}

export function SortableTh<K extends string>({
  label,
  sortKey,
  activeKey,
  direction,
  onSort,
}: SortableThProps<K>) {
  const isActive = activeKey === sortKey;
  return (
    <th aria-sort={isActive ? (direction === "asc" ? "ascending" : "descending") : "none"}>
      <button type="button" className="sortable-th" onClick={() => onSort(sortKey)}>
        {label}
        <span className="sort-indicator">{isActive ? (direction === "asc" ? "▲" : "▼") : "↕"}</span>
      </button>
    </th>
  );
}
