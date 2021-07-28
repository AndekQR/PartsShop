global class AutocreatedRegHandler1627459352860 implements Auth.RegistrationHandler {
    global User createUser(Id portalId, Auth.UserData data) {
        if (data.attributeMap.containsKey('sfdc_networkid')) {
            Account a = [
                    SELECT Id
                    FROM account
                    WHERE Name = 'PartsShop'
            ];
            Contact c = new Contact();
            c.accountId = a.Id;
            c.email = data.email;
            c.firstName = data.firstName;
            c.lastName = data.lastName;
            insert(c);

            User u = new User();
            Profile p = [
                    SELECT Id
                    FROM profile
                    WHERE Name = 'PartsShop User'
            ];
            u.username = data.email;
            u.email = data.email;
            u.lastName = data.lastName;
            u.firstName = data.firstName;
            String alias = data.username;
            if (alias.length() > 8) {
                alias = alias.substring(0, 8);
            }
            u.alias = alias;
            u.languagelocalekey = UserInfo.getLocale();
            u.localesidkey = UserInfo.getLocale();
            u.emailEncodingKey = 'UTF-8';
            u.timeZoneSidKey = 'America/Los_Angeles';
            u.profileId = p.Id;
            u.contactId = c.Id;
            return u;
        } else {
            User u = new User();
            Profile p = [
                    SELECT Id
                    FROM profile
                    WHERE name = 'Standard User'
            ];
            u.username = data.email;
            u.email = data.email;
            u.lastName = data.lastName;
            u.firstName = data.firstName;
            String alias = data.username;
            if (alias.length() > 8) {
                alias = alias.substring(0, 8);
            }
            u.alias = alias;
            u.languagelocalekey = UserInfo.getLocale();
            u.localesidkey = UserInfo.getLocale();
            u.emailEncodingKey = 'UTF-8';
            u.timeZoneSidKey = 'America/Los_Angeles';
            u.profileId = p.Id;
            return u;
        }
    }

    global void updateUser(Id userId, Id portalId, Auth.UserData data) {
        User u = new User(id = userId);
        //TODO: Customize the username. Must be 80 characters or less.
        //u.username = data.username + '@myorg.com';
        u.email = data.email;
        u.lastName = data.lastName;
        u.firstName = data.firstName;
        //String alias = data.username;
        //Alias must be 8 characters or less
        //if(alias.length() > 8) {
        //alias = alias.substring(0, 8);
        //}
        //u.alias = alias;
        update(u);
    }
}