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
                console.log(JSON.parse(JSON.stringify(returnValue)));
                this.setPaginationData(component, returnValue);
                this.formatDates(component);
            } else {
                this.getNotificationHandler(component).handleActionError(response);
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
                element.CreatedDate = $A.localizationService.formatDateTime(element.createdDate);
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
                this.getNotificationHandler(component).showSuccessToast('Review successfully added.');
                component.set('v.newReviewContent', '');
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },

    getNotificationHandler: function(component) {
        return component.find('notificationHandler');
    }
})