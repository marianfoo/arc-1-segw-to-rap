# Cursor chat export: prompt 2 js to ts

Exported from Cursor globalStorage on 2026-05-11.

Session:
- ID: `ceed902d-3ab7-4b64-b5d2-a09e2c76000b`
- Title: `prompt 2 js to ts`

Files:
- `session_ceed902d-3ab7-4b64-b5d2-a09e2c76000b.md` - readable normalized transcript from `cursor-session`.
- `session_ceed902d-3ab7-4b64-b5d2-a09e2c76000b.json` - normalized JSON transcript from `cursor-session`.
- `cursor-raw-chat_ceed902d-3ab7-4b64-b5d2-a09e2c76000b.json` - raw Cursor composer and bubble export, preserving 190 original bubbles in order.
- `cursor-tool-calls_ceed902d-3ab7-4b64-b5d2-a09e2c76000b.jsonl` - extracted tool-call audit trail from raw bubble `toolFormerData`; 142 tool records.

Validation:
- Normalized export contains 11 user/assistant messages.
- Raw export contains 190 bubbles and 0 missing bubble records.
- Tool-call JSONL contains 142 extracted tool calls.
- A high-risk credential assignment scan found no obvious password/token/API-key assignments. Review manually before public commit.

Notes:
- `cursor-session` did not expose tool calls in its normalized JSON/Markdown output for this chat.
- The MCP/tool-call details are present in Cursor raw bubble data under `toolFormerData`, which is why the raw export and extracted JSONL are included.
