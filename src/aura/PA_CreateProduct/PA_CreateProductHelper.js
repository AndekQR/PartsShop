({

    setProductCategories: function (component) {
        let product = component.get('v.newProduct');
        let action = component.get('c.getAllProductCategories');
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                if (returnValue.length > 0) {
                    product.ProductCategory__c = returnValue[0].Id;
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

    validateImageUrl: function (component) {
        let cmp = component.find('imageUrl');
        cmp.showHelpMessageIfInvalid();
        return cmp.get('v.validity').valid;
    },

    saveProduct: function (component) {
        let productObject = component.get('v.newProduct');
        let productImages = component.get('v.productImages');
        let productSpecifications = component.get('v.productSpecifications');

        productObject.sobjectType = 'Product__c';
        let specsMap = new Map();
        productSpecifications.forEach(element => specsMap[element.Name] = element.Value__c);
        let imagesMap = new Map();
        productImages.forEach(element => imagesMap[element.name] = element.data.match(/,(.*)$/)[1]);
        let action = component.get('c.saveProduct');
        action.setParams({
            product: productObject,
            imagesData: imagesMap,
            specs: specsMap
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                this.clearForm(component);
                let resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Approve Process",
                    "message": "Product successfully send to approve process.",
                    "type": "success"
                });
                resultsToast.fire();
            } else {
                this.handleError(response);
            }
        });
        $A.enqueueAction(action);
    },

    clearForm: function (component) {
        component.set('v.newProduct', {});
        component.set('v.productImages', []);
        component.set('v.productSpecifications', []);
        component.set('v.image', '');
        component.set('v.specyfication', {});
    },

    readFile: function (component, helper, file) {
        if (!file) return;
        if (!file.type.match(/(image.*)/)) {
            return alert('Image file not supported');
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

})