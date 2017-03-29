public class CreateAppraisalFromPortalController {

  public case c {get;set;}
  public String caseId {get;set;}
  public Boolean isEdit {get;set;}
  public String recordType {get;set;}
  public String recordTypeName {get;set;}
  public string ToCustomer{get;set;}
  public string ToCreditUnion{get;set;}
  public Boolean isAccess{get;set;}
  public String OldStatus{get;set;}
  public String OldReasonCode{get;set;}

  
  public Boolean EnableSection{get;set;} //SP*
  public Set<String> ProfileSets = new Set<String>{'Consumer Community User','Credit Union Community User'}; //SP*
  
    public CreateAppraisalFromPortalController(ApexPages.StandardController controller) {
      isEdit = false;
      isAccess = true;

      
      c = new Case();
      caseId = ApexPages.currentPage().getParameters().get('id');
      if(caseId != null){
          string cid = String.escapeSingleQuotes(caseId);
          c = [Select Id, IsDeleted, CaseNumber, ContactId, AccountId, AssetId, ParentId, SuppliedName, SuppliedEmail, SuppliedPhone, SuppliedCompany, Type, Status, Reason, Origin, Subject, Priority, Description, IsClosed, ClosedDate, IsEscalated, HasCommentsUnreadByOwner, HasSelfServiceComments, OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, ContactPhone, ContactMobile, ContactEmail, ContactFax, LastViewedDate, LastReferencedDate, EngineeringReqNumber__c, SLAViolation__c, Product__c, PotentialLiability__c, Case_Number__c, Case_Narrative__c, Support_Order_No__c, No_Of_Children_for_Paternity__c, Customer_emoticon__c, Customer_emoticon_value__c, pkbgeolocalization__Latitude__s, pkbgeolocalization__Longitude__s, pkbgeolocalization__c FROM Case   WHERE Id =: cid];
            
         OldStatus = c.Status;
           
        
          
      
       //SP*   
          Id profileId=userinfo.getProfileId();
          String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
          system.debug('##ProfileName'+profileName); 
          if(ProfileSets.contains(profileName))
            {
                EnableSection = False;
                System.debug('##EnableSection' +EnableSection );
            }else{
                EnableSection = True;
                System.debug('##EnableSection' +EnableSection );
            }
            
        //SP*  

        //Sirisha
            if(profileName == 'Credit Union Community User' || profileName == 'Consumer Community User'){
                isAccess = false;
            }
            if(isAccess){
                //ToCustomer = 'id='+c.Id+'&EmailSubject=Case+Number+'+c.CaseNumber+'+ : +'+c.Reference_Thread_Id__c+'&EmailFromId=0D2r0000000004h&EmailToId='+c.ContactId+'&_emailAdditionalTo='+c.Email__c+'&SelectTemplates=1';
                //ToCreditUnion = 'id='+c.Id+'&EmailSubject=Case+Number+'+c.CaseNumber+'+ : +'+c.Reference_Thread_Id__c+'&EmailFromId=0D2r0000000004h&EmailToId='+c.Credit_Union_Email_Account__c+'&_emailAdditionalTo='+c.Credit_Union_Email_Account__c+'&SelectTemplates=1';

            }
        //sirisha
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
        List<RecordType> recType = [SELECT Id, Name, DeveloperName, isActive FROM RecordType WHERE sObjectType = 'Case' AND isActive = true AND Name = 'Complaint'];
        options.add(new SelectOption(recType[0].DeveloperName, recType[0].Name));
         recType = [SELECT Id, Name, DeveloperName, isActive FROM RecordType WHERE sObjectType = 'Case' AND isActive = true AND Name != 'Complaint'];
        
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
            //newPage = new PageReference('/'+prefix+'/e?noovverride=1&RecordType='+rt.Id);
            //newPage = new PageReference('/500/e?retURL=%2F500%2Fo&RecordType='+rt.Id+'&ent=Case');
           newPage = new PageReference('/apex/Create_Appraisal_Form');
           newPage.getParameters().put('nooverride', '1');    

        }
        if(recordType == 'Complaint_Case'){
           newPage = new PageReference('/500/e');
           newPage.getParameters().put('nooverride', '1');
           newPage.getParameters().put('retURL', '/500/o');  
           newPage.getParameters().put('RecordType', rt.Id);  
        }
        if(recordType == 'Inquiry'){
           newPage = new PageReference('/500/e');
           newPage.getParameters().put('nooverride', '1');
           newPage.getParameters().put('retURL', '/500/o');  
           newPage.getParameters().put('RecordType', rt.Id);
        }
        return newPage;
    }
 /**************** Cancel ****************/
    public pageReference cancel(){
        PageReference pageRef = new PageReference('/500/o');
        return pageRef;
    }
/**************** Save() ****************/   
   public PageReference save() {
   RecordType rtId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Appraisal_Complaint' LIMIT 1];   
   String typeId = rtId.Id;
   Case createCase = new Case();
    //createCase.First_Name__c = c.First_Name__c;
    //createCase.Last_Name__c = c.Last_Name__c;
    //createCase.Email__c = c.Email__c;
    //createCase.Phone_Number__c = c.Phone_Number__c;
    /*createCase.Address__c = c.Address__c;
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
    createCase.Request_Q_A__c = c.Request_Q_A__c;
    createCase.Status = c.Status;
    createCase.Q_A_Approved__c = c.Q_A_Approved__c;
    createCase.Reason_Code__c = c.Reason_Code__c;
    createCase.Analyst__c = c.Analyst__c;   
    createCase.Legacy_Case_Number__c = c.Legacy_Case_Number__c; 
    createCase.Stage_2_QA_Request__c = c.Stage_2_QA_Request__c;
    createCase.Case_Resolution_QA__c = c.Case_Resolution_QA__c;
    createCase.Stage_2_Determination_QAApproved__c = c.Stage_2_Determination_QAApproved__c;
    createCase.Appealed__c = c.Appealed__c;
    createCase.Violation__c = c.Violation__c;
    createCase.CFR_Citation__c = c.CFR_Citation__c;
    createCase.Stage_2_Programm_Officer_Approved__c = c.Stage_2_Programm_Officer_Approved__c;
    createCase.Appealed_Date__c = c.Appealed_Date__c;
    if(c.id <> null)createCase.ownerid = c.ownerid;
    createCase.RecordTypeId = rtId.Id;
    if(c.id <> null)createCase.Id = c.Id;
    
    //Sirisha update 16th july 15
    //Exception handling for blank Analyst

    if(createCase.Request_Q_A__c)
    {       
        if(createCase.Analyst__c == null){  
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please fill analyst'));
            return null;
        }
        
    }

    if(createCase.Stage_2_QA_Request__c)
    {       
        if(createCase.Analyst__c == null){  
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please fill analyst'));
            return null;
        }
        
    }

    if(c.id <> null && (createCase.Status <> OldStatus) && (createCase.Reason_Code__c == OldReasonCode)){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select the Reason Code when you want to change the Internal Status'));
        return null;
    }
    */
    try{
    upsert createCase;
    isEdit = false;
    }catch(Exception  e){ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));}
      
     if(caseId == null){
         //PageReference pageRef = new PageReference('/apex/Appraisal_Form_View?id='+createCase.Id);
         PageReference pageRef = new PageReference('/500/o');
         return pageRef;
     } 
        return null;
    }
    
 //  
 public pagereference Redirect()
{
     If(ApexPages.currentPage().getParameters().get('RecordType') != '0123500000005xD')
     {
           String hostname = ApexPages.currentPage().getHeaders().get('Host'); 
           String optyURL2 = 'https://'+hostname+'/'+'/00Q/e?nooverride=1';
           pagereference pageref = new pagereference(optyURL2);
           pageref.setredirect(true);
           return pageref;
     }
     else
          return null;
}

}