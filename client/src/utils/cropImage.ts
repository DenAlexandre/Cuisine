const TARGET_WIDTH = 800;
const TARGET_HEIGHT = 600;
const JPEG_QUALITY = 0.8;
// Gris chaud plutôt que blanc pur : le blanc se confondait avec le fond des
// cartes/pages, rendant les bandes de recadrage invisibles (l'image semblait
// coupée alors qu'elle était entière, juste avec un fond de la même couleur).
const LETTERBOX_COLOR = "#ede4d9";

// Redimensionne l'image, proportions conservées, pour qu'elle tienne entière
// dans le cadre TARGET_WIDTH x TARGET_HEIGHT (comme un CSS object-fit: contain,
// contrairement à l'ancien recadrage en "cover" qui coupait les bords), avec un
// fond neutre dans les bandes restantes, puis compresse en JPEG pour limiter la
// taille stockée en base.
export function cropImageToDataUrl(file: File): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();

    reader.onerror = () => reject(new Error("Lecture du fichier impossible."));
    reader.onload = () => {
      const img = new Image();
      img.onerror = () => reject(new Error("Image invalide."));
      img.onload = () => {
        const canvas = document.createElement("canvas");
        canvas.width = TARGET_WIDTH;
        canvas.height = TARGET_HEIGHT;
        const ctx = canvas.getContext("2d");
        if (!ctx) {
          reject(new Error("Le recadrage d'image n'est pas supporté par ce navigateur."));
          return;
        }

        ctx.fillStyle = LETTERBOX_COLOR;
        ctx.fillRect(0, 0, TARGET_WIDTH, TARGET_HEIGHT);

        const scale = Math.min(TARGET_WIDTH / img.width, TARGET_HEIGHT / img.height);
        const drawWidth = img.width * scale;
        const drawHeight = img.height * scale;
        const dx = (TARGET_WIDTH - drawWidth) / 2;
        const dy = (TARGET_HEIGHT - drawHeight) / 2;

        ctx.drawImage(img, 0, 0, img.width, img.height, dx, dy, drawWidth, drawHeight);
        resolve(canvas.toDataURL("image/jpeg", JPEG_QUALITY));
      };
      img.src = reader.result as string;
    };

    reader.readAsDataURL(file);
  });
}
