---
title: Quick Start
description: Get up and running in 5 minutes with this quick start guide.
category: basics
createdAt: 2025-01-01T01:00:00.000Z
---

# Quick Start Guide

Get your project running in just 5 minutes with this streamlined setup process.

## 5-Minute Setup

### Step 1: Create Your Project (1 minute)

```bash
npx create-nuxt-app@latest my-docs-site
cd my-docs-site
```

### Step 2: Add Essential Dependencies (2 minutes)

```bash
npm install @nuxt/content @nuxtjs/tailwindcss
```

### Step 3: Configure Nuxt (1 minute)

Update your `nuxt.config.ts`:

```typescript
export default defineNuxtConfig({
  modules: [
    '@nuxt/content',
    '@nuxtjs/tailwindcss'
  ],
  content: {
    highlight: {
      theme: 'github-dark'
    }
  }
})
```

### Step 4: Create Your First Page (1 minute)

Create `pages/index.vue`:

```vue
<template>
  <div class="container mx-auto px-4 py-8">
    <h1 class="text-4xl font-bold mb-4">Welcome to My Docs</h1>
    <p class="text-gray-600">Your documentation site is ready!</p>
  </div>
</template>
```

### Step 5: Start Development Server

```bash
npm run dev
```

🎉 **Congratulations!** Your documentation site is now running at `http://localhost:3000`.

## Essential Commands

Here are the commands you'll use most frequently:

| Command | Description |
|---------|-------------|
| `npm run dev` | Start development server |
| `npm run build` | Build for production |
| `npm run generate` | Generate static site |
| `npm run preview` | Preview production build |

## Quick Tips

### Adding New Content

1. Create markdown files in the `content/` directory
2. Add frontmatter with title and description
3. Your content will automatically be available at the corresponding route

### Styling

- Tailwind CSS is pre-configured
- Add custom styles in `assets/css/main.css`
- Use Tailwind classes directly in your components

### Navigation

Create a simple navigation component:

```vue
<template>
  <nav class="bg-white shadow">
    <div class="container mx-auto px-4">
      <div class="flex justify-between h-16">
        <NuxtLink to="/" class="flex items-center font-bold text-xl">
          My Docs
        </NuxtLink>
        <div class="flex items-center space-x-4">
          <NuxtLink to="/docs" class="hover:text-blue-600">
            Documentation
          </NuxtLink>
        </div>
      </div>
    </div>
  </nav>
</template>
```

## What's Next?

- 📖 Read the [Getting Started](/getting-started) guide for detailed setup
- 🔧 Explore [Advanced Features](/advanced-features) for more functionality
- 📋 Check the [API Reference](/api-reference) for complete documentation
- 🐛 Visit [Troubleshooting](/troubleshooting) if you encounter issues

## Pro Tips

1. **Use TypeScript**: Enable TypeScript for better development experience
2. **Content Collections**: Organize content in folders for better structure
3. **SEO Optimization**: Add meta tags and structured data
4. **Performance**: Enable static generation for better performance

Ready to dive deeper? Check out our comprehensive [Getting Started](/getting-started) guide! 