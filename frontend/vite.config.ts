import { defineConfig } from 'vite';
import path from "path";
import react from '@vitejs/plugin-react';
import tailwindcss from "tailwindcss";

// https://vitejs.dev/config/
export default defineConfig({
  base: './',
  plugins: [react(),],
  server: {
    proxy: {
      '/api': { 
        target: 'http://localhost:80',
        changeOrigin: true,
        secure: false,
      }
    }
  },
  build: {
    outDir: '../dist/',
  },
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  css: {
    postcss: {
      plugins: [tailwindcss()],
    },
  },
})
