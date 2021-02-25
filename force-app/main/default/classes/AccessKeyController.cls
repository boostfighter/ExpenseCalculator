public class AccessKeyController {
    @auraEnabled
    public static String mailVerification(String customUserId){
        //------------------generate random number----------------------
        String randomNumber = '';
        Integer len = 5 ;
        String str = string.valueof(Math.abs(Crypto.getRandomLong()));
        randomNumber = str.substring( 0 , len);
        //--------------------------------------------------------------
        
        //-------------------------Send Mail----------------------------
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        ETSelf__Custom_User__c CU = [Select id,Name,ETSelf__Email__c From ETSelf__Custom_User__c Where Id=:customUserId Limit 1];
        if(CU.ETSelf__Email__c != null && CU.ETSelf__Email__c != ''){
            // Step 1: Create a new Email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            // Step 2: Set list of people who should get the email
            List<String> sendTo = new List<String>();
            sendTo.add(CU.ETSelf__Email__c);
            mail.setToAddresses(sendTo);
            
            // Step 3: Set who the email is sent from
            //mail.setReplyTo('sirdavid@bankofnigeria.com');
            mail.setSenderDisplayName('Access Key Verification');
            
            // (Optional) Set list of people who should be CC'ed
            //List<String> ccTo = new List<String>();
            //ccTo.add('business@bankofnigeria.com');
            //mail.setCcAddresses(ccTo);
            
            // Step 4. Set email contents - you can use variables!
            mail.setSubject('Access Key Verification');
            String body = randomNumber;
            mail.setHtmlBody(body);
            
            mails.add(mail);
            
            // Step 5: Send all emails in the master list
            Messaging.sendEmail(mails);
        }
        //--------------------------------------------------------------
        
        return randomNumber;
    }
    
    
    @auraEnabled
    public static void setAccessKey(String customUserId,String keyValue){
        ETSelf__Custom_User__c CU = [Select id,Name,ETSelf__Access_Key__c From ETSelf__Custom_User__c Where Id=:customUserId Limit 1];
        
        //-----------------------------------Access Code Encoding-----------------------------------
        // Generate an AES key for the purpose of this sample. 
        // Normally this key should be stored in a protected custom setting 
        // or an encrypted field on a custom object
        //Blob cryptoKey = Crypto.generateAesKey(256);//128, 192, or 256
        String keyString = 'MG6+kr7jRH9CIA/FPx0ZcUg/BiPF7j23kw5Yujp7daM=';
        Blob cryptoKey = EncodingUtil.base64decode(keyString);
        
        // Generate the data to be encrypted.
        Blob data = Blob.valueOf(keyValue);
        
        // Encrypt the data and have Salesforce.com generate the initialization vector
        Blob encryptedData = Crypto.encryptWithManagedIV('AES256', cryptoKey, data);
        
        //Encrypted key convert to string
        String encryptedString = EncodingUtil.base64encode(encryptedData);
        
        CU.ETSelf__Access_Key__c = encryptedString;
        Update CU;
        
        /*
        // Decrypt the data - the first 16 bytes contain the initialization vector
        Blob decryptedData = Crypto.decryptWithManagedIV('AES256', cryptoKey, encryptedData);
        
        // Decode the decrypted data for subsequent use
        String decryptedDataString = decryptedData.toString();
        
        //String encryptedString = EncodingUtil.base64encode(encryptedData);
        //Blob base64 = EncodingUtil.base64decode(encryptedString);
        */
    }
    
    
    
}