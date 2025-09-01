CREATE OR REPLACE PACKAGE Sys IS
  TYPE LookupPackageCharge_Rec IS RECORD (
  -- LookupPackageCharge : begin -----------------------------------------------
    ItmCode        ItemChg.ItmCode%TYPE,
    PkgCode        ItemChg.PkgCode%TYPE,
    AcmCode        ItemChg.AcmCode%TYPE,
    ItcType        ItemChg.ItcType%TYPE,
    ItcAmt1        ItemChg.ItcAmt1%TYPE,
    ItcAmt2        ItemChg.ItcAmt2%TYPE,
    ItcAmt3        ItemChg.ItcAmt1%TYPE,
    ItcAmt4        ItemChg.ItcAmt2%TYPE,
    CpsId          ItemChg.CpsId%TYPE,
    CpsPct         ItemChg.CpsPct%TYPE,
    ItmName        Item.ItmName%TYPE,
    ItmCName       Item.ItmCName%TYPE,
    ItmCat         Item.ItmCat%TYPE,
    ItmType        Item.ItmType%TYPE,
    ItmRlvl        Item.ItmRlvl%TYPE
  -- LookupPackageCharge : end -------------------------------------------------
  );

  TYPE LookupCharge_Rec IS RECORD (
  -- LookupCharge : begin ------------------------------------------------------
    PkgCode        SlipTx.PkgCode%TYPE,
    ItmCode        SlipTx.ItmCode%TYPE,
    ItmCat         Item.ItmCat%TYPE,
    ItmType        SlipTx.ItmType%TYPE,
    StnOAmt        SlipTx.StnOAmt%TYPE,
    StnBAmt        SlipTx.StnBAmt%TYPE,
    StnDisc        SlipTx.StnDisc%TYPE,
    StnTDate       SlipTx.StnTDate%TYPE,
    DocCode        SlipTx.DocCode%TYPE,
    StnDesc        SlipTx.StnDesc%TYPE,
    AcmCode        SlipTx.AcmCode%TYPE,
    StnDIFlag      SlipTx.StnDIFlag%TYPE,
    StnCpsFlag     SlipTx.StnCpsFlag%TYPE,
    Unit           SlipTx.Unit%TYPE,
    StnRlvl        SlipTx.StnRlvl%TYPE,
    GlcCode        SlipTx.GlcCode%TYPE
  -- LookupCharge : end --------------------------------------------------------
  );

  TYPE NewConPceChange_Rec IS RECORD (
  -- NewConPceChange : begin ---------------------------------------------------
	StnID        SlipTx.StnID%TYPE,
	StnSeq       SlipTx.StnSeq%TYPE,
	PkgCode      SlipTx.PkgCode%TYPE,
	ItmCode      SlipTx.ItmCode%TYPE,
	StnCPSFlag   SlipTx.StnCPSFlag%TYPE,
	Stndesc      SlipTx.Stndesc%TYPE,
	ItmType      SlipTx.ItmType%TYPE,
	StnBAmt      SlipTx.StnBAmt%TYPE,
	firstStnBAmt SlipTx.StnBAmt%TYPE,
	StnDisc      SlipTx.StnDisc%TYPE,
	oldBAmt      SlipTx.StnBAmt%TYPE,
	oldDisc      SlipTx.StnDisc%TYPE,
	newAcmCode   SlipTx.AcmCode%TYPE,
	newOAmt      SlipTx.StnOAmt%TYPE,
	newBAmt      SlipTx.StnBAmt%TYPE,
	newDisc      SlipTx.StnDisc%TYPE,
	newCPSFlag   VARCHAR2(2),
	newGlcCode   SlipTx.GlcCode%TYPE,
	Unit         SlipTx.Unit%TYPE,
	Glccode      SlipTx.GlcCode%TYPE
  -- NewConPceChange : end -----------------------------------------------------
  );
end;
/

DROP TYPE LookupCharge_Tab;
CREATE OR REPLACE TYPE LookupCharge_Obj IS OBJECT (
  -- LookupCharge : begin ------------------------------------------------------
    PkgCode        VARCHAR2(10),
    ItmCode        VARCHAR2(10),
    ItmCat         VARCHAR2(1),
    ItmType        VARCHAR2(1),
    StnOAmt        FLOAT(126),
    StnBAmt        FLOAT(126),
    StnDisc        FLOAT(126),
    StnTDate       DATE,
    DocCode        VARCHAR2(10),
    StnDesc        VARCHAR2(80),
    AcmCode        VARCHAR2(10),
    StnDIFlag      VARCHAR2(2),
    StnCpsFlag     VARCHAR2(1),
    CpsId          NUMBER(22),
    CpsPct         FLOAT(126),
    Unit           NUMBER(10),
    StnDesc1       VARCHAR2(80),
    IRefNo         VARCHAR2(90),
    StnRlvl        NUMBER(22),
    GlcCode        VARCHAR2(8)
  -- LookupCharge : end --------------------------------------------------------
  );
/

CREATE OR REPLACE TYPE LookupCharge_Tab IS TABLE OF LookupCharge_Obj;
/

DROP TYPE NewConPceChange_Tab;
CREATE OR REPLACE TYPE NewConPceChange_Obj IS OBJECT (
  -- NewConPceChange : begin ---------------------------------------------------
    StnID        NUMBER(22),
    StnSeq       NUMBER(22),
    PkgCode      VARCHAR2(10),
    ItmCode      VARCHAR2(10),
    StnCPSFlag   VARCHAR2(1),
    Stndesc      VARCHAR2(80),
    ItmType      VARCHAR2(1),
    StnBAmt      FLOAT(126),
    firstStnBAmt FLOAT(126),
    StnDisc      FLOAT(126),
    oldBAmt      FLOAT(126),
    oldDisc      FLOAT(126),
    newAcmCode   VARCHAR2(10),
    newOAmt      FLOAT(126),
    newBAmt      FLOAT(126),
    newDisc      FLOAT(126),
    newCPSFlag   VARCHAR2(2),
    newGlcCode   VARCHAR2(8),
    Unit         NUMBER(10),
    Glccode      VARCHAR2(8)
  -- NewConPceChange : end -----------------------------------------------------
  );
/

CREATE OR REPLACE TYPE NewConPceChange_Tab IS TABLE OF NewConPceChange_Obj;
/
