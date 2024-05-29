import { LightningElement, api, track } from 'lwc';
import getLogDetails from '@salesforce/apex/LogDetailController.getLogDetails';
import { loadStyle } from 'lightning/platformResourceLoader';
import FileLoggerCSS from '@salesforce/resourceUrl/FileLoggerCSS';
import { NavigationMixin } from 'lightning/navigation';
import NUMBER_OF_RECORDS_AT_ONCE from '@salesforce/label/c.NUMBER_OF_RECORDS_AT_ONCE';

const columns = [
    {
        label: "Log Number", fieldName: "logRecordId", type: 'url', typeAttributes: { label: { fieldName: 'name' }, target: '_blank' }
    },
    {
        label: "User Name", fieldName: "userId", type: 'url', typeAttributes: { label: { fieldName: 'userName' }, target: '_blank' }
    },
    {
        label: "Log Length", fieldName: "logLength"
    },
    {
        label: "Status", fieldName: "status"
    },
    {
        label: "Start Time", fieldName: "startTime"
    },
    {
        label: "", type: "button-icon", 
        typeAttributes: {
            iconName: "utility:preview", name: 'Preview', 
            disabled: {fieldName: "isPreviewDisabled"}
        }
    }
]

export default class ListLogDetail extends NavigationMixin(LightningElement) {

    @api recordId;
    columns = columns;
    @track records = [];
    numberOfRecord = 10;
    count = 0;
    showLogDetail = false;
    message;
    currentFetchedRecord = [];
    styleLoaded = false;

    connectedCallback() {
        this.numberOfRecord = NUMBER_OF_RECORDS_AT_ONCE ? parseInt(NUMBER_OF_RECORDS_AT_ONCE) : 10;
        this.fetchLogDetailsRecord();
    }

    renderedCallback(){
        if(!this.styleLoaded) {
            this.loadStyle();
        }
    }

    getNextSegment(event) {
        this.count++;
        this.fetchLogDetailsRecord();
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'Preview':
                this.previewFile(row);
                break;
            default:
        }
    }

    previewFile(row) {
        if(row.contentDocumentId) {
            this[NavigationMixin.Navigate]({
                type: 'standard__namedPage',
                attributes: {
                    pageName: 'filePreview'
                },
                state : {
                    selectedRecordId: row.contentDocumentId
                }
            });
        }
    }

    fetchLogDetailsRecord() {
        getLogDetails({recordId: this.recordId, offSet: this.numberOfRecord*this.count, numberOfRecord: this.numberOfRecord}).then(result => {
            if(result.isSuccess) {
                result.records.forEach(record => {
                    record.logRecordId = "/" + record.recordId;
                    record.userId = "/" + record.userId;
                    record.isPreviewDisabled = record.contentDocumentId ? false : true;
                });
                this.currentFetchedRecord = result.records;
                this.records = [...this.records, ...result.records];
                this.showLogDetail = this.records ? this.records.length > 0 : false;
            }else {
                // Handle Error.
                this.message = result.message;
                this.currentFetchedRecord = [];
            }
        }).catch(error => {
            // Handle Error.
            this.message = JSON.stringify(error);
        });
    }

    get showMore() {
        if(this.currentFetchedRecord && this.currentFetchedRecord.length < this.numberOfRecord) {
            return false;
        }
        return true;
    }

    loadStyle() {
        Promise.all([
            loadStyle( this, FileLoggerCSS )
            ]).then(() => {
                console.log( 'Files loaded' );
            })
            .catch(error => {
                console.log( error.body.message );
        });
    }
}