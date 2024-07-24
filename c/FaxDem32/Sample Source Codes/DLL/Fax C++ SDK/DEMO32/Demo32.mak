# Microsoft Developer Studio Generated NMAKE File, Based on Demo32.dsp
!IF "$(CFG)" == ""
CFG=Demo32 - Win32 Release
!MESSAGE No configuration specified. Defaulting to Demo32 - Win32 Release.
!ENDIF 

!IF "$(CFG)" != "Demo32 - Win32 Release" && "$(CFG)" != "Demo32 - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "Demo32.mak" CFG="Demo32 - Win32 Release"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Demo32 - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "Demo32 - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "Demo32 - Win32 Release"

OUTDIR=.\Winrel_b
INTDIR=.\Winrel_b
# Begin Custom Macros
OutDir=.\Winrel_b
# End Custom Macros

ALL : "$(OUTDIR)\Demo32.exe" "$(OUTDIR)\Demo32.bsc"


CLEAN :
	-@erase "$(INTDIR)\ASCII.OBJ"
	-@erase "$(INTDIR)\ASCII.SBR"
	-@erase "$(INTDIR)\BLOCKDOC.OBJ"
	-@erase "$(INTDIR)\BLOCKDOC.SBR"
	-@erase "$(INTDIR)\CFUNC.OBJ"
	-@erase "$(INTDIR)\CFUNC.SBR"
	-@erase "$(INTDIR)\DEMO.OBJ"
	-@erase "$(INTDIR)\DEMO.res"
	-@erase "$(INTDIR)\DEMO.SBR"
	-@erase "$(INTDIR)\DIALOGS.OBJ"
	-@erase "$(INTDIR)\DIALOGS.SBR"
	-@erase "$(INTDIR)\DIBPAL.OBJ"
	-@erase "$(INTDIR)\DIBPAL.SBR"
	-@erase "$(INTDIR)\DISP.OBJ"
	-@erase "$(INTDIR)\DISP.SBR"
	-@erase "$(INTDIR)\DLGBC.OBJ"
	-@erase "$(INTDIR)\DLGBC.SBR"
	-@erase "$(INTDIR)\DLGC.OBJ"
	-@erase "$(INTDIR)\DLGC.SBR"
	-@erase "$(INTDIR)\DlgNms.obj"
	-@erase "$(INTDIR)\DlgNms.sbr"
	-@erase "$(INTDIR)\FAXDLG.OBJ"
	-@erase "$(INTDIR)\FAXDLG.SBR"
	-@erase "$(INTDIR)\IMGDOC.OBJ"
	-@erase "$(INTDIR)\IMGDOC.SBR"
	-@erase "$(INTDIR)\IMGVW.OBJ"
	-@erase "$(INTDIR)\IMGVW.SBR"
	-@erase "$(INTDIR)\INPUTVW.OBJ"
	-@erase "$(INTDIR)\INPUTVW.SBR"
	-@erase "$(INTDIR)\LOGS.OBJ"
	-@erase "$(INTDIR)\LOGS.SBR"
	-@erase "$(INTDIR)\LOGSFRAM.OBJ"
	-@erase "$(INTDIR)\LOGSFRAM.SBR"
	-@erase "$(INTDIR)\LOGSVIEW.OBJ"
	-@erase "$(INTDIR)\LOGSVIEW.SBR"
	-@erase "$(INTDIR)\LWLBOX.OBJ"
	-@erase "$(INTDIR)\LWLBOX.SBR"
	-@erase "$(INTDIR)\MAGNIFYW.OBJ"
	-@erase "$(INTDIR)\MAGNIFYW.SBR"
	-@erase "$(INTDIR)\MAINFRM.OBJ"
	-@erase "$(INTDIR)\MAINFRM.SBR"
	-@erase "$(INTDIR)\MDIChildFrame.obj"
	-@erase "$(INTDIR)\MDIChildFrame.sbr"
	-@erase "$(INTDIR)\Opencmtx.obj"
	-@erase "$(INTDIR)\Opencmtx.sbr"
	-@erase "$(INTDIR)\PBPOS.OBJ"
	-@erase "$(INTDIR)\PBPOS.SBR"
	-@erase "$(INTDIR)\PHBDLG.OBJ"
	-@erase "$(INTDIR)\PHBDLG.SBR"
	-@erase "$(INTDIR)\SEARCHBX.OBJ"
	-@erase "$(INTDIR)\SEARCHBX.SBR"
	-@erase "$(INTDIR)\SPLITTER.OBJ"
	-@erase "$(INTDIR)\SPLITTER.SBR"
	-@erase "$(INTDIR)\STDAFX.OBJ"
	-@erase "$(INTDIR)\STDAFX.SBR"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\Demo32.bsc"
	-@erase "$(OUTDIR)\Demo32.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp1 /MT /W3 /GX /Od /I "..\..\..\..\inc" /D "NDEBUG" /D "WIN32" /D "_WINDOWS" /D "_THREAD" /D "_MBCS" /Fr"$(INTDIR)\\" /Fp"$(INTDIR)\Demo32.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /J /FD /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "NDEBUG" /mktyplib203 /win32 
RSC=rc.exe
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\DEMO.res" /d "NDEBUG" /d "WIN32" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Demo32.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\ASCII.SBR" \
	"$(INTDIR)\BLOCKDOC.SBR" \
	"$(INTDIR)\CFUNC.SBR" \
	"$(INTDIR)\DEMO.SBR" \
	"$(INTDIR)\DIALOGS.SBR" \
	"$(INTDIR)\DIBPAL.SBR" \
	"$(INTDIR)\DISP.SBR" \
	"$(INTDIR)\DLGBC.SBR" \
	"$(INTDIR)\DLGC.SBR" \
	"$(INTDIR)\DlgNms.sbr" \
	"$(INTDIR)\FAXDLG.SBR" \
	"$(INTDIR)\IMGDOC.SBR" \
	"$(INTDIR)\IMGVW.SBR" \
	"$(INTDIR)\INPUTVW.SBR" \
	"$(INTDIR)\LOGS.SBR" \
	"$(INTDIR)\LOGSFRAM.SBR" \
	"$(INTDIR)\LOGSVIEW.SBR" \
	"$(INTDIR)\LWLBOX.SBR" \
	"$(INTDIR)\MAGNIFYW.SBR" \
	"$(INTDIR)\MAINFRM.SBR" \
	"$(INTDIR)\MDIChildFrame.sbr" \
	"$(INTDIR)\Opencmtx.sbr" \
	"$(INTDIR)\PBPOS.SBR" \
	"$(INTDIR)\PHBDLG.SBR" \
	"$(INTDIR)\SEARCHBX.SBR" \
	"$(INTDIR)\SPLITTER.SBR" \
	"$(INTDIR)\STDAFX.SBR"

"$(OUTDIR)\Demo32.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib bidib.lib bijpeg.lib pbook32.lib biprint.lib bitiff.lib bidisp.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\Demo32.pdb" /machine:IX86 /def:".\DEMO32.DEF" /out:"$(OUTDIR)\Demo32.exe" /libpath:"..\..\..\..\Lib" 
DEF_FILE= \
	".\DEMO32.DEF"
LINK32_OBJS= \
	"$(INTDIR)\ASCII.OBJ" \
	"$(INTDIR)\BLOCKDOC.OBJ" \
	"$(INTDIR)\CFUNC.OBJ" \
	"$(INTDIR)\DEMO.OBJ" \
	"$(INTDIR)\DIALOGS.OBJ" \
	"$(INTDIR)\DIBPAL.OBJ" \
	"$(INTDIR)\DISP.OBJ" \
	"$(INTDIR)\DLGBC.OBJ" \
	"$(INTDIR)\DLGC.OBJ" \
	"$(INTDIR)\DlgNms.obj" \
	"$(INTDIR)\FAXDLG.OBJ" \
	"$(INTDIR)\IMGDOC.OBJ" \
	"$(INTDIR)\IMGVW.OBJ" \
	"$(INTDIR)\INPUTVW.OBJ" \
	"$(INTDIR)\LOGS.OBJ" \
	"$(INTDIR)\LOGSFRAM.OBJ" \
	"$(INTDIR)\LOGSVIEW.OBJ" \
	"$(INTDIR)\LWLBOX.OBJ" \
	"$(INTDIR)\MAGNIFYW.OBJ" \
	"$(INTDIR)\MAINFRM.OBJ" \
	"$(INTDIR)\MDIChildFrame.obj" \
	"$(INTDIR)\Opencmtx.obj" \
	"$(INTDIR)\PBPOS.OBJ" \
	"$(INTDIR)\PHBDLG.OBJ" \
	"$(INTDIR)\SEARCHBX.OBJ" \
	"$(INTDIR)\SPLITTER.OBJ" \
	"$(INTDIR)\STDAFX.OBJ" \
	"$(INTDIR)\DEMO.res"

"$(OUTDIR)\Demo32.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "Demo32 - Win32 Debug"

OUTDIR=.\Windeb_b
INTDIR=.\Windeb_b
# Begin Custom Macros
OutDir=.\Windeb_b
# End Custom Macros

ALL : "$(OUTDIR)\Demo32.exe" "$(OUTDIR)\Demo32.bsc"


CLEAN :
	-@erase "$(INTDIR)\ASCII.OBJ"
	-@erase "$(INTDIR)\ASCII.SBR"
	-@erase "$(INTDIR)\BLOCKDOC.OBJ"
	-@erase "$(INTDIR)\BLOCKDOC.SBR"
	-@erase "$(INTDIR)\CFUNC.OBJ"
	-@erase "$(INTDIR)\CFUNC.SBR"
	-@erase "$(INTDIR)\DEMO.OBJ"
	-@erase "$(INTDIR)\DEMO.res"
	-@erase "$(INTDIR)\DEMO.SBR"
	-@erase "$(INTDIR)\DIALOGS.OBJ"
	-@erase "$(INTDIR)\DIALOGS.SBR"
	-@erase "$(INTDIR)\DIBPAL.OBJ"
	-@erase "$(INTDIR)\DIBPAL.SBR"
	-@erase "$(INTDIR)\DISP.OBJ"
	-@erase "$(INTDIR)\DISP.SBR"
	-@erase "$(INTDIR)\DLGBC.OBJ"
	-@erase "$(INTDIR)\DLGBC.SBR"
	-@erase "$(INTDIR)\DLGC.OBJ"
	-@erase "$(INTDIR)\DLGC.SBR"
	-@erase "$(INTDIR)\DlgNms.obj"
	-@erase "$(INTDIR)\DlgNms.sbr"
	-@erase "$(INTDIR)\FAXDLG.OBJ"
	-@erase "$(INTDIR)\FAXDLG.SBR"
	-@erase "$(INTDIR)\IMGDOC.OBJ"
	-@erase "$(INTDIR)\IMGDOC.SBR"
	-@erase "$(INTDIR)\IMGVW.OBJ"
	-@erase "$(INTDIR)\IMGVW.SBR"
	-@erase "$(INTDIR)\INPUTVW.OBJ"
	-@erase "$(INTDIR)\INPUTVW.SBR"
	-@erase "$(INTDIR)\LOGS.OBJ"
	-@erase "$(INTDIR)\LOGS.SBR"
	-@erase "$(INTDIR)\LOGSFRAM.OBJ"
	-@erase "$(INTDIR)\LOGSFRAM.SBR"
	-@erase "$(INTDIR)\LOGSVIEW.OBJ"
	-@erase "$(INTDIR)\LOGSVIEW.SBR"
	-@erase "$(INTDIR)\LWLBOX.OBJ"
	-@erase "$(INTDIR)\LWLBOX.SBR"
	-@erase "$(INTDIR)\MAGNIFYW.OBJ"
	-@erase "$(INTDIR)\MAGNIFYW.SBR"
	-@erase "$(INTDIR)\MAINFRM.OBJ"
	-@erase "$(INTDIR)\MAINFRM.SBR"
	-@erase "$(INTDIR)\MDIChildFrame.obj"
	-@erase "$(INTDIR)\MDIChildFrame.sbr"
	-@erase "$(INTDIR)\Opencmtx.obj"
	-@erase "$(INTDIR)\Opencmtx.sbr"
	-@erase "$(INTDIR)\PBPOS.OBJ"
	-@erase "$(INTDIR)\PBPOS.SBR"
	-@erase "$(INTDIR)\PHBDLG.OBJ"
	-@erase "$(INTDIR)\PHBDLG.SBR"
	-@erase "$(INTDIR)\SEARCHBX.OBJ"
	-@erase "$(INTDIR)\SEARCHBX.SBR"
	-@erase "$(INTDIR)\SPLITTER.OBJ"
	-@erase "$(INTDIR)\SPLITTER.SBR"
	-@erase "$(INTDIR)\STDAFX.OBJ"
	-@erase "$(INTDIR)\STDAFX.SBR"
	-@erase "$(OUTDIR)\Demo32.bsc"
	-@erase "$(OUTDIR)\Demo32.exe"
	-@erase "$(OUTDIR)\Demo32.pdb"
	-@erase ".\IMG.IDB"
	-@erase ".\IMG.PDB"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp1 /MTd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_WINDOWS" /D "_THREAD" /D "_MBCS" /Fr"$(INTDIR)\\" /Fp"$(INTDIR)\Demo32.pch" /YX /Fo"$(INTDIR)\\" /Fd".\IMG.PDB" /J /FD /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "_DEBUG" /mktyplib203 /win32 
RSC=rc.exe
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\DEMO.res" /d "_DEBUG" /d "WIN32" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Demo32.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\ASCII.SBR" \
	"$(INTDIR)\BLOCKDOC.SBR" \
	"$(INTDIR)\CFUNC.SBR" \
	"$(INTDIR)\DEMO.SBR" \
	"$(INTDIR)\DIALOGS.SBR" \
	"$(INTDIR)\DIBPAL.SBR" \
	"$(INTDIR)\DISP.SBR" \
	"$(INTDIR)\DLGBC.SBR" \
	"$(INTDIR)\DLGC.SBR" \
	"$(INTDIR)\DlgNms.sbr" \
	"$(INTDIR)\FAXDLG.SBR" \
	"$(INTDIR)\IMGDOC.SBR" \
	"$(INTDIR)\IMGVW.SBR" \
	"$(INTDIR)\INPUTVW.SBR" \
	"$(INTDIR)\LOGS.SBR" \
	"$(INTDIR)\LOGSFRAM.SBR" \
	"$(INTDIR)\LOGSVIEW.SBR" \
	"$(INTDIR)\LWLBOX.SBR" \
	"$(INTDIR)\MAGNIFYW.SBR" \
	"$(INTDIR)\MAINFRM.SBR" \
	"$(INTDIR)\MDIChildFrame.sbr" \
	"$(INTDIR)\Opencmtx.sbr" \
	"$(INTDIR)\PBPOS.SBR" \
	"$(INTDIR)\PHBDLG.SBR" \
	"$(INTDIR)\SEARCHBX.SBR" \
	"$(INTDIR)\SPLITTER.SBR" \
	"$(INTDIR)\STDAFX.SBR"

"$(OUTDIR)\Demo32.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib bidib.lib bijpeg.lib pbook32.lib biprint.lib bitiff.lib bidisp.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\Demo32.pdb" /debug /machine:IX86 /def:".\DEMO32.DEF" /out:"$(OUTDIR)\Demo32.exe" /libpath:"..\..\..\..\Lib" 
DEF_FILE= \
	".\DEMO32.DEF"
LINK32_OBJS= \
	"$(INTDIR)\ASCII.OBJ" \
	"$(INTDIR)\BLOCKDOC.OBJ" \
	"$(INTDIR)\CFUNC.OBJ" \
	"$(INTDIR)\DEMO.OBJ" \
	"$(INTDIR)\DIALOGS.OBJ" \
	"$(INTDIR)\DIBPAL.OBJ" \
	"$(INTDIR)\DISP.OBJ" \
	"$(INTDIR)\DLGBC.OBJ" \
	"$(INTDIR)\DLGC.OBJ" \
	"$(INTDIR)\DlgNms.obj" \
	"$(INTDIR)\FAXDLG.OBJ" \
	"$(INTDIR)\IMGDOC.OBJ" \
	"$(INTDIR)\IMGVW.OBJ" \
	"$(INTDIR)\INPUTVW.OBJ" \
	"$(INTDIR)\LOGS.OBJ" \
	"$(INTDIR)\LOGSFRAM.OBJ" \
	"$(INTDIR)\LOGSVIEW.OBJ" \
	"$(INTDIR)\LWLBOX.OBJ" \
	"$(INTDIR)\MAGNIFYW.OBJ" \
	"$(INTDIR)\MAINFRM.OBJ" \
	"$(INTDIR)\MDIChildFrame.obj" \
	"$(INTDIR)\Opencmtx.obj" \
	"$(INTDIR)\PBPOS.OBJ" \
	"$(INTDIR)\PHBDLG.OBJ" \
	"$(INTDIR)\SEARCHBX.OBJ" \
	"$(INTDIR)\SPLITTER.OBJ" \
	"$(INTDIR)\STDAFX.OBJ" \
	"$(INTDIR)\DEMO.res"

"$(OUTDIR)\Demo32.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("Demo32.dep")
!INCLUDE "Demo32.dep"
!ELSE 
!MESSAGE Warning: cannot find "Demo32.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "Demo32 - Win32 Release" || "$(CFG)" == "Demo32 - Win32 Debug"
SOURCE=.\ASCII.CPP

"$(INTDIR)\ASCII.OBJ"	"$(INTDIR)\ASCII.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\BLOCKDOC.CPP

"$(INTDIR)\BLOCKDOC.OBJ"	"$(INTDIR)\BLOCKDOC.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\CFUNC.C

"$(INTDIR)\CFUNC.OBJ"	"$(INTDIR)\CFUNC.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\DEMO.CPP

"$(INTDIR)\DEMO.OBJ"	"$(INTDIR)\DEMO.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\DEMO.RC

"$(INTDIR)\DEMO.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)


SOURCE=.\DIALOGS.CPP

"$(INTDIR)\DIALOGS.OBJ"	"$(INTDIR)\DIALOGS.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\DIBPAL.CPP

"$(INTDIR)\DIBPAL.OBJ"	"$(INTDIR)\DIBPAL.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\DISP.CPP

"$(INTDIR)\DISP.OBJ"	"$(INTDIR)\DISP.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\DLGBC.CPP

"$(INTDIR)\DLGBC.OBJ"	"$(INTDIR)\DLGBC.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\DLGC.CPP

"$(INTDIR)\DLGC.OBJ"	"$(INTDIR)\DLGC.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\DlgNms.cpp

"$(INTDIR)\DlgNms.obj"	"$(INTDIR)\DlgNms.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\FAXDLG.CPP

"$(INTDIR)\FAXDLG.OBJ"	"$(INTDIR)\FAXDLG.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\IMGDOC.CPP

"$(INTDIR)\IMGDOC.OBJ"	"$(INTDIR)\IMGDOC.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\IMGVW.CPP

"$(INTDIR)\IMGVW.OBJ"	"$(INTDIR)\IMGVW.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\INPUTVW.CPP

"$(INTDIR)\INPUTVW.OBJ"	"$(INTDIR)\INPUTVW.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\LOGS.CPP

"$(INTDIR)\LOGS.OBJ"	"$(INTDIR)\LOGS.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\LOGSFRAM.CPP

"$(INTDIR)\LOGSFRAM.OBJ"	"$(INTDIR)\LOGSFRAM.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\LOGSVIEW.CPP

"$(INTDIR)\LOGSVIEW.OBJ"	"$(INTDIR)\LOGSVIEW.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\LWLBOX.CPP

"$(INTDIR)\LWLBOX.OBJ"	"$(INTDIR)\LWLBOX.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\MAGNIFYW.CPP

"$(INTDIR)\MAGNIFYW.OBJ"	"$(INTDIR)\MAGNIFYW.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\MAINFRM.CPP

"$(INTDIR)\MAINFRM.OBJ"	"$(INTDIR)\MAINFRM.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\MDIChildFrame.cpp

"$(INTDIR)\MDIChildFrame.obj"	"$(INTDIR)\MDIChildFrame.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\Opencmtx.cpp

"$(INTDIR)\Opencmtx.obj"	"$(INTDIR)\Opencmtx.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\PBPOS.CPP

"$(INTDIR)\PBPOS.OBJ"	"$(INTDIR)\PBPOS.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\PHBDLG.CPP

"$(INTDIR)\PHBDLG.OBJ"	"$(INTDIR)\PHBDLG.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\SEARCHBX.CPP

"$(INTDIR)\SEARCHBX.OBJ"	"$(INTDIR)\SEARCHBX.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\SPLITTER.CPP

"$(INTDIR)\SPLITTER.OBJ"	"$(INTDIR)\SPLITTER.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\STDAFX.CPP

"$(INTDIR)\STDAFX.OBJ"	"$(INTDIR)\STDAFX.SBR" : $(SOURCE) "$(INTDIR)"



!ENDIF 

