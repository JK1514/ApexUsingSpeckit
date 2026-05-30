trigger Lead on Lead (before insert, before update) {
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        LeadAttentionFlagService.evaluate((List<Lead>) Trigger.new);
    }
}
