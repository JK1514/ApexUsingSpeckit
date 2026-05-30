/**
 * Batch Apex class to backfill the Attention_Flag__c field on existing Lead records.
 * Evaluates LeadSource and sets the flag to 'High Priority' for Web, Advertisement, or Partner sources.
 */
public with sharing class LeadAttentionFlagBackfillBatch implements Database.Batchable<SObject>, Database.Stateful {

    private static final String URGENCY_HIGH_PRIORITY = 'High Priority';
    private static final Set<String> HIGH_PRIORITY_SOURCES = new Set<String>{'web', 'advertisement', 'partner'};

    private Integer recordsProcessed;
    private Integer recordsUpdated;

    /**
     * Constructor initializes the counter.
     */
    public LeadAttentionFlagBackfillBatch() {
        recordsProcessed = 0;
        recordsUpdated = 0;
    }

    /**
     * Queries all Lead records that need evaluation.
     * Only queries leads where LeadSource is not null.
     *
     * @param bc Batchable context
     * @return QueryLocator for Lead records
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, LeadSource, Attention_Flag__c
            FROM Lead
            WHERE LeadSource != null
        ]);
    }

    /**
     * Processes each batch of Leads and sets the Attention_Flag__c field.
     *
     * @param bc Batchable context
     * @param scope List of Lead records to process
     */
    public void execute(Database.BatchableContext bc, List<Lead> scope) {
        List<Lead> leadsToUpdate = new List<Lead>();

        for (Lead lead : scope) {
            recordsProcessed++;
            String source = String.isBlank(lead.LeadSource) ? '' : lead.LeadSource.trim().toLowerCase();

            if (HIGH_PRIORITY_SOURCES.contains(source)) {
                lead.Attention_Flag__c = URGENCY_HIGH_PRIORITY;
                leadsToUpdate.add(lead);
            } else if (lead.Attention_Flag__c != null) {
                // Clear the flag if source no longer matches
                lead.Attention_Flag__c = null;
                leadsToUpdate.add(lead);
            }
        }

        if (!leadsToUpdate.isEmpty()) {
            try {
                Database.update(leadsToUpdate, AccessLevel.USER_MODE);
                recordsUpdated += leadsToUpdate.size();
            } catch (Exception ex) {
                // Log error for debugging - in production, consider using Platform Events or custom logging
                System.debug('Error updating leads: ' + ex.getMessage());
            }
        }
    }

    /**
     * Finalizes the batch job and logs summary.
     *
     * @param bc Batchable context
     */
    public void finish(Database.BatchableContext bc) {
        System.debug(
            'LeadAttentionFlagBackfillBatch completed. ' +
            'Records processed: ' + recordsProcessed +
            ', Records updated: ' + recordsUpdated
        );
    }
}
