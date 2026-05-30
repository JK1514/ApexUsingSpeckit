# Implementation Plan: Lead Attention Flag

**Branch**: `001-lead-attention-flag` | **Date**: 2026-05-28 | **Spec**: specs/001-lead-attention-flag/spec.md

**Input**: Feature specification from `/specs/001-lead-attention-flag/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

[Extract from feature spec: primary requirement + technical approach from research]

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Apex (Salesforce Platform API Version 59.0)

**Primary Dependencies**: Salesforce Apex Language, Standard Lead Object

**Storage**: Standard Salesforce Lead Object (no additional storage required)

**Testing**: Apex Unit Tests with @IsTest annotation

**Target Platform**: [e.g., Linux server, iOS 15+, WASM or NEEDS CLARIFICATION]

**Project Type**: Salesforce Apex Classes (Object-Oriented Design)

**Performance Goals**: Bulkified Apex design to handle up to 200 records per transaction within governor limits

**Constraints**: Must comply with Salesforce Governor Limits (100 SOQL queries, 150 DML statements per transaction); Must use with sharing for security; Must handle bulk operations

**Scale/Scope**: Designed for standard Salesforce orgs with typical Lead volumes; Extensible architecture for future Lead Source values

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*


*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

## Constitution Compliance Check

Based on the project constitution, the following principles apply to this feature:

### Library-First Principle
- **Status**: APPLICABLE
- **Justification**: The Lead Attention Flag will be implemented as a standalone Apex library that can be independently tested and documented.
- **Verification**: All Apex classes will be self-contained with clear purpose and documentation.

### CLI Interface Principle
- **Status**: NOT APPLICABLE
- **Justification**: This is a Salesforce Apex feature that operates within the platform, not a standalone CLI tool.

### Test-First Principle (NON-NEGOTIABLE)
- **Status**: MUST COMPLY
- **Requirement**: TDD mandatory: Tests written ? User approved ? Tests fail ? Then implement
- **Verification**: Apex unit tests will be written for all functionality before implementation.

### Integration Testing Principle
- **Status**: APPLICABLE
- **Requirement**: Focus areas requiring integration tests: New library contract tests, Contract changes
- **Verification**: Integration tests will verify the urgency flag displays correctly on Lead record pages and list views.

### Observability Principle
- **Status**: APPLICABLE
- **Requirement**: Text I/O ensures debuggability; Structured logging required
- **Verification**: Apex debug logs will be used for troubleshooting; follows structured logging patterns where applicable.

### Simplicity Principle (YAGNI)
- **Status**: MUST COMPLY
- **Requirement**: Start simple, YAGNI principles
- **Verification**: Implementation will only include the three specified Lead Source values (Web, Advertisement, Partner) for version 1.

## Gates Evaluation

All gates must pass before proceeding to Phase 0 research:
- [x] Library-First: Design follows standalone library principles
- [ ] Test-First: Tests will be written before implementation (to be completed in Phase 2)
- [ ] Integration Testing: Integration test strategy defined (to be completed in Phase 1)
- [x] Observability: Design considers debuggability
- [x] Simplicity: Scope limited to essential features for v1

**Note**: Test-First and Integration Testing gates will be validated during implementation phases.


## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
# [REMOVE IF UNUSED] Option 1: Single project (DEFAULT)
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# [REMOVE IF UNUSED] Option 2: Web application (when "frontend" + "backend" detected)
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# [REMOVE IF UNUSED] Option 3: Mobile + API (when "iOS/Android" detected)
api/
└── [same as backend above]

ios/ or android/
└── [platform-specific structure: feature modules, UI flows, platform tests]
```

**Structure Decision**: [Document the selected structure and reference the real
directories captured above]

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
