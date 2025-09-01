@echo off  

del dummy.txt
del *.pdf
del *.txt
 
if exist %1\update.bat goto start
echo ======================================= | mod  
echo [Error] Cannot find update.bat
echo =======================================
goto end

:===== start =====
echo =======================================================
echo * Release Date: 2009/10/23; use update.bat
echo * Release Date: 2009/11/4; Add machine config for interface
echo * Release Date: 2009/11/9; Add day case posting
echo * Release Date: 2009/11/11; Fix refax for urine
echo * Release Date: 2009/11/17; Add Report Filter
echo * Release Date: 2009/11/19; Color blue for none reported items
echo * Release Date: 2009/11/20; Fix reference for chem offline text
echo * Release Date: 2009/11/24; Add reprint/refax on enquiry
echo * Release Date: 2009/11/25; Add chinese for referal report
echo * Release Date: 2009/11/25; Fix mb report for long name
echo * Release Date: 2009/11/30; Fix diff report
echo * Release Date: 2009/12/04; Fix refax message box
echo * Release Date: 2009/12/09; Fix doctor maintenance
echo * Release Date: 2009/12/10; Fix report bug when changing location
echo * Release Date: 2009/12/11; Fix partial report bug in chem
echo * Release Date: 2009/12/14; Fix MB report specimen type
echo * Release Date: 2009/12/16; Add upload referral report using FTP
echo * Release Date: 2010/2/3; Add dummy.txt for upload
echo * Release Date: 2010/2/4; delete dummy.txt before ftp
echo * Release Date: 2010/2/5; add log for pdf
echo * Release Date: 2010/2/5; billing report for twah
echo * Release Date: 2010/2/5; fix urine report format
echo * Release Date: 2010/2/8; change report field size
echo * Release Date: 2010/3/1; del local tif file
echo * Release Date: 2010/3/4; new db structure for japanese
echo * Release Date: 2010/3/5; delta maintenance
echo * Release Date: 2010/3/8; tune pdf
echo * Release Date: 2010/3/9; fix mb reprint
echo * Release Date: 2010/3/11; hide mb pdf for debug
echo * Release Date: 2010/3/12; fix coag report, add panic list
echo * Release Date: 2010/3/15; add view only for profile maintenance
echo * Release Date: 2010/3/18; fix tat report
echo * Release Date: 2010/3/24; new report format
echo * Release Date: 2010/3/25; fix test reg, enhance panic list
echo * Release Date: 2010/3/29; fix ftp; fix tat
echo * Release Date: 2010/3/29; new cumulation datawindow
echo * Release Date: 2010/4/15; fix mb result dt/add mb report dt/report by
echo * Release Date: 2010/4/16; pdf add version2
echo * Release Date: 2010/5/6; hkah change phone #
echo * Release Date: 2010/5/7; fix pdf
echo * Release Date: 2010/5/12; update bloodbank
echo * Release Date: 2010/5/17; add disclaimer
echo * Release Date: 2010/5/18; Fix ref decimal
echo * Release Date: 2010/5/18; Fix mb rpt
echo * Release Date: 2010/5/28; Fix misc reports
echo * Release Date: 2010/5/31; Misc update...
echo * Release Date: 2010/6/1; Fix Print Ref
echo * Release Date: 2010/6/4; regen pdf
echo * Release Date: 2010/6/7; fix mb pdf
echo * Release Date: 2010/6/8; new bloodbank
echo * Release Date: 2010/6/22; new bloodbank
echo * Release Date: 2010/6/23; add change location logic in mb report
echo * Release Date: 2010/6/24; bloodbank update
echo * Release Date: 2010/6/29; bloodbank update
echo * Release Date: 2010/7/12; upload instrument update
echo * Release Date: 2010/7/13; bloodbank update
echo * Release Date: 2010/7/14; fix qc
echo * Release Date: 2010/7/19; bloodbank update
echo * Release Date: 2010/7/20; bloodbank update
echo * Release Date: 2010/7/26; bloodbank update
echo * Release Date: 2010/7/26; update int_tcode generation
echo * Release Date: 2010/8/3; fax update
echo * Release Date: 2010/8/3; fix edit reg
echo * Release Date: 2010/8/3; fix bio fax 2 page
echo * Release Date: 2010/8/3; fix udc error 2
echo * Release Date: 2010/8/4; qc update
echo * Release Date: 2010/8/5; enable preview for referral
echo * Release Date: 2010/8/5; bloodbank update
echo * Release Date: 2010/8/6; qc update
echo * Release Date: 2010/8/6; bloodbank update3
echo * Release Date: 2010/8/16; report update
echo * Release Date: 2010/8/20; misc update
echo * Release Date: 2010/8/20; bloodbank update
echo * Release Date: 2010/8/21; bloodbank update
echo * Release Date: 2010/8/22; mgmt report update
echo * Release Date: 2010/8/26; fix qc maintenance
echo * Release Date: 2010/8/30; fix change hospnum
echo * Release Date: 2010/8/30; bloodbank update
echo * Release Date: 2010/8/31; bloodbank update
echo * Release Date: 2010/9/1; ref file upload
echo * Release Date: 2010/9/1; ref file upload2
echo * Release Date: 2010/9/22; bloodbank update
echo * Release Date: 2010/9/27; misc update
echo * Release Date: 2010/10/4; Dr OTH fix 2
echo * Release Date: 2010/10/5; enable archive qc graph
echo * Release Date: 2010/10/5; fix report
echo * Release Date: 2010/10/9; fix ref module bug
echo * Release Date: 2010/10/9; urine report longer speciment type 2 tem
echo * Release Date: 2010/10/15; misc update 2
echo * Release Date: 2010/11/9; blood bank X
echo * Release Date: 2010/11/12; blood bank add screen calc; demo lab num
echo * Release Date: 2010/11/16; DEMO MODE
echo * Release Date: 2010/11/17; Fix BB report
echo * Release Date: 2010/11/30; QC TRACE chart value change from 0 to 0.5
echo * Release Date: 2010/12/1; Fix ref report
echo * Release Date: 2010/12/6; Bact neg comment
echo * Release Date: 2010/12/8; Set QC Trace to 0.5
echo * Release Date: 2010/12/14; Fix fax report
echo * Release Date: 2010/12/17; crossmatch interface debug 3
echo * Release Date: 2010/12/22; japanese test update
echo * Release Date: 2010/12/30; hem report update
echo * Release Date: 2011/1/12; fix status R in microbio
echo * Release Date: 2011/1/18; change crossmatch machine code
echo * Release Date: 2011/1/19; fix release bb 2
echo * Release Date: 2011/2/1; bb update
echo * Release Date: 2011/2/10; japanese update
echo * Release Date: 2011/2/10; japanese update 2
echo * Release Date: 2011/2/15; misc update
echo * Release Date: 2011/2/22; fix panic report
echo * Release Date: 2011/2/22; QC Westgard
echo * Release Date: 2011/2/23; QC Westgard fix1
echo * Release Date: 2011/2/23; BB QC fix1
echo * Release Date: 2011/2/23; BB QC fix2
echo * Release Date: 2011/2/23; QC Westgard final
echo * Release Date: 2011/2/28; MB big fix
echo * Release Date: 2011/2/28; QC summ fix
echo * Release Date: 2011/3/7; misc update2
echo * Release Date: 2011/3/7; bb fix
echo * Release Date: 2011/3/15; bb qc fix
echo * Release Date: 2011/3/17; fix reprint Coag bug
echo * Release Date: 2011/3/21; misc update1
echo * Release Date: 2011/3/31; misc update2
echo * Release Date: 2011/4/4; misc update3
echo * Release Date: 2011/5/6; add xx change codes
echo * Release Date: 2011/5/11; fix add bb inv bloodgroup mapping for file
echo * Release Date: 2011/5/12; fix bb slide warning
echo * Release Date: 2011/5/13; misc fix
echo * Release Date: 2011/5/18; mgmt report update
echo * Release Date: 2011/5/19; misc update 1
echo * Release Date: 2011/5/20; bb slide checking for newborn
echo * Release Date: 2011/5/20; bb query mode fix
echo * Release Date: 2011/5/24; incomplete worklist
echo * Release Date: 2011/5/24; bb bug fix
echo * Release Date: 2011/5/25; bb bug fix
echo * Release Date: 2011/5/27; partial report bug fix
echo * Release Date: 2011/5/27; incomplete worklist update
echo * Release Date: 2011/6/3; misc update
echo * Release Date: 2011/6/13; misc update
echo * Release Date: 2011/6/21; fix comma in number field
echo * Release Date: 2011/9/28; pdf version
echo * Release Date: 2011/10/21; misc update
echo * Release Date: 2011/10/26; ftp update
echo * Release Date: 2011/10/26; billing update
echo * Release Date: 2011/11/4; fix billing 2
echo * Release Date: 2011/11/8; misc fix
echo * Release Date: 2011/11/9; misc fix
echo * Release Date: 2011/11/10; misc fix
echo * Release Date: 2011/11/18; add new diff test
echo * Release Date: 2011/11/21; fix blood gas
echo * Release Date: 2011/11/29; fix bb report 2
echo * Release Date: 2011/11/30; misc fix
echo * Release Date: 2011/12/1; fix HK billing CBC
echo * Release Date: 2011/12/5; misc fix2
echo * Release Date: 2011/12/15; fix blood gas
echo * Release Date: 2012/1/9; fix jap lang, io warning?
echo * Release Date: 2012/1/13; fix age month
echo * Release Date: 2012/1/13; bb misc fix
echo * Release Date: 2012/1/16; fix blood gas report/free print label
echo * Release Date: 2012/1/16; change free print label font 10 to original
echo * Release Date: 2012/2/6; fix bb report
echo * Release Date: 2012/2/8; fix pat maintenance
echo * Release Date: 2012/2/16; inpatient microbio report 1
echo * Release Date: 2012/3/8; bb fix?
echo * Release Date: 2012/3/12; misc fix?
echo * Release Date: 2012/5/8; v3.00
echo * Release Date: 2012/5/21; fix reg
echo * Release Date: 2012/5/25; ewell alert add lab_num
echo * Release Date: 2012/6/5; CBC charge fix
echo * Release Date: 2012/6/6; CBC charge fix2
echo * Release Date: 2012/7/24; 3.02 Outpatient billing
echo * Release Date: 2012/7/25; 3.02 Outpatient billing 3
echo * Release Date: 2012/8/16; fix billing routine to stat, fix bb
echo * Release Date: 2012/8/17; incomplete worklist fix, bill mon, fix bb
echo * Release Date: 2012/8/21; fix qc comment
echo * Release Date: 2012/8/22; version 3.03 r4
echo * Release Date: 2012/9/18; version 3.04
echo * Release Date: 2012/9/21; version 3.04 deployed to TWAH
echo * Release Date: 2012/9/27; hotfix mb report
echo * Release Date: 2012/10/29; version 3.05
echo * Release Date: 2012/12/04; bug fixed.
echo * Release Date: 2012/12/10; version 3.07 
echo * Release Date: 2012/12/12; version 3.08
echo * Release Date: 2012/12/17; fix report sorting
echo * Release Date: 2012/12/28; mgmt report
echo * Release Date: 2013/01/07; version 3.09
echo * Release Date: 2013/01/21; fix upload referral
echo * Release Date: 2013/01/21; version 3.10
echo * Release Date: 2013/01/31; version 3.10
echo * Release Date: 2013/03/04; version 3.11 add BUF tests
echo * Release Date: 2013/05/21; enhance status report
echo * Release Date: 2013/07/8; version 3.12 added blood transfusion report
echo * Release Date: 2013/7/9; transfusion report bug fix
echo * Release Date: 2013/7/12; transfusion report reprint
echo * Release Date: 2013/7/15; fix transfusion pdf
echo * Release Date: 2013/7/17; fix transfusion pdf
echo * Release Date: 2013/8/5; fix multipage no cum report
echo * Release Date: 2013/8/19; fix blood bank report error
echo * Release Date: 2013/8/21; fix mb report for long comment
echo * Release Date: 2013/9/6; fix previous blood group, refax bloodbank report, regen bloodbank pdf
echo * Release Date: 2013/9/25; fix reprint lock
echo * Release Date: 2013/10/17; 1)add location when reg from ewell barcode
echo * Release Date: 2013/10/17; 2)outer join item charge table for billing report
echo * Release Date: 2013/10/17; 3)add XVANA XVANB for infection control
echo * Release Date: 2013/11/8; fix hem cum report
echo * Release Date: 2013/11/20; fix reload button for c6000
echo * Release Date: 2014/1/9; fix reload button for c6000
echo * Release Date: 2014/1/21; fix mb report
echo * Release Date: 2014/2/11; add stat price on billing report
echo * Release Date: 2014/2/26; change tat calculation
echo * Release Date: 2014/3/3; sum in panic report
echo * Release Date: 2014/3/14; add security
echo * Release Date: 2014/3/19; fix printer bug
echo * Release Date: 2014/3/24; add qc sec
echo * Release Date: 2014/4/8; test slip printer
echo * Release Date: 2014/4/15; add location ar code
echo * Release Date: 2014/5/16; change mb comment fonts
echo * Release Date: 2014/6/17; 1.add mb tech comment 2.add reprint QR-code 3.add pat label
echo * Release Date: 2014/6/17; fix label1
echo * Release Date: 2014/7/16; 3.27
echo * Release Date: 2014/7/24; 3.28
echo * Release Date: 2014/8/19; 3.29 mb modify layout
echo * Release Date: 2014/9/5; Fix Dr name
echo * Release Date: 2014/9/15; Fix Dr name3
echo * Release Date: 2014/10/15; 3.3 add reprint ref
echo * Release Date: 2014/10/24; fixed OK
echo * Release Date: 2014/11/24; 3.31 add maldi interface
echo * Release Date: 2014/11/24; amend display
echo * Release Date: 2015/2/5; microbio tech comment
echo * Release Date: 2015/5/11; hk print 1 copy only
echo * Release Date: 2015/5/11; fix signature line in chem
echo * Release Date: 2015/5/15; change report
echo * Release Date: 2015/6/2; stool online 1
echo * Release Date: 2015/6/2; new hospital name
echo * Release Date: 2015/6/3; fix 2 page fax for chem 3
echo * Release Date: 2015/6/11; lis3.35
echo * Release Date: 2015/7/29; lis4
echo * Release Date: 2015/7/29; lis4 redeploy
echo * Release Date: 2015/7/30; lis4 redeploy2
echo * Release Date: 2015/8/6; patient maintenance
echo * Release Date: 2015/8/21; patient merge
echo * Release Date: 2015/8/25; fix
echo * Release Date: 2015/8/27; fix qc
echo * Release Date: 2015/9/8; isbt128 3digit bloodgrp code
echo * Release Date: 2015/10/13; isbt128 instrument label with check digit
echo * Release Date: 2016/7/21; lis4.03 add pdf store
echo * Release Date: 2016/8/3; enlarge label for HKAH
echo * Release Date: 2016/8/4; enlarge label hospnum size
echo * Release Date: 2016/8/22; update pathology
echo * Release Date: 2016/8/24; add report log for mb
echo * Release Date: 2016/9/6; fix mb regen pdf
echo * Release Date: 2016/9/7; add dr email address
echo * Release Date: 2016/9/8; location ward code
echo * Release Date: 2016/9/13; dr email log; dr maintenance set sort 2
echo * Release Date: 2016/9/14; fix stool regen pdf
echo * Release Date: 2016/9/20; enlarge dr email
echo * Release Date: 2016/9/22; 4.04 add IPXX; dr mail log filter CIS success mail 
echo * Release Date: 2016/9/27; single side pdf
echo * Release Date: 2016/10/4; fix path bug
echo * Release Date: 2016/10/11; fix multi-user re-release
echo * Release Date: 2016/10/12; doc maintenance sort by doc code
echo * Release Date: 2016/10/14; add NRXX
echo * Release Date: 2016/10/24; add resend email
echo * Release Date: 2016/11/2; add resend with regen
echo * Release Date: 2016/11/22; mb add score tw; fix hem rpt
echo * Release Date: 2016/12/9; add critical report flag
echo * Release Date: 2016/12/16; location email
echo * Release Date: 2017/1/10; change hoklas footer wording
echo * Release Date: 2017/1/24; remove location email
echo * Release Date: 2017/1/31; 4.07 block dr email
echo * Release Date: 2017/2/9; 4.08 add patient update button
echo * Release Date: 2017/4/5; bb update
echo * Release Date: 2017/4/20; stool report update
echo * Release Date: 2017/4/28; stool report update2
echo * Release Date: 2017/5/11; bb add report; active hats dr only in dr mapping
echo * Release Date: 2017/5/12; bb update2
echo * Release Date: 2017/8/25; fixed mb interim report upload + ref
echo * Release Date: 2017/8/28; fix chem cum report
echo * Release Date: 2017/9/6; check dup for profile
echo * Release Date: 2017/11/8; 4.09 check for patho files before release
echo * Release Date: 2017/11/13; 4.10 add fax for AMC2
echo * Release Date: 2017/11/20; Fix QC for same mach name; units allows 10 char2
echo * Release Date: 2017/12/4; Status report by test add priority
echo * Release Date: 2017/12/22; Update
echo * Release Date: 2017/12/27; Update blood bank disposal; add checking
echo * Release Date: 2018/1/8; fix qc bug
echo * Release Date: 2018/1/24; 4.12 Enlarge patient name to varchar2(90), fix screen
echo * Release Date: 2018/1/29; add report hospnum
echo * Release Date: 2018/2/19; blood bank retriction
echo * Release Date: 2018/3/8; check prev blood group
echo * Release Date: 2018/3/9; rollback NRXX to fix test reg
echo * Release Date: 2018/4/3; Add patient comments
echo * Release Date: 2018/4/18; enlarge doctor name; add spec_maint security key
echo * Release Date: 2018/4/26; force re-authorize for patient change; add dr and room in result entry and auth windows; add resend email for auth windows
echo * Release Date: 2018/6/11; 4.15: 1.Added add in urine normal range maintenance. 2.QC graph increased to 400 points 3.allow sign in chem value result entry;
echo * Release Date: 2018/6/14; Added single test view in cumulative screen. hotfix 
echo * Release Date: 2018/8/8; Change faxhold folder
echo * Release Date: 2018/9/18; billing report export to excel
echo * Release Date: 2018/11/1; add coag flag
echo * Release Date: 2018/10/28; add indent space for chem report, influz code!!
echo * Release Date: 2018/11/15; add mouse scroll events
echo * Release Date: 2019/3/7; outpatient billing
echo * Release Date: 2019/3/19; remove LBXX hardcode
echo * Release Date: 2019/8/26; update for CRC, v4
echo * Release Date: 2019/9/12; refer bug fixed : result and test comment field swapped
echo * Release Date: 2019/8/26; update for CRCv - QC, v12
echo * Release Date: 2019/9/20; Fix pathology
echo * Release Date: 2020/1/10; 4.21
echo * Release Date: 2020/1/23; Report update for fax path
echo * Release Date: 2020/3/26; Normal user cannot modify when printed final; panic list
echo * Release Date: 2020/3/30; hotfix hem result
echo * Release Date: 2020/5/14; 4 char location code maintenance
echo * Release Date: 2020/6/11; covid letter1
echo * Release Date: 2020/6/12; fix alex signature
echo * Release Date: 2020/6/16; change patid logic1
echo * Release Date: 2020/6/18; reload names
echo * Release Date: 2020/6/22; chinese name report; update COVID letter footer
echo * Release Date: 2020/7/2; COVID export
echo * Release Date: 2020/7/6; COVID export update
echo * Release Date: 2020/7/7; COVID letter fix 3
echo * Release Date: 2020/7/21; not print COVID letter
echo * Release Date: 2020/7/22; blood bank hotfix
echo * Release Date: 2020/7/23; amc2 hotfix
echo * Release Date: 2020/7/28; change covid testcode
echo * Release Date: 2020/9/7; modify for new HC code
echo * Release Date: 2020/9/8; fix covid letter query
echo * Release Date: 2020/9/25; fix stool report version
echo * Release Date: 2020/10/9; fix covid font
echo * Release Date: 2020/11/9; new covid letter template1
echo * Release Date: 2020/11/10; update covid export
echo * Release Date: 2020/11/20; update covid letter sql
echo * Release Date: 2020/12/2; get TWAH patient from barcode, reload
echo * Release Date: 2020/12/28; implement print lock.
echo * Release Date: 2020/12/31; force delete pdf for preview
echo * Release Date: 2021/1/1; fix health code
echo * Release Date: 2021/1/5; pat label update2
echo * Release Date: 2021/2/18; add moleculer genetics
echo * Release Date: 2021/2/25; Change report without changing the report date
echo * Release Date: 2021/3/4; moleculer genetics text
echo * Release Date: 2021/3/5; fix moleculer genetics text report; update printer maintenance; UPD rpt V3
echo * Release Date: 2021/3/8; fix moleculer genetics text report 3;
echo * Release Date: 2021/3/23; fix moleculer genetics text report;
echo * Release Date: 2021/7/6; COVID IGG cert archive
echo * Release Date: 2023/8/30; hem report testing
echo =======================================================

copy %1\*.exe . /y
copy %1\*.pbd . /y
copy %1\signature . /y
copy %1\tnsnames.ora . /y
copy %1\fax.bat . /y
copy %1\setbullzip.bat . /y
copy %1\removebullzip.bat . /y
copy %1\delpdf.bat . /y
mkdir preview

echo *** Program has been update at %time% on %date% 
echo =======================================================

:======== end
