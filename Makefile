# Makefile for docs-ui project

# Detect available container runtime
DOCKER_CMD := $(shell command -v docker 2> /dev/null || command -v podman 2> /dev/null || echo "docker")

.PHONY: help install dev build generate preview lint fix clean docker-build docker-run docker-clean test audit format check

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
lint:
	@echo "🔍 Running Biome linting..."
	npm run lint

fix:
	@echo "🔧 Fixing linting issues..."
	npm run lint:fix

format:
	@echo "💅 Formatting code..."
	npm run format

check:
	@echo "✅ Running complete code quality check..."
	npm run check

# Maintenance commands
clean: ## Clean build artifacts and caches
	rm -rf .nuxt .output dist node_modules/.cache
	@echo "Cleaned build artifacts and caches"

clean-all: ## Clean everything including node_modules
	rm -rf .nuxt .output dist node_modules
	@echo "Cleaned all build artifacts and node_modules"

reinstall: clean-all install ## Clean and reinstall dependencies

# Docker commands
docker-build: ## Build Docker image (requires local build first)
	@echo "Building locally first..."
	npm run generate
	$(DOCKER_CMD) build -f Dockerfile.static -t docs-ui .

docker-build-dev: ## Build Docker image with full build process (may fail due to native bindings)
	$(DOCKER_CMD) build -f Dockerfile -t docs-ui .

docker-run: ## Run Docker container
	$(DOCKER_CMD) run -d -p 8080:8080 --name docs-ui-container docs-ui

docker-stop: ## Stop Docker container
	$(DOCKER_CMD) stop docs-ui-container || true
	$(DOCKER_CMD) rm docs-ui-container || true

docker-clean: docker-stop ## Clean Docker containers and images
	$(DOCKER_CMD) rmi docs-ui || true
	@echo "Cleaned Docker containers and images"

deploy-prep: ## Prepare for deployment (build + test)
	@echo "Preparing for deployment..."
	make clean
	make install
	make lint
	make generate
	@echo "✅ Ready for deployment!"

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

ci-docker: install lint generate docker-build ## Full CI with Docker testing
	@echo "🐳 Testing Docker container..."
	@$(DOCKER_CMD) run -d --name test-container -p 8080:8080 docs-ui:latest
	@sleep 3
	@if curl -f http://localhost:8080 > /dev/null 2>&1; then \
		echo "✅ Docker container test passed"; \
		$(DOCKER_CMD) stop test-container; \
		$(DOCKER_CMD) rm test-container; \
	else \
		echo "❌ Docker container test failed"; \
		$(DOCKER_CMD) logs test-container; \
		$(DOCKER_CMD) stop test-container; \
		$(DOCKER_CMD) rm test-container; \
		exit 1; \
	fi
	@echo "🎉 Full CI pipeline with Docker testing completed successfully"

ci-local: ## Run complete CI pipeline locally (same as GitHub Actions)
	@echo "🚀 Running local CI pipeline..."
	@echo "Step 1: Linting..."
	@make lint
	@echo "Step 2: Building (production config)..."
	@make ci-build
	@echo "Step 3: Docker build test..."
	@make docker-build
	@echo "Step 4: Docker container test..."
	@make ci-docker
	@echo "✅ Local CI pipeline completed - ready for deployment!"

ci-build: ## Build using production config (same as GitHub Actions)
	@echo "🏭 Building with production configuration (no ESLint dependencies)..."
	@cp package.docker.json package.json.backup
	@cp nuxt.config.docker.ts nuxt.config.backup.ts
	@cp package.docker.json package.json
	@cp nuxt.config.docker.ts nuxt.config.ts
	@npm ci --no-fund --silent
	@npm run generate
	@echo "🔄 Restoring original configuration..."
	@mv package.json.backup package.json
	@mv nuxt.config.backup.ts nuxt.config.ts
	@echo "✅ Production build completed successfully"

# DigitalOcean specific commands
.PHONY: docker-build-do docker-run-do docker-stop-do deploy-do-prep

docker-build-do: ## Build Docker image for DigitalOcean (port 80)
	@echo "🐳 Building Docker image for DigitalOcean..."
	@make generate
	$(DOCKER_CMD) build -f Dockerfile.do -t docs-ui:do-latest .
	@echo "✅ DigitalOcean Docker image built!"

docker-run-do: ## Run DigitalOcean Docker image locally for testing (maps port 80->8080)
	@echo "🚀 Running DigitalOcean Docker image locally..."
	$(DOCKER_CMD) run -d --name docs-ui-do -p 8080:80 docs-ui:do-latest
	@echo "📝 DigitalOcean container running at http://localhost:8080"

docker-stop-do: ## Stop DigitalOcean Docker container
	@echo "🛑 Stopping DigitalOcean Docker container..."
	@$(DOCKER_CMD) stop docs-ui-do 2>/dev/null || true
	@$(DOCKER_CMD) rm docs-ui-do 2>/dev/null || true
	@echo "✅ DigitalOcean container stopped!"

deploy-do-prep: ## Prepare for DigitalOcean deployment (build + test DO image)
	@echo "🚀 Preparing for DigitalOcean deployment..."
	@make generate
	@make lint
	@make docker-build-do
	@echo "🧪 Testing DigitalOcean image..."
	@$(DOCKER_CMD) run -d --name test-do-container -p 8081:80 docs-ui:do-latest
	@sleep 3
	@if curl -f http://localhost:8081/health > /dev/null 2>&1; then \
		echo "✅ DigitalOcean container test passed"; \
		$(DOCKER_CMD) stop test-do-container; \
		$(DOCKER_CMD) rm test-do-container; \
	else \
		echo "❌ DigitalOcean container test failed"; \
		$(DOCKER_CMD) logs test-do-container; \
		$(DOCKER_CMD) stop test-do-container; \
		$(DOCKER_CMD) rm test-do-container; \
		exit 1; \
	fi
	@echo "✅ Ready for DigitalOcean deployment!" 