({
    setProductCategories: function (component) {
        let product = component.get('v.newProduct');
        let action = component.get('c.getAllProductCategories');
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                if (returnValue.length > 0) {
                    product = {
                        category: {
                            id: returnValue[0].id
                        }
                    };
                    component.set('v.newProduct', product);
                }
                component.set('v.allCategories', returnValue);
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },


    validateFields: function (component) {
        return component.find('productField').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            let isValid = inputCmp.get('v.validity').valid;
            return validSoFar && isValid;
        }, true);
    },

    saveProduct: function (component) {
        this.showSpinner(component);
        let productObject = component.get('v.newProduct');
        let productImages = component.get('v.productImages');
        let productSpecifications = component.get('v.productSpecifications');
        let mainImageName = component.get('v.mainImageName');
        if(mainImageName) {
            let imageIndex = productImages.findIndex(item => item.name === mainImageName);
            productImages.splice(0,0,productImages.splice(imageIndex, 1)[0]);
        }

        let specsMap = new Map();
        productSpecifications.forEach(element => specsMap[element.name] = element.value);
        let imagesMap = new Map();
        productImages.forEach(element => imagesMap[element.name] = element.data.match(/,(.*)$/)[1]);
        let action = component.get('c.saveProduct');
        action.setParams({
            product: productObject,
            imagesData: imagesMap,
            specs: specsMap
        });
        action.setCallback(this, (response) => {
            this.hideSpinner(component);
            let state = response.getState();
            if (state === 'SUCCESS') {
                this.clearForm(component);
                this.getNotificationHandler(component).showSuccessToast($A.get('$Label.c.product_send_approve_process'));
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },

    clearForm: function (component) {
        component.set('v.newProduct', {});
        component.set('v.productImages', []);
        component.set('v.productSpecifications', []);
        component.set('v.image', '');
        component.set('v.specification', {});
    },

    readFile: function (component, helper, file) {
        if (!file) {
            return;
        }
        if (!file.type.match(/(image.*)/)) {
            this.getNotificationHandler(component).showErrorToast($A.get('$label.c.image_file_format_not_supported'));
            return;
        }
        let allImages = component.get('v.productImages');
        let reader = new FileReader();
        reader.onloadend = function () {
            let dataURL = reader.result;
            let fileName = file.name;
            allImages.push({
                name: fileName,
                data: dataURL
            });
            component.set('v.productImages', allImages);
        };
        reader.readAsDataURL(file);
    },

    showSpinner: function (component) {
        let spinnerComponent = component.find('spinner');
        spinnerComponent.turnOn();
    },
    hideSpinner: function (component) {
        let spinnerComponent = component.find('spinner');
        spinnerComponent.turnOff();
    },

    getNotificationHandler: function(component) {
        return component.find('notificationHandler');
    },

    setMainImageNameIfNotSet: function(component, name) {
        let currentName = component.get('v.mainImageName');
        if(!currentName) {
            component.set('v.mainImageName', name);
        }
    }
})