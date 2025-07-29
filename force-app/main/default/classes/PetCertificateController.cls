public with sharing class PetCertificateController {
    @AuraEnabled
    public static Id generatePetCertificate(Id petId) {
        PageReference pdfPage = Page.CertificadoPet; 
        pdfPage.getParameters().put('id', petId);
        Blob pdfBlob = pdfPage.getContentAsPDF();

        ContentVersion cv = new ContentVersion();
        cv.Title = 'Certificado_' + petId;
        cv.PathOnClient = 'Certificado_' + petId + '.pdf';
        cv.VersionData = pdfBlob;
        insert cv;

        Id contentDocumentId = [
            SELECT ContentDocumentId 
            FROM ContentVersion 
            WHERE Id = :cv.Id 
            LIMIT 1
        ].ContentDocumentId;

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocumentId;
        cdl.LinkedEntityId = petId;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;

        return contentDocumentId;
    }
}
