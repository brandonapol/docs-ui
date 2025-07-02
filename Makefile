# Makefile for docs-ui project

.PHONY: help install dev build generate preview lint fix clean docker-build docker-run docker-clean test audit

# Default target
help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

# Development commands
install: ## Install dependencies
	npm install --no-fund --silent

dev: ## Start development server
	npm run dev

build: ## Build the application
	npm run build

generate: ## Generate static files
	npm run generate

preview: ## Preview the built application
	npm run preview

# Code quality commands
lint: ## Run ESLint to check code quality
	npm run lint

fix: ## Auto-fix ESLint issues
	npm run lint:fix

# Maintenance commands
clean: ## Clean build artifacts and caches
	rm -rf .nuxt .output dist node_modules/.cache
	@echo "Cleaned build artifacts and caches"

clean-all: ## Clean everything including node_modules
	rm -rf .nuxt .output dist node_modules
	@echo "Cleaned all build artifacts and node_modules"

reinstall: clean-all install ## Clean and reinstall dependencies

# Docker commands
docker-build: ## Build Docker image
	podman build -f Dockerfile -t docs-ui .

docker-run: ## Run Docker container
	podman run -d -p 8080:80 --name docs-ui-container docs-ui

docker-stop: ## Stop Docker container
	podman stop docs-ui-container || true
	podman rm docs-ui-container || true

docker-clean: docker-stop ## Clean Docker containers and images
	podman rmi docs-ui || true
	@echo "Cleaned Docker containers and images"

# Security and maintenance
audit: ## Run npm audit
	npm audit

audit-fix: ## Fix npm audit issues
	npm audit fix

# Quick commands
start: dev ## Alias for dev
serve: preview ## Alias for preview
check: lint ## Alias for lint

serve-static: ## Generate and serve static files
	npm run generate
	npx serve .output/public


# Advanced commands
fresh: clean-all install dev ## Complete fresh start (clean, install, dev)

ci: install lint build ## CI/CD pipeline commands
	@echo "CI pipeline completed successfully" 