public with sharing class LeadAttentionFlagService {
    private static final LeadSourceRule RULE = new LeadSourceHighPriorityRule();
    private static final LeadAttentionFlag FLAG_EVALUATOR = new LeadAttentionFlag(RULE);

    /**
     * Evaluates and sets the Attention_Flag__c field on a list of Leads.
     * Designed for trigger consumption - bulkified.
     *
     * @param leads List of Lead records to evaluate.
     */
    public static void evaluate(List<Lead> leads) {
        if (leads == null || leads.isEmpty()) {
            return;
        }
        for (Lead lead : leads) {
            lead.Attention_Flag__c = FLAG_EVALUATOR.getUrgency(lead);
        }
    }

    /**
     * Returns the urgency flag for a given Lead ID.
     * This method is designed for Lightning Web Component consumption.
     *
     * @param leadId The Salesforce Id of the Lead record.
     * @return String The urgency flag ('High Priority') or null if none.
     */
    @AuraEnabled(cacheable=true)
    public static String getUrgency(Id leadId) {
        if (leadId == null) {
            return null;
        }
        Lead lead = [SELECT Id, LeadSource FROM Lead WHERE Id = :leadId LIMIT 1];
        return FLAG_EVALUATOR.getUrgency(lead);
    }
}