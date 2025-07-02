<template>
  <div class="bg-white min-h-screen">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <!-- Breadcrumbs -->
      <nav class="flex mb-8" aria-label="Breadcrumb">
        <ol class="inline-flex items-center space-x-1 md:space-x-3">
          <li class="inline-flex items-center">
            <NuxtLink to="/" class="inline-flex items-center text-sm font-medium text-gray-700 hover:text-blue-600">
              <svg class="w-4 h-4 mr-2" fill="currentColor" viewBox="0 0 20 20">
                <path d="M10.707 2.293a1 1 0 00-1.414 0l-7 7a1 1 0 001.414 1.414L9 5.414V17a1 1 0 102 0V5.414l5.293 5.293a1 1 0 001.414-1.414l-7-7z"/>
              </svg>
              Home
            </NuxtLink>
          </li>
          <li>
            <div class="flex items-center">
              <svg class="w-6 h-6 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 111.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd"/>
              </svg>
              <NuxtLink to="/docs" class="ml-1 text-sm font-medium text-gray-700 hover:text-blue-600 md:ml-2">
                Documentation
              </NuxtLink>
            </div>
          </li>
          <li v-if="document" aria-current="page">
            <div class="flex items-center">
              <svg class="w-6 h-6 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 111.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd"/>
              </svg>
              <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2">{{ document.title }}</span>
            </div>
          </li>
        </ol>
      </nav>

      <!-- Document Content -->
      <article v-if="document" class="prose prose-lg max-w-none">
        <!-- Header -->
        <header class="mb-8 border-b border-gray-200 pb-8">
          <div class="flex items-center gap-3 mb-4">
            <span 
              v-if="document.category"
              :class="getCategoryColor(document.category)"
              class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium capitalize"
            >
              {{ document.category }}
            </span>
            <time 
              v-if="document.createdAt" 
              :datetime="document.createdAt"
              class="text-sm text-gray-500"
            >
              {{ formatDate(document.createdAt) }}
            </time>
          </div>
          
          <h1 class="text-4xl font-bold text-gray-900 mb-4">{{ document.title }}</h1>
          
          <p v-if="document.description" class="text-xl text-gray-600 leading-relaxed">
            {{ document.description }}
          </p>
        </header>

        <!-- Document Body -->
        <ContentRenderer :value="document" class="prose-content" />
      </article>

      <!-- Loading State -->
      <div v-else-if="pending" class="text-center py-12">
        <div class="inline-flex items-center">
          <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-blue-600" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
          <span class="text-gray-600">Loading document...</span>
        </div>
      </div>

      <!-- Navigation -->
      <nav v-if="document && (prevDoc || nextDoc)" class="mt-12 pt-8 border-t border-gray-200">
        <div class="flex justify-between">
          <div class="flex-1">
            <NuxtLink
              v-if="prevDoc"
              :to="prevDoc._path"
              class="group inline-flex items-center text-sm font-medium text-gray-500 hover:text-gray-700 mb-3"
            >
              <svg class="w-4 h-4 mr-2 group-hover:-translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
              </svg>
              Previous
            </NuxtLink>
            <div v-if="prevDoc">
              <NuxtLink :to="prevDoc._path" class="block text-lg font-semibold text-gray-900 hover:text-blue-600">
                {{ prevDoc.title }}
              </NuxtLink>
            </div>
          </div>
          
          <div class="flex-1 text-right">
            <NuxtLink
              v-if="nextDoc"
              :to="nextDoc._path"
              class="group inline-flex items-center text-sm font-medium text-gray-500 hover:text-gray-700 mb-3"
            >
              Next
              <svg class="w-4 h-4 ml-2 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
              </svg>
            </NuxtLink>
            <div v-if="nextDoc">
              <NuxtLink :to="nextDoc._path" class="block text-lg font-semibold text-gray-900 hover:text-blue-600">
                {{ nextDoc.title }}
              </NuxtLink>
            </div>
          </div>
        </div>
      </nav>
    </div>
  </div>
</template>

<script setup>
const route = useRoute()

// Load the document
const { data: document, pending } = await useLazyAsyncData(`doc-${route.params.slug}`, () =>
  queryContent(route.path).findOne()
)

// Handle 404
if (!document.value && !pending.value) {
  throw createError({
    statusCode: 404,
    statusMessage: 'Document not found'
  })
}

// Load navigation documents
const { data: allDocs } = await useLazyAsyncData('nav-docs', () =>
  queryContent().where({ _partial: false }).sort({ createdAt: 1 }).find()
)

// Find previous and next documents
const prevDoc = computed(() => {
  if (!allDocs.value || !document.value) return null
  
  const currentIndex = allDocs.value.findIndex(doc => doc._path === document.value._path)
  return currentIndex > 0 ? allDocs.value[currentIndex - 1] : null
})

const nextDoc = computed(() => {
  if (!allDocs.value || !document.value) return null
  
  const currentIndex = allDocs.value.findIndex(doc => doc._path === document.value._path)
  return currentIndex < allDocs.value.length - 1 ? allDocs.value[currentIndex + 1] : null
})

// SEO
useHead(() => ({
  title: document.value?.title,
  meta: [
    { name: 'description', content: document.value?.description },
    { property: 'og:title', content: document.value?.title },
    { property: 'og:description', content: document.value?.description },
    { property: 'og:type', content: 'article' },
    { property: 'article:published_time', content: document.value?.createdAt }
  ]
}))

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
.prose-content :deep(h1) {
  @apply text-3xl font-bold text-gray-900 mb-6 mt-8 first:mt-0;
}

.prose-content :deep(h2) {
  @apply text-2xl font-semibold text-gray-800 mb-4 mt-8;
}

.prose-content :deep(h3) {
  @apply text-xl font-medium text-gray-700 mb-3 mt-6;
}

.prose-content :deep(p) {
  @apply text-gray-600 leading-relaxed mb-4;
}

.prose-content :deep(ul) {
  @apply list-disc pl-6 mb-4 space-y-2;
}

.prose-content :deep(ol) {
  @apply list-decimal pl-6 mb-4 space-y-2;
}

.prose-content :deep(li) {
  @apply text-gray-600;
}

.prose-content :deep(code) {
  @apply bg-gray-100 px-2 py-1 rounded text-sm font-mono text-gray-800;
}

.prose-content :deep(pre) {
  @apply bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto mb-4;
}

.prose-content :deep(pre code) {
  @apply bg-transparent p-0 text-gray-100;
}

.prose-content :deep(blockquote) {
  @apply border-l-4 border-blue-500 pl-4 italic text-gray-700 mb-4;
}

.prose-content :deep(a) {
  @apply text-blue-600 hover:text-blue-800 underline;
}

.prose-content :deep(table) {
  @apply w-full border-collapse border border-gray-300 mb-4;
}

.prose-content :deep(th),
.prose-content :deep(td) {
  @apply border border-gray-300 px-4 py-2;
}

.prose-content :deep(th) {
  @apply bg-gray-50 font-semibold text-gray-800;
}

.prose-content :deep(td) {
  @apply text-gray-600;
}
</style> 