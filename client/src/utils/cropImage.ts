const TARGET_WIDTH = 800;
const TARGET_HEIGHT = 600;
const JPEG_QUALITY = 0.8;

// Recadre l'image au centre pour remplir exactement TARGET_WIDTH x TARGET_HEIGHT
// (comme un CSS object-fit: cover), puis compresse en JPEG pour limiter la taille
// stockée en base.
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

        const targetRatio = TARGET_WIDTH / TARGET_HEIGHT;
        const sourceRatio = img.width / img.height;

        let sx = 0;
        let sy = 0;
        let sWidth = img.width;
        let sHeight = img.height;

        if (sourceRatio > targetRatio) {
          sWidth = img.height * targetRatio;
          sx = (img.width - sWidth) / 2;
        } else {
          sHeight = img.width / targetRatio;
          sy = (img.height - sHeight) / 2;
        }

        ctx.drawImage(img, sx, sy, sWidth, sHeight, 0, 0, TARGET_WIDTH, TARGET_HEIGHT);
        resolve(canvas.toDataURL("image/jpeg", JPEG_QUALITY));
      };
      img.src = reader.result as string;
    };

    reader.readAsDataURL(file);
  });
}
