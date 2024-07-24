

static  void LoadFaxNames(CDialog  *cDlg, BOOL bClose)
{
    CQueueFaxSampleApp     *pApp = (CQueueFaxSampleApp *)AfxGetApp();
    CListBox    *pPortBox = (CListBox *)cDlg->GetDlgItem(IDC_FAXPORTS);
    int         nWidth = 0;

    for ( int i = 0; i < MAX_FAXPORTS; i++) {
        if(pApp->FaxPorts[i])
        {
            if (pApp->FaxPorts[i]->IsOpen() || bClose)
            {
                TSSessionParameters CSession ;
                GetSessionParameters(pApp->FaxPorts[i],&CSession) ;
                CString cFax = CSession.PortName;
                cFax += ':' ;
                                cFax += CSession.ModemName;
                cFax +=  '.';
                cFax += CSession.FaxType;

                pPortBox->SetItemData(pPortBox->AddString(cFax), (DWORD)(i));
                if(cFax.GetLength() > nWidth)
                {
                    nWidth = cFax.GetLength();
                }
            }
        }
    }
    pPortBox->SetHorizontalExtent(8*nWidth);
    pPortBox->SetCurSel(0);
}