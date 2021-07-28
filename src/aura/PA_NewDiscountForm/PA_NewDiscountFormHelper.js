({
    setUserProducts: function (component) {
        let action = component.get('c.allUserProducts');
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                component.set('v.products', returnValue);
                let mapped = this.mapToDualListOptions(returnValue);
                component.set('v.userProducts', mapped);
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },

    mapToDualListOptions: function (products) {
        return products.map((element => {
            return {
                label: element.name,
                value: element.id
            }
        }))
    },

    clearForm: function (component) {
        let discount = {
            size: 5,
            status: 'Active'
        };
        component.set('v.discount', discount);
        component.set('v.discountProducts', []);
        component.set('v.usersEmail', []);
        component.set('v.userEmail', '');
    },

    addToEmailList: function (component) {
        let email = component.get('v.userEmail');
        let emailList = component.get('v.usersEmail');
        emailList.push(email);
        component.set('v.usersEmail', emailList);
        component.set('v.userEmail', '');
    },

    fireNewRecordEvent: function (component) {
        let event = component.getEvent('PA_NewRecordEvent');
        event.fire();
    },

    setFormData: function (component, event) {
        let params = event.getParam('arguments');
        this.getDiscountDetails(component, params.discountId);
    },

    getDiscountDetails: function (component, discountId) {
        let action = component.get('c.getDiscountFullData');
        action.setParams({
            discountId: discountId
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                component.set('v.discountProducts', returnValue.products.map(element => element.id));
                component.set('v.usersEmail', returnValue.usersEmail);
                returnValue.products = null;
                returnValue.usersEmail = null;
                returnValue.status = 'Active';
                component.set('v.discount', returnValue);
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },

    showDiscountSummaryModal: function (component) {
        let discount = component.get('v.discount');
        let productsIds = component.get('v.discountProducts');
        let products = component.get('v.products').filter(element => productsIds.includes(element.id));
        let usersEmail = component.get('v.usersEmail');
        $A.createComponent('c:PA_NewDiscountSummary', {
            discount: discount,
            discountProducts: products,
            usersEmails: usersEmail
        }, (resultBody, status, errorMessage) => {
            if (status === 'SUCCESS') {
                component.find('overlayLib').showCustomModal({
                    body: resultBody,
                    showCloseButton: true,
                    cssClass: ''
                });
            } else {
                console.log("Error: " + errorMessage);
            }
        });
    },

    getNotificationHandler: function(component) {
        return component.find('notificationHandler');
    }
})