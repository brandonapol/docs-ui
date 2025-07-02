<template>
  <div class="bg-gray-50 min-h-screen py-12">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <!-- Header -->
      <div class="text-center mb-12">
        <h1 class="text-4xl font-bold text-gray-900 mb-4">
          All Documentation
        </h1>
        <p class="text-lg text-gray-600 max-w-2xl mx-auto">
          Browse our complete collection of guides, references, and tutorials to help you succeed.
        </p>
      </div>

      <!-- Filter Buttons -->
      <div class="flex flex-wrap justify-center gap-2 mb-8">
        <button
          @click="selectedCategory = null"
          :class="[
            'px-4 py-2 rounded-full text-sm font-medium transition-colors',
            selectedCategory === null
              ? 'bg-blue-600 text-white'
              : 'bg-white text-gray-700 hover:bg-gray-100'
          ]"
        >
          All Categories
        </button>
        <button
          v-for="category in categories"
          :key="category"
          @click="selectedCategory = category"
          :class="[
            'px-4 py-2 rounded-full text-sm font-medium transition-colors capitalize',
            selectedCategory === category
              ? 'bg-blue-600 text-white'
              : 'bg-white text-gray-700 hover:bg-gray-100'
          ]"
        >
          {{ category }}
        </button>
      </div>

      <!-- Documents Grid -->
      <div v-if="filteredDocs && filteredDocs.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <NuxtLink
          v-for="doc in filteredDocs"
          :key="doc._path"
          :to="doc._path"
          class="group block bg-white rounded-lg shadow-sm hover:shadow-md transition-shadow duration-200 overflow-hidden border border-gray-200"
        >
          <div class="p-6">
            <!-- Category Badge -->
            <div class="flex items-center justify-between mb-3">
              <span 
                :class="getCategoryColor(doc.category)"
                class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium capitalize"
              >
                {{ doc.category }}
              </span>
              <div class="opacity-0 group-hover:opacity-100 transition-opacity">
                <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                </svg>
              </div>
            </div>
            
            <!-- Title -->
            <h2 class="text-xl font-semibold text-gray-900 mb-2 group-hover:text-blue-600 transition-colors">
              {{ doc.title }}
            </h2>
            
            <!-- Description -->
            <p class="text-gray-600 text-sm mb-4 line-clamp-3">
              {{ doc.description }}
            </p>
            
            <!-- Footer -->
            <div class="flex items-center justify-between text-xs text-gray-500">
              <span>
                {{ formatDate(doc.createdAt) }}
              </span>
              <span class="text-blue-600 group-hover:text-blue-700 font-medium">
                Read more →
              </span>
            </div>
          </div>
        </NuxtLink>
      </div>

      <!-- Empty State -->
      <div v-else-if="docs && docs.length === 0" class="text-center py-12">
        <svg class="mx-auto h-12 w-12 text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
        </svg>
        <h3 class="text-lg font-medium text-gray-900 mb-2">No documentation found</h3>
        <p class="text-gray-600">There are no documents available at the moment.</p>
      </div>

      <!-- Loading State -->
      <div v-else-if="pending" class="text-center py-12">
        <div class="inline-flex items-center">
          <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-blue-600" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
          <span class="text-gray-600">Loading documentation...</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
// SEO
useHead({
  title: 'All Documentation',
  meta: [
    { name: 'description', content: 'Browse our complete collection of documentation including guides, API references, and troubleshooting tips.' }
  ]
})

// Load all documents
const { data: docs, pending } = await useLazyAsyncData('docs-list', () =>
  queryContent()
    .where({ _partial: false })
    .sort({ createdAt: -1, title: 1 })
    .find()
)

// Category filtering
const selectedCategory = ref(null)

// Get unique categories
const categories = computed(() => {
  if (!docs.value) return []
  
  const uniqueCategories = [...new Set(docs.value.map(doc => doc.category))]
  return uniqueCategories.filter(Boolean).sort()
})

// Filter documents by category
const filteredDocs = computed(() => {
  if (!docs.value) return []
  
  if (selectedCategory.value === null) {
    return docs.value
  }
  
  return docs.value.filter(doc => doc.category === selectedCategory.value)
})

// Get category color classes
const getCategoryColor = (category) => {
  const colors = {
    basics: 'bg-green-100 text-green-800',
    reference: 'bg-blue-100 text-blue-800',
    advanced: 'bg-purple-100 text-purple-800',
    support: 'bg-red-100 text-red-800',
    default: 'bg-gray-100 text-gray-800'
  }
  
  return colors[category] || colors.default
}

// Format date helper
const formatDate = (dateString) => {
  if (!dateString) return ''
  
  const date = new Date(dateString)
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}
</script>

<style scoped>
.line-clamp-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style> 