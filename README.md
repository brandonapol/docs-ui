# Documentation Site

[![Build and Deploy](https://github.com/yourusername/docs-ui/actions/workflows/deploy.yml/badge.svg)](https://github.com/yourusername/docs-ui/actions/workflows/deploy.yml)
[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-Live-brightgreen)](https://yourusername.github.io/docs-ui)

A beautiful, modern documentation website built with Nuxt 3 and Nuxt Content.

## Features

- **Modern Stack**: Nuxt 3, Vue 3, TypeScript
- **Content Management**: Nuxt Content with Markdown support  
- **Beautiful UI**: Tailwind CSS with responsive design
- **Code Quality**: Biome for fast linting and formatting
- **SEO Optimized**: Meta tags, sitemap, structured data
- **Developer Experience**: Hot reload, TypeScript support
- **Production Ready**: Docker support, CI/CD pipeline

## Getting Started

### Prerequisites

- Node.js 20.9.0 or higher
- npm 10.0.0 or higher

### Installation

```bash
git clone <repository-url>
cd docs-ui
npm install
```

### Development

```bash
npm run dev
```

Visit `http://localhost:3000` to see your site.

### Available Make Commands

**Development:**
- `make dev` - Start development server
- `make lint` - Check code quality with Biome
- `make fix` - Auto-fix linting issues with Biome
- `make format` - Format code with Biome
- `make clean` - Clean build artifacts

**Building:**
- `make generate` - Generate static files
- `make docker-build` - Build Docker image (production-ready)
- `make deploy-prep` - Complete deployment preparation

**CI/CD Testing:**
- `make ci` - Basic CI pipeline (install + lint + build)
- `make ci-build` - Build using production config (no linting dependencies)
- `make ci-docker` - Full CI with Docker testing
- `make ci-local` - Complete local CI pipeline (same as GitHub Actions)

The static files will be in the `.output/public/` directory.

## 🔄 CI/CD Pipeline

This project includes a comprehensive GitHub Actions workflow that automatically:

### ✅ **Automated Testing**
- **Code Quality**: Biome linting and formatting checks on every push and PR
- **Build Testing**: Generates static site using production config (no linting dependencies)
- **Docker Testing**: Builds container and tests HTTP responses
- **Multi-environment**: Tests on Node.js 20 with Ubuntu latest
- **Zero Dependencies**: Biome avoids native binding issues completely

### 🚀 **Automated Deployment**
- **Main Branch**: Auto-deploys to GitHub Pages on every push to `main`
- **Pull Requests**: Creates preview deployments on `gh-pages-preview` branch
- **Peaceiris Integration**: Uses `peaceiris/actions-gh-pages` for reliable deployments

### 🌐 **GitHub Pages Setup**

**Quick Setup:**
```bash
# Run the setup script to configure GitHub Pages
./scripts/setup-github-pages.sh
```

**Manual Setup:**
1. Go to your repository settings
2. Navigate to "Pages" section
3. Set source to "GitHub Actions"
4. Push to `main` branch to trigger deployment

**URLs:**
- **Production**: `https://yourusername.github.io/docs-ui`
- **Preview**: `https://yourusername.github.io/docs-ui` (branch: `gh-pages-preview`)

### 🧪 **Local Testing**

Test the complete CI pipeline locally before pushing:

```bash
# Run the same checks as GitHub Actions
make ci-local

# Test just Docker builds
make ci-docker

# Quick development checks
make lint
make generate
```

### 🔧 **Workflow Triggers**

The CI/CD pipeline runs on:

- **Push to `main`**: Full pipeline + deployment to GitHub Pages
- **Push to `develop`**: Full pipeline (no deployment)  
- **Pull Requests to `main`**: Full pipeline + preview deployment

**Pipeline Stages:**
1. **Lint** → Biome code quality and formatting checks
2. **Build** → Static site generation using production config (avoids dependency issues)
3. **Test** → Docker container build and HTTP response testing
4. **Deploy** → GitHub Pages deployment (main branch only)
5. **Preview** → Preview deployment (PRs only)

### 🔧 **Biome Integration**

The CI/CD pipeline uses **Biome** for linting and formatting because:
- **Fast**: Rust-based, extremely fast performance
- **Reliable**: No native binding issues in containers or CI
- **Modern**: Built-in formatter and linter in one tool
- **Zero Config**: Works great out of the box for JavaScript/TypeScript

This approach ensures reliable builds across all environments while maintaining code quality checks.

## ✨ Features

- 🚀 **Nuxt 3** - Latest version with Vue 3, TypeScript, and Vite
- 📝 **Nuxt Content** - File-based CMS for Markdown content
- 🎨 **Tailwind CSS** - Utility-first CSS framework for styling
- 🔍 **Full-text Search** - Powered by Fuse.js for fast, client-side search
- 📱 **Responsive Design** - Mobile-first, works on all devices
- 🌙 **Syntax Highlighting** - Beautiful code blocks with GitHub Dark theme
- 🧭 **Navigation** - Breadcrumbs, next/previous links, and smart routing
- ⚡ **Performance** - Optimized for speed and SEO

## 🚀 Quick Start

### Prerequisites

- Node.js 16.x or later
- npm, yarn, or pnpm

### Installation

```bash
# Clone the repository (or download the files)
git clone <your-repo-url>
cd docs-ui

# Install dependencies
npm install
# or
yarn install
# or
pnpm install
```

### Development

```bash
# Start the development server
npm run dev
# or
yarn dev
# or
pnpm dev
```

Visit `http://localhost:3000` to see your documentation site.

### Production

```bash
# Build for production
npm run build

# Preview the production build
npm run preview

# Generate static site (optional)
npm run generate
```

## 📁 Project Structure

```
docs-ui/
├── assets/css/           # Global styles and Tailwind CSS
├── components/           # Vue components (if needed)
├── content/              # Markdown documentation files
│   ├── getting-started.md
│   ├── api-reference.md
│   ├── troubleshooting.md
│   ├── advanced-features.md
│   └── quick-start.md
├── layouts/              # Layout components
│   └── default.vue       # Main layout with navbar and footer
├── pages/                # Page components and routing
│   ├── index.vue         # Homepage with search
│   ├── docs/
│   │   └── index.vue     # Documentation listing page
│   └── [...slug].vue     # Dynamic page for individual docs
├── nuxt.config.ts        # Nuxt configuration
├── package.json          # Dependencies and scripts
└── README.md             # This file
```

## 📝 Adding Documentation

### Creating New Documentation

1. **Add a new Markdown file** to the `content/` directory:

```markdown
---
title: Your Document Title
description: Brief description of the document
category: Guide  # Guide, Reference, Support, etc.
createdAt: 2024-01-25
---

# Your Document Title

Your content goes here...

## Section 1

Content for section 1.

## Section 2

Content for section 2.
```

2. **Frontmatter fields**:
   - `title`: The document title (required)
   - `description`: Brief description for search results and meta tags
   - `category`: Used for organization and filtering
   - `createdAt`: Publication date

3. **File naming**: Use kebab-case for filenames (e.g., `getting-started.md`)

### Organizing Content

- **Flat structure**: All docs in `/content/` root for simplicity
- **Nested structure**: Create subdirectories like `/content/guides/`, `/content/api/`

### Markdown Features

The site supports all standard Markdown features plus:

- **Code highlighting** with language specification
- **Tables** for structured data
- **Links** between documents (use relative paths)
- **Images** (place in `/public/` directory)

## 🎨 Customization

### Styling

The site uses Tailwind CSS for styling. Key files:

- `assets/css/main.css` - Main stylesheet with Tailwind imports
- `layouts/default.vue` - Main layout structure
- `pages/index.vue` - Homepage design
- `pages/docs/index.vue` - Documentation listing design

### Colors and Theme

Modify the color scheme in `assets/css/main.css`:

```css
/* Change primary colors */
.prose-custom {
  @apply prose-a:text-purple-600 hover:prose-a:text-purple-800;
}

/* Update button colors in templates */
class="bg-purple-600 hover:bg-purple-700"
```

### Navigation

Update the navigation in `layouts/default.vue`:

```vue
<!-- Add more navigation items -->
<div class="flex items-center space-x-4">
  <NuxtLink to="/docs">All Docs</NuxtLink>
  <NuxtLink to="/about">About</NuxtLink>
  <NuxtLink to="/contact">Contact</NuxtLink>
</div>
```

## 🔍 Search Configuration

The search is powered by Fuse.js and configured in `pages/index.vue`:

```javascript
const fuse = new Fuse(docs, {
  keys: ['title', 'description', 'body'],
  threshold: 0.4,  // Adjust search sensitivity
  includeScore: true
})
```

### Search Customization

- **Search fields**: Modify the `keys` array to change what fields are searched
- **Sensitivity**: Adjust `threshold` (0.0 = exact match, 1.0 = match anything)
- **Results**: Change the `slice(0, 5)` to show more/fewer results

## 🚀 Deployment

### Static Generation

Generate a static site for deployment:

```bash
npm run generate
# or using Makefile
make generate
```

### Docker Deployment

Build and deploy using Docker (recommended for production):

```bash
# Quick deployment preparation
make deploy-prep

# Build Docker image (builds locally first to avoid native binding issues)
make docker-build

# Run the container
make docker-run
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-docs`
3. Add your documentation or improvements
4. Commit changes: `git commit -am 'Add new documentation'`
5. Push to the branch: `git push origin feature/new-docs`
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Documentation Issues**: Open an issue in this repository
- **Nuxt 3 Help**: [Nuxt Documentation](https://nuxt.com/docs)
- **Nuxt Content Help**: [Nuxt Content Documentation](https://content.nuxtjs.org/)
- **Tailwind CSS**: [Tailwind Documentation](https://tailwindcss.com/docs)

---

Built with ❤️ using [Nuxt 3](https://nuxt.com) and [Nuxt Content](https://content.nuxtjs.org/) # docs-ui
