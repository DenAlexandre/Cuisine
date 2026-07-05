import { useRef, useState } from "react";
import type { ChangeEvent, ClipboardEvent } from "react";
import type { RecipeCategory } from "../api/recipes";
import { CategoryThumbnail } from "./CategoryThumbnail";
import { cropImageToDataUrl } from "../utils/cropImage";

interface PhotoFieldProps {
  previewUrl: string | null;
  category: RecipeCategory;
  onChange: (photoBase64: string | null) => void;
}

// Tant qu'aucune photo n'a été choisie, affiche l'image par défaut de la
// catégorie sélectionnée ; cliquer dessus (ou sur une photo déjà choisie)
// ouvre le sélecteur de fichier pour en choisir une autre. Le bloc est aussi
// focusable pour accepter un collage (Ctrl+V) d'une image copiée dans le
// presse-papiers, sans passer par le sélecteur de fichier.
export function PhotoField({ previewUrl, category, onChange }: PhotoFieldProps) {
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [error, setError] = useState<string | null>(null);

  async function applyImageFile(file: File) {
    setError(null);
    try {
      const dataUrl = await cropImageToDataUrl(file);
      onChange(dataUrl);
    } catch {
      setError("Impossible de traiter cette image.");
    }
  }

  async function handleFileChange(e: ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    e.target.value = "";
    if (!file) return;
    await applyImageFile(file);
  }

  async function handlePaste(e: ClipboardEvent<HTMLButtonElement>) {
    const imageItem = Array.from(e.clipboardData?.items ?? []).find((item) =>
      item.type.startsWith("image/")
    );
    if (!imageItem) return;
    e.preventDefault();
    const file = imageItem.getAsFile();
    if (!file) return;
    await applyImageFile(file);
  }

  return (
    <div className="photo-field">
      <button
        type="button"
        className="photo-field-preview"
        onClick={() => fileInputRef.current?.click()}
        onPaste={handlePaste}
      >
        {previewUrl ? (
          <img src={previewUrl} alt="Photo de la recette" />
        ) : (
          <CategoryThumbnail category={category} />
        )}
        <span className="photo-field-overlay">Changer la photo</span>
      </button>
      <input
        ref={fileInputRef}
        type="file"
        accept="image/*"
        onChange={handleFileChange}
        hidden
      />

      <div className="photo-field-actions">
        <p className="muted">
          Photo par défaut selon la catégorie. Cliquez dessus pour en choisir une autre, ou
          sélectionnez-la puis collez (Ctrl+V) une image copiée dans le presse-papiers
          (recadrée et compressée automatiquement).
        </p>
        {previewUrl && (
          <button type="button" className="link-button danger-link" onClick={() => onChange(null)}>
            Revenir à l'image par défaut
          </button>
        )}
      </div>
      {error && <p className="error">{error}</p>}
    </div>
  );
}
