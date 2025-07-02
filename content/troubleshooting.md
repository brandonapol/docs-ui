---
title: Troubleshooting
description: Common issues and solutions to help you resolve problems quickly.
category: support
createdAt: 2025-01-01T04:00:00.000Z
---

# Troubleshooting

Find solutions to common issues and problems you might encounter.

## Installation Issues

### Node.js Version Compatibility

**Problem:** Getting errors during installation or build process.

**Solution:** Ensure you're using Node.js 18 or higher:

```bash
node --version
# Should show v18.0.0 or higher

# If you need to update Node.js
# Using nvm (recommended)
nvm install 18
nvm use 18

# Or download from nodejs.org
```

### Package Installation Failures

**Problem:** `npm install` fails with permission errors.

**Solution:**
```bash
# Clear npm cache
npm cache clean --force

# Try installing again
npm install

# If still failing, try with different registry
npm install --registry https://registry.npmjs.org/
```

### Port Already in Use

**Problem:** Development server can't start because port 3000 is in use.

**Solution:**
```bash
# Find what's using port 3000
lsof -ti:3000

# Kill the process (replace PID with actual process ID)
kill -9 PID

# Or start on a different port
npm run dev -- --port 3001
```

## Development Issues

### Hot Reload Not Working

**Problem:** Changes to files don't trigger automatic reloads.

**Solution:**
1. Check if you're editing files outside the project directory
2. Restart the development server:
   ```bash
   # Stop with Ctrl+C, then restart
   npm run dev
   ```
3. Clear browser cache and refresh

### Styles Not Loading

**Problem:** CSS styles aren't being applied.

**Solution:**
```bash
# Make sure Tailwind is properly configured
npm install @nuxtjs/tailwindcss

# Check nuxt.config.ts includes:
# modules: ['@nuxtjs/tailwindcss']

# Restart dev server after config changes
```

### Content Not Rendering

**Problem:** Markdown content isn't showing up on pages.

**Solution:**
1. Verify file is in the `content/` directory
2. Check frontmatter syntax:
   ```yaml
   ---
   title: Your Title
   description: Your description
   ---
   ```
3. Restart development server after adding new content files

## Build and Deployment Issues

### Build Failures

**Problem:** `npm run build` fails with errors.

**Solution:**
```bash
# Clear .nuxt directory
rm -rf .nuxt

# Clear node_modules and reinstall
rm -rf node_modules package-lock.json
npm install

# Try building again
npm run build
```

### Static Generation Issues

**Problem:** `npm run generate` fails or produces empty pages.

**Solution:**
1. Check that all content queries use proper async data composables:
   ```javascript
   // ✅ Correct
   const { data: docs } = await useLazyAsyncData('docs', () => 
     queryContent().find()
   )

   // ❌ Incorrect
   const docs = await queryContent().find()
   ```

2. Add routes to `nuxt.config.ts`:
   ```typescript
   export default defineNuxtConfig({
     nitro: {
       prerender: {
         routes: ['/getting-started', '/quick-start', '/api-reference']
       }
     }
   })
   ```

### Memory Issues During Build

**Problem:** Build process runs out of memory.

**Solution:**
```bash
# Increase Node.js memory limit
NODE_OPTIONS="--max-old-space-size=4096" npm run build

# Or add to package.json scripts:
"build": "NODE_OPTIONS='--max-old-space-size=4096' nuxt build"
```

## API and Data Issues

### API Connection Failures

**Problem:** Can't connect to external APIs.

**Solution:**
1. Check network connectivity
2. Verify API endpoints and credentials
3. Check for CORS issues:
   ```javascript
   // Add to nuxt.config.ts
   nitro: {
     routeRules: {
       '/api/**': { 
         headers: { 
           'Access-Control-Allow-Origin': '*' 
         } 
       }
     }
   }
   ```

### Content Query Errors

**Problem:** Getting errors when querying content.

**Solution:**
```javascript
// Always handle potential undefined results
const { data: content } = await useLazyAsyncData('content', () =>
  queryContent(route.params.slug).findOne()
)

if (!content.value) {
  throw createError({
    statusCode: 404,
    statusMessage: 'Content not found'
  })
}
```

## Performance Issues

### Slow Page Loading

**Problem:** Pages take too long to load.

**Solution:**
1. Enable static generation:
   ```bash
   npm run generate
   ```

2. Optimize images:
   ```vue
   <!-- Use Nuxt Image component -->
   <NuxtImg src="/image.jpg" width="400" height="300" />
   ```

3. Implement lazy loading:
   ```vue
   <template>
     <div>
       <LazyMyComponent v-if="showComponent" />
     </div>
   </template>
   ```

### Large Bundle Size

**Problem:** JavaScript bundle is too large.

**Solution:**
1. Analyze bundle:
   ```bash
   npm run build --analyze
   ```

2. Use dynamic imports:
   ```javascript
   // Instead of
   import MyComponent from '~/components/MyComponent.vue'

   // Use
   const MyComponent = defineAsyncComponent(() => 
     import('~/components/MyComponent.vue')
   )
   ```

## Common Error Messages

### "Cannot resolve module"

**Error:** Module resolution failures.

**Solution:**
```bash
# Clear node_modules and reinstall
rm -rf node_modules package-lock.json
npm install

# Check import paths are correct
# Use ~ for project root: ~/components/MyComponent.vue
```

### "Hydration mismatch"

**Error:** Server and client render differently.

**Solution:**
1. Avoid using browser-only APIs in server-side code
2. Use `process.client` checks:
   ```javascript
   if (process.client) {
     // Client-only code
   }
   ```
3. Use `<ClientOnly>` component for client-specific content

### "404 - Page not found"

**Error:** Routes not working properly.

**Solution:**
1. Check file names in `pages/` directory
2. Verify dynamic route syntax: `[slug].vue`
3. For static generation, ensure routes are prerendered

## Getting Help

### Enable Debug Mode

Add debugging to your development environment:

```bash
# Add to .env
DEBUG=nuxt:*
NUXT_DEBUG=true

# Run with debug output
npm run dev
```

### Check Logs

Look for detailed error information:

```bash
# Check browser console for client-side errors
# Check terminal for server-side errors

# Enable verbose logging in nuxt.config.ts
export default defineNuxtConfig({
  debug: true,
  devtools: { enabled: true }
})
```

### Community Resources

- **Nuxt Documentation**: https://nuxt.com/docs
- **GitHub Issues**: https://github.com/nuxt/nuxt/issues  
- **Discord Community**: https://discord.com/invite/ps2h6QT
- **Stack Overflow**: Tag questions with `nuxt.js`

### Still Need Help?

If you can't find a solution here:

1. Check the [Getting Started](/getting-started) guide for setup issues
2. Review the [API Reference](/api-reference) for usage examples
3. Explore [Advanced Features](/advanced-features) for complex scenarios
4. Search existing issues on GitHub
5. Create a minimal reproduction example
6. Contact support with detailed error information

## Prevention Tips

### Best Practices

1. **Keep dependencies updated**:
   ```bash
   npm audit
   npm update
   ```

2. **Use TypeScript** for better error catching:
   ```bash
   npm install --save-dev typescript
   ```

3. **Test in production mode** before deploying:
   ```bash
   npm run build
   npm run preview
   ```

4. **Monitor console** for warnings and errors during development

5. **Use proper error boundaries** in your components:
   ```vue
   <script setup>
   defineErrorHandling((error) => {
     console.error('Component error:', error)
   })
   </script>
   ```

Remember: Most issues have been encountered by others. Search existing resources before creating new support requests! 