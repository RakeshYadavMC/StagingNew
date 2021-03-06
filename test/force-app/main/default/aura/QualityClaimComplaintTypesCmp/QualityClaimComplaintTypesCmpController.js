({
    init: function(component, event, helper) {
        helper.init(component, event, helper);
        component.set('v.isBeamInternal', helper.isBeamInternalUser(component,event, helper));
    },
    handleNavigate: function(component, event, helper) {
        var isPageValid = helper.isPageValid(component, event, helper);
        if (!isPageValid) {
            helper.showToast('Invalid Fields', 'Error', 'error');
        }else{
        	helper.navigateToPage(component,event, helper);
        }
        
    },
})