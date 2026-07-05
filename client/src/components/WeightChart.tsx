import type { WeightEntry } from "../api/weight";

interface WeightChartProps {
  entries: WeightEntry[];
}

function formatDateShort(iso: string) {
  return new Date(iso).toLocaleDateString("fr-FR", { day: "2-digit", month: "short" });
}

const WIDTH = 600;
const HEIGHT = 200;
const MARGIN_LEFT = 40;
const MARGIN_RIGHT = 12;
const MARGIN_TOP = 12;
const MARGIN_BOTTOM = 8;
const PLOT_WIDTH = WIDTH - MARGIN_LEFT - MARGIN_RIGHT;
const PLOT_HEIGHT = HEIGHT - MARGIN_TOP - MARGIN_BOTTOM;

// Graphique d'évolution du poids, avec une échelle Y resserrée sur la plage
// réelle des valeurs (+ marge) plutôt que partir de 0 : les variations restent
// lisibles même sur de petits écarts de poids.
export function WeightChart({ entries }: WeightChartProps) {
  if (entries.length < 2) return null;

  const sorted = [...entries].sort(
    (a, b) => new Date(a.recordedAt).getTime() - new Date(b.recordedAt).getTime()
  );
  const weights = sorted.map((e) => e.weightKg);
  const minWeight = Math.min(...weights);
  const maxWeight = Math.max(...weights);
  const padding = Math.max(1, (maxWeight - minWeight) * 0.2);
  const yMin = minWeight - padding;
  const yMax = maxWeight + padding;

  function xFor(i: number) {
    return sorted.length === 1
      ? MARGIN_LEFT + PLOT_WIDTH / 2
      : MARGIN_LEFT + (i / (sorted.length - 1)) * PLOT_WIDTH;
  }
  function yFor(weight: number) {
    return MARGIN_TOP + PLOT_HEIGHT - ((weight - yMin) / (yMax - yMin)) * PLOT_HEIGHT;
  }

  const points = sorted.map((entry, i) => `${xFor(i)},${yFor(entry.weightKg)}`).join(" ");
  const gridValues = [yMax, (yMin + yMax) / 2, yMin];

  return (
    <div className="weight-chart">
      <svg viewBox={`0 0 ${WIDTH} ${HEIGHT}`} width="100%" height={HEIGHT} preserveAspectRatio="none">
        {gridValues.map((value) => (
          <g key={value}>
            <line
              x1={MARGIN_LEFT}
              x2={WIDTH - MARGIN_RIGHT}
              y1={yFor(value)}
              y2={yFor(value)}
              stroke="var(--border)"
              strokeDasharray="4 4"
            />
            <text x={MARGIN_LEFT - 8} y={yFor(value) + 4} textAnchor="end" fontSize="11" fill="var(--text)">
              {value.toFixed(1)}
            </text>
          </g>
        ))}
        <polyline points={points} fill="none" stroke="var(--accent)" strokeWidth="2" />
        {sorted.map((entry, i) => (
          <circle key={entry.id} cx={xFor(i)} cy={yFor(entry.weightKg)} r="3.5" fill="var(--accent)" />
        ))}
      </svg>
      <div className="weight-chart-labels">
        <span>{formatDateShort(sorted[0].recordedAt)}</span>
        <span>{formatDateShort(sorted[sorted.length - 1].recordedAt)}</span>
      </div>
    </div>
  );
}
