import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import sello from '@salesforce/resourceUrl/sello';

// Campos de Adoption__c
import ADOPTION_DATE_FIELD from '@salesforce/schema/Adoption__c.Adoption_Date__c';
import STATUS_FIELD        from '@salesforce/schema/Adoption__c.Status__c';
import CONTACT_NAME_FIELD  from '@salesforce/schema/Adoption__c.Contact__r.Name';
import CONTACT_AGE_FIELD   from '@salesforce/schema/Adoption__c.Contact__r.Age__c';
import PET_NAME_FIELD      from '@salesforce/schema/Adoption__c.Pet__r.Name';
import PET_BREED_FIELD     from '@salesforce/schema/Adoption__c.Pet__r.Breed__c';

const FIELDS = [
    ADOPTION_DATE_FIELD,
    STATUS_FIELD,
    CONTACT_NAME_FIELD,
    CONTACT_AGE_FIELD,
    PET_NAME_FIELD,
    PET_BREED_FIELD
];

export default class AdoptionDetails extends LightningElement {
    @api recordId;
    selloImg = sello; // Imagen del sello

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    adoption;

    // ----- GETTERS -----
    get contactName() {
        return this._getField(CONTACT_NAME_FIELD);
    }

    get contactAge() {
        return this._getField(CONTACT_AGE_FIELD) || 'N/A';
    }

    get petName() {
        return this._getField(PET_NAME_FIELD);
    }

    get petBreed() {
        return this._getField(PET_BREED_FIELD);
    }

    get adoptionDate() {
        return this._getField(ADOPTION_DATE_FIELD);
    }

    get status() {
        return this._getField(STATUS_FIELD);
    }

    get isAdopted() {
        // Ajusta los valores según el picklist real
        return this.status === 'Completed' || this.status === 'Finalizado';
    }

    get isLoading() {
        return !this.adoption.data && !this.adoption.error;
    }

    get hasError() {
        return this.adoption.error;
    }

    // ----- MÉTODO UTILITARIO -----
    _getField(field) {
        return getFieldValue(this.adoption.data, field);
    }
}
