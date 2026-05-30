public abstract with sharing class LeadSourceRule {
    /**
     * Returns the urgency flag value for the given Lead.
     * @param lead The Lead record to evaluate.
     * @return String urgency flag, or null if none.
     */
    public abstract String getUrgency(Lead lead);
}