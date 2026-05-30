@IsTest
private class LeadAttentionFlagTest {
    
    @IsTest
    static void testGetUrgency_WithWebLead_ReturnsHighPriority() {
        // Arrange
        LeadSourceRule rule = new LeadSourceHighPriorityRule();
        LeadAttentionFlag flag = new LeadAttentionFlag(rule);
        Lead lead = new Lead(LeadSource = 'Web');
        
        // Act
        String result = flag.getUrgency(lead);
        
        // Assert
        System.assertEquals('High Priority', result);
    }
    
    @IsTest
    static void testGetUrgency_WithAdvertisementLead_ReturnsHighPriority() {
        // Arrange
        LeadSourceRule rule = new LeadSourceHighPriorityRule();
        LeadAttentionFlag flag = new LeadAttentionFlag(rule);
        Lead lead = new Lead(LeadSource = 'Advertisement');
        
        // Act
        String result = flag.getUrgency(lead);
        
        // Assert
        System.assertEquals('High Priority', result);
    }
    
    @IsTest
    static void testGetUrgency_WithPartnerLead_ReturnsHighPriority() {
        // Arrange
        LeadSourceRule rule = new LeadSourceHighPriorityRule();
        LeadAttentionFlag flag = new LeadAttentionFlag(rule);
        Lead lead = new Lead(LeadSource = 'Partner');
        
        // Act
        String result = flag.getUrgency(lead);
        
        // Assert
        System.assertEquals('High Priority', result);
    }
    
    @IsTest
    static void testGetUrgency_WithOtherLead_ReturnsNull() {
        // Arrange
        LeadSourceRule rule = new LeadSourceHighPriorityRule();
        LeadAttentionFlag flag = new LeadAttentionFlag(rule);
        Lead lead = new Lead(LeadSource = 'Other');
        
        // Act
        String result = flag.getUrgency(lead);
        
        // Assert
        System.assertEquals(null, result);
    }
    
    @IsTest
    static void testGetUrgency_WithNullLead_ReturnsNull() {
        // Arrange
        LeadSourceRule rule = new LeadSourceHighPriorityRule();
        LeadAttentionFlag flag = new LeadAttentionFlag(rule);
        
        // Act
        String result = flag.getUrgency(null);
        
        // Assert
        System.assertEquals(null, result);
    }
    
    @IsTest
    static void testGetUrgencies_Bulkified_ReturnsCorrectMap() {
        // Arrange
        LeadSourceRule rule = new LeadSourceHighPriorityRule();
        LeadAttentionFlag flag = new LeadAttentionFlag(rule);
        
        Lead lead1 = new Lead(Id = Id.valueOf('00Q000000000001AAA'), LeadSource = 'Web');
        Lead lead2 = new Lead(Id = Id.valueOf('00Q000000000002BBB'), LeadSource = 'Advertisement');
        Lead lead3 = new Lead(Id = Id.valueOf('00Q000000000003CCC'), LeadSource = 'Partner');
        Lead lead4 = new Lead(Id = Id.valueOf('00Q000000000004DDD'), LeadSource = 'Other');
        
        List<Lead> leads = new List<Lead>{lead1, lead2, lead3, lead4};
        
        // Act
        Map<Id, String> result = flag.getUrgencies(leads);
        
        // Assert
        System.assertEquals(4, result.size());
        System.assertEquals('High Priority', result.get(lead1.Id));
        System.assertEquals('High Priority', result.get(lead2.Id));
        System.assertEquals('High Priority', result.get(lead3.Id));
        System.assertEquals(null, result.get(lead4.Id));
    }
    
    @IsTest
    static void testGetUrgencies_EmptyList_ReturnsEmptyMap() {
        // Arrange
        LeadSourceRule rule = new LeadSourceHighPriorityRule();
        LeadAttentionFlag flag = new LeadAttentionFlag(rule);
        
        // Act
        Map<Id, String> result = flag.getUrgencies(new List<Lead>());
        
        // Assert
        System.assertEquals(0, result.size());
    }
    
    @IsTest
    static void testGetUrgencies_NullList_ReturnsEmptyMap() {
        // Arrange
        LeadSourceRule rule = new LeadSourceHighPriorityRule();
        LeadAttentionFlag flag = new LeadAttentionFlag(rule);
        
        // Act
        Map<Id, String> result = flag.getUrgencies(null);
        
        // Assert
        System.assertEquals(0, result.size());
    }
}