({
    showReclamationModal: function(component) {
        let order = component.get('v.order');
        $A.createComponent('c:PA_CaseForm', {
            orderObject: order
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
})