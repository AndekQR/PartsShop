({
    setReviews: function (component) {
        let pageNumber = component.get('v.pageNumber');
        let pageSize = component.get('v.pageSize');
        let productId = component.get('v.productId');
        let action = component.get('c.getReviews');
        action.setParams({
            productId: productId,
            page: pageNumber,
            pageSize: pageSize
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                this.setPaginationData(component, returnValue);
                this.formatDates(component);
            } else {
                this.handleError(response);
            }
        });
        $A.enqueueAction(action);
    },

    setPaginationData: function (component, returnValue) {
        component.set('v.reviews', returnValue.data);
        component.set('v.allDataSize', returnValue.allProductsSize);
        this.setAllPageSize(component);
    },

    formatDates: function (component) {
        let allReviews = component.get('v.reviews');
        if (allReviews !== null) {
            allReviews.forEach(element => {
                element.CreatedDate = $A.localizationService.formatDateTime(element.CreatedDate);
            })
        }
        component.set('v.reviews', allReviews);
    },

    setAllPageSize: function (component) {
        let pageSize = component.get('v.pageSize');
        let allDataSize = component.get('v.allDataSize');
        let number = (Math.ceil(allDataSize / pageSize));
        if (number < 0) {
            component.set('v.allPageSize', 0);
        } else {
            component.set('v.allPageSize', number);
        }
    },

    setFirstPage: function (component) {
        component.set('v.pageNumber', 1);
        this.setReviews(component);
    },

    setLastPage: function (component) {
        let allPageSize = component.get('v.allPageSize');
        component.set('v.pageNumber', (allPageSize));
        this.setReviews(component);
    },

    setNextPage: function (component) {
        let pageNumber = component.get('v.pageNumber');
        let allPageSize = component.get('v.allPageSize');
        if (pageNumber < allPageSize) {
            component.set('v.pageNumber', (pageNumber + 1));
            this.setReviews(component);
        }
    },

    setPreviousPage: function (component) {
        let pageNumber = component.get('v.pageNumber');
        if (pageNumber > 1) {
            component.set('v.pageNumber', (pageNumber - 1));
            this.setReviews(component);
        }
    },

    showToast: function (title, message, type) {
        let resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        resultsToast.fire();
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

    saveReview: function (component) {
        let content = component.get('v.newReviewContent');
        let rating = component.get('v.newReviewRating');
        let productId = component.get('v.productId');
        let action = component.get('c.saveReview');
        action.setParams({
            content: content,
            productId: productId,
            rating: rating
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                this.setReviews(component);
                this.showToast('Saved', 'Review successfully added.', 'success');
                component.set('v.newReviewContent', '');
            } else {
                this.handleError(response);
            }
        });
        $A.enqueueAction(action);
    }
})