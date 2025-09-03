#!/bin/bash
# Local Git Repository Setup Script
# This script initializes the local git repository and pushes to GitHub

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
REPO_NAME="mad-apps-issues"
REPO_OWNER="mad"  # Change this to your GitHub username/org
REPO_FULL="${REPO_OWNER}/${REPO_NAME}"

echo -e "${BLUE}📁 Setting up local Git repository${NC}"
echo "================================================="

# Function to print status messages
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Change to the project directory
PROJECT_DIR="/Users/mad/src/mad-apps-issues"
if [ ! -d "$PROJECT_DIR" ]; then
    log_error "Project directory not found: $PROJECT_DIR"
    exit 1
fi

cd "$PROJECT_DIR"
log_info "Working in directory: $(pwd)"

# Initialize git repository if not already initialized
if [ ! -d ".git" ]; then
    log_info "Initializing Git repository..."
    git init
    log_success "Git repository initialized"
else
    log_info "Git repository already exists"
fi

# Create .gitignore if it doesn't exist
if [ ! -f ".gitignore" ]; then
    log_info "Creating .gitignore file..."
    cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# Virtual environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Logs
*.log
logs/

# Temporary files
*.tmp
*.temp
migration_report_*.json

# Backup files
*.bak
*.backup

EOF
    log_success "Created .gitignore file"
fi

# Add all files to git
log_info "Adding files to Git..."
git add .

# Check if there are changes to commit
if git diff --staged --quiet; then
    log_warning "No changes to commit"
else
    log_info "Committing changes..."
    git commit -m "Initial setup: Mad Apps Issues tracking repository

- GitHub issue templates for bugs, features, web platform, desktop apps, and documentation
- GitHub Actions workflows for auto-labeling, triage, and stale issue management
- Comprehensive labeling system with component, type, priority, and platform labels
- Documentation including issue guidelines and triage process
- Setup scripts for repository initialization and issue migration
- Automation for welcome messages and issue routing

This repository serves as the central issue tracking hub for the entire Mad Apps Suite,
including desktop applications (maditemmaker, madquestmaker, theme-editor, story-engine,
terminal-kingpin) and the upcoming MadHub web platform."
    
    log_success "Changes committed"
fi

# Set up remote if not already set
if ! git remote | grep -q "origin"; then
    log_info "Adding remote origin..."
    git remote add origin "https://github.com/$REPO_FULL.git"
    log_success "Remote origin added"
else
    log_info "Remote origin already exists"
    # Update remote URL in case it changed
    git remote set-url origin "https://github.com/$REPO_FULL.git"
fi

# Set default branch name to main
log_info "Setting default branch to main..."
git branch -M main

# Check if GitHub CLI is available for authentication check
if command -v gh &> /dev/null; then
    if ! gh auth status &> /dev/null; then
        log_warning "GitHub CLI not authenticated. You may need to enter credentials when pushing."
    fi
fi

# Push to GitHub
log_info "Pushing to GitHub..."
if git push -u origin main; then
    log_success "Successfully pushed to GitHub!"
else
    log_error "Failed to push to GitHub. You may need to:"
    echo "1. Authenticate with GitHub (gh auth login or set up SSH keys)"
    echo "2. Make sure the repository exists on GitHub"
    echo "3. Check your internet connection"
    echo ""
    echo "You can also try pushing manually:"
    echo "git push -u origin main"
    exit 1
fi

log_success "Git repository setup complete!"

echo ""
echo "================================================="
echo -e "${GREEN}🎉 Local Git Setup Complete!${NC}"
echo ""
echo "Repository details:"
echo "📁 Local path: $PROJECT_DIR"
echo "🌐 GitHub URL: https://github.com/$REPO_FULL"
echo "📋 Issues URL: https://github.com/$REPO_FULL/issues"
echo "💬 Discussions: https://github.com/$REPO_FULL/discussions"
echo ""
echo "Next steps:"
echo "1. 🔧 Run the repository setup script to configure GitHub:"
echo "   ./scripts/setup-repository.sh"
echo ""
echo "2. 🧪 Test the issue templates by creating a test issue:"
echo "   https://github.com/$REPO_FULL/issues/new"
echo ""
echo "3. 📋 Migrate existing issues from other repositories:"
echo "   ./scripts/migrate-existing-issues.py --source-repos mad/madcore,mad/maditemmaker --dry-run"
echo ""
echo "4. 👥 Share with your community and start tracking issues!"
echo ""
echo "Happy issue tracking! 🚀"