({
    removeResultBox: function (component) {
        let resultBox = component.find('resultBox');
        $A.util.removeClass(resultBox, 'slds-is-open');
    },

    clearSelected: function (component) {
        component.set('v.selectRecordName', '');
        component.set('v.selectRecordId', '');
    },
})