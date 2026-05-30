# Technical Research: Lead Attention Flag

**Date**: 2026-05-28
**Feature**: Lead Attention Flag (specs/001-lead-attention-flag/spec.md)

## Decisions Made

### Language/Version: Apex (Salesforce Platform API Version 59.0)
- **Decision**: Use Salesforce Apex language with API Version 59.0 (current as of 2026)
- **Rationale**: 
  - Native Salesforce platform language ensures seamless integration with Lead objects
  - API Version 59.0 provides latest features and security updates
  - Apex is required for implementing custom business logic on Lead records
- **Alternatives Considered**:
  - Formula Fields: Rejected because they cannot implement complex object-oriented design required
  - Process Builder/Flow: Rejected because they don't support the extensible class structure requirement
  - Lightning Web Components (LWC) alone: Rejected because LWC cannot access Lead Source values without Apex intermediary for complex logic

### Primary Dependencies: Salesforce Apex Language, Standard Lead Object
- **Decision**: Leverage standard Salesforce Lead object and Apex language
- **Rationale**:
  - No external dependencies needed - uses core Salesforce platform capabilities
  - Lead object already contains the Lead Source field to be evaluated
  - Apex provides necessary triggers and class structure for implementation

### Storage: Standard Salesforce Lead Object (no additional storage required)
- **Decision**: Use existing Lead object fields; no custom fields required for v1
- **Rationale**:
  - Urgency flag is computed dynamically from Lead Source, not stored
  - Avoids wasting storage on derivable data
  - Eliminates need for data migration or field creation
  - Follows Salesforce best practices of minimizing custom fields

### Testing: Apex Unit Tests with @IsTest annotation
- **Decision**: Implement comprehensive Apex unit tests following Test-First principle
- **Rationale**:
  - Required by constitution's Test-First principle (NON-NEGOTIABLE)
  - Apex unit tests are the standard testing framework for Salesforce
  - Enables validation of bulkification and governor limit compliance
  - Supports continuous integration in Salesforce DX workflows

### Target Platform: Salesforce Lightning Experience only
- **Decision**: Support only Salesforce Lightning UI
- **Rationale**:
  - The users only use Salesforce Lightning Developer Edition

### Project Type: Salesforce Apex Classes (Object-Oriented Design)
- **Decision**: Implement using object-oriented Apex with factory pattern
- **Rationale**:
  - Explicitly required by feature specification: "implemented in Apex using object-oriented concepts such as classes and subclasses"
  - Factory pattern enables easy extensibility for new Lead Source values
  - Follows Salesforce Apex best practices for maintainable code
  - Separates concerns: factory for object creation, individual classes for each Lead Source rule

### Performance Goals: Bulkified Apex design to handle up to 200 records per transaction within governor limits
- **Decision**: Design for bulk processing from the start
- **Rationale**:
  - Salesforce Governor Limits restrict transactions to 200 records for many operations
  - Bulkification is essential for any data-triggered Apex in Salesforce
  - Ensures functionality works with data imports, bulk edits, and integration processes
  - Prevents runtime errors in production environments

### Constraints: Must comply with Salesforce Governor Limits; Must use with sharing for security; Must handle bulk operations
- **Decision**: Strict adherence to Salesforce development best practices
- **Rationale**:
  - Governor Limits are hard constraints that cannot be exceeded
  - "with sharing" ensures respect for organization-wide defaults and sharing rules
  - Bulk handling is mandatory for any trigger-based solution
  - These constraints drive the factory pattern and bulk-safe query design

### Scale/Scope: Designed for standard Salesforce orgs with typical Lead volumes; Extensible architecture for future Lead Source values
- **Decision**: Build foundation that scales with business growth
- **Rationale":
  - Architecture designed to handle enterprise-scale Lead volumes
  - Extensible factory pattern allows adding new Lead Sources without modifying core logic
  - Initial scope limited to three Lead Sources as specified, but ready for expansion
  - Follows YAGNI principle by not over-engineering for hypothetical future requirements

## Dependencies and Integrations

### Internal Dependencies
- Standard Salesforce Lead object (contains Lead Source field)
- Apex runtime environment (provided by Salesforce platform)
- Salesforce security sharing model

### External Dependencies
- None - entirely self-contained within Salesforce platform

### Integration Points
- Lead triggers (before insert, before update)
- Lead record pages (via LWC component or formula field)
- Lead list views (via LWC component or formula field)
- Future: Potential integration with Salesforce Flow or Process Builder for declarative use

## Open Questions
None - all technical decisions have been resolved based on feature requirements and Salesforce best practices.
