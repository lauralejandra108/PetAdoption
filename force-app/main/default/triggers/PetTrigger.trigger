trigger PetTrigger on Pet__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            PetTriggerHandler.calculateNextVaccinationDate(Trigger.new);
        }
    }
}
