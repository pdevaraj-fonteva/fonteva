public class CreateApprisalFormController{

    public string THANK_URL{get;set;}
    public string LANDING_URL{get;set;}
    
    public case c {get;set;}
    public String caseId {get;set;}
    public Boolean isEdit {get;set;}
    public String recordType {get;set;}
    public String recordTypeName {get;set;}
    
    String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
    Pattern MyPattern = Pattern.compile(emailRegex);

    public CreateApprisalFormController(ApexPages.StandardController controller) {
      
    }
    
    public CreateApprisalFormController() {
        //THANK_URL = CreditUnionUtility.getURL('Thanks');
        //LANDING_URL = CreditUnionUtility.getURL('Landing');
        isEdit = false;
        c = new Case();
        caseId = ApexPages.currentPage().getParameters().get('id');
        if(caseId != null){
            String cid = String.escapeSingleQuotes(caseId);
              //c = [SELECT Id, RecordTypeId, CaseNumber, First_Name__c, Last_Name__c, Email__c, Phone_Number__c,Individual_Property_Owner__c,Financial_Institution_Lender__c, Mortgage_Broker__c, Appraisal_Management_Company__c, Business_Property_Owner__c, Non_Financial_Institution_Lender__c, Appraisal_report_inaccurate__c, Appraiser__c, Lender__c, Appraiser_independence__c,  Appraisal_fee_related_issue__c, Describe_your_complaint__c, Non_compliance_with_Uniform_Standards_of__c, Improper_or_attempted_improper_influen__c, Removal_or_exclusion_from_an_approved_ap__c, Residential_1_to_4_Family__c, Commercial_or_Multi_Family_over_4_units__c, Address_of_the_Property_Involved__c,If_Yes_date_of_contact__c,At_what_company_or_government_agency__c, Who_did_you_contact__c, Briefly_describe_your_complain_Do_not_s__c,Address__c,Other_whoareyou_check_appropriate_box__c,Appraisal_Management_Company_2__c,Are_you_employed_by_the_subject_of_your__c,Other_AF_Sec3__c,Name_First_Last_Business__c,Phone_AF_Sec4__c,Address_City_State_Zip_Code_AF_Sec4__c,Other_AF_Sec5__c,Type_of_Property__c,Have_you_tried_to_resolve_your_complaint__c    FROM Case WHERE Id =: cid];
              c = [Select Id, IsDeleted,CaseNumber, ContactId, AccountId, AssetId, ParentId, SuppliedName, SuppliedEmail, SuppliedPhone, SuppliedCompany, Type, Status, Reason, Origin, Subject, Priority, Description, IsClosed, ClosedDate, IsEscalated, HasCommentsUnreadByOwner, HasSelfServiceComments, OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, ContactPhone, ContactMobile, ContactEmail, ContactFax, LastViewedDate, LastReferencedDate, EngineeringReqNumber__c, SLAViolation__c, Product__c, PotentialLiability__c, Case_Number__c, Case_Narrative__c, Support_Order_No__c, No_Of_Children_for_Paternity__c, Customer_emoticon__c, Customer_emoticon_value__c, pkbgeolocalization__Latitude__s, pkbgeolocalization__Longitude__s, pkbgeolocalization__c FROM Case   WHERE Id =: cid];
              //RecordType rt = [SELECT Id, Name, DeveloperName FROM RecordType WHERE Id = :c.RecordTypeId ];
              //System.Debug('Record Type Info :: ' + rt);
              //recordTypeName = rt.DeveloperName;
              //System.Debug('Record Type Name :: ' +recordTypeName);
        }
    }


  
    
   List<Case> caselst = new List<case>();
   
/**************** Edit() ****************/
public pageReference edit(){
         //PageReference pageRef = new PageReference('/apex/Appraisal_Form?id='+caseId);
         return null;
}

/**************** Record Type Selection ****************/
     public List<SelectOption> getRTType(){
        List<SelectOption> options = new List<SelectOption>();
        
        List<RecordType> recType = [SELECT Id, Name, DeveloperName, isActive FROM RecordType WHERE sObjectType = 'Case' AND isActive = true];
        
        for(RecordType rt : recType){
            options.add(new SelectOption(rt.DeveloperName, rt.Name));
        }
        return options;
     }
    public pageReference recordType(){
        system.debug('Record Type ' + recordType);
        PageReference newPage;
        //String prefix = Quote.SObjectType.getDescribe().getKeyPrefix();
        RecordType rt = [SELECT Id FROM RecordType WHERE DeveloperName = :recordType AND sObjectType = 'Case'];
        if(recordType == 'Appraisal_Complaint'){
           refreshPage();
           newPage = new PageReference('/apex/Create_Appraisal_Form');
           newPage.getParameters().put('nooverride', '1');    

        }
        if(recordType == 'Complaint_Case'){
            refreshPage();
           newPage = new PageReference('/500/e');
           newPage.getParameters().put('nooverride', '1');
           newPage.getParameters().put('retURL', '/500/o');  
           newPage.getParameters().put('RecordType', rt.Id);  
        }
        if(recordType == 'Inquiry'){
            refreshPage();
           newPage = new PageReference('/500/e');
           newPage.getParameters().put('nooverride', '1');
           newPage.getParameters().put('retURL', '/500/o');  
           newPage.getParameters().put('RecordType', rt.Id);
        }
        return newPage;
    }
 /**************** Cancel ****************/
    public pageReference cancel(){
        refreshPage();
        PageReference pageRef = new PageReference(LANDING_URL);
        pageref.setredirect(true);
        return pageRef;
    }
/**************** Save() ****************/   
   public PageReference save() {
    
    String EmailString = null; //c.Email__c;
    //validation
    Matcher EmailMatcher = MyPattern.matcher(EmailString);
    if (!EmailMatcher.matches()) {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Email is not correct, please enter correct email'));
        return null;
    }
    
    //if((c.Phone_Number__c <> null && c.Phone_Number__c <> '')){
       // if((c.Phone_Number__c+'').length() != 10){
         //   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Phone Number must be 10 digit number'));
           // return null;
        //}
    //}
    
    
        //try{
            RecordType rtId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Appraisal_Complaint' LIMIT 1];
            
            String typeId = rtId.Id;
            Case createCase = new Case();
            /*createCase.First_Name__c = c.First_Name__c;
            createCase.Last_Name__c = c.Last_Name__c;
            createCase.Email__c = c.Email__c;
            createCase.Phone_Number__c = c.Phone_Number__c;
            createCase.Address__c = c.Address__c;
            createCase.Individual_Property_Owner__c = c.Individual_Property_Owner__c;
            createCase.Financial_Institution_Lender__c = c.Financial_Institution_Lender__c;
            createCase.Mortgage_Broker__c = c.Mortgage_Broker__c;       
            createCase.Appraisal_Management_Company__c = c.Appraisal_Management_Company__c;
            createCase.Business_Property_Owner__c = c.Business_Property_Owner__c;
            createCase.Non_Financial_Institution_Lender__c = c.Non_Financial_Institution_Lender__c;
            createCase.Appraiser__c = c.Appraiser__c;
            createCase.Other_whoareyou_check_appropriate_box__c=c.Other_whoareyou_check_appropriate_box__c; 
            createCase.Appraisal_Management_Company_2__c=c.Appraisal_Management_Company_2__c;
            createCase.Appraisal_Management_Company__c=c.Appraisal_Management_Company__c;
            createCase.Lender__c = c.Lender__c;
            createCase.Are_you_employed_by_the_subject_of_your__c=c.Are_you_employed_by_the_subject_of_your__c;
            createCase.Other_AF_Sec3__c=c.Other_AF_Sec3__c;
            createCase.Name_First_Last_Business__c=c.Name_First_Last_Business__c;
            createCase.Phone_AF_Sec4__c=c.Phone_AF_Sec4__c;
            createCase.Address_City_State_Zip_Code_AF_Sec4__c=c.Address_City_State_Zip_Code_AF_Sec4__c;
            createCase.Appraiser_independence__c = c.Appraiser_independence__c;
            createCase.Appraisal_report_inaccurate__c = c.Appraisal_report_inaccurate__c;
            createCase.Appraisal_fee_related_issue__c = c.Appraisal_fee_related_issue__c;
            createCase.Describe_your_complaint__c = c.Describe_your_complaint__c;
            createCase.Non_compliance_with_Uniform_Standards_of__c = c.Non_compliance_with_Uniform_Standards_of__c;
            createCase.Improper_or_attempted_improper_influen__c = c.Improper_or_attempted_improper_influen__c;
            createCase.Removal_or_exclusion_from_an_approved_ap__c = c.Removal_or_exclusion_from_an_approved_ap__c;
            createCase.Other_AF_Sec5__c=c.Other_AF_Sec5__c;
            createCase.Type_of_Property__c=c.Type_of_Property__c;
            createCase.Have_you_tried_to_resolve_your_complaint__c=c.Have_you_tried_to_resolve_your_complaint__c;
            createCase.Address_of_the_Property_Involved__c = c.Address_of_the_Property_Involved__c;
            createCase.If_Yes_date_of_contact__c = c.If_Yes_date_of_contact__c;
            createCase.At_what_company_or_government_agency__c = c.At_what_company_or_government_agency__c;
            createCase.Who_did_you_contact__c = c.Who_did_you_contact__c;
            createCase.Briefly_describe_your_complain_Do_not_s__c = c.Briefly_describe_your_complain_Do_not_s__c;
            createCase.RecordTypeId = rtId.Id;
            createCase.Id = c.Id;
            */
            upsert createCase;
            isEdit = false;
            
             if(caseId == null){

                refreshPage();
                 pagereference pageref = new pagereference(THANK_URL+'?pmess=comp');
         
                 pageref.setredirect(true);
                 return pageref; 
             }
        //}
        /*catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e+''));
            return null;
        }*/
        return null;
    }
    
    private void refreshPage(){
        isEdit = false;
        c = new Case();
        caseId = ApexPages.currentPage().getParameters().get('id');
        if(caseId != null){
              //c = [SELECT Id, RecordTypeId, CaseNumber, First_Name__c, Last_Name__c, Email__c, Phone_Number__c,Individual_Property_Owner__c,Financial_Institution_Lender__c, Mortgage_Broker__c, Appraisal_Management_Company__c, Business_Property_Owner__c, Non_Financial_Institution_Lender__c, Appraisal_report_inaccurate__c, Appraiser__c, Lender__c, Appraiser_independence__c,  Appraisal_fee_related_issue__c, Describe_your_complaint__c, Non_compliance_with_Uniform_Standards_of__c, Improper_or_attempted_improper_influen__c, Removal_or_exclusion_from_an_approved_ap__c, Residential_1_to_4_Family__c, Commercial_or_Multi_Family_over_4_units__c, Address_of_the_Property_Involved__c,If_Yes_date_of_contact__c,At_what_company_or_government_agency__c, Who_did_you_contact__c, Briefly_describe_your_complain_Do_not_s__c,Address__c,Other_whoareyou_check_appropriate_box__c,Appraisal_Management_Company_2__c,Are_you_employed_by_the_subject_of_your__c,Other_AF_Sec3__c,Name_First_Last_Business__c,Phone_AF_Sec4__c,Address_City_State_Zip_Code_AF_Sec4__c,Other_AF_Sec5__c,Type_of_Property__c,Have_you_tried_to_resolve_your_complaint__c    FROM Case WHERE Id =: caseId];
              c = [Select Id, IsDeleted, CaseNumber, ContactId, AccountId, AssetId, ParentId, SuppliedName, SuppliedEmail, SuppliedPhone, SuppliedCompany, Type, Status, Reason, Origin, Subject, Priority, Description, IsClosed, ClosedDate, IsEscalated, HasCommentsUnreadByOwner, HasSelfServiceComments, OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, ContactPhone, ContactMobile, ContactEmail, ContactFax, LastViewedDate, LastReferencedDate, EngineeringReqNumber__c, SLAViolation__c, Product__c, PotentialLiability__c, Case_Number__c, Case_Narrative__c, Support_Order_No__c, No_Of_Children_for_Paternity__c, Customer_emoticon__c, Customer_emoticon_value__c, pkbgeolocalization__Latitude__s, pkbgeolocalization__Longitude__s, pkbgeolocalization__c FROM Case   WHERE Id =: caseId];
              //RecordType rt = [SELECT Id, Name, DeveloperName FROM RecordType WHERE Id = :c.RecordTypeId ];
              //System.Debug('Record Type Info :: ' + rt);
              //recordTypeName = rt.DeveloperName;
              //System.Debug('Record Type Name :: ' +recordTypeName);
        }
    }

}