public with sharing class PA_UserDiscountNotifier implements Database.Batchable<sObject>, Database.Stateful {

    private PA_Discount discount { get; set; }
    private List<String> productsIds { get; set; }
    private Set<String> usersEmails { get; set; }

    public PA_UserDiscountNotifier(PA_Discount discount, List<String> productsIds, List<String> usersEmails) {
        this.discount = discount;
        this.productsIds = productsIds;
        Set<String> emails = new Set<String>();
        emails.addAll(usersEmails);
        this.usersEmails = emails;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        if (usersEmails == null || usersEmails.isEmpty()) {
            return Database.getQueryLocator('SELECT Id, Product__r.Id, Product__r.Name, CreatedBy.Name, CreatedBy.Email ' +
                    'FROM FavoriteProduct__c ' +
                    'WHERE Product__c IN :productsIds');
        }
        return Database.getQueryLocator('SELECT Id, Product__r.Id, Product__r.Name, CreatedBy.Name, CreatedBy.Email ' +
                'FROM FavoriteProduct__c ' +
                'WHERE CreatedBy.Email IN :usersEmails AND Product__c IN :productsIds');
    }

    public void execute(Database.BatchableContext BC, List<SObject> objects) {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate template = [
                SELECT Id, HtmlValue, Subject
                FROM EmailTemplate
                WHERE Name = 'New Discount Template'
                LIMIT 1
        ];
        if (template != null) {
            for (FavoriteProduct__c favoriteProduct : (List<FavoriteProduct__c>) objects) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String>{
                        favoriteProduct.CreatedBy.Email
                });
                String htmlBody = String.format(template.HtmlValue, new List<String>{
                        favoriteProduct.CreatedBy.Name,
                        favoriteProduct.Product__r.Name,
                        discount.size + '%',
                        discount.startDate.format(),
                        discount.endDate.format(),
                        System.Label.partsshop_community_base_address + 'product-detail?productId=' + favoriteProduct.Product__r.Id
                });
                mail.setHtmlBody(htmlBody);
                String subject = String.format(template.Subject, new List<String>{
                        favoriteProduct.CreatedBy.Name
                });
                mail.setSubject(subject);
                mails.add(mail);
            }
        }
        Messaging.sendEmail(mails);
    }

    public void finish(Database.BatchableContext BC) {}
}