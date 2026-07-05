import { useEffect, useState } from "react";
import { fetchCategories } from "../api/categories";
import type { Category } from "../api/categories";

interface CategoryFilterProps {
  value: number | null;
  onChange: (categorieCode: number | null) => void;
}

export function CategoryFilter({ value, onChange }: CategoryFilterProps) {
  const [categories, setCategories] = useState<Category[]>([]);

  useEffect(() => {
    fetchCategories()
      .then(({ categories }) => setCategories(categories))
      .catch(() => setCategories([]));
  }, []);

  return (
    <select
      className="category-filter"
      value={value ?? ""}
      onChange={(e) => onChange(e.target.value === "" ? null : Number(e.target.value))}
    >
      <option value="">Toutes les catégories</option>
      {categories.map((c) => (
        <option key={c.code} value={c.code}>
          {c.nom}
        </option>
      ))}
    </select>
  );
}
