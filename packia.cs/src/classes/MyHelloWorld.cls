public class MyHelloWorld {
   public MyHelloWorld(){
   
     List<Contact> con = [select id from contact limit 1000];
     System.debug('Con@@@@@@@::' + con);
     

     utilclass ut = new utilclass();
     ut.getMyInfo();
     //System.debug('@@@@@@@@@@@@@@@  i:' + loopi);
     //System.debug('@@@@@@@@@@@@@@@  i:' + loopJ);
   }
}