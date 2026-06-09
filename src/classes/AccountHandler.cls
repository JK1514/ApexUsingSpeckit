/**
 * Created by Jamal on 6/8/2026.
 */

public with sharing class AccountHandler {
 public static Account insertNewAccount(String acctName)
 {

     Account newAcct;
     try
     {
         if (String.isNotBlank(acctName))
         {

             //Make sure you instatiate the newAcct variable.
             //Secondly ensure that the field 'Name' is mentioned in the constructor so that SF knows
             //what field is being set to get the acctName variable.
             newAcct = new Account(Name=acctName);
             insert newAcct;
         }
         else {
             return null;
         }

     } catch (Exception e)
     {
         System.debug('An error occurred while inserting the account: ' + e.getMessage());
         return null;
     }
     return newAcct;
  }
 }