public class LeadSourceHighPriorityRule extends LeadSourceRule {
    private static final String URGENCY = 'High Priority';
    
    public override String getUrgency(Lead lead) {
        // Trim and case-insensitive comparison
        String source = String.isBlank(lead.LeadSource) ? '' : lead.LeadSource.trim();
        if (source == 'Web' || source == 'Advertisement' || source == 'Partner') {
            return URGENCY;
        }
        return null;
    }
}