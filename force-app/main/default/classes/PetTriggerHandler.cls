public class PetTriggerHandler {
    public static void calculateNextVaccinationDate(List<Pet__c> newPets) {
        Set<String> speciesSet = new Set<String>();
        
        for (Pet__c pet : newPets) {
            if (pet.Species__c != null) {
                speciesSet.add(pet.Species__c);
            }
        }

        Map<String, Vaccination_Periodicity__mdt> periodicityMap = new Map<String, Vaccination_Periodicity__mdt>();
        for (Vaccination_Periodicity__mdt record : [
            SELECT MasterLabel, Species_c__c, IntervalDays_c__c
            FROM Vaccination_Periodicity__mdt
            WHERE Species_c__c IN :speciesSet
        ]) {
            periodicityMap.put(record.Species_c__c, record);
        }

        for (Pet__c pet : newPets) {
            if (pet.Last_Vaccination_Date__c != null && pet.Species__c != null) {
                Vaccination_Periodicity__mdt config = periodicityMap.get(pet.Species__c);
                if (config != null && config.IntervalDays_c__c != null) {
                    pet.Next_Vaccination_Date__c = pet.Last_Vaccination_Date__c.addMonths(Integer.valueOf(config.IntervalDays_c__c));
                } else {
                    // No config found; optional: clear next date
                    pet.Next_Vaccination_Date__c = null;
                }
            }
        }
    }
}
