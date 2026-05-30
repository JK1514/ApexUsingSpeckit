// Backfill Attention_Flag__c for existing Lead records
// Rule: LeadSource = 'Web', 'Advertisement', or 'Partner' -> 'High Priority'
Set<String> highPrioritySources = new Set<String>{'Web', 'Advertisement', 'Partner'};
List<Lead> leads = [SELECT Id, LeadSource, Attention_Flag__c FROM Lead WHERE LeadSource IN :highPrioritySources AND Attention_Flag__c = null];
System.debug('Leads to update: ' + leads.size());
for (Lead l : leads) {
    l.Attention_Flag__c = 'High Priority';
}
Database.update(leads, AccessLevel.USER_MODE);
System.debug('Updated ' + leads.size() + ' leads with Attention Flag = High Priority');
