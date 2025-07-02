export default defineNuxtConfig({
  compatibilityDate: '2025-01-01',
  devtools: { enabled: false },

  // Configure base URL based on deployment target
  app: {
    baseURL: process.env.GITHUB_PAGES === 'true' ? '/docs-ui/' : '/',
  },

  modules: [
    '@nuxt/content',
    '@nuxtjs/tailwindcss',
    // '@nuxt/eslint' - disabled for Docker builds
  ],
  content: {
    highlight: {
      theme: 'github-dark',
    },
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
        '/troubleshooting',
      ],
    },
  },
})
