({
    setUserProducts: function(component) {
        let action = component.get('c.allUserProducts');
        action.setCallback(this, (response) => {
            let state = response.getState();
            if(state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                let mapped = this.mapToDualListOptions(returnValue);
                component.set('v.userProducts', mapped);
            } else {
                this.handleError(response);
            }
        });
        $A.enqueueAction(action);
    },

    mapToDualListOptions: function(products) {
        return products.map((element => {
            return {
                label: element.name,
                value: element.id
            }
        }))
    },


    clearForm: function(component) {
        let discount = {
            size: 5
        };
        component.set('v.discount', discount);
        component.set('v.discountProducts', []);
        component.set('v.usersEmail', []);
        component.set('v.userEmail', '');
    },

    addDiscount: function(component) {
        let discount = component.get('v.discount');
        let discountProducts = component.get('v.discountProducts');
        let emails = component.get('v.usersEmail');
        let action = component.get('c.addDiscount');
        action.setParams({
            discount: discount,
            productsIds: discountProducts,
            usersEmails: emails
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if(state === 'SUCCESS') {
                this.showToast('Success', 'Discount is now available', 'success');
                this.clearForm(component);
            } else {
                this.showToast('Error', 'Something went wrong! Try again.', 'error');
            }
        });
        $A.enqueueAction(action);
    },

    showToast: function (title, message, type) {
        let resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        resultsToast.fire();
    },

    addToEmailList: function(component) {
        let email = component.get('v.userEmail');
        let emailList = component.get('v.usersEmail');
        emailList.push(email);
        component.set('v.usersEmail', emailList);
        component.set('v.userEmail', '');
    },

    handleError: function (response) {
        let errors = response.getError();
        if (errors) {
            if (errors[0] && errors[0].message) {
                console.error("Error message: " +
                    errors[0].message);
            }
        } else {
            console.error("Unknown error");
        }
    },
})