/****************************************************************************/
/*            (c) Copyright Black Ice Software Inc.  1994.                  */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/*                                                                          */
/****************************************************************************/
#ifndef _PARSER_INCLUDE_
#define _PARSER_INCLUDE_

//--> Generic Parse Event <-------------------------------------------

class TCParseEvent
 {
  protected:
   char     m_chrCommand;

  public:
                TCParseEvent( const char);
   virtual	    ~TCParseEvent( void) {};
   int          Check( istream&);
   virtual int  Process( istream&, ostream&);
 };

class TCParseEventString
 : public TCParseEvent
 {
  protected:
   char*    m_string;

  public:
   TCParseEventString( const char, const char* = NULL);
   ~TCParseEventString( void);
   int Process( istream&, ostream&);
 };

//--> Different Parse Events <----------------------------------------

#ifdef _WIN32
class TCParseEventDate
 : public TCParseEvent
 {
  public:
   TCParseEventDate( void) : TCParseEvent( 'd') {};
   int Process( istream&, ostream&);
 };

class TCParseEventDateLong
 : public TCParseEvent
 {
  public:
   TCParseEventDateLong( void) : TCParseEvent( 'D') {};
   int Process( istream&, ostream&);
 };

class TCParseEventTime
 : public TCParseEvent
 {
  public:
   TCParseEventTime( void) : TCParseEvent( 't') {};
   int Process( istream&, ostream&);
 };

class TCParseEventTime24h
 : public TCParseEvent
 {
  public:
   TCParseEventTime24h( void) : TCParseEvent( 'T') {};
   int Process( istream&, ostream&);
 };
#endif // _WIN32

//--> Generic Parser <------------------------------------------------

class TCParser
 {
  protected:
   char             m_chrEscape;
   TCParseEvent **  m_pEvent;
   int              m_nEvent;

   void        AddEvent( TCParseEvent*);
   void        RemoveEvent( int);
   void        RemoveEvent( TCParseEvent*);
   int         Check( istream&);

  public:
   TCParser( const char);
   ~TCParser( void);
   void Parse( istream&, ostream&);
   void Parse( const char*, char*);
 };

//--> Fax Header Parser <---------------------------------------------

class TCParseHeader
  : public TCParser
 {
  protected:

  public:
   TCParseHeader( const char*, int = 0, int = 0);
   ~TCParseHeader( void);
 };

class TCParseOCXHeader
  : public TCParser
 {
  protected:

  public:
   TCParseOCXHeader( const char*);
   ~TCParseOCXHeader( void);
 };

#endif // _PARSER_INCLUDE_