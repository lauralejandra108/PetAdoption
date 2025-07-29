public with sharing class PetController {
    
    @AuraEnabled
    public static String getFileUrl(Id contentVersionId) {
        ContentVersion cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionId LIMIT 1];
        ContentDistribution cd = new ContentDistribution(
            Name = 'PetImage',
            ContentVersionId = cv.Id,
            PreferencesAllowViewInBrowser = true
        );
        insert cd;

        return cd.DistributionPublicUrl;
    }

    @AuraEnabled
    public static void createPet(String name, String photoUrl) {
        Pet__c pet = new Pet__c();
        pet.Name = name;
        pet.Photo__c = photoUrl;
        insert pet;
    }
}
