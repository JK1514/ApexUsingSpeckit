# Contracts

This directory is reserved for interface contracts when the project exposes functionality to external systems or users.

## Why Not Applicable for This Feature

The Lead Attention Flag feature is an internal Salesforce implementation that:
1. Operates entirely within the Salesforce platform
2. Does not expose public APIs or external interfaces
3. Integrates with standard Salesforce UI components (record pages, list views)
4. Uses internal Salesforce mechanisms (Apex, LWC, Custom Metadata)

Therefore, no external contracts need to be defined for this feature.

## Internal Contracts
While not stored in this directory, the following internal agreements exist:
- Apex class interfaces (factory pattern)
- Trigger context variables
- LWC component properties
- Custom Metadata Type field definitions

