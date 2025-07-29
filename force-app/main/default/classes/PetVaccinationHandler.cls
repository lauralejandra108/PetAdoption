public class PetVaccinationHandler {
    public static void calculateNextVaccinationDate(List<Pet__c> petList) {
        // Cargar custom metadata: especie → días de intervalo
        Map<String, Integer> speciesToInterval = new Map<String, Integer>();
        for (Vaccination_Periodicity__mdt config : [
            SELECT Species_c__c, IntervalDays_c__c FROM Vaccination_Periodicity__mdt
        ]) {
            if (config.Species_c__c != null && config.IntervalDays_c__c != null) {
                speciesToInterval.put(config.Species_c__c, config.IntervalDays_c__c.intValue());
            }
        }

        for (Pet__c pet : petList) {
            if (pet.Species__c != null && pet.Last_Vaccination_Date__c != null) {
                Integer interval = speciesToInterval.get(pet.Species__c);
                if (interval != null) {
                    pet.Next_Vaccination_Date__c = pet.Last_Vaccination_Date__c.addDays(interval);
                }
            }
        }
    }
}
