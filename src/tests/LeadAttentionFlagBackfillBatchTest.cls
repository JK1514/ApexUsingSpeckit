@IsTest
private class LeadAttentionFlagBackfillBatchTest {

    @TestSetup
    static void setup() {
        List<Lead> leads = new List<Lead>();

        // Leads that should get High Priority flag
        leads.add(new Lead(
            LastName = 'Web Lead',
            Company = 'Web Company',
            LeadSource = 'Web'
        ));
        leads.add(new Lead(
            LastName = 'Ad Lead',
            Company = 'Ad Company',
            LeadSource = 'Advertisement'
        ));
        leads.add(new Lead(
            LastName = 'Partner Lead',
            Company = 'Partner Company',
            LeadSource = 'Partner'
        ));
        leads.add(new Lead(
            LastName = 'Web Lead Mixed Case',
            Company = 'Web Company 2',
            LeadSource = 'web'
        ));
        leads.add(new Lead(
            LastName = 'Partner Lead Mixed Case',
            Company = 'Partner Company 2',
            LeadSource = 'PARTNER'
        ));

        // Leads that should NOT get High Priority flag
        leads.add(new Lead(
            LastName = 'Phone Lead',
            Company = 'Phone Company',
            LeadSource = 'Phone Inquiry'
        ));
        leads.add(new Lead(
            LastName = 'Referral Lead',
            Company = 'Referral Company',
            LeadSource = 'Referral'
        ));
        leads.add(new Lead(
            LastName = 'No Source Lead',
            Company = 'No Source Company'
        ));

        insert leads;
    }

    @IsTest
    static void testBackfillBatch() {
        Test.startTest();
        LeadAttentionFlagBackfillBatch batch = new LeadAttentionFlagBackfillBatch();
        Id jobId = Database.executeBatch(batch, 50);
        Test.stopTest();

        // Verify High Priority leads
        List<Lead> highPriorityLeads = [
            SELECT Id, Attention_Flag__c, LeadSource
            FROM Lead
            WHERE LeadSource IN ('Web', 'Advertisement', 'Partner', 'web', 'PARTNER')
        ];
        for (Lead lead : highPriorityLeads) {
            Assert.areEqual('High Priority', lead.Attention_Flag__c,
                'Lead with source ' + lead.LeadSource + ' should have High Priority flag');
        }

        // Verify non-matching leads have null flag
        List<Lead> nonMatchingLeads = [
            SELECT Id, Attention_Flag__c, LeadSource
            FROM Lead
            WHERE LeadSource IN ('Phone Inquiry', 'Referral') OR LeadSource = null
        ];
        for (Lead lead : nonMatchingLeads) {
            Assert.isNull(lead.Attention_Flag__c,
                'Lead with source ' + lead.LeadSource + ' should not have High Priority flag');
        }
    }

    @IsTest
    static void testBackfillBatchClearsIncorrectFlags() {
        // Set incorrect flags on leads that shouldn't have them
        List<Lead> leadsToUpdate = [
            SELECT Id, Attention_Flag__c
            FROM Lead
            WHERE LeadSource IN ('Phone Inquiry', 'Referral')
        ];
        for (Lead lead : leadsToUpdate) {
            lead.Attention_Flag__c = 'High Priority';
        }
        update leadsToUpdate;

        Test.startTest();
        LeadAttentionFlagBackfillBatch batch = new LeadAttentionFlagBackfillBatch();
        Database.executeBatch(batch, 50);
        Test.stopTest();

        // Verify flags were cleared
        List<Lead> verifiedLeads = [
            SELECT Id, Attention_Flag__c, LeadSource
            FROM Lead
            WHERE LeadSource IN ('Phone Inquiry', 'Referral')
        ];
        for (Lead lead : verifiedLeads) {
            Assert.isNull(lead.Attention_Flag__c,
                'Lead with source ' + lead.LeadSource + ' should have cleared flag');
        }
    }

    @IsTest
    static void testBackfillBatchWithEmptyScope() {
        Test.startTest();
        LeadAttentionFlagBackfillBatch batch = new LeadAttentionFlagBackfillBatch();
        batch.execute(null, new List<Lead>());
        Test.stopTest();

        // No assertion needed - just verify no exception is thrown
    }
}
