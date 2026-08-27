import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Key, matchesKey, truncateToWidth } from "@earendil-works/pi-tui";

type UsageWindow = {
	percent?: number;
	resetsAt?: string;
	status?: string;
};

type UsageResponse = {
	usage?: {
		rolling?: UsageWindow;
		weekly?: UsageWindow;
		monthly?: UsageWindow;
	};
};

function formatPercent(percent: number | undefined): string {
	return typeof percent === "number" && Number.isFinite(percent) ? `${Math.round(percent)}%` : "—";
}

function formatRemaining(percent: number | undefined): string {
	return typeof percent === "number" && Number.isFinite(percent)
		? `${Math.max(0, Math.round(100 - percent))}%`
		: "—";
}

function formatReset(resetsAt: string | undefined): string {
	const reset = resetsAt ? Date.parse(resetsAt) : NaN;
	if (Number.isNaN(reset)) return "—";

	const minutes = Math.max(0, Math.ceil((reset - Date.now()) / 60_000));
	const days = Math.floor(minutes / 1_440);
	const hours = Math.floor((minutes % 1_440) / 60);
	const remainingMinutes = minutes % 60;
	return days > 0 ? `${days}d ${hours}h` : hours > 0 ? `${hours}h ${remainingMinutes}m` : `${remainingMinutes}m`;
}

export default function goUsageExtension(pi: ExtensionAPI) {
	pi.registerCommand("go-usage", {
		description: "Show OpenCode Go quota usage",
		handler: async (_args, ctx) => {
			if (ctx.mode !== "tui") {
				ctx.ui.notify("/go-usage requires TUI mode", "error");
				return;
			}

			try {
				const apiKey = await ctx.modelRegistry.getApiKeyForProvider("opencode-go");
				if (!apiKey) throw new Error("OpenCode Go is not authenticated.");

				const response = await fetch("https://opencode.ai/zen/go/v1/usage", {
					headers: { Authorization: `Bearer ${apiKey}` },
					signal: AbortSignal.timeout(10_000),
				});
				if (!response.ok) throw new Error(`OpenCode Go usage request failed (${response.status}).`);

				const usage = (await response.json() as UsageResponse).usage;
				if (!usage) throw new Error("OpenCode Go returned no usage data.");

				const rows: Array<[string, UsageWindow | undefined]> = [
					["5 hours", usage.rolling],
					["Week", usage.weekly],
					["Month", usage.monthly],
				];

				await ctx.ui.custom<void>((_tui, theme, _keybindings, done) => ({
					render: (width) => [
						truncateToWidth(theme.fg("accent", theme.bold("OpenCode Go usage")), width),
						truncateToWidth(theme.fg("dim", "Window       Used    Left    Resets in"), width),
						...rows.map(([label, window]) => {
							const used = formatPercent(window?.percent);
							const color = window?.status === "ok" ? "success" : "warning";
							return truncateToWidth(
								`${label.padEnd(12)} ${theme.fg(color, used.padStart(5))} ${formatRemaining(window?.percent).padStart(7)}  ${formatReset(window?.resetsAt)}`,
								width,
							);
						}),
						truncateToWidth(theme.fg("dim", "Esc or Enter to close"), width),
					],
					invalidate: () => {},
					handleInput: (data) => {
						if (matchesKey(data, Key.escape) || matchesKey(data, Key.enter)) done();
					},
				}));
			} catch (error) {
				ctx.ui.notify(error instanceof Error ? error.message : "Unable to load OpenCode Go usage.", "error");
			}
		},
	});
}
