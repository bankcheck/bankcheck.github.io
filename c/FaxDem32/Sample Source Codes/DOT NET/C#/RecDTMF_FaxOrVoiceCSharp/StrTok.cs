/*********************************************************
*                                                        *
*  Black Ice RecDTMF_FaxOrVoice C# Sample                *
*                                                        *
*  StrTok.cs                                             *
*                                                        *
*  (c) Copyright Black Ice Software Inc. 1991-2007       *
*                                                        *
*  All Rights Reserved                                   *
*                                                        *
*********************************************************/

using System;

public class CStrTok
{
    static String Stored;

    public static String StrTok(String ScanString,
                                String Token)
    {
        int i, sLen;
        String vCh, OutStr = "";

        if (Token == "") return "";

        if (ScanString != "") Stored = ScanString;

        if (Stored == "") return "";

        if (Stored.Length >= Token.Length)
        {
            if (Stored.Substring(0, Token.Length - 1) == Token)
            {
                Stored = Stored.Substring(Token.Length - 1);
                return "";
            }
        }

        sLen = Stored.Length - 1;

        for (i = 0; i <= sLen; i++)
        {
            vCh = Stored.Substring(i, Token.Length);

            if (vCh == Token)
            {
                if ((i + Token.Length) <= sLen)
                {
                    Stored = Stored.Substring(i + Token.Length);
                    return OutStr;
                }
                else break;
            }
            else
            {
                vCh = Stored.Substring(i, 1);
                OutStr += vCh;
            }
        }

        Stored = "";
        return OutStr;
    }
}