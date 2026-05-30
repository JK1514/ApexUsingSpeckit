public with sharing class LeadAttentionFlag {
    private final LeadSourceRule rule;
    
    /**
     * Constructor for dependency injection
     * @param rule The LeadSourceRule implementation to use
     */
    public LeadAttentionFlag(LeadSourceRule rule) {
        this.rule = rule;
    }
    
    /**
     * Returns the urgency flag for a single Lead record
     * @param lead The Lead record to evaluate
     * @return String urgency flag, or null if none
     */
    public String getUrgency(Lead lead) {
        if (lead == null) {
            return null;
        }
        return rule.getUrgency(lead);
    }
    
    /**
     * Returns urgency flags for a list of Lead records (bulkified)
     * @param leads List of Lead records to evaluate
     * @return Map<Lead Id, String urgency flag>
     */
    public Map<Id, String> getUrgencies(List<Lead> leads) {
        Map<Id, String> result = new Map<Id, String>();
        if (leads == null || leads.isEmpty()) {
            return result;
        }
        
        for (Lead lead : leads) {
            result.put(lead.Id, getUrgency(lead));
        }
        return result;
    }
}