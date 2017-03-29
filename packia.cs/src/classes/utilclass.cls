public class utilclass{

   public void getMyInfo(){
      List<Account> acc = [select id from Account limit 1000];
      System.debug('Accounts::::' + acc);
      System.debug('Hello World');
      
     boolean exitloop = false;
     integer loopI = 0;
     integer loopJ=0;
     for(integer i=0;(i<=10000  && exitloop==false);i++){
       for(integer j=i;(j<=10000 && exitloop==false);j++){
         System.debug('i=' + i + '----j=' + j);
         //System.debug('-------------------::::' + System.Limits.getCpuTime());
         if(System.Limits.getCpuTime()>=14999){
           //exitloop = true;
           loopI=i;
           loopJ=j;
         }
       }
     }
   }
  
}