trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert, after insert, before delete) {
	/*if (Trigger.isBefore) {
		if (Trigger.isInsert) {
			ContentDocumentLinkTriggerHandler.handleBeforeInsert(Trigger.New);
		} else if (Trigger.isUpdate) {
			ContentDocumentLinkTriggerHandler.handleBeforeUpdate(Trigger.New, Trigger.oldMap);
		}  else if (Trigger.isDelete) {
			ContentDocumentLinkTriggerHandler.handleBeforeDelete(Trigger.Old, Trigger.oldMap);
		}
	}
	*/

	if (Trigger.isAfter ) {
		if (Trigger.isInsert) {
			ContentDocumentLinkTriggerHandler.handleAfterInsert(Trigger.New, Trigger.newMap);
		}
	}
    if (Trigger.isBefore) {
        if (Trigger.isDelete) {
            ContentDocumentLinkTriggerHandler.handleBeforeDelete(Trigger.New, Trigger.oldMap);
        }
    }
}