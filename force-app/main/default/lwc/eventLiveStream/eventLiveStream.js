import { LightningElement, api, track } from 'lwc';
import { subscribe, unsubscribe} from 'lightning/empApi';
import getUserDetail from '@salesforce/apex/EventLiveStreamController.getUserDetail';

// Import platform event field
// import EventUuid from "@salesforce/schema/Log_Entry_Event__e.EventUuid";
// import CreatedDate from "@salesforce/schema/Log_Entry_Event__e.CreatedDate";
// import User_Name from "@salesforce/schema/Log_Entry_Event__e.User_Name__c";
// import Origin from "@salesforce/schema/Log_Entry_Event__e.Origin__c";
// import Level from "@salesforce/schema/Log_Entry_Event__e.Level__c";
// import Message from "@salesforce/schema/Log_Entry_Event__e.Message__c";

export default class EventLiveStream extends LightningElement {

    isStreamingOn = false;
    loggingLevelValue = "All";
    messages = [];
    filteredMessages = [];
    subscription = {};
    @api channelName = '/event/Log_Entry_Event__e';
    totalStreamEvents = 0;
    selectedUserName;
    selectedOrigin;
    selectedLoggigLevel;
    messageContains;

    handleStreamStart(event) {
        this.handleSubscribe();
    }

    handleStremStop(event) {
        this.handleUnsubscribe();
    }

    handleClearEventStream() {
        this.messages = [];
        this.filteredMessages = [];
        this.getUserDetail();
    }

    handleLoggingLevelChange(event) {
        this.selectedLoggigLevel = event.detail.value;
        this.filterMessages();
    }

    handleMessageChange(event) {
        this.messageContains = event.detail.value;
        this.filterMessages();
    }

    handleLoggedByChange(event) {
        if(event.detail.recordId) {
            this.fetchUserDetail(event.detail.recordId);
        }else {
            this.selectedUserName = null;
            this.filterMessages();
        }
    }

    handleOriginLocationChange(event) {
        this.selectedOrigin = event.detail.value;
        this.filterMessages();
    }

    get loggingLevel() {
        return [
            { label: 'All', value: '' },
            { label: 'DEBUG', value: 'DEBUG' },
            { label: 'ERROR', value: 'ERROR' },
        ];
    }

    proxyToObj(obj){
        return JSON.parse(JSON.stringify(obj));
    }

    handleSubscribe() {
        const self = this;
        const messageCallback = function (response) {
            var obj = JSON.parse(JSON.stringify(response));
            self.messages = self.proxyToObj(self.messages);
            self.messages.push(self.getMessageDetail(obj.data.payload));
            if(self.isValidPayload(self.getMessageDetail(obj.data.payload))) {
                self.filteredMessages.push(self.getMessageDetail(obj.data.payload));
                self.totalStreamEvents++;
            }
        };
 
        subscribe(this.channelName, -1, messageCallback).then(response => {
            console.log('Subscription request sent to: ', JSON.stringify(response.channel));
            this.subscription = response;
            this.isStreamingOn = true;
        });
    }

    handleUnsubscribe() {
        const self = this;
        unsubscribe(this.subscription, response => {
            console.log('unsubscribe() response: ' + JSON.stringify(response));
            self.isStreamingOn = false;
        });
    }

    isValidPayload(payload) {
        let countForNotBlank = 0;
        let countForMatchingFilter = 0;
        countForNotBlank = this.selectedUserName ? countForNotBlank + 1 : countForNotBlank;
        countForNotBlank = this.selectedOrigin ? countForNotBlank + 1 : countForNotBlank;
        countForNotBlank = this.selectedLoggigLevel ? countForNotBlank + 1 : countForNotBlank;
        countForNotBlank = this.messageContains ? countForNotBlank + 1 : countForNotBlank;
        
        countForMatchingFilter = this.selectedUserName && payload.username === this.selectedUserName ? countForMatchingFilter + 1 : countForMatchingFilter;
        countForMatchingFilter = this.selectedOrigin && payload.origin.includes(this.selectedOrigin) ? countForMatchingFilter + 1 : countForMatchingFilter;
        countForMatchingFilter = this.selectedLoggigLevel && payload.loggigLevel === this.selectedLoggigLevel ? countForMatchingFilter + 1 : countForMatchingFilter;
        countForMatchingFilter = this.messageContains && payload.message.includes(this.messageContains) ? countForMatchingFilter + 1 : countForMatchingFilter;
        if(countForNotBlank == 0) {
            return true;
        }else {
            return (countForNotBlank == countForMatchingFilter);
        }
    }

    getMessageDetail(payload) {
        let message = {
            "EventUuid": payload.EventUuid,
            "createdDate": payload.CreatedDate,
            "username": payload.User_Name__c,
            "origin": this.getOrigin(payload.Origin__c),
            "loggigLevel": payload.Level__c,
            "message": payload.Message__c,
            "className": payload.Level__c === "ERROR" ? "error" : "success"
        }
        return message;
    }

    getOrigin(origin) {
        if(!origin) {
            return origin;
        }
        if(!origin.includes("\n")) {
            return origin.includes(',') ? origin.split(',')[0] : origin;
        }
        let originList = origin.split('\n');
        if(originList.length >= 2 && originList[1] && originList[1].includes(',')) {
            return originList[1].split(',')[0];
        }else if(originList.length >= 2 && originList[1]) {
            return originList[1];
        }
        return '';
    }

    fetchUserDetail(userId) {
        getUserDetail({userId : userId}).then(result => {
            if(result.isSuccess) {
                this.selectedUserName = result.user.Username;
                this.filterMessages();
            }else {
                // Handle Error.
            }
        }).catch(error => {
            // Handle Error.
            console.log("Error : " + JSON.stringify(error));
        });
    }

    filterMessages() {
        if(this.messages) {
            let temp = [];
            this.messages.forEach(message => {
                if(this.isValidPayload(message)) {
                    temp.push(message);
                }
            });
            this.filteredMessages = [... temp];
        }
    }

    get streamEventTitle() {
        return "Total Stream Event(s) : " + this.totalStreamEvents
    }
}