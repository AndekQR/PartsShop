({
    openNewProductBodyContent: function() {
        let event = $A.get('e.c:PA_ChangeBodyContentEvent');
        event.setParams({
            whatToShow: 'newProductScreen'
        });
        event.fire();
    },
    openWatchListBodyContent: function() {
        let event = $A.get('e.c:PA_ChangeBodyContentEvent');
        event.setParams({
            whatToShow: 'watchListScreen'
        });
        event.fire();
    },
    openCartBodyContent: function() {
        let event = $A.get('e.c:PA_ChangeBodyContentEvent');
        event.setParams({
            whatToShow: 'cartScreen'
        });
        event.fire();
    },
    showSpinner: function (component) {
        let spinnerComponent = component.find('spinner');
        spinnerComponent.turnOn();
    },
    hideSpinner: function (component) {
        let spinnerComponent = component.find('spinner');
        spinnerComponent.turnOff();
    },
})