import { useEffect, useState } from "react";
import type { FormEvent } from "react";
import {
  addWeightEntry,
  deleteAllWeightEntries,
  deleteWeightEntry,
  fetchWeightHistory,
} from "../api/weight";
import type { WeightEntry } from "../api/weight";
import { calculateBmi, classifyBmi } from "../utils/bmi";
import type { BmiCategory } from "../utils/bmi";
import { WeightChart } from "../components/WeightChart";

const GAUGE_MIN = 15;
const GAUGE_MAX = 40;
const GAUGE_SEGMENTS = [
  { max: 18.5, color: "#3b82f6" },
  { max: 25, color: "#2f9e44" },
  { max: 30, color: "#e2622b" },
  { max: GAUGE_MAX, color: "#d1435b" },
];

function formatDateTime(iso: string) {
  return new Date(iso).toLocaleString("fr-FR", { dateStyle: "medium", timeStyle: "short" });
}

export function ImcPage() {
  const [weight, setWeight] = useState("");
  const [height, setHeight] = useState("");
  const [result, setResult] = useState<{ bmi: number; category: BmiCategory } | null>(null);

  // Dernière taille connue (déduite de l'historique), réutilisée pour recalculer
  // l'IMC quand on saisit juste un poids sans repasser par le formulaire du haut.
  const [lastKnownHeight, setLastKnownHeight] = useState<number | null>(null);

  const [todayWeight, setTodayWeight] = useState("");
  const [history, setHistory] = useState<WeightEntry[]>([]);
  const [historyLoading, setHistoryLoading] = useState(true);
  const [weightError, setWeightError] = useState<string | null>(null);
  const [submittingWeight, setSubmittingWeight] = useState(false);

  useEffect(() => {
    fetchWeightHistory()
      .then(({ entries }) => {
        setHistory(entries);
        // Pré-remplit le formulaire avec la dernière taille connue et le dernier
        // poids saisi, et affiche directement le résultat sans attendre un clic.
        const mostRecentWithHeight = entries.find((entry) => entry.heightCm != null);
        const lastHeight = mostRecentWithHeight?.heightCm ?? null;
        const lastWeight = entries[0]?.weightKg ?? null;

        if (lastHeight != null) {
          setLastKnownHeight(lastHeight);
          setHeight(String(lastHeight));
        }
        if (lastWeight != null) {
          setWeight(String(lastWeight));
        }
        if (lastHeight != null && lastWeight != null) {
          const bmi = calculateBmi(lastWeight, lastHeight);
          setResult({ bmi, category: classifyBmi(bmi) });
        }
      })
      .finally(() => setHistoryLoading(false));
  }, []);

  function handleCalculate(e: FormEvent) {
    e.preventDefault();
    const w = Number(weight);
    const h = Number(height);
    if (!w || !h) return;
    // Calcul de prévisualisation uniquement : n'enregistre rien dans le suivi.
    // Seul "Entrer mon poids aujourd'hui" ajoute une ligne à l'historique.
    const bmi = calculateBmi(w, h);
    setResult({ bmi, category: classifyBmi(bmi) });
    setLastKnownHeight(h);
  }

  async function handleAddWeight(e: FormEvent) {
    e.preventDefault();
    const w = Number(todayWeight);
    if (!w) return;
    setWeightError(null);
    setSubmittingWeight(true);
    try {
      const { entry } = await addWeightEntry(w, lastKnownHeight);
      setHistory((prev) => [entry, ...prev]);
      setTodayWeight("");
      setWeight(String(w));
      // Taille déjà connue : on refait le calcul d'IMC et on l'affiche sur la jauge.
      if (entry.bmi != null) {
        setResult({ bmi: entry.bmi, category: classifyBmi(entry.bmi) });
      }
    } catch (err) {
      setWeightError(err instanceof Error ? err.message : "Erreur lors de l'enregistrement.");
    } finally {
      setSubmittingWeight(false);
    }
  }

  async function handleDeleteEntry(id: number) {
    if (!window.confirm("Supprimer cette pesée ?")) return;
    setWeightError(null);
    try {
      await deleteWeightEntry(id);
      setHistory((prev) => prev.filter((entry) => entry.id !== id));
    } catch (err) {
      setWeightError(err instanceof Error ? err.message : "Erreur lors de la suppression.");
    }
  }

  async function handleDeleteAll() {
    if (!window.confirm("Supprimer tout le suivi du poids ? Cette action est irréversible.")) {
      return;
    }
    setWeightError(null);
    try {
      await deleteAllWeightEntries();
      setHistory([]);
    } catch (err) {
      setWeightError(err instanceof Error ? err.message : "Erreur lors de la suppression.");
    }
  }

  const markerPosition = result
    ? Math.min(100, Math.max(0, ((result.bmi - GAUGE_MIN) / (GAUGE_MAX - GAUGE_MIN)) * 100))
    : 0;

  return (
    <div>
      <h1>Calcul de l'IMC</h1>
      <p className="muted">
        L'indice de masse corporelle donne une estimation de la corpulence à partir du poids et de
        la taille.
      </p>

      <section className="create-recipe">
        <form onSubmit={handleCalculate} className="imc-form">
          <label>
            Poids (kg)
            <input
              type="number"
              min={1}
              step="0.1"
              value={weight}
              onChange={(e) => setWeight(e.target.value)}
              required
            />
          </label>
          <label>
            Taille (cm)
            <input
              type="number"
              min={1}
              step="1"
              value={height}
              onChange={(e) => setHeight(e.target.value)}
              required
            />
          </label>
          <button type="submit">Calculer mon IMC</button>
        </form>

        {result && (
          <div className="imc-result">
            <p className="imc-value" style={{ color: result.category.color }}>
              IMC : {result.bmi.toFixed(1)}
            </p>
            <p
              className="status-badge"
              style={{ backgroundColor: `${result.category.color}22`, color: result.category.color }}
            >
              {result.category.label} —{" "}
              {result.category.advice === "correct" ? "Corpulence à maintenir" : "À améliorer"}
            </p>

            <div className="imc-gauge">
              {GAUGE_SEGMENTS.map((seg, i) => {
                const prevMax = i === 0 ? GAUGE_MIN : GAUGE_SEGMENTS[i - 1].max;
                const width = ((seg.max - prevMax) / (GAUGE_MAX - GAUGE_MIN)) * 100;
                return (
                  <div key={seg.color} style={{ width: `${width}%`, backgroundColor: seg.color }} />
                );
              })}
              <div className="imc-gauge-marker" style={{ left: `${markerPosition}%` }} title="Vous êtes ici">
                ▲
              </div>
            </div>
            <div className="imc-gauge-labels">
              <span>{GAUGE_MIN}</span>
              <span>18.5</span>
              <span>25</span>
              <span>30</span>
              <span>{GAUGE_MAX}+</span>
            </div>

            <p className="muted imc-save-status">
              Ce calcul n'est pas enregistré automatiquement — utilisez « Entrer mon poids
              aujourd'hui » ci-dessous pour l'ajouter à votre suivi.
            </p>
          </div>
        )}
      </section>

      <section>
        <div className="page-header">
          <h2>Suivi du poids</h2>
          {history.length > 0 && (
            <button type="button" className="danger" onClick={handleDeleteAll}>
              Supprimer le suivi
            </button>
          )}
        </div>

        <form onSubmit={handleAddWeight} className="weight-entry-form">
          <label>
            Mon poids aujourd'hui (kg)
            <input
              type="number"
              min={1}
              step="0.1"
              value={todayWeight}
              onChange={(e) => setTodayWeight(e.target.value)}
              required
            />
          </label>
          <button type="submit" disabled={submittingWeight}>
            Entrer mon poids aujourd'hui
          </button>
        </form>
        {weightError && <p className="error">{weightError}</p>}

        <WeightChart entries={history} />

        {historyLoading && <p>Chargement de l'historique...</p>}
        {!historyLoading && history.length === 0 && <p>Aucune pesée enregistrée pour le moment.</p>}
        {history.length > 0 && (
          <ul className="my-recipes-list">
            {history.map((entry) => (
              <li key={entry.id}>
                <span>{formatDateTime(entry.recordedAt)}</span>
                <span>{entry.weightKg} kg</span>
                {entry.bmi != null && <span className="muted">IMC : {entry.bmi.toFixed(1)}</span>}
                <button
                  type="button"
                  className="link-button danger-link"
                  onClick={() => handleDeleteEntry(entry.id)}
                >
                  Supprimer
                </button>
              </li>
            ))}
          </ul>
        )}
      </section>
    </div>
  );
}
