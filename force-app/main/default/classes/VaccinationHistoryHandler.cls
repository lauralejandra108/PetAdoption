public class VaccinationHistoryHandler {
    public static void setDateFromPet(List<Vaccination_History__c> histories) {
        Set<Id> petIds = new Set<Id>();
        
        // Recoger todos los Pet__c relacionados
        for (Vaccination_History__c vh : histories) {
            if (vh.Pet__c != null) {
                petIds.add(vh.Pet__c);
            }
        }

        // Traer los Pet con su campo Last_Vaccination_Date__c
        Map<Id, Pet__c> petMap = new Map<Id, Pet__c>(
            [SELECT Id, Last_Vaccination_Date__c FROM Pet__c WHERE Id IN :petIds]
        );

        // Asignar esa fecha al campo Date__c del historial
        for (Vaccination_History__c vh : histories) {
            if (vh.Pet__c != null && petMap.containsKey(vh.Pet__c)) {
                vh.Date__c = petMap.get(vh.Pet__c).Last_Vaccination_Date__c;
            }
        }
    }
}
