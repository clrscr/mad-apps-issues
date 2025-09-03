# 📋 Issue Reporting Guidelines

This guide helps you create high-quality issues that can be resolved quickly and effectively.

## 🎯 Before You Start

### 1. Search First 🔍
Before creating a new issue:
- Search [existing issues](https://github.com/mad/mad-apps-issues/issues)
- Check [closed issues](https://github.com/mad/mad-apps-issues/issues?q=is%3Aissue+is%3Aclosed) 
- Browse [discussions](https://github.com/mad/mad-apps-issues/discussions)

### 2. Choose the Right Template 📝
Select the appropriate issue template:
- **🐛 Bug Report** - For broken functionality
- **✨ Feature Request** - For new features or improvements
- **🌐 Web Platform Issue** - For MadHub web-specific problems
- **🖥️ Desktop App Issue** - For desktop application problems
- **📚 Documentation Issue** - For documentation problems

## 📋 Writing Effective Issues

### Issue Title Best Practices ✏️

#### Good Titles ✅
```
[BUG] maditemmaker crashes when importing large JSON files
[FEATURE] Add keyboard shortcuts to theme-editor
[WEB] API timeout when uploading files larger than 10MB
[DESKTOP] madquestmaker won't start on macOS Sonoma
```

#### Poor Titles ❌
```
It doesn't work
Problem with app
Feature request
Bug
```

**Title Guidelines:**
- Start with appropriate prefix: `[BUG]`, `[FEATURE]`, `[WEB]`, `[DESKTOP]`, `[DOCS]`
- Be specific and descriptive
- Include the affected component when relevant
- Keep it under 80 characters
- Don't use ALL CAPS except for prefixes

### Bug Report Best Practices 🐛

#### Essential Information
1. **Clear Description**: What exactly is broken?
2. **Steps to Reproduce**: Exact steps that trigger the issue
3. **Expected Behavior**: What should happen?
4. **Actual Behavior**: What actually happens?
5. **Environment**: OS, Python version, app version
6. **Screenshots/Videos**: Visual evidence when applicable

#### Example Bug Report Structure
```markdown
## Bug Description
The maditemmaker application crashes with a "Segmentation fault" error when attempting to import JSON files larger than 50MB.

## Steps to Reproduce
1. Open maditemmaker v2.0.0
2. Go to File → Import → JSON File
3. Select a JSON file larger than 50MB (e.g., 'large_items_database.json')
4. Click "Import"
5. Application crashes immediately

## Expected Behavior
The JSON file should import successfully, or show a progress dialog for large files.

## Actual Behavior
Application crashes with segmentation fault, no error message shown to user.

## Environment
- OS: macOS 14.0 (23A344)
- Python: 3.12.0
- maditemmaker: v2.0.0
- madcore: v1.0.0
- Installation: Built from source

## Additional Context
- Smaller files (< 10MB) import fine
- Crash happens immediately, no partial import
- Console shows: "Segmentation fault: 11"
```

### Feature Request Best Practices ✨

#### Essential Information
1. **Problem Statement**: What problem does this solve?
2. **Proposed Solution**: How should it work?
3. **User Stories**: Who benefits and how?
4. **Acceptance Criteria**: How to know it's complete?
5. **Impact Assessment**: Priority and complexity estimates

#### Example Feature Request Structure
```markdown
## Problem Statement
Users frequently need to batch-edit multiple RPG items at once, but currently have to open and edit each item individually in maditemmaker.

## Proposed Solution
Add a "Batch Edit" mode that allows users to:
- Select multiple items from the project tree
- Edit common fields for all selected items
- Preview changes before applying
- Undo batch operations

## User Stories
**As a** game developer
**I want** to batch-edit multiple weapon items
**So that** I can quickly balance all weapons at once

**As a** content creator  
**I want** to batch-update item categories
**So that** I can reorganize my item database efficiently

## Acceptance Criteria
- [ ] Multi-select items in project tree (Ctrl+Click, Shift+Click)
- [ ] Batch edit dialog showing only common fields
- [ ] Preview mode showing which items will change
- [ ] Apply/Cancel buttons with confirmation
- [ ] Undo support for batch operations
- [ ] Progress bar for large batch operations

## Impact Assessment
- **Complexity**: Medium
- **Priority**: High
- **User Benefit**: High
- **Development Effort**: Medium
```

## 🏷️ Labels and Organization

### Automatic Labels
The system automatically applies labels based on your issue content:

- **Component Labels**: `component/madcore`, `component/maditemmaker`, etc.
- **Type Labels**: `type/bug`, `type/feature`, `type/documentation`
- **Priority Labels**: `priority/critical`, `priority/high`, `priority/medium`, `priority/low`
- **Platform Labels**: `platform/desktop`, `platform/web`, `platform/all`

### Manual Labels (Applied by Maintainers)
- `status/triage` - Needs review
- `status/confirmed` - Confirmed issue
- `status/in-progress` - Being worked on
- `status/blocked` - Waiting on something
- `needs-more-info` - Missing information
- `duplicate` - Duplicate of another issue
- `good-first-issue` - Good for new contributors
- `help-wanted` - Community help requested

## 📸 Including Media

### Screenshots
- Use screenshots for UI issues, errors, layout problems
- Circle or highlight the problematic area
- Include full window context when relevant
- Use PNG format for best quality

### Videos/GIFs
- Use for complex reproduction steps
- Keep under 10MB for GitHub uploads
- Show the complete user interaction
- Include audio narration if helpful

### Code Samples
```python
# Use code blocks for:
# - Error messages
# - Configuration files
# - Log outputs
# - Reproduction code

# Always format properly and include context
try:
    result = maditemmaker.import_json(large_file)
except Exception as e:
    print(f"Error: {e}")  # This is where it crashes
```

## ⚡ Priority Guidelines

### Critical Priority 🔴
Issues that should be labeled `priority/critical`:
- Application crashes or data loss
- Security vulnerabilities
- Blocking production workflows
- Major functionality completely broken

### High Priority 🟠  
Issues that should be labeled `priority/high`:
- Important features not working
- Significant user experience problems
- Performance issues affecting usability
- Integration failures

### Medium Priority 🟡
Standard issues:
- Minor bugs with workarounds
- Feature improvements
- Documentation gaps
- Cosmetic issues

### Low Priority 🟢
Nice-to-have improvements:
- Feature suggestions
- Minor UI tweaks
- Edge case bugs
- Documentation enhancements

## 🔄 Issue Lifecycle

### What Happens After You Submit
1. **Auto-labeling** (< 1 minute): System applies initial labels
2. **Triage** (24-48 hours): Maintainer reviews and confirms
3. **Planning** (varies): Issue added to project board/milestone
4. **Implementation** (varies): Developer works on solution
5. **Review** (varies): Solution tested and reviewed
6. **Resolution** (varies): Issue closed with solution

### Your Role During the Process
- **Respond promptly** to requests for more information
- **Test proposed solutions** when asked
- **Provide additional context** if the issue evolves
- **Be patient** - quality solutions take time

## ❌ Common Mistakes to Avoid

### Don't:
- Create duplicate issues without searching first
- Use vague titles like "It doesn't work"
- Skip required template sections
- Include sensitive information (passwords, keys)
- Expect immediate responses
- Bump issues frequently
- Create issues for general questions (use Discussions)

### Do:
- Search before creating new issues
- Use specific, descriptive titles
- Fill out all relevant template sections
- Include reproduction steps and environment details
- Be patient and respectful
- Test with latest versions first
- Use appropriate communication channels

## 🆘 Getting Help

If you need help with creating an issue:
- 💬 Ask in [Discussions](https://github.com/mad/mad-apps-issues/discussions)
- 🔍 Check the [Q&A section](https://github.com/mad/mad-apps-issues/discussions/categories/q-a)
- 📖 Read our [documentation](https://github.com/mad/mad-apps-issues/wiki)
- 📧 Email support@mad-apps.com for sensitive issues

## 📊 Quality Metrics

We track issue quality metrics to improve the process:
- **Time to first response**: Target < 48 hours
- **Resolution time**: Varies by complexity and priority
- **Duplicate rate**: Target < 5%
- **Information completeness**: Measured by requests for more info

Your well-written issues help us maintain these quality standards and resolve problems faster!

---

**Thank you for helping improve Mad Apps Suite!** 🚀

*These guidelines are living documents - suggest improvements via issues or discussions.*