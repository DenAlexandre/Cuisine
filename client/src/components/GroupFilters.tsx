import { useEffect, useState } from "react";
import { fetchGroupes, fetchSousGroupes, fetchSousSousGroupes } from "../api/groupes";
import type { GroupeOption } from "../api/groupes";

export interface GroupFilterValue {
  groupeCode: number | null;
  sousGroupeCode: number | null;
  sousSousGroupeCode: number | null;
}

export const EMPTY_GROUP_FILTER: GroupFilterValue = {
  groupeCode: null,
  sousGroupeCode: null,
  sousSousGroupeCode: null,
};

interface GroupFiltersProps {
  value: GroupFilterValue;
  onChange: (value: GroupFilterValue) => void;
}

function toCodeOrNull(raw: string): number | null {
  return raw === "" ? null : Number(raw);
}

export function GroupFilters({ value, onChange }: GroupFiltersProps) {
  const [groupes, setGroupes] = useState<GroupeOption[]>([]);
  const [sousGroupes, setSousGroupes] = useState<GroupeOption[]>([]);
  const [sousSousGroupes, setSousSousGroupes] = useState<GroupeOption[]>([]);

  useEffect(() => {
    fetchGroupes()
      .then(({ groupes }) => setGroupes(groupes))
      .catch(() => setGroupes([]));
  }, []);

  useEffect(() => {
    if (value.groupeCode === null) {
      setSousGroupes([]);
      return;
    }
    fetchSousGroupes(value.groupeCode)
      .then(({ sousGroupes }) => setSousGroupes(sousGroupes))
      .catch(() => setSousGroupes([]));
  }, [value.groupeCode]);

  useEffect(() => {
    if (value.groupeCode === null || value.sousGroupeCode === null) {
      setSousSousGroupes([]);
      return;
    }
    fetchSousSousGroupes(value.groupeCode, value.sousGroupeCode)
      .then(({ sousSousGroupes }) => setSousSousGroupes(sousSousGroupes))
      .catch(() => setSousSousGroupes([]));
  }, [value.groupeCode, value.sousGroupeCode]);

  return (
    <div className="group-filters">
      <select
        value={value.groupeCode ?? ""}
        onChange={(e) =>
          onChange({
            groupeCode: toCodeOrNull(e.target.value),
            sousGroupeCode: null,
            sousSousGroupeCode: null,
          })
        }
      >
        <option value="">Tous les groupes</option>
        {groupes.map((g) => (
          <option key={g.code} value={g.code}>
            {g.nom}
          </option>
        ))}
      </select>

      <select
        value={value.sousGroupeCode ?? ""}
        disabled={value.groupeCode === null}
        onChange={(e) =>
          onChange({
            ...value,
            sousGroupeCode: toCodeOrNull(e.target.value),
            sousSousGroupeCode: null,
          })
        }
      >
        <option value="">Tous les sous-groupes</option>
        {sousGroupes.map((sg) => (
          <option key={sg.code} value={sg.code}>
            {sg.nom}
          </option>
        ))}
      </select>

      <select
        value={value.sousSousGroupeCode ?? ""}
        disabled={value.sousGroupeCode === null}
        onChange={(e) => onChange({ ...value, sousSousGroupeCode: toCodeOrNull(e.target.value) })}
      >
        <option value="">Tous les sous-sous-groupes</option>
        {sousSousGroupes.map((ssg) => (
          <option key={ssg.code} value={ssg.code}>
            {ssg.nom}
          </option>
        ))}
      </select>
    </div>
  );
}
