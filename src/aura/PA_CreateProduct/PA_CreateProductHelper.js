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
                this.handleError(response);
            }
        });
        $A.enqueueAction(action);
    },

    handleError: function (response) {
        let errors = response.getError();
        if (errors) {
            if (errors[0] && errors[0].message) {
                console.log("Error message: " +
                    errors[0].message);
            }
        } else {
            console.log("Unknown error");
        }
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

        let specsMap = new Map();
        productSpecifications.forEach(element => specsMap[element.name] = element.value);
        let imagesMap = new Map();
        productImages.forEach(element => imagesMap[element.name] = element.data.match(/,(.*)$/)[1]);
        let action = component.get('c.saveProduct');
        console.log(JSON.parse(JSON.stringify(productObject)));
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
                this.showToast('Approve Process', $A.get('$Label.c.product_send_approve_process'), 'success');
            } else {
                this.showToast('Error', $A.get('$Label.c.something_went_wrong'), 'error');
                this.handleError(response);
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
            this.showToast('Error', $A.get('$label.c.image_file_format_not_supported'), 'error');
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
    }
})