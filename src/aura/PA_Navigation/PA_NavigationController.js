({
    onNavigate: function(component, event, helper) {
        let params = event.getParam('arguments');
        let url = params.address;
        let productId = params.productId;
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            url: url+'?c__productId='+productId
        });
        urlEvent.fire();
    },
})