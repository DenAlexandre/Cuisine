import { useEffect, useState } from "react";
import type { FormEvent } from "react";
import { downloadDatabaseExport, fetchSystemSettings, updateSystemSettings } from "../api/system";

export function AdminSystemPage() {
  const [exporting, setExporting] = useState(false);
  const [exportError, setExportError] = useState<string | null>(null);

  const [referenceWeight, setReferenceWeight] = useState("");
  const [settingsLoading, setSettingsLoading] = useState(true);
  const [savingSettings, setSavingSettings] = useState(false);
  const [settingsError, setSettingsError] = useState<string | null>(null);
  const [settingsSaved, setSettingsSaved] = useState(false);

  useEffect(() => {
    fetchSystemSettings()
      .then(({ settings }) => setReferenceWeight(String(settings.referenceWeightKg)))
      .catch(() => setSettingsError("Impossible de charger les réglages."))
      .finally(() => setSettingsLoading(false));
  }, []);

  async function handleExport() {
    setExportError(null);
    setExporting(true);
    try {
      await downloadDatabaseExport();
    } catch (err) {
      setExportError(err instanceof Error ? err.message : "Erreur lors de l'export.");
    } finally {
      setExporting(false);
    }
  }

  async function handleSaveSettings(e: FormEvent) {
    e.preventDefault();
    const weight = Number(referenceWeight);
    if (!weight) return;
    setSettingsError(null);
    setSettingsSaved(false);
    setSavingSettings(true);
    try {
      await updateSystemSettings(weight);
      setSettingsSaved(true);
    } catch (err) {
      setSettingsError(err instanceof Error ? err.message : "Erreur lors de l'enregistrement.");
    } finally {
      setSavingSettings(false);
    }
  }

  return (
    <div>
      <h1>Options système</h1>

      <section className="create-recipe">
        <h2>Alcoolémie estimée des cocktails</h2>
        <p className="muted">
          Poids de référence utilisé pour estimer l'alcoolémie (g/L de sang) des cocktails, faute
          de connaître le poids réel de chaque visiteur. Cette estimation reste indicative et ne
          remplace pas un éthylotest.
        </p>
        {settingsLoading ? (
          <p>Chargement...</p>
        ) : (
          <form onSubmit={handleSaveSettings} className="imc-form">
            <label>
              Poids de référence (kg)
              <input
                type="number"
                min={1}
                step="1"
                value={referenceWeight}
                onChange={(e) => {
                  setReferenceWeight(e.target.value);
                  setSettingsSaved(false);
                }}
                required
              />
            </label>
            <button type="submit" disabled={savingSettings}>
              {savingSettings ? "Enregistrement..." : "Enregistrer"}
            </button>
          </form>
        )}
        {settingsSaved && <p className="muted">Réglage enregistré ✓</p>}
        {settingsError && <p className="error">{settingsError}</p>}
      </section>

      <section className="create-recipe">
        <h2>Export des données</h2>
        <p className="muted">
          Génère un export des données (utilisateurs, recettes, aliments...) au format .sql,
          téléchargé directement dans le navigateur. Suppose un schéma déjà à jour (installé via
          les migrations) : ce fichier contient les données, pas la structure des tables.
        </p>
        <button type="button" onClick={handleExport} disabled={exporting}>
          {exporting ? "Export en cours..." : "Exporter les données (.sql)"}
        </button>
        {exportError && <p className="error">{exportError}</p>}
      </section>
    </div>
  );
}
