import DateFormat from "sap/ui/core/format/DateFormat";

const dateMedium = DateFormat.getDateInstance({ style: "medium" });

/**
 * Custom formatters for status / task / priority display (no built-in OData equivalent).
 * @namespace com.demo.migration.projects.modern.model
 */
const formatter = {
	statusText(status?: string): string {
		switch (status) {
			case "A":
				return "Approved";
			case "D":
				return "Draft";
			case "X":
				return "Cancelled";
			default:
				return status ?? "";
		}
	},

	statusState(status?: string): "Success" | "Warning" | "Error" | "None" {
		if (status === "A") {
			return "Success";
		}
		if (status === "X") {
			return "Error";
		}
		if (status === "D") {
			return "Warning";
		}
		return "None";
	},

	taskStatusText(status?: string): string {
		if (status === "O") {
			return "Open";
		}
		if (status === "P") {
			return "In Progress";
		}
		if (status === "C") {
			return "Completed";
		}
		return status ?? "";
	},

	taskStatusState(status?: string): "Success" | "Warning" | "Error" | "None" {
		if (status === "C") {
			return "Success";
		}
		if (status === "P") {
			return "Warning";
		}
		return "None";
	},

	priorityText(prio?: string | number): string {
		if (prio === "1" || prio === 1) {
			return "Low";
		}
		if (prio === "2" || prio === 2) {
			return "Medium";
		}
		if (prio === "3" || prio === 3) {
			return "High";
		}
		return `${prio ?? ""}`;
	},

	priorityState(prio?: string | number): "Success" | "Warning" | "Error" | "None" {
		if (prio === "3" || prio === 3) {
			return "Error";
		}
		if (prio === "2" || prio === 2) {
			return "Warning";
		}
		return "None";
	},

	dateShort(value?: Date | string): string {
		return formatShortDate(value);
	},

	hoursDecimal(hours?: string | number | null): string {
		if (hours === null || hours === undefined || hours === "") {
			return "";
		}
		const parsed = parseFloat(String(hours));
		if (Number.isNaN(parsed)) {
			return String(hours);
		}
		return `${parsed.toFixed(2)} h`;
	},

	formatDateRange(start?: Date | string, end?: Date | string): string {
		const formattedStart = formatShortDate(start);
		const formattedEnd = formatShortDate(end);
		if (!formattedStart && !formattedEnd) {
			return "";
		}
		return `${formattedStart} – ${formattedEnd}`;
	}
};

function formatShortDate(value?: Date | string): string {
	if (value === undefined || value === null || value === "") {
		return "";
	}
	const asDate = value instanceof Date ? value : new Date(value);
	if (Number.isNaN(asDate.getTime())) {
		return "";
	}
	return dateMedium.format(asDate);
}

export default formatter;
