#!/usr/bin/env node
/**
 * Validates a local metadata.xml against @sap-ux/edmx-parser (same stack as FE writers).
 */
import fs from 'node:fs';
import { parse } from '@sap-ux/edmx-parser';

const path = process.argv[2];
if (!path) {
	console.error('Usage: validate-metadata.mjs <metadata.xml>');
	process.exit(1);
}
try {
	parse(await fs.promises.readFile(path, 'utf8'));
	console.log('EDMX parsed OK:', path);
} catch (e) {
	console.error('Parse failed:', e.message ?? e);
	process.exit(1);
}
