@echo off
REM Lead Attention Flag - Post-Deployment Verification Script (Windows)
REM Run this script after deploying to a Salesforce org
REM Usage: scripts\post-deployment-verification.bat [org-alias]

setlocal enabledelayedexpansion

echo ==========================================
echo Lead Attention Flag - Post-Deployment Verification
echo ==========================================

REM Check if sf is available
where sf >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ERROR: Salesforce CLI (sf) not found. Please install it first.
    exit /b 1
)

REM Set org alias (default: devorg-agentforce)
if "%~1"=="" (
    set "ORG_ALIAS=devorg-agentforce"
) else (
    set "ORG_ALIAS=%~1"
)
echo Using org alias: %ORG_ALIAS%

REM 1. Verify Apex Classes
echo.
echo 1. Verifying Apex Classes...
echo ---------------------------
sf force:apex:class:list --target-org %ORG_ALIAS% --status Active --output table

REM 2. Verify LWC Component
echo.
echo 2. Verifying Lightning Web Component...
echo ----------------------------------------
sf force:lightning:component:list --target-org %ORG_ALIAS% --status Active --output table

REM 3. Run Apex Tests
echo.
echo 3. Running Apex Tests...
echo -------------------------
sf force:apex:test:run --target-org %ORG_ALIAS% --class-names LeadAttentionFlagTest,LeadSourceHighPriorityRuleTest --result-format human

REM 4. Create Test Leads
echo.
echo 4. Creating Test Leads...
echo -------------------------
sf data:create record --target-org %ORG_ALIAS% --sobject Lead --values "FirstName='CLI' LastName='WebLead' Company='Test Company' LeadSource='Web'"
sf data:create record --target-org %ORG_ALIAS% --sobject Lead --values "FirstName='CLI' LastName='AdLead' Company='Test Company' LeadSource='Advertisement'"
sf data:create record --target-org %ORG_ALIAS% --sobject Lead --values "FirstName='CLI' LastName='PartnerLead' Company='Test Company' LeadSource='Partner'"
sf data:create record --target-org %ORG_ALIAS% --sobject Lead --values "FirstName='CLI' LastName='OtherLead' Company='Test Company' LeadSource='Phone'"

REM 5. Query Test Leads
echo.
echo 5. Querying Test Leads...
echo -------------------------
sf data:soql:query --target-org %ORG_ALIAS% --query "SELECT Id, Name, LeadSource FROM Lead WHERE FirstName='CLI' ORDER BY CreatedDate DESC"

REM 6. Verify Field-Level Security
echo.
echo 6. Verifying LeadSource Field...
echo --------------------------------
sf force:schema:field:get --target-org %ORG_ALIAS% --sobject Lead --field-name LeadSource

echo.
echo ==========================================
echo Verification Complete!
echo ==========================================
echo.
echo Next Steps:
echo 1. Open Lightning App Builder in Setup
echo 2. Add 'leadAttentionFlag' component to Lead Record Page
echo 3. Save and activate the page
echo 4. View the test leads to verify the urgency flag displays correctly

endlocal