({
    init: function (component, event, helper) {
        helper.setFirstPage(component);
    },

    change: function (component, event, helper) {
        helper.setFirstPage(component);
    },

    onSave: function (component, event, helper) {
        let content = component.get('v.newReviewContent');
        let rating = component.get('v.newReviewRating');
        let productId = component.get('v.productId');
        let action = component.get('c.saveReview');
        action.setParams({
            'content': content,
            'productId': productId,
            'rating': rating
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                helper.setReviews(component);
                component.set('v.newReviewContent', '');
                let resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Saved",
                    "message": "Review successfully added.",
                    "type": "success"
                });
                resultsToast.fire();

            } else {
                console.log('save error');
            }
        });
        $A.enqueueAction(action);
    },

    setReviews: function (component, event, helper) {
        helper.setReviews(component);
    },

    nextPage: function (component, event, helper) {
        helper.setNextPage(component);
    },

    previousPage: function (component, event, helper) {
        helper.setPreviousPage(component);
    },

    firstPage: function (component, event, helper) {
        helper.setFirstPage(component);
    },

    lastPage: function (component, event, helper) {
        helper.setLastPage(component);

    }

})