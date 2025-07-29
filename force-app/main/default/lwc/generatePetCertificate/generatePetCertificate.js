import { LightningElement, api } from 'lwc';

export default class GeneratePetCertificate extends LightningElement {
    @api recordId;

    handleGenerate() {
        const baseUrl = window.location.origin;
        const pdfUrl = `${baseUrl}/apex/CertificadoPet?id=${this.recordId}`;
        window.open(pdfUrl, '_blank'); // Abre el PDF en nueva pestaña
    }
}
