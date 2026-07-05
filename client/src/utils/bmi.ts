export interface BmiCategory {
  label: string;
  advice: "correct" | "ameliorer";
  color: string;
}

export function calculateBmi(weightKg: number, heightCm: number): number {
  const heightM = heightCm / 100;
  return weightKg / (heightM * heightM);
}

export function classifyBmi(bmi: number): BmiCategory {
  if (bmi < 18.5) return { label: "Insuffisance pondérale", advice: "ameliorer", color: "#3b82f6" };
  if (bmi < 25) return { label: "Corpulence normale", advice: "correct", color: "#2f9e44" };
  if (bmi < 30) return { label: "Surpoids", advice: "ameliorer", color: "#e2622b" };
  return { label: "Obésité", advice: "ameliorer", color: "#d1435b" };
}
