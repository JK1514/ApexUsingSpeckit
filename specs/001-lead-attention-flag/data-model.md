# Data Model: Lead Attention Flag

**Date**: 2026-05-28
**Feature**: Lead Attention Flag (specs/001-lead-attention-flag/spec.md)

## Entity Relationship Diagram (ERD)

`mermaid
erDiagram
    LEAD ||..| LEAD-SOURCE-RULE : evaluates
    LEAD-SOURCE-RULE ||..| URGENCY-FLAG : defines
    LEAD {
        string Id PK
        string Source
        string CreatedDate
        string LastModifiedDate
    }
    LEAD-SOURCE-RULE {
        string LeadSource PK
        string UrgencyLevel
        boolean IsActive
    }
    URGENCY-FLAG {
        string Level PK
        string DisplayText
        integer PriorityOrder
    }
`

## Entity Definitions

### Lead (Standard Salesforce Object)
- **Description**: Standard Salesforce Lead object containing the Lead Source field to be evaluated
- **Key Attributes**:
  - Id: Unique identifier (string)
  - Source: Lead Source value (string) - **evaluated field**
  - CreatedDate: Record creation timestamp
  - LastModifiedDate: Record last update timestamp
- **Relationships**: 
  - Evaluates against LeadSourceRule to determine urgency level
  - One-to-many with LeadSourceRule (many Leads can map to one rule)

### LeadSourceRule (Logical Entity)
- **Description**: Defines mapping between Lead Source values and urgency levels
- **Key Attributes**:
  - LeadSource: The Lead Source value (string, primary key) - e.g., "Web", "Advertisement", "Partner"
  - UrgencyLevel: The urgency level assigned (string, foreign key to UrgencyFlag.Level)
  - IsActive: Whether this rule is currently active (boolean)
- **Business Rules**:
  - Each Lead Source value maps to exactly one urgency level
  - Only active rules are evaluated
  - Rules can be deactivated without deletion for historical tracking

### UrgencyFlag (Logical Entity)
- **Description**: Defines the urgency levels and their display properties
- **Key Attributes**:
  - Level: Urgency level identifier (string, primary key) - e.g., "High", "Medium", "Low"
  - DisplayText: Text to display in UI (string) - e.g., "High Priority"
  - PriorityOrder: Numerical priority for sorting (integer)
- **Initial Values for v1**:
  - Level: "High", DisplayText: "High Priority", PriorityOrder: 1

## Data Flow

1. **Lead Creation/Update**:
   - When a Lead record is inserted or updated
   - Trigger fires to evaluate Lead.Source value
   
2. **Rule Evaluation**:
   - System looks up active LeadSourceRule where LeadSource = Lead.Source
   - If found, retrieves associated UrgencyLevel
   - If not found, returns null/default (no urgency flag)

3. **Urgency Flag Display**:
   - Retrieved UrgencyLevel maps to UrgencyFlag entity
   - DisplayText is shown on Lead record and list views
   - PriorityOrder determines sort order in list views

## Validation Rules

### LeadSourceRule Validation
- **LeadSource**: Required, must match standard Salesforce Lead Source picklist values
- **UrgencyLevel**: Required, must reference existing UrgencyFlag.Level
- **IsActive**: Defaults to true when created

### Business Logic Validation
- No duplicate active LeadSourceRule entries for same LeadSource value
- UrgencyLevel values must be predefined in system
- At least one active rule must exist for system to be functional

## Extensibility Points

### Adding New Lead Source Values
1. Create new LeadSourceRule record:
   - LeadSource: "NewSourceValue"
   - UrgencyLevel: "AppropriateLevel" (e.g., "Medium")
   - IsActive: true
2. If new UrgencyLevel needed:
   - Create new UrgencyFlag record with Level, DisplayText, PriorityOrder
3. No Apex code changes required - purely data-driven

### Modifying Existing Rules
1. Update existing LeadSourceRule:
   - Change UrgencyLevel to remap Lead Source
   - Toggle IsActive to enable/disable rule
2. Update UrgencyFlag DisplayText or PriorityOrder as needed
3. Changes take effect immediately for new evaluations

## Implementation Notes

### Storage Approach
- LeadSourceRule and UrgencyFlag will be implemented as Custom Metadata Types
- This allows:
  - Deployment between environments via change sets
  - Editing without code changes
  - Packageable components
  - SOQL queries without governor limit concerns for metadata

### Alternative Approach Considered
- Hard-coded maps in Apex classes: Rejected because violates extensibility requirement
- Custom objects: Rejected because Custom Metadata Types are better suited for configuration data
- Formula fields: Rejected because cannot implement object-oriented design

### Query Patterns
- All queries will be bulkified and selective
- Use of WHERE clauses on indexed fields (LeadSource is standard indexed field)
- No queries inside loops - maps will be used for efficient lookups
