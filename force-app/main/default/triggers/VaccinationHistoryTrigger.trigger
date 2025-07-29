trigger VaccinationHistoryTrigger on Vaccination_History__c (before insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
        VaccinationHistoryHandler.setDateFromPet(trigger.new);
    }
}
