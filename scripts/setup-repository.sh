#!/bin/bash
# Mad Apps Issues Repository Setup Script
# This script initializes the GitHub repository with labels, settings, and configurations

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

echo -e "${BLUE}🚀 Mad Apps Issues Repository Setup${NC}"
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

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    log_error "GitHub CLI is not installed. Please install it first:"
    echo "https://cli.github.com/"
    exit 1
fi

# Check if user is logged in to GitHub CLI
if ! gh auth status &> /dev/null; then
    log_error "Please login to GitHub CLI first:"
    echo "gh auth login"
    exit 1
fi

log_info "Checking if repository exists..."

# Check if repository already exists
if gh repo view "$REPO_FULL" &> /dev/null; then
    log_warning "Repository $REPO_FULL already exists!"
    echo "Do you want to continue with setup? (y/N)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "Setup cancelled."
        exit 0
    fi
else
    log_info "Creating GitHub repository..."
    gh repo create "$REPO_FULL" --public --description "Central issue tracking for Mad Apps Suite - Desktop and Web applications for game development, creative writing, and developer tools"
    log_success "Repository created: https://github.com/$REPO_FULL"
fi

log_info "Setting up repository labels..."

# Component Labels
declare -A COMPONENT_LABELS=(
    ["component/madcore"]="0052cc"
    ["component/maditemmaker"]="0e8a16"
    ["component/madquestmaker"]="fbca04"
    ["component/theme-editor"]="d73a4a"
    ["component/story-engine"]="0052cc"
    ["component/terminal-kingpin"]="5319e7"
    ["component/madhub-web"]="1d76db"
    ["component/mad-toolbox"]="f9d0c4"
)

# Type Labels
declare -A TYPE_LABELS=(
    ["type/bug"]="d73a4a"
    ["type/feature"]="0e8a16"
    ["type/documentation"]="0052cc"
    ["type/performance"]="fbca04"
    ["type/security"]="b60205"
    ["type/enhancement"]="84b6eb"
)

# Priority Labels
declare -A PRIORITY_LABELS=(
    ["priority/critical"]="b60205"
    ["priority/high"]="d93f0b"
    ["priority/medium"]="fbca04"
    ["priority/low"]="0e8a16"
)

# Platform Labels  
declare -A PLATFORM_LABELS=(
    ["platform/desktop"]="1d76db"
    ["platform/web"]="0052cc"
    ["platform/all"]="5319e7"
)

# Status Labels
declare -A STATUS_LABELS=(
    ["status/triage"]="fef2c0"
    ["status/confirmed"]="0e8a16"
    ["status/in-progress"]="1d76db"
    ["status/blocked"]="d93f0b"
    ["needs-more-info"]="d4c5f9"
    ["duplicate"]="cfd3d7"
    ["good-first-issue"]="7057ff"
    ["help-wanted"]="008672"
    ["stale"]="fef2c0"
    ["keep-open"]="0e8a16"
)

# Function to create label
create_label() {
    local label_name="$1"
    local label_color="$2"
    local label_description="$3"
    
    if gh label list --repo "$REPO_FULL" | grep -q "^$label_name"; then
        log_warning "Label '$label_name' already exists, updating..."
        gh label edit "$label_name" --repo "$REPO_FULL" --color "$label_color" --description "$label_description" 2>/dev/null || true
    else
        gh label create "$label_name" --repo "$REPO_FULL" --color "$label_color" --description "$label_description" 2>/dev/null || true
        log_success "Created label: $label_name"
    fi
}

# Create all labels
log_info "Creating component labels..."
for label in "${!COMPONENT_LABELS[@]}"; do
    component=${label#component/}
    create_label "$label" "${COMPONENT_LABELS[$label]}" "Issues related to $component"
done

log_info "Creating type labels..."
create_label "type/bug" "${TYPE_LABELS[type/bug]}" "Something isn't working"
create_label "type/feature" "${TYPE_LABELS[type/feature]}" "New feature or request"
create_label "type/documentation" "${TYPE_LABELS[type/documentation]}" "Improvements or additions to documentation"
create_label "type/performance" "${TYPE_LABELS[type/performance]}" "Performance related issues"
create_label "type/security" "${TYPE_LABELS[type/security]}" "Security related issues"
create_label "type/enhancement" "${TYPE_LABELS[type/enhancement]}" "Enhancement to existing functionality"

log_info "Creating priority labels..."
create_label "priority/critical" "${PRIORITY_LABELS[priority/critical]}" "Critical priority - blocking issue"
create_label "priority/high" "${PRIORITY_LABELS[priority/high]}" "High priority issue"
create_label "priority/medium" "${PRIORITY_LABELS[priority/medium]}" "Medium priority issue"
create_label "priority/low" "${PRIORITY_LABELS[priority/low]}" "Low priority issue"

log_info "Creating platform labels..."
create_label "platform/desktop" "${PLATFORM_LABELS[platform/desktop]}" "Desktop applications"
create_label "platform/web" "${PLATFORM_LABELS[platform/web]}" "Web platform"
create_label "platform/all" "${PLATFORM_LABELS[platform/all]}" "All platforms"

log_info "Creating status labels..."
create_label "status/triage" "${STATUS_LABELS[status/triage]}" "Needs triage"
create_label "status/confirmed" "${STATUS_LABELS[status/confirmed]}" "Confirmed issue"
create_label "status/in-progress" "${STATUS_LABELS[status/in-progress]}" "Work in progress"
create_label "status/blocked" "${STATUS_LABELS[status/blocked]}" "Blocked on external dependency"
create_label "needs-more-info" "${STATUS_LABELS[needs-more-info]}" "More information needed"
create_label "duplicate" "${STATUS_LABELS[duplicate]}" "This issue or pull request already exists"
create_label "good-first-issue" "${STATUS_LABELS[good-first-issue]}" "Good for newcomers"
create_label "help-wanted" "${STATUS_LABELS[help-wanted]}" "Extra attention is needed"
create_label "stale" "${STATUS_LABELS[stale]}" "Stale issue"
create_label "keep-open" "${STATUS_LABELS[keep-open]}" "Exempt from stale bot"

log_success "All labels created successfully!"

# Enable repository features
log_info "Configuring repository settings..."

# Enable Issues, Wikis, and Discussions
gh repo edit "$REPO_FULL" --enable-issues --enable-wiki 2>/dev/null || true

# Try to enable discussions (may require GitHub API)
log_info "Attempting to enable discussions..."
gh repo edit "$REPO_FULL" --enable-discussions 2>/dev/null || log_warning "Could not enable discussions automatically. Please enable manually in repository settings."

log_success "Repository configuration complete!"

# Setup branch protection (optional)
log_info "Setting up branch protection for main branch..."
gh api repos/"$REPO_FULL"/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":[]}' \
  --field enforce_admins=false \
  --field required_pull_request_reviews='{"required_approving_review_count":1,"dismiss_stale_reviews":true}' \
  --field restrictions=null 2>/dev/null || log_warning "Could not set up branch protection. You may need to do this manually."

# Create initial project board
log_info "Creating project board..."
gh project create --repo "$REPO_FULL" --title "Mad Apps Suite Issues" --body "Central issue tracking and project management for Mad Apps Suite" 2>/dev/null || log_warning "Could not create project board automatically."

log_success "Repository setup completed!"

echo ""
echo "================================================="
echo -e "${GREEN}🎉 Setup Complete!${NC}"
echo ""
echo "Next steps:"
echo "1. 📁 Push your local files to the repository:"
echo "   cd /path/to/mad-apps-issues"
echo "   git init"
echo "   git add ."
echo "   git commit -m 'Initial setup: issue templates, workflows, and documentation'"
echo "   git branch -M main"
echo "   git remote add origin https://github.com/$REPO_FULL.git"
echo "   git push -u origin main"
echo ""
echo "2. 🔧 Manually enable the following if not auto-configured:"
echo "   - Discussions (in repository settings)"
echo "   - Branch protection rules"
echo "   - GitHub Projects (for issue tracking)"
echo ""
echo "3. 📝 Customize the repository:"
echo "   - Update README.md with your specific details"
echo "   - Modify issue templates if needed"
echo "   - Configure team members and permissions"
echo ""
echo "4. 🚀 Start using the repository:"
echo "   - Create your first issue to test the system"
echo "   - Share the repository with your community"
echo "   - Monitor the GitHub Actions for automation"
echo ""
echo -e "${BLUE}Repository URL: https://github.com/$REPO_FULL${NC}"
echo -e "${BLUE}Issues URL: https://github.com/$REPO_FULL/issues${NC}"
echo ""
echo "Happy issue tracking! 🐛✨"