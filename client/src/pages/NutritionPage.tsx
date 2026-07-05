import { useEffect, useRef, useState } from "react";
import { searchAliments } from "../api/aliments";
import type { Aliment } from "../api/aliments";
import { EMPTY_GROUP_FILTER, GroupFilters } from "../components/GroupFilters";
import type { GroupFilterValue } from "../components/GroupFilters";

function formatValue(value: number | null): string {
  return value === null ? "—" : value.toString();
}

export function NutritionPage() {
  const [query, setQuery] = useState("");
  const [groupFilter, setGroupFilter] = useState<GroupFilterValue>(EMPTY_GROUP_FILTER);
  const [results, setResults] = useState<Aliment[]>([]);
  const [searched, setSearched] = useState(false);
  const timeoutRef = useRef<number | undefined>(undefined);

  const hasGroupFilter = groupFilter.groupeCode !== null;
  const hasQuery = query.trim().length >= 2;

  useEffect(() => {
    window.clearTimeout(timeoutRef.current);
    if (!hasQuery && !hasGroupFilter) {
      setResults([]);
      setSearched(false);
      return;
    }
    timeoutRef.current = window.setTimeout(() => {
      searchAliments({
        q: query.trim(),
        groupeCode: groupFilter.groupeCode,
        sousGroupeCode: groupFilter.sousGroupeCode,
        sousSousGroupeCode: groupFilter.sousSousGroupeCode,
      })
        .then(({ aliments }) => {
          setResults(aliments);
          setSearched(true);
        })
        .catch(() => setResults([]));
    }, 250);
    return () => window.clearTimeout(timeoutRef.current);
  }, [query, groupFilter, hasQuery, hasGroupFilter]);

  return (
    <div>
      <h1>Nutrition</h1>
      <p className="muted">
        Recherchez un aliment par nom, ou affinez par groupe / sous-groupe / sous-sous-groupe.
      </p>

      <GroupFilters value={groupFilter} onChange={setGroupFilter} />

      <input
        type="text"
        placeholder="Rechercher un aliment (ex: pomme, poulet...)"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        className="nutrition-search"
      />

      {searched && results.length === 0 && <p>Aucun aliment trouvé.</p>}

      {results.length > 0 && (
        <div className="table-scroll">
          <table className="nutrition-table">
            <thead>
              <tr>
                <th>Aliment</th>
                <th>Groupe</th>
                <th>Protéines (g)</th>
                <th>Glucides (g)</th>
                <th>Lipides (g)</th>
                <th>Énergie (kcal)</th>
              </tr>
            </thead>
            <tbody>
              {results.map((aliment) => (
                <tr key={aliment.code}>
                  <td>{aliment.nom}</td>
                  <td className="muted">{aliment.groupe}</td>
                  <td>{formatValue(aliment.proteines)}</td>
                  <td>{formatValue(aliment.glucides)}</td>
                  <td>{formatValue(aliment.lipides)}</td>
                  <td>{formatValue(aliment.energie)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
