({
    init: function (component, event, helper) {
        helper.setProductCategories(component);
        component.set('v.specification', {});
    },

    onSaveProduct: function (component, event, helper) {
        if (helper.validateFields(component)) {
            helper.saveProduct(component);
        }
    },

    onImageAdd: function (component, event, helper) {
        let newImage = component.get('v.image');
        let allImages = component.get('v.productImages');
        allImages.push(newImage);
        component.set('v.productImages', allImages);
        component.set('v.image', {});
    },

    onSpecificationAdd: function (component, event, helper) {
        let newSpecification = component.get('v.specification');
        let allSpecs = component.get('v.productSpecifications');
        allSpecs.push(newSpecification);
        component.set('v.specification', {});
        component.set('v.productSpecifications', allSpecs);
    },

    onDragOver: function (component, event) {
        event.preventDefault();
    },

    onDrop: function (component, event, helper) {
        event.stopPropagation();
        event.preventDefault();
        event.dataTransfer.dropEffect = 'copy';
        let files = event.dataTransfer.files;
        helper.setMainImageNameIfNotSet(component, files[0].name);
        Array.prototype.forEach.call(files, (file) => {
            helper.readFile(component, helper, file)
        });
    },

    onMainImageChoose: function(component, event, helper) {
        let imageName = event.currentTarget.dataset.name;
        component.set('v.mainImageName', imageName);
    },
})