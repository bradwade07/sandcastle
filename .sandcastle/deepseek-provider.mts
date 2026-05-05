import type { AgentProvider } from "@ai-hero/sandcastle";

declare const process: any;

export function deepseek(model = "deepseek-v4-flash"): AgentProvider {
  const env: Record<string, string> = {};
  if (typeof process !== 'undefined' && process.env) {
    const apiKey = process.env.DEEPSEEK_API_KEY;
    if (apiKey) {
      env.DEEPSEEK_API_KEY = apiKey;
    }
  }

  return {
    name: "deepseek",
    env,
    captureSessions: false,
    buildPrintCommand({ prompt }) {
      return {
        command: `npx @sluisr/deepseek-cli -m ${model} --approval-mode=yolo -p ""`,
        stdin: prompt,
      };
    },
    parseStreamLine(line) {
      if (!line.trim()) return [];
      return [{ type: "text", text: line } as any];
    },
  };
}
