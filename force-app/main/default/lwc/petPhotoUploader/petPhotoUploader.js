import { LightningElement, api } from 'lwc';
import uploadFile from '@salesforce/apex/PetPhotoUploaderController.uploadFile';

export default class PetPhotoUploader extends LightningElement {
    @api recordId;
    pet; // Puedes setearlo desde el parent si lo necesitas
    fileName = '';
    fileData;
    

    handleFileChange(event) {
        const file = event.target.files[0];
        if (file) {
            this.fileName = file.name;

            const reader = new FileReader();
            reader.onload = () => {
                const base64 = reader.result.split(',')[1];
                this.fileData = {
                    fileName: file.name,
                    base64: base64
                };
            };
            reader.readAsDataURL(file);
        }
    }

    handleUpload() {
        if (!this.fileData) {
            alert('Por favor selecciona un archivo antes de subirlo.');
            return;
        }

        uploadFile({
            petId: this.recordId,
            base64Data: this.fileData.base64,
            fileName: this.fileData.fileName
        })
        .then(result => {
            console.log('Archivo subido con éxito:', result);
            // Forzar recarga de imagen
            this.pet.Photo__c = result; // asumimos que el Apex devuelve la nueva URL
        })
        .catch(error => {
            console.error('Error al subir el archivo:', error.body.message);
        });
    }
}
