<template>
  <div class="bg-gradient-to-br from-blue-50 to-indigo-100 min-h-screen">
    <!-- Hero Section -->
    <section class="relative overflow-hidden">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-24">
        <div class="text-center">
          <h1 class="text-5xl md:text-7xl font-bold text-gray-900 mb-6">
            DOCS
          </h1>
          <p class="text-xl text-gray-600 max-w-3xl mx-auto mb-12 leading-relaxed">
            Comprehensive documentation for developers, designers, and teams. 
            Find guides, API references, troubleshooting tips, and advanced features 
            to help you build amazing projects.
          </p>
          
          <!-- Search Bar -->
          <div class="max-w-2xl mx-auto mb-12">
            <div class="relative">
              <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
              </div>
              <input
                v-model="searchQuery"
                type="text"
                placeholder="Search documentation..."
                class="block w-full pl-10 pr-3 py-4 border border-gray-300 rounded-lg leading-5 bg-white placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-lg"
                @keyup.enter="performSearch"
              >
            </div>
            
            <!-- Search Results -->
            <div v-if="searchResults.length > 0" class="mt-4 bg-white rounded-lg shadow-lg border border-gray-200 max-h-96 overflow-y-auto">
              <div class="p-2">
                <div
                  v-for="result in searchResults.slice(0, 5)"
                  :key="result.item._path"
                  class="p-3 hover:bg-gray-50 rounded-md cursor-pointer transition-colors"
                  @click="navigateToResult(result.item._path)"
                >
                  <h3 class="font-semibold text-gray-900 mb-1">{{ result.item.title }}</h3>
                  <p class="text-sm text-gray-600 mb-2">{{ result.item.description }}</p>
                  <div class="flex items-center text-xs text-gray-500">
                    <span class="bg-blue-100 text-blue-800 px-2 py-1 rounded-full">
                      {{ result.item.category }}
                    </span>
                    <span class="ml-2">Score: {{ Math.round(result.score * 100) }}%</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- CTA Button -->
          <div class="flex flex-col sm:flex-row gap-4 justify-center items-center">
            <NuxtLink
              to="/docs"
              class="inline-flex items-center px-8 py-4 border border-transparent text-lg font-medium rounded-lg text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors"
            >
              Browse All Documentation
              <svg class="ml-2 -mr-1 w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M10.293 3.293a1 1 0 011.414 0l6 6a1 1 0 010 1.414l-6 6a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-4.293-4.293a1 1 0 010-1.414z" clip-rule="evenodd" />
              </svg>
            </NuxtLink>
          </div>
        </div>
      </div>
    </section>

    <!-- Features Grid -->
    <section class="py-24 bg-white">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-16">
          <h2 class="text-3xl font-bold text-gray-900 mb-4">Everything You Need</h2>
          <p class="text-lg text-gray-600">Comprehensive documentation to help you succeed</p>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          <!-- Feature 1 -->
          <div class="text-center p-6 bg-gray-50 rounded-lg">
            <div class="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center mx-auto mb-4">
              <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
              </svg>
            </div>
            <h3 class="text-lg font-semibold text-gray-900 mb-2">Quick Start</h3>
            <p class="text-gray-600">Get up and running in minutes with our step-by-step guides</p>
          </div>

          <!-- Feature 2 -->
          <div class="text-center p-6 bg-gray-50 rounded-lg">
            <div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center mx-auto mb-4">
              <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
            </div>
            <h3 class="text-lg font-semibold text-gray-900 mb-2">API Reference</h3>
            <p class="text-gray-600">Complete API documentation with examples and use cases</p>
          </div>

          <!-- Feature 3 -->
          <div class="text-center p-6 bg-gray-50 rounded-lg">
            <div class="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center mx-auto mb-4">
              <svg class="w-6 h-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
              </svg>
            </div>
            <h3 class="text-lg font-semibold text-gray-900 mb-2">Advanced Features</h3>
            <p class="text-gray-600">Powerful features for complex workflows and integrations</p>
          </div>

          <!-- Feature 4 -->
          <div class="text-center p-6 bg-gray-50 rounded-lg">
            <div class="w-12 h-12 bg-red-100 rounded-lg flex items-center justify-center mx-auto mb-4">
              <svg class="w-6 h-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 5.636l-3.536 3.536m0 5.656l3.536 3.536M9.172 9.172L5.636 5.636m3.536 9.192L5.636 18.364M12 2.25a9.75 9.75 0 100 19.5 9.75 9.75 0 000-19.5z" />
              </svg>
            </div>
            <h3 class="text-lg font-semibold text-gray-900 mb-2">Troubleshooting</h3>
            <p class="text-gray-600">Solutions to common problems and expert support</p>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import Fuse from 'fuse.js'

// SEO
useHead({
  title: 'DOCS - Comprehensive Documentation',
  meta: [
    {
      name: 'description',
      content:
        'Comprehensive documentation for developers, designers, and teams. Find guides, API references, and troubleshooting tips.',
    },
  ],
})

// Search functionality
const searchQuery = ref('')
const searchResults = ref([])
const router = useRouter()

// Load all documents for search
const { data: searchDocs } = await useLazyAsyncData('search-docs', () =>
  queryContent().sort({ _stem: 1, $numeric: true }).find()
)

// Configure Fuse.js for fuzzy search
const fuse = computed(() => {
  if (!searchDocs.value) return null

  return new Fuse(searchDocs.value, {
    keys: [
      { name: 'title', weight: 0.4 },
      { name: 'description', weight: 0.3 },
      { name: 'body', weight: 0.2 },
      { name: 'category', weight: 0.1 },
    ],
    threshold: 0.4,
    includeScore: true,
  })
})

// Perform search
const performSearch = () => {
  if (!searchQuery.value.trim() || !fuse.value) {
    searchResults.value = []
    return
  }

  const results = fuse.value.search(searchQuery.value.trim())
  searchResults.value = results
}

// Navigate to search result
const navigateToResult = (path) => {
  router.push(path)
}

// Watch search query and perform search
watch(searchQuery, (newQuery) => {
  if (newQuery.trim()) {
    performSearch()
  } else {
    searchResults.value = []
  }
})
</script> 