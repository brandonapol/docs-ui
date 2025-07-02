<template>
  <div class="min-h-screen bg-gray-50 flex flex-col">
    <!-- Navigation -->
    <nav class="bg-white shadow-sm border-b">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
          <div class="flex items-center">
            <NuxtLink to="/" class="text-2xl font-bold text-gray-900 hover:text-blue-600 transition-colors">
              DOCS
            </NuxtLink>
          </div>
          <div class="flex items-center space-x-8">
            <NuxtLink 
              to="/docs" 
              class="text-gray-600 hover:text-blue-600 font-medium transition-colors"
            >
              All Docs
            </NuxtLink>
          </div>
        </div>
      </div>
    </nav>

    <!-- Main Content -->
    <main class="flex-1">
      <slot />
    </main>

    <!-- Footer -->
    <footer class="bg-white border-t mt-auto">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="text-center text-gray-500">
          <p>&copy; 2025 Documentation Site. Built with Nuxt 3 and Nuxt Content.</p>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
// SEO and meta configuration
useHead({
  titleTemplate: '%s - Documentation',
  meta: [
    { name: 'description', content: 'Comprehensive documentation for our platform' },
    { name: 'viewport', content: 'width=device-width, initial-scale=1' }
  ],
  link: [
    { rel: 'stylesheet', href: 'https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap' }
  ]
})
</script> 