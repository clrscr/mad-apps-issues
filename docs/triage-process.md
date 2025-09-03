# 🔍 Issue Triage Process

This document outlines the issue triage process for Mad Apps Suite maintainers and contributors.

## 🎯 Triage Goals

The triage process aims to:
- **Classify** issues by type, component, and priority
- **Validate** issue reports and reproduction steps  
- **Route** issues to appropriate team members
- **Prioritize** work based on impact and urgency
- **Maintain** high-quality issue queue

## 📋 Triage Workflow

### Stage 1: Initial Assessment (Within 24 hours)

#### 1. Validate Issue Template Usage
- ✅ **Complete**: All required sections filled out
- ⚠️ **Incomplete**: Missing critical information → Add `needs-more-info` label
- ❌ **Wrong Template**: Guide user to correct template

#### 2. Check for Duplicates  
- Search existing issues using key terms
- Check recently closed issues
- If duplicate found:
  - Add `duplicate` label
  - Reference original issue
  - Close with explanation

#### 3. Verify Basic Information
- **Component identification**: Correct component label applied?
- **Platform relevance**: Desktop/web/both?
- **Version information**: Current version affected?
- **Reproduction viability**: Can this be reproduced?

### Stage 2: Detailed Triage (Within 48 hours)

#### 1. Reproduce Bug Reports
```bash
# Bug reproduction checklist:
□ Environment setup matches reported issue
□ Steps followed exactly as described  
□ Issue reproduced successfully
□ Root cause identified (if obvious)
□ Workaround available?
```

#### 2. Evaluate Feature Requests
```markdown
# Feature evaluation criteria:
□ Aligns with project goals and roadmap
□ Clear user benefit and use case
□ Technical feasibility assessed
□ Implementation complexity estimated
□ Breaking changes identified
```

#### 3. Assess Documentation Issues
```markdown
# Documentation assessment:
□ Information accuracy verified
□ Current documentation reviewed
□ Scope of update determined
□ Related documentation identified
```

### Stage 3: Prioritization and Assignment

#### Priority Matrix

| Impact | Urgency | Priority | SLA |
|--------|---------|----------|-----|
| High | High | Critical | 24 hours |
| High | Medium | High | 1 week |
| Medium | High | High | 1 week |
| Medium | Medium | Medium | 2 weeks |
| Low | Any | Low | Best effort |

#### Priority Assignment Guidelines

**Critical Priority 🔴**
```yaml
criteria:
  - Security vulnerabilities
  - Data loss or corruption
  - Application crashes affecting all users
  - Blocking production deployments
  - API downtime or major service outages

actions:
  - Add `priority/critical` label
  - Add `needs-immediate-attention` label  
  - Notify team lead immediately
  - Consider hotfix release
```

**High Priority 🟠**
```yaml
criteria:
  - Major features completely broken
  - Performance issues affecting most users
  - Integration failures with popular tools
  - Critical workflow interruptions

actions:
  - Add `priority/high` label
  - Assign to next sprint
  - Consider for patch release
```

**Medium Priority 🟡**
```yaml
criteria:
  - Minor bugs with workarounds
  - Feature improvements with clear benefits
  - Documentation gaps affecting onboarding
  - UI/UX improvements

actions:
  - Add `priority/medium` label
  - Add to product backlog
  - Schedule for future release
```

**Low Priority 🟢**
```yaml
criteria:
  - Edge case bugs
  - Nice-to-have features
  - Minor documentation improvements
  - Cosmetic issues

actions:
  - Add `priority/low` label  
  - Add `help-wanted` if suitable for contributors
  - Consider for major release cycles
```

## 🏷️ Label Management

### Required Labels for Triaged Issues
Every triaged issue must have:
1. **Component label**: `component/madcore`, `component/maditemmaker`, etc.
2. **Type label**: `type/bug`, `type/feature`, etc.
3. **Priority label**: `priority/critical`, `priority/high`, etc.
4. **Status label**: `status/confirmed`, `needs-more-info`, etc.

### Optional Labels
- **Platform labels**: `platform/desktop`, `platform/web`
- **Difficulty labels**: `difficulty/easy`, `difficulty/hard`  
- **Area labels**: `area/ui-ux`, `area/api`, `area/performance`
- **Special labels**: `good-first-issue`, `help-wanted`

### Label Maintenance
```bash
# Weekly label cleanup tasks:
□ Remove outdated status labels
□ Update priority based on new information
□ Add missing component/type labels
□ Archive completed milestone labels
```

## 👥 Assignment Strategy

### Component Ownership
| Component | Primary Owner | Backup |
|-----------|---------------|--------|
| madcore | @lead-developer | @senior-dev |
| maditemmaker | @rpg-specialist | @lead-developer |
| madquestmaker | @rpg-specialist | @ui-developer |  
| theme-editor | @ui-developer | @lead-developer |
| story-engine | @ai-specialist | @lead-developer |
| terminal-kingpin | @game-developer | @rpg-specialist |
| madhub-web | @web-developer | @api-developer |
| mad-toolbox | @tools-developer | @lead-developer |

### Assignment Rules
1. **Auto-assign** critical issues to component owner
2. **Team discussion** for high-priority cross-component issues
3. **Community assignment** for `good-first-issue` and `help-wanted`
4. **Load balancing** when owners are overloaded

## 📊 Triage Metrics

### Key Performance Indicators

#### Response Time Metrics
```yaml
targets:
  first_response: "< 24 hours"
  triage_completion: "< 48 hours"  
  critical_response: "< 4 hours"
  
measurement:
  - Track time from issue creation to first maintainer response
  - Track time from creation to triage completion
  - Monitor critical issue response times
```

#### Quality Metrics  
```yaml
targets:
  duplicate_rate: "< 5%"
  needs_more_info_rate: "< 15%"
  triage_accuracy: "> 95%"
  
measurement:
  - Monitor duplicate issue creation rates
  - Track how often we need to request more information  
  - Measure how often initial triage labels change
```

#### Resolution Metrics
```yaml
targets:
  critical_resolution: "< 1 week"
  high_resolution: "< 2 weeks"
  medium_resolution: "< 1 month"
  
measurement:
  - Track time from triage to resolution
  - Monitor resolution rates by priority
  - Identify blockers and bottlenecks
```

### Weekly Triage Reports
```markdown
# Sample Weekly Triage Report
## Issues Triaged: 23
- New bugs: 8 (4 critical, 2 high, 2 medium)
- Feature requests: 12 (1 high, 8 medium, 3 low)
- Documentation: 3 (all medium)

## Response Times
- Average first response: 18 hours ✅
- Average triage completion: 36 hours ✅
- Critical issues: 2 hours average ✅

## Quality Metrics
- Duplicates: 1 (4.3%) ✅
- Needs more info: 3 (13%) ✅
- Triage accuracy: 22/23 (95.7%) ✅
```

## 🔄 Escalation Process

### When to Escalate
1. **Technical complexity** exceeds triage team knowledge
2. **Resource conflicts** require management decision
3. **Community issues** need diplomatic handling
4. **Security issues** need specialized review
5. **Legal/licensing** questions arise

### Escalation Paths
```yaml
technical_issues:
  to: "@lead-developer"
  when: "Complex technical decisions needed"
  
resource_conflicts:  
  to: "@project-manager"
  when: "Priority disputes or resource allocation"
  
community_issues:
  to: "@community-manager"  
  when: "User conflicts or communication issues"
  
security_issues:
  to: "@security-team"
  when: "Potential vulnerabilities or exploits"
```

## 🤖 Automation Integration

### Automated Triage Actions
```yaml
auto_labeling:
  - Component detection based on keywords
  - Priority detection for critical keywords
  - Platform detection from templates
  
auto_responses:
  - Welcome message for first-time contributors
  - More info requests for incomplete issues
  - Duplicate detection and closure
  
auto_escalation:
  - Critical issue notifications
  - Overdue triage alerts  
  - Stale issue management
```

### Manual Review Points
- All `priority/critical` labels
- Complex `duplicate` determinations
- Controversial feature requests
- Cross-component architectural issues

## 📚 Triage Team Training

### New Triager Onboarding
1. **Shadow experienced triager** for 1 week
2. **Review triage guidelines** and label system
3. **Practice on closed issues** to build skills
4. **Start with low-priority issues** for training
5. **Graduate to full triage** after certification

### Ongoing Training Topics
- **Product roadmap updates** for feature evaluation
- **Technical architecture changes** for bug assessment
- **Community management** for user interaction
- **Security awareness** for vulnerability identification

### Certification Process
```markdown
# Triager Certification Checklist
□ Successfully triaged 20+ issues with 95% accuracy
□ Demonstrated knowledge of all major components
□ Completed security and community training
□ Received positive feedback from senior triagers
□ Passed written assessment on guidelines and procedures
```

## 📞 Communication Guidelines

### Internal Communication
- **Slack #triage** channel for daily coordination
- **Weekly triage meetings** for process improvements
- **Monthly metrics review** with project leadership
- **Quarterly training updates** for skill development

### External Communication
- **Professional and helpful** tone in all interactions
- **Clear explanations** for issue status changes
- **Prompt responses** to user questions
- **Escalate** difficult situations to community team

### Standard Response Templates
```markdown
# Need More Information
Thank you for reporting this issue! To help us investigate, we need additional information:

[specific information needed]

Please update your issue description with these details, and we'll continue investigating.

# Duplicate Issue  
This issue appears to be a duplicate of #[number]. We're tracking this problem there.

If you believe this is not a duplicate, please explain how your issue differs and we'll reconsider.

# Cannot Reproduce
We've attempted to reproduce this issue but haven't been successful. This could be due to:

- Environment differences
- Missing reproduction steps  
- Issue already fixed in newer version

Please verify you're using the latest version and provide additional details if the issue persists.
```

---

**This process ensures consistent, high-quality issue triage that serves both the development team and the community effectively.** 🚀

*Last updated: [Date] - Process improvements welcome via issues or discussions!*