#!/usr/bin/env python3
"""
Mad Apps Issues Migration Script

This script helps migrate existing issues from individual repositories 
to the central mad-apps-issues repository.

Usage:
    python migrate-existing-issues.py --source-repos madcore,maditemmaker,madquestmaker
"""

import argparse
import json
import subprocess
import sys
from datetime import datetime
from typing import List, Dict, Any
import time

def run_gh_command(cmd: List[str]) -> Dict[str, Any]:
    """Run a GitHub CLI command and return the JSON result."""
    try:
        result = subprocess.run(
            cmd, 
            capture_output=True, 
            text=True, 
            check=True
        )
        if result.stdout.strip():
            return json.loads(result.stdout)
        return {}
    except subprocess.CalledProcessError as e:
        print(f"❌ Command failed: {' '.join(cmd)}")
        print(f"Error: {e.stderr}")
        return {}
    except json.JSONDecodeError as e:
        print(f"❌ Failed to parse JSON response: {e}")
        return {}

def get_repo_issues(repo: str) -> List[Dict[str, Any]]:
    """Get all issues from a repository."""
    print(f"🔍 Fetching issues from {repo}...")
    
    issues = []
    page = 1
    per_page = 100
    
    while True:
        cmd = [
            "gh", "issue", "list",
            "--repo", repo,
            "--state", "all",
            "--json", "number,title,body,state,labels,author,createdAt,updatedAt,comments",
            "--limit", str(per_page),
            f"--page={page}"
        ]
        
        result = run_gh_command(cmd)
        if not result or not isinstance(result, list):
            break
            
        if not result:  # Empty page means we're done
            break
            
        issues.extend(result)
        page += 1
        
        # Rate limiting
        time.sleep(0.5)
    
    print(f"✅ Found {len(issues)} issues in {repo}")
    return issues

def create_migration_issue(target_repo: str, source_repo: str, issue: Dict[str, Any], dry_run: bool = False) -> bool:
    """Create a migrated issue in the target repository."""
    
    # Create new issue title with migration marker
    original_title = issue.get('title', 'Untitled Issue')
    new_title = f"[MIGRATED from {source_repo}] {original_title}"
    
    # Create migration notice for the body
    migration_notice = f"""
> **🔄 This issue was migrated from [{source_repo}](https://github.com/{source_repo})**
> - **Original Issue**: #{issue.get('number', 'unknown')}
> - **Original Author**: @{issue.get('author', {}).get('login', 'unknown')}
> - **Created**: {issue.get('createdAt', 'unknown')}
> - **State**: {issue.get('state', 'unknown')}

---

"""
    
    # Combine migration notice with original body
    original_body = issue.get('body', '') or '*No description provided.*'
    new_body = migration_notice + original_body
    
    # Map labels to new component labels
    original_labels = [label.get('name', '') for label in issue.get('labels', [])]
    new_labels = map_labels_for_migration(source_repo, original_labels)
    
    if dry_run:
        print(f"🔸 DRY RUN: Would create issue '{new_title}' with labels: {new_labels}")
        return True
    
    # Create the issue
    cmd = [
        "gh", "issue", "create",
        "--repo", target_repo,
        "--title", new_title,
        "--body", new_body
    ]
    
    # Add labels if any
    if new_labels:
        for label in new_labels:
            cmd.extend(["--label", label])
    
    print(f"📝 Creating issue: {new_title}")
    result = run_gh_command(cmd)
    
    if result:
        print(f"✅ Created issue #{result.get('number')} in {target_repo}")
        return True
    else:
        print(f"❌ Failed to create issue in {target_repo}")
        return False

def map_labels_for_migration(source_repo: str, original_labels: List[str]) -> List[str]:
    """Map original labels to new centralized labels."""
    
    # Component mapping based on source repository
    component_map = {
        'madcore': 'component/madcore',
        'maditemmaker': 'component/maditemmaker', 
        'madquestmaker': 'component/madquestmaker',
        'theme_editor': 'component/theme-editor',
        'story-engine': 'component/story-engine',
        'terminal-kingpin': 'component/terminal-kingpin',
        'madhub-web': 'component/madhub-web',
        'mad-toolbox': 'component/mad-toolbox'
    }
    
    # Standard label mappings
    label_map = {
        # Type mappings
        'bug': 'type/bug',
        'enhancement': 'type/feature',
        'feature': 'type/feature',
        'documentation': 'type/documentation',
        'performance': 'type/performance',
        'security': 'type/security',
        
        # Priority mappings  
        'critical': 'priority/critical',
        'high-priority': 'priority/high',
        'medium-priority': 'priority/medium',
        'low-priority': 'priority/low',
        
        # Status mappings
        'needs-more-info': 'needs-more-info',
        'duplicate': 'duplicate',
        'good-first-issue': 'good-first-issue',
        'help-wanted': 'help-wanted',
        
        # Platform mappings
        'desktop': 'platform/desktop',
        'web': 'platform/web',
    }
    
    new_labels = []
    
    # Add component label based on source repo
    repo_name = source_repo.split('/')[-1]  # Get repo name without owner
    if repo_name in component_map:
        new_labels.append(component_map[repo_name])
    
    # Map existing labels
    for label in original_labels:
        label_lower = label.lower()
        if label_lower in label_map:
            new_labels.append(label_map[label_lower])
        elif label.startswith('component/'):
            new_labels.append(label)  # Keep existing component labels
        elif label.startswith('type/'):
            new_labels.append(label)  # Keep existing type labels
        elif label.startswith('priority/'):
            new_labels.append(label)  # Keep existing priority labels
    
    # Add migration label
    new_labels.append('migrated-issue')
    
    # Remove duplicates and return
    return list(set(new_labels))

def create_migration_report(migrations: List[Dict[str, Any]], output_file: str = None):
    """Create a migration report."""
    
    if output_file is None:
        output_file = f"migration_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
    
    report = {
        'migration_date': datetime.now().isoformat(),
        'total_issues': len(migrations),
        'successful_migrations': len([m for m in migrations if m['success']]),
        'failed_migrations': len([m for m in migrations if not m['success']]),
        'issues': migrations
    }
    
    with open(output_file, 'w') as f:
        json.dump(report, f, indent=2)
    
    print(f"📊 Migration report saved to: {output_file}")

def main():
    parser = argparse.ArgumentParser(description='Migrate issues to mad-apps-issues repository')
    parser.add_argument(
        '--source-repos', 
        required=True, 
        help='Comma-separated list of source repositories (e.g., mad/madcore,mad/maditemmaker)'
    )
    parser.add_argument(
        '--target-repo', 
        default='mad/mad-apps-issues',
        help='Target repository for migrated issues'
    )
    parser.add_argument(
        '--dry-run', 
        action='store_true',
        help='Show what would be migrated without actually creating issues'
    )
    parser.add_argument(
        '--limit',
        type=int,
        help='Limit number of issues to migrate per repository'
    )
    parser.add_argument(
        '--state',
        choices=['open', 'closed', 'all'],
        default='all',
        help='Which issues to migrate (default: all)'
    )
    parser.add_argument(
        '--output',
        help='Output file for migration report (default: auto-generated)'
    )
    
    args = parser.parse_args()
    
    # Parse source repositories
    source_repos = [repo.strip() for repo in args.source_repos.split(',')]
    
    print("🚀 Mad Apps Issues Migration Tool")
    print("=" * 50)
    print(f"Source repositories: {', '.join(source_repos)}")
    print(f"Target repository: {args.target_repo}")
    print(f"Dry run: {'Yes' if args.dry_run else 'No'}")
    print(f"State filter: {args.state}")
    if args.limit:
        print(f"Limit per repo: {args.limit}")
    print()
    
    if not args.dry_run:
        confirm = input("⚠️  This will create new issues in the target repository. Continue? (y/N): ")
        if confirm.lower() != 'y':
            print("Migration cancelled.")
            return
        print()
    
    all_migrations = []
    
    # Process each source repository
    for source_repo in source_repos:
        print(f"🔄 Processing repository: {source_repo}")
        print("-" * 30)
        
        # Get issues from source repository
        issues = get_repo_issues(source_repo)
        
        if not issues:
            print(f"⚠️  No issues found in {source_repo}")
            continue
        
        # Apply state filter
        if args.state != 'all':
            issues = [issue for issue in issues if issue.get('state') == args.state]
            print(f"📝 Filtered to {len(issues)} {args.state} issues")
        
        # Apply limit if specified
        if args.limit:
            issues = issues[:args.limit]
            print(f"📝 Limited to {len(issues)} issues")
        
        # Migrate each issue
        for i, issue in enumerate(issues, 1):
            print(f"📋 Processing issue {i}/{len(issues)}: #{issue.get('number')}")
            
            success = create_migration_issue(
                args.target_repo, 
                source_repo, 
                issue, 
                args.dry_run
            )
            
            migration_record = {
                'source_repo': source_repo,
                'source_issue_number': issue.get('number'),
                'source_issue_title': issue.get('title'),
                'success': success,
                'timestamp': datetime.now().isoformat()
            }
            
            all_migrations.append(migration_record)
            
            # Rate limiting between issues
            if not args.dry_run:
                time.sleep(1)
        
        print(f"✅ Completed processing {source_repo}")
        print()
    
    # Generate migration report
    if all_migrations:
        create_migration_report(all_migrations, args.output)
        
        successful = len([m for m in all_migrations if m['success']])
        total = len(all_migrations)
        
        print("📊 Migration Summary:")
        print(f"   Total issues processed: {total}")
        print(f"   Successful migrations: {successful}")
        print(f"   Failed migrations: {total - successful}")
        
        if args.dry_run:
            print("\n🔸 This was a dry run. No issues were actually created.")
            print("   Remove --dry-run flag to perform the actual migration.")
    else:
        print("⚠️  No issues were processed.")

if __name__ == "__main__":
    # Check if GitHub CLI is available
    try:
        subprocess.run(["gh", "--version"], capture_output=True, check=True)
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("❌ GitHub CLI is not installed or not available in PATH.")
        print("Please install GitHub CLI: https://cli.github.com/")
        sys.exit(1)
    
    # Check if user is authenticated
    try:
        subprocess.run(["gh", "auth", "status"], capture_output=True, check=True)
    except subprocess.CalledProcessError:
        print("❌ Not authenticated with GitHub CLI.")
        print("Please run: gh auth login")
        sys.exit(1)
    
    main()