#!/usr/bin/env node
import { readFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import {
	generate,
	TemplateType,
	OdataVersion
} from '@sap-ux/fiori-elements-writer';
import { ServiceType } from '@sap-ux/odata-service-writer';

const __dirname = dirname(fileURLToPath(import.meta.url));
const projectRoot = join(__dirname, '..');
const mdPath = join(
	projectRoot,
	'webapp/localService/mainService/metadata.xml'
);
const metadata = readFileSync(mdPath, 'utf8');

/** @see @sap-ux/ui5-application-writer ProjectType — backend-served metadata */
const PROJECT_TYPE_EDMX = 'EDMXBackend';

const ui5Ver = '1.147.0';

const fsEditor = await generate(
	projectRoot,
	{
		app: {
			id: 'com.demo.migration.projects.fe',
			projectType: PROJECT_TYPE_EDMX,
			title: 'DM Projects',
			description: 'Fiori Elements LROP (legacy UI5 demo migration)',
			flpAppId: 'demodmprojectsfe'
		},
		appOptions: {
			typescript: true,
			eslint: true,
			sapux: true,
			loadReuseLibs: true,
			npmPackageConsumption: false
		},
		package: {
			name: 'dm-projects-fe'
		},
		ui5: {
			ui5Theme: 'sap_horizon',
			localVersion: ui5Ver,
			version: ui5Ver,
			minUI5Version: ui5Ver,
			framework: 'SAPUI5'
		},
		service: {
			name: 'mainService',
			type: ServiceType.EDMX,
			url: 'https://example-s4hana.local:50001',
			path: '/sap/opu/odata4/sap/zui_dm_projects_o4/srvd/sap/zui_dm_projects_o4/0001',
			version: OdataVersion.v4,
			metadata,
			ignoreCertError: true
		},
		template: {
			type: TemplateType.ListReportObjectPage,
			settings: {
				entityConfig: {
					mainEntityName: 'Project',
					navigationEntity: {
						EntitySet: 'Task',
						Name: 'Task'
					}
				}
			}
		}
	}
);

await new Promise((res, rej) => {
	fsEditor.commit((err) => (err ? rej(err) : res()));
});

console.log(`Fiori Elements LROP generated under ${projectRoot}`);
