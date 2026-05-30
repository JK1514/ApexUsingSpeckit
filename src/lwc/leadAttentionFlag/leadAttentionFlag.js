import { LightningElement, api, wire } from 'lwc';
import getUrgency from '@salesforce/apex/LeadAttentionFlagService.getUrgency';

export default class LeadAttentionFlag extends LightningElement {
    @api recordId;
    urgencyText;
    hasUrgency = false;
    error;

    @wire(getUrgency, { leadId: '$recordId' })
    wiredUrgency({ error, data }) {
        if (data) {
            this.urgencyText = data;
            this.hasUrgency = !!data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.urgencyText = '';
            this.hasUrgency = false;
        }
    }
}