export type Sex = "homme" | "femme";
export type ActivityLevel = "sedentaire" | "leger" | "modere" | "actif" | "tres_actif";

const ACTIVITY_FACTORS: Record<ActivityLevel, number> = {
  sedentaire: 1.2,
  leger: 1.375,
  modere: 1.55,
  actif: 1.725,
  tres_actif: 1.9,
};

export const ACTIVITY_OPTIONS: { value: ActivityLevel; label: string }[] = [
  { value: "sedentaire", label: "Sédentaire (peu ou pas de sport)" },
  { value: "leger", label: "Légèrement actif (sport 1 à 3x/semaine)" },
  { value: "modere", label: "Modérément actif (sport 3 à 5x/semaine)" },
  { value: "actif", label: "Actif (sport 6 à 7x/semaine)" },
  { value: "tres_actif", label: "Très actif (sport intense quotidien)" },
];

// Formule de Mifflin-St Jeor (référence actuelle, plus fiable que l'ancienne
// formule de Harris-Benedict) pour estimer le métabolisme de base (BMR), puis
// multiplié par un facteur d'activité physique pour obtenir la dépense
// énergétique totale journalière (TDEE) : l'apport calorique de maintien.
export function calculateMaintenanceCalories(
  weightKg: number,
  heightCm: number,
  age: number,
  sex: Sex,
  activityLevel: ActivityLevel
): number {
  const bmr = 10 * weightKg + 6.25 * heightCm - 5 * age + (sex === "homme" ? 5 : -161);
  return bmr * ACTIVITY_FACTORS[activityLevel];
}
