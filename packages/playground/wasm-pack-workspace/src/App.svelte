<script lang="ts">
	import Dependency from 'playground-hmr-test-dependency';
	import { onMount } from 'svelte';
	// eslint-disable-next-line node/no-missing-import
	import initAdd, { add } from 'add';
	// eslint-disable-next-line node/no-missing-import
	import initHello, { greet } from 'hello_world';
	// eslint-disable-next-line node/no-missing-import
	import type { InitOutput as HelloInitOutput } from 'hello_world';

	const test = (obj: any, name: string) => {
		if (obj !== undefined) {
			console.log(name, 'is not undefined!');
		}
	};

	onMount(async () => {
		initHello().then((m: HelloInitOutput) => {
			console.log('WASM module "hello_world" initialized');
			test(m, 'WASM Greeter module');
			greet('World');
		});
	});
</script>

<h1>Hello world!</h1>
<Dependency />

{#await initAdd()}
	<p>Loading...</p>
{:then wasm}
	<p>19 + 23 = {add(19, 23)}</p>
	<p>{test(wasm, 'WASM Adder')}</p>
{/await}

<style>
	h1 {
		color: #ff3e00;
	}
</style>
