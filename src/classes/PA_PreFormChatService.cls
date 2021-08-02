public with sharing class PA_PreFormChatService {

    public class TranscriptInput {
        @InvocableVariable(required = true)
        public Id routableId;
    }

    public class VisitorData {
        @InvocableVariable(required = true)
        public String firstName;
        @InvocableVariable(required = true)
        public String lastName;
        @InvocableVariable(required = true)
        public String email;
    }

    @InvocableMethod(label='Get User Data')
    public static List<VisitorData> getUserData(List<TranscriptInput> transcriptInputs) {
        List<VisitorData> data = new List<VisitorData>();
        for (TranscriptInput transcriptInput : transcriptInputs) {
            List<LiveChatTranscript> liveChatTranscripts = [
                    SELECT Id, FirstName__c, LastName__c, Email__c
                    FROM LiveChatTranscript
                    WHERE Id = :transcriptInput.routableId
            ];
            VisitorData visitorData = new VisitorData();
            visitorData.firstName = liveChatTranscripts.get(0).FirstName__c;
            visitorData.lastName = liveChatTranscripts.get(0).LastName__c;
            visitorData.email = liveChatTranscripts.get(0).Email__c;
            data.add(visitorData);
        }
        return data;
    }
}