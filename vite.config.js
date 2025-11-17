import { defineConfig } from 'vite';

export default defineConfig({
  base: process.env.NODE_ENV === 'production' ? '/ruby-wasm-study/' : '/',
  build: {
    outDir: 'dist'
  },
  publicDir: 'public'
});
