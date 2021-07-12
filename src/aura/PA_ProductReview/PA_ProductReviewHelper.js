({
    setReviews: function(component) {
        let productId = component.get('v.productId');
        let action = component.get('c.getReviews');
        action.setParams({
            'productId': productId
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if(state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                component.set('v.reviews', returnValue);
                this.formatDates(component);
            } else {
                console.log('save error');
            }
        });
        $A.enqueueAction(action);
    },

    formatDates: function(component) {
        let allReviews = component.get('v.reviews');
        if(allReviews != null) {
            allReviews.forEach(element => {
                element.CreatedDate = $A.localizationService.formatDateTime(element.CreatedDate);
            })
        }
        component.set('v.reviews', allReviews);
    },

    setAllPageSize: function (component) {
        let pageSize = component.get('v.pageSize');
        let objects = component.get('v.reviews');
        let number = (Math.ceil(objects.length / pageSize))-1;
        if(number < 0) {
            component.set('v.allPageSize', 0);
        } else {
            component.set('v.allPageSize', number);
        }
    },

    setFirstPage: function (component) {
        let objects = component.get('v.reviews');
        let pageSize = component.get('v.pageSize');
        this.setAllPageSize(component);
        if (objects.length <= pageSize) {
            component.set('v.objects_page', objects);
        } else {
            component.set('v.objects_page', objects.slice(0, pageSize));
        }
        component.set('v.pageNumber', 0);
    },

    setLastPage: function(component) {
        let objects = component.get('v.reviews');
        let allPageSize = component.get('v.allPageSize');
        let pageSize = component.get('v.pageSize');

        let from = (allPageSize ) *pageSize;
        let to = (allPageSize + 1) * pageSize;
        component.set('v.objects_page', objects.slice(from, to));
        component.set('v.pageNumber', (allPageSize));
    },

    setNextPage: function (component) {
        let objects = component.get('v.reviews');
        let pageNumber = component.get('v.pageNumber');
        let pageSize = component.get('v.pageSize');
        let allPageSize = component.get('v.allPageSize');

        if (pageNumber < allPageSize) {
            let from = (pageNumber + 1) *pageSize;
            let to = (pageNumber + 2) * pageSize;
            component.set('v.objects_page', objects.slice(from, to));
            component.set('v.pageNumber', (pageNumber + 1));
        }
    },

    setPreviousPage: function (component) {
        let objects = component.get('v.reviews');
        let pageNumber = component.get('v.pageNumber');
        let pageSize = component.get('v.pageSize');

        if(pageNumber > 0) {
            let from = (pageNumber - 1) * pageSize;
            let to = pageSize * pageNumber;
            component.set('v.objects_page', objects.slice(from, to));
            component.set('v.pageNumber', (pageNumber - 1));
        }
    }

})