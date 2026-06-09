/**
 * Created by Jamal on 6/8/2026.
 */

public with sharing class StringListTest {


    public static List<String> generateStringList(Integer listlength)
    {
        List<String> randomstrings = new List<String>();
        for (Integer i = 0; i < listlength; i++)
        {
            randomstrings.add('Test '+i);
            System.debug('In generateStringList method: String '+i+': '+randomstrings[i]);
        }
        return randomstrings;
    }
}