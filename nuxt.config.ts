export default defineNuxtConfig({
  compatibilityDate: '2025-01-01',
  devtools: { enabled: true },
  modules: [
    '@nuxt/content',
    '@nuxtjs/tailwindcss'
  ],
  content: {
    highlight: {
      theme: 'github-dark'
    }
  },
  css: ['~/assets/css/main.css'],
  nitro: {
    prerender: {
      crawlLinks: true,
      failOnError: false,
      routes: [
        '/getting-started',
        '/quick-start', 
        '/api-reference',
        '/advanced-features',
        '/troubleshooting'
      ]
    }
  }
}) 