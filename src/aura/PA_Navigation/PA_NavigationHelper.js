({
    navigate: function(url) {
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            url: url
        });
        urlEvent.fire();
    }
})