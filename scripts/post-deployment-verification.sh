#!/bin/bash
# Lead Attention Flag - Post-Deployment Verification Script
# Run this script after deploying to a Salesforce org
# Usage: ./scripts/post-deployment-verification.sh

set -e

echo "=========================================="
echo "Lead Attention Flag - Post-Deployment Verification"
echo "=========================================="

# Check if sf is available
if ! command -v sf &> /dev/null; then
    echo "ERROR: Salesforce CLI (sf) not found. Please install it first."
    exit 1
fi

# Check for authenticated org
ORG_ALIAS="${1:-my-org}"
echo "Using org alias: $ORG_ALIAS"

# 1. Verify Apex Classes
echo ""
echo "1. Verifying Apex Classes..."
echo "---------------------------"
sf force:apex:class:list --target-org "$ORG_ALIAS" --status Active --output table | grep -E "LeadSourceRule|LeadSourceHighPriorityRule|LeadAttentionFlag|LeadAttentionFlagService" || echo "WARNING: Some classes not found"

# 2. Verify LWC Component
echo ""
echo "2. Verifying Lightning Web Component..."
echo "----------------------------------------"
sf force:lightning:component:list --target-org "$ORG_ALIAS" --status Active --output table | grep -i "leadattentionflag" || echo "WARNING: LWC component not found"

# 3. Run Apex Tests
echo ""
echo "3. Running Apex Tests..."
echo "------------------------"
sf force:apex:test:run --target-org "$ORG_ALIAS" --class-names LeadAttentionFlagTest,LeadSourceHighPriorityRuleTest --result-format human

# 4. Create Test Leads
echo ""
echo "4. Creating Test Leads..."
echo "-------------------------"
sf data:create record --target-org "$ORG_ALIAS" --sobject Lead --values "FirstName='CLI' LastName='WebLead' Company='Test Company' LeadSource='Web'"
sf data:create record --target-org "$ORG_ALIAS" --sobject Lead --values "FirstName='CLI' LastName='AdLead' Company='Test Company' LeadSource='Advertisement'"
sf data:create record --target-org "$ORG_ALIAS" --sobject Lead --values "FirstName='CLI' LastName='PartnerLead' Company='Test Company' LeadSource='Partner'"
sf data:create record --target-org "$ORG_ALIAS" --sobject Lead --values "FirstName='CLI' LastName='OtherLead' Company='Test Company' LeadSource='Phone'"

# 5. Query Test Leads
echo ""
echo "5. Querying Test Leads..."
echo "-------------------------"
sf data:soql:query --target-org "$ORG_ALIAS" --query "SELECT Id, Name, LeadSource FROM Lead WHERE FirstName='CLI' ORDER BY CreatedDate DESC"

# 6. Verify Field-Level Security
echo ""
echo "6. Verifying LeadSource Field..."
echo "--------------------------------"
sf force:schema:field:get --target-org "$ORG_ALIAS" --sobject Lead --field-name LeadSource

echo ""
echo "=========================================="
echo "Verification Complete!"
echo "=========================================="
echo ""
echo "Next Steps:"
echo "1. Open Lightning App Builder in Setup"
echo "2. Add 'leadAttentionFlag' component to Lead Record Page"
echo "3. Save and activate the page"
echo "4. View the test leads to verify the urgency flag displays correctly"