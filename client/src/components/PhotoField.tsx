import { useState } from "react";
import type { ChangeEvent } from "react";
import { cropImageToDataUrl } from "../utils/cropImage";

interface PhotoFieldProps {
  previewUrl: string | null;
  onChange: (photoBase64: string | null) => void;
}

export function PhotoField({ previewUrl, onChange }: PhotoFieldProps) {
  const [error, setError] = useState<string | null>(null);

  async function handleFileChange(e: ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    e.target.value = "";
    if (!file) return;

    setError(null);
    try {
      const dataUrl = await cropImageToDataUrl(file);
      onChange(dataUrl);
    } catch {
      setError("Impossible de traiter cette image.");
    }
  }

  return (
    <div className="photo-field">
      {previewUrl && (
        <div className="photo-preview">
          <img src={previewUrl} alt="Aperçu de la recette" />
          <button type="button" className="link-button danger-link" onClick={() => onChange(null)}>
            Retirer la photo
          </button>
        </div>
      )}
      <input type="file" accept="image/*" onChange={handleFileChange} />
      <p className="muted">L'image est automatiquement recadrée et compressée.</p>
      {error && <p className="error">{error}</p>}
    </div>
  );
}
