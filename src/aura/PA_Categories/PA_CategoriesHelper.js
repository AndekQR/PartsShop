({
    setAllCategories: function(component) {
        let action = component.get('c.getAllProductCategories');
        action.setCallback(this, (response) => {
            let state = response.getState();
            if(state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                component.set('v.categories', returnValue);
            } else {
                this.handleError(response);
            }
        });
        $A.enqueueAction(action);
    },

    handleError: function (response) {
        let errors = response.getError();
        if (errors) {
            if (errors[0] && errors[0].message) {
                console.error("Error message: " +
                    errors[0].message);
            }
        } else {
            console.error("Unknown error");
        }
    },

    fireCategoryChangeEvent: function(component, event) {
        this.removeHighlight(component);
        this.highlightClickedLi(event);
        let categoryId = event.currentTarget.dataset.id;
        let categoryEvent = component.getEvent('PA_CategoryChange');
        categoryEvent.setParams({
            categoryId: categoryId
        });
        categoryEvent.fire();
    },

    highlightClickedLi: function(event) {
        let clickedLi = event.target;
        $A.util.addClass(clickedLi, 'categoryContainer__list__element-active');
    },

    removeHighlight: function(component) {
        let cmps = document.getElementsByClassName("categoryContainer__list__element-active");
        for (let i = 0; i < cmps.length; i++) {
            $A.util.removeClass(cmps[i], 'categoryContainer__list__element-active');
        }
    }
})