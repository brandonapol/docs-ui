import withNuxt from './.nuxt/eslint.config.mjs'

export default withNuxt({
  ignores: [
    // Dependencies
    'node_modules/**',
    
    // Build outputs
    '.nuxt/**',
    '.output/**',
    'dist/**',
    
    // Generated files
    '.turbo/**',
    '.vercel/**',
    '.netlify/**',
    '.wrangler/**',
    
    // Logs
    '**/*.log*',
    
    // Cache directories
    '.cache/**',
    '.parcel-cache/**',
    '.next/**',
    
    // Temporary
    'tmp/**',
    'temp/**',
    
    // Package manager
    'package-lock.json',
    'yarn.lock',
    'pnpm-lock.yaml',
    
    // Docker
    'Dockerfile',
    'docker-compose*.yml'
  ],
  rules: {
    // Add any custom rules here
    'vue/multi-word-component-names': 'off',
    'vue/no-multiple-template-root': 'off'
  }
}) 