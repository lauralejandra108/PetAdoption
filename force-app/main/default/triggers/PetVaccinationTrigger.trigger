trigger PetVaccinationTrigger on Pet__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            PetVaccinationHandler.calculateNextVaccinationDate(Trigger.new);
        }
    }
}
