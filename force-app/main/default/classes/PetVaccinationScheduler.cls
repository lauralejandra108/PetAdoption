public with sharing class PetVaccinationScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
    
        Database.executeBatch(new PetVaccinationBatch(), 50);
    }
}
