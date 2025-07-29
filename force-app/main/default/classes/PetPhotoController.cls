public with sharing class PetPhotoController {
    @AuraEnabled
    public static String uploadFile(Id petId, String base64Data, String fileName) {
     if (String.isBlank(base64Data) || String.isBlank(fileName)) {
            throw new AuraHandledException('Faltan datos para la carga del archivo.');
        }

        // Convertir base64 a blob
        Blob fileBody = EncodingUtil.base64Decode(base64Data);

        // Crear ContentVersion
        ContentVersion cv = new ContentVersion();
        cv.Title = fileName;
        cv.PathOnClient = fileName;
        cv.VersionData = fileBody;
        insert cv;

        // Obtener ContentDocumentId
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
        cdl.LinkedEntityId = petId; // por ejemplo, Account, Custom Object, etc.
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;

        // (Opcional) actualizar campo personalizado con la URL
        // Pet__c pet = [SELECT Id, Photo__c FROM Pet__c WHERE Id = :petId LIMIT 1];
        // pet.Photo__c = '/sfc/servlet.shepherd/document/download/' + cdl.ContentDocumentId;
        // update pet;

        // Devolver ContentDocumentId como referencia
        return cdl.ContentDocumentId;
    }
}
