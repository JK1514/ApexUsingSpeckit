@IsTest
private class LeadSourceHighPriorityRuleTest {
    
    @IsTest
    static void testGetUrgency_Web_ReturnsHighPriority() {
        // Arrange
        LeadSourceHighPriorityRule rule = new LeadSourceHighPriorityRule();
        Lead lead = new Lead(LeadSource = 'Web');
        
        // Act
        String result = rule.getUrgency(lead);
        
        // Assert
        System.assertEquals('High Priority', result);
    }
    
    @IsTest
    static void testGetUrgency_Advertisement_ReturnsHighPriority() {
        // Arrange
        LeadSourceHighPriorityRule rule = new LeadSourceHighPriorityRule();
        Lead lead = new Lead(LeadSource = 'Advertisement');
        
        // Act
        String result = rule.getUrgency(lead);
        
        // Assert
        System.assertEquals('High Priority', result);
    }
    
    @IsTest
    static void testGetUrgency_Partner_ReturnsHighPriority() {
        // Arrange
        LeadSourceHighPriorityRule rule = new LeadSourceHighPriorityRule();
        Lead lead = new Lead(LeadSource = 'Partner');
        
        // Act
        String result = rule.getUrgency(lead);
        
        // Assert
        System.assertEquals('High Priority', result);
    }
    
    @IsTest
    static void testGetUrgency_Other_ReturnsNull() {
        // Arrange
        LeadSourceHighPriorityRule rule = new LeadSourceHighPriorityRule();
        Lead lead = new Lead(LeadSource = 'Other');
        
        // Act
        String result = rule.getUrgency(lead);
        
        // Assert
        System.assertEquals(null, result);
    }
    
    @IsTest
    static void testGetUrgency_EmptyLeadSource_ReturnsNull() {
        // Arrange
        LeadSourceHighPriorityRule rule = new LeadSourceHighPriorityRule();
        Lead lead = new Lead(LeadSource = '');
        
        // Act
        String result = rule.getUrgency(lead);
        
        // Assert
        System.assertEquals(null, result);
    }
    
    @IsTest
    static void testGetUrgency_NullLeadSource_ReturnsNull() {
        // Arrange
        LeadSourceHighPriorityRule rule = new LeadSourceHighPriorityRule();
        Lead lead = new Lead();
        
        // Act
        String result = rule.getUrgency(lead);
        
        // Assert
        System.assertEquals(null, result);
    }
    
    @IsTest
    static void testGetUrgency_WhitespaceLeadSource_ReturnsNull() {
        // Arrange
        LeadSourceHighPriorityRule rule = new LeadSourceHighPriorityRule();
        Lead lead = new Lead(LeadSource = '   ');
        
        // Act
        String result = rule.getUrgency(lead);
        
        // Assert
        System.assertEquals(null, result);
    }
    
    @IsTest
    static void testGetUrgency_CaseInsensitive_Web_ReturnsHighPriority() {
        // Arrange
        LeadSourceHighPriorityRule rule = new LeadSourceHighPriorityRule();
        Lead lead = new Lead(LeadSource = 'web'); // lowercase
        
        // Act
        String result = rule.getUrgency(lead);
        
        // Assert
        System.assertEquals('High Priority', result);
    }
    
    @IsTest
    static void testGetUrgency_CaseInsensitive_ADVERTISEMENT_ReturnsHighPriority() {
        // Arrange
        LeadSourceHighPriorityRule rule = new LeadSourceHighPriorityRule();
        Lead lead = new Lead(LeadSource = 'ADVERTISEMENT'); // uppercase
        
        // Act
        String result = rule.getUrgency(lead);
        
        // Assert
        System.assertEquals('High Priority', result);
    }
    
    @IsTest
    static void testGetUrgency_LeadingTrailingWhitespace_ReturnsHighPriority() {
        // Arrange
        LeadSourceHighPriorityRule rule = new LeadSourceHighPriorityRule();
        Lead lead = new Lead(LeadSource = ' Web '); // whitespace around
        
        // Act
        String result = rule.getUrgency(lead);
        
        // Assert
        System.assertEquals('High Priority', result);
    }
}