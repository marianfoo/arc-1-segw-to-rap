import type {SuiteConfiguration} from "sap/ui/test/starter/config";
export default {
	name: "QUnit test suite for the UI5 Application: com.demo.migration.projects.modern",
	defaults: {
		page: "ui5://test-resources/com/demo/migration/projects/modern/Test.qunit.html?testsuite={suite}&test={name}",
		qunit: {
			version: 2
		},
		sinon: {
			version: 4
		},
		ui5: {
			language: "EN",
			theme: "sap_horizon"
		},
		coverage: {
			only: ["com/demo/migration/projects/modern/"],
			never: ["test-resources/com/demo/migration/projects/modern/"]
		},
		loader: {
			paths: {
				"com/demo/migration/projects/modern": "../"
			}
		}
	},
	tests: {
		"unit/unitTests": {
			title: "Unit tests for com.demo.migration.projects.modern"
		},
		"integration/opaTests": {
			title: "Integration tests for com.demo.migration.projects.modern"
		}
	}
} satisfies SuiteConfiguration;
