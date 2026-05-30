List<Lead> leads = [SELECT Id, Name, Email, LeadSource, Attention_Flag__c FROM Lead WHERE LeadSource != null LIMIT 200];
for (Lead l : leads) {
    System.debug(l.Name + ' | Email: ' + l.Email + ' | LeadSource: ' + l.LeadSource + ' | AttentionFlag: ' + l.Attention_Flag__c);
}
