<script lang="ts">
	import Dependency from 'playground-hmr-test-dependency';
	import { onMount } from 'svelte';
	// eslint-disable-next-line node/no-missing-import
	import initAdd, { add } from 'add';
	// eslint-disable-next-line node/no-missing-import
	import initHello, { greet } from 'hello_world';

	onMount(async () => {
		initHello().then(() => {
			console.log('WASM module "hello_world" initialized');
			greet('Hello!');
		});
	});

	const test = (obj) => {
		if (obj !== undefined) {
			console.log('It does exist!');
		}
	};
</script>

<h1>Hello world!</h1>
<Dependency />

{#await initAdd()}
	<p>Loading...</p>
{:then wasm}
	<p>19 + 23 = {add(19, 23)}</p>
	<p>{test(wasm)}</p>
{/await}

<style>
	h1 {
		color: #ff3e00;
	}
</style>
