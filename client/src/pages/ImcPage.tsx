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
import { ACTIVITY_OPTIONS, calculateMaintenanceCalories } from "../utils/calories";
import type { ActivityLevel, Sex } from "../utils/calories";
import { WeightChart } from "../components/WeightChart";
import { useAuth } from "../context/AuthContext";

// Âge/sexe/niveau d'activité ne sont utiles qu'à l'estimation calorique (pas à
// l'IMC lui-même) et ne concernent qu'un affichage indicatif : mémorisés en
// local par utilisateur plutôt qu'envoyés au serveur, pour éviter de re-saisir
// à chaque visite sans pour autant les mêler au suivi de poids partagé.
function imcProfileKey(userId: number) {
  return `cuisine.imc-profile.${userId}`;
}

interface ImcProfile {
  age: string;
  sex: Sex;
  activityLevel: ActivityLevel;
}

function loadImcProfile(userId: number): ImcProfile {
  try {
    const raw = localStorage.getItem(imcProfileKey(userId));
    if (!raw) throw new Error("none");
    return { age: "", sex: "homme", activityLevel: "sedentaire", ...JSON.parse(raw) };
  } catch {
    return { age: "", sex: "homme", activityLevel: "sedentaire" };
  }
}

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
  const { user } = useAuth();
  const [weight, setWeight] = useState("");
  const [height, setHeight] = useState("");
  const [age, setAge] = useState("");
  const [sex, setSex] = useState<Sex>("homme");
  const [activityLevel, setActivityLevel] = useState<ActivityLevel>("sedentaire");
  const [result, setResult] = useState<{
    bmi: number;
    category: BmiCategory;
    maintenanceKcal: number | null;
  } | null>(null);

  useEffect(() => {
    if (!user) return;
    const profile = loadImcProfile(user.id);
    setAge(profile.age);
    setSex(profile.sex);
    setActivityLevel(profile.activityLevel);
  }, [user]);

  // Dernière taille connue (déduite de l'historique), réutilisée pour recalculer
  // l'IMC quand on saisit juste un poids sans repasser par le formulaire du haut.
  const [lastKnownHeight, setLastKnownHeight] = useState<number | null>(null);

  const [todayWeight, setTodayWeight] = useState("");
  const [history, setHistory] = useState<WeightEntry[]>([]);
  const [historyLoading, setHistoryLoading] = useState(true);
  const [weightError, setWeightError] = useState<string | null>(null);
  const [submittingWeight, setSubmittingWeight] = useState(false);

  useEffect(() => {
    if (!user) return;
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
          // Lu directement depuis le stockage local (plutôt que l'état React
          // age/sex/activityLevel, pas garanti à jour à ce stade) pour que
          // l'apport calorique s'affiche dès le chargement, pas seulement
          // après un clic sur "Calculer mon IMC".
          const profile = loadImcProfile(user.id);
          const ageNum = Number(profile.age);
          const maintenanceKcal = ageNum
            ? calculateMaintenanceCalories(lastWeight, lastHeight, ageNum, profile.sex, profile.activityLevel)
            : null;
          setResult({ bmi, category: classifyBmi(bmi), maintenanceKcal });
        }
      })
      .finally(() => setHistoryLoading(false));
  }, [user]);

  // null si l'âge n'est pas renseigné : l'apport calorique reste optionnel,
  // seul l'IMC (poids + taille) est requis.
  function maintenanceKcalFor(w: number, h: number): number | null {
    const ageNum = Number(age);
    if (!ageNum) return null;
    return calculateMaintenanceCalories(w, h, ageNum, sex, activityLevel);
  }

  function handleCalculate(e: FormEvent) {
    e.preventDefault();
    const w = Number(weight);
    const h = Number(height);
    if (!w || !h) return;
    // Calcul de prévisualisation uniquement : n'enregistre rien dans le suivi.
    // Seul "Entrer mon poids aujourd'hui" ajoute une ligne à l'historique.
    const bmi = calculateBmi(w, h);
    setResult({ bmi, category: classifyBmi(bmi), maintenanceKcal: maintenanceKcalFor(w, h) });
    setLastKnownHeight(h);
    if (user) {
      localStorage.setItem(imcProfileKey(user.id), JSON.stringify({ age, sex, activityLevel }));
    }
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
        setResult({
          bmi: entry.bmi,
          category: classifyBmi(entry.bmi),
          maintenanceKcal: entry.heightCm != null ? maintenanceKcalFor(w, entry.heightCm) : null,
        });
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

      <div className="imc-layout">
        <section className="create-recipe imc-profile-card">
          <h2>Votre profil</h2>
          <form onSubmit={handleCalculate} className="imc-form">
            <div className="imc-form-row">
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
            </div>
            <div className="imc-form-row">
              <label>
                Âge (facultatif)
                <input
                  type="number"
                  min={1}
                  max={120}
                  step="1"
                  value={age}
                  onChange={(e) => setAge(e.target.value)}
                />
              </label>
              <label>
                Sexe
                <select value={sex} onChange={(e) => setSex(e.target.value as Sex)}>
                  <option value="homme">Homme</option>
                  <option value="femme">Femme</option>
                </select>
              </label>
            </div>
            <label>
              Niveau d'activité
              <select
                value={activityLevel}
                onChange={(e) => setActivityLevel(e.target.value as ActivityLevel)}
              >
                {ACTIVITY_OPTIONS.map((option) => (
                  <option key={option.value} value={option.value}>
                    {option.label}
                  </option>
                ))}
              </select>
            </label>
            <button type="submit">Calculer mon IMC</button>
          </form>
        </section>

        <section className="create-recipe imc-result-card">
          <h2>Résultat</h2>
          {result ? (
            <div className="imc-result">
              <div className="imc-headline">
                <span className="imc-emoji" aria-hidden="true">
                  {result.category.emoji}
                </span>
                <div>
                  <p className="imc-value" style={{ color: result.category.color }}>
                    {result.bmi.toFixed(1)}
                  </p>
                  <p
                    className="status-badge"
                    style={{
                      backgroundColor: `${result.category.color}22`,
                      color: result.category.color,
                    }}
                  >
                    {result.category.label} —{" "}
                    {result.category.advice === "correct" ? "Corpulence à maintenir" : "À améliorer"}
                  </p>
                </div>
              </div>

              <div className="imc-gauge">
                {GAUGE_SEGMENTS.map((seg, i) => {
                  const prevMax = i === 0 ? GAUGE_MIN : GAUGE_SEGMENTS[i - 1].max;
                  const width = ((seg.max - prevMax) / (GAUGE_MAX - GAUGE_MIN)) * 100;
                  return (
                    <div key={seg.color} style={{ width: `${width}%`, backgroundColor: seg.color }} />
                  );
                })}
                <div
                  className="imc-gauge-marker"
                  style={{ left: `${markerPosition}%` }}
                  title="Vous êtes ici"
                >
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

              <div className="imc-kcal-callout">
                {result.maintenanceKcal != null ? (
                  <p>
                    <strong>{Math.round(result.maintenanceKcal)} kcal/jour</strong>
                    <span className="muted"> est la limite maximale en fonction de votre profil.</span>
                  </p>
                ) : (
                  <p className="muted">
                    Renseignez votre âge pour estimer votre apport calorique de maintien.
                  </p>
                )}
              </div>

              <p className="muted imc-save-status">
                Ce calcul n'est pas enregistré automatiquement — utilisez « Entrer mon poids
                aujourd'hui » ci-dessous pour l'ajouter à votre suivi.
              </p>
            </div>
          ) : (
            <p className="muted imc-placeholder">
              Renseignez votre poids et votre taille pour voir votre résultat ici.
            </p>
          )}
        </section>
      </div>

      <section className="create-recipe imc-tracking-card">
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
          <ul className="my-recipes-list imc-history-list">
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
