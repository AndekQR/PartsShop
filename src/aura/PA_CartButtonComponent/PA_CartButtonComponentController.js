({
    refreshData: function(component, event, helper) {
        helper.setAllCartProducts(component);
        helper.setCartPriceSum(component);
    },

    navigateToCart: function(component, event, helper) {
        let navigation = component.find('navigation');
        navigation.navigateToCart();
    },
})