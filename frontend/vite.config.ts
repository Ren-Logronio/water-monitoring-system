import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vitejs.dev/config/
export default defineConfig({
  base: './',
  plugins: [react()],
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
  }
  
})
