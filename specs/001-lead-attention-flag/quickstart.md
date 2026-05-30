# Quick Start Guide: Lead Attention Flag

**Date**: 2026-05-28
**Feature**: Lead Attention Flag (specs/001-lead-attention-flag/spec.md)

## Overview
This guide provides steps to implement the Lead Attention Flag feature in a Salesforce DX project.

## Prerequisites
- Salesforce DX CLI
- VS Code with Salesforce Extensions
- Dev Hub or scratch org access

## Implementation Phases

### Phase 1: Data Model
1. Create Custom Metadata Types: LeadSourceRule__mdt, UrgencyFlag__mdt
2. Add initial data records for Web, Advertisement, Partner Lead Sources

### Phase 2: Apex Logic
1. Create LeadUrgencyFlagFactory class (factory pattern)
2. Create LeadUrgencyFlag base class
3. Create concrete classes for each Lead Source
4. Create Lead trigger (before insert/update)

### Phase 3: User Interface
1. Create LWC component: leadUrgencyFlag
2. Add to Lightning record pages and list views

### Phase 4: Testing
1. Write Apex unit tests with @IsTest
2. Test bulk scenarios (200 records)
3. Validate code coverage >=75%

## Key Commands
- sfdx force:source:push
- sfdx force:apex:test:run
- sfdx force:org:open

## Validation
- Check for governor limit compliance
- Verify with sharing keyword usage
- Confirm extensibility for new Lead Sources

