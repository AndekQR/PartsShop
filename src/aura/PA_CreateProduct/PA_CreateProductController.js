({
    init: function (component, event, helper) {
        helper.setProductCategories(component);
    },

    onSaveProduct: function (component, event, helper) {
        helper.saveProduct(component);
    },

    onImageAdd: function (component, event, helper) {
        let isValid = helper.validateImageUrl(component);
        if (isValid) {
            let newImage = component.get('v.image');
            let allImages = component.get('v.productImages');
            allImages.push(newImage);
            component.set('v.productImages', allImages);
            component.set('v.image', {});
        }
    },

    onSpecificationAdd: function(component, event, helper) {
        let newSpecification = component.get('v.specyfication');
        let allSpecs = component.get('v.productSpecifications');
        allSpecs.push(newSpecification);
        component.set('v.specyfication', {});
        component.set('v.productSpecifications', allSpecs);
    },

    onDragOver: function(component, event) {
        event.preventDefault();
    },

    onDrop: function(component, event, helper) {
        event.stopPropagation();
        event.preventDefault();
        event.dataTransfer.dropEffect = 'copy';
        let files = event.dataTransfer.files;
        // if (files.length>1) {
        //     return alert("You can only upload one profile picture");
        // }
        files.forEach(file =>helper.readFile(component, helper, file));
        // helper.readFile(component, helper, files[0]);
    }
})