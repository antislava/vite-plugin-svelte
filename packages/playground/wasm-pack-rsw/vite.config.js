import svelte from '@sveltejs/vite-plugin-svelte';
import { defineConfig } from 'vite';
import ViteRsw from 'vite-plugin-rsw';

export default defineConfig(({ command, mode }) => {
	const isProduction = mode === 'production';
	return {
		plugins: [
			ViteRsw.default({
				mode: 'release',
				// isLib: true,
				crates: ['add', 'hello_world']
			}),
			svelte()
		],
		build: {
			minify: isProduction
		}
	};
});
