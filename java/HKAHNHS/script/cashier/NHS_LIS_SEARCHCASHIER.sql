create or replace function "NHS_LIS_SEARCHCASHIER"
(
    v_cashierCode varchar2
)
return types.cursor_type
as
    outcur types.cursor_type;
begin 
    open outcur for
    
    select 
       'CASH',CshRec,CshPayOut,Round(to_number(CshRec + CshPayOut), 2)
    from cashier
    where CshCode = v_cashierCode
    union all
    select 
           'CREDIT CARD',CshCard,CshCardOut,Round(to_number(CshCard + CshCardOut), 2)
    from cashier
    where CshCode = v_cashierCode
    union all
    select 
           'CHEQUE',CshChq,CshChqOut,Round(to_number(CshChq + CshChqOut), 2)
    from cashier
    where CshCode = v_cashierCode
    union all
    select 
           'EPS',CshEps,0,CshEps
    from cashier
    where CshCode = v_cashierCode
    union all
    select 
           'AUTOPAY',CshATP,CshATPOut,Round(to_number(CshATP + CshATPOut), 2)
    from cashier
    where CshCode = v_cashierCode
    union all
    select 
           'CUP',CshCupIn,CshCupOut,Round(to_number(CshCupIn + CshCupOut), 2)
    from cashier
    where CshCode = v_cashierCode
    union all
    select 
           'OCTOPUS',CshOctIn,CshOctOut,Round(to_number(CshOctIn + CshOctOut), 2)
    from cashier
    where CshCode = v_cashierCode
    union all
    select 
           'Advance Payment/Withdraw',CshAdv,CshPayIn,Round(to_number(CshAdv + CshPayIn), 2)
    from cashier
    where CshCode = v_cashierCode
    union all
    select 
           'Total',Round(to_number(CshRec + CshCard + CshChq + CshEps + CshATP + CshAdv + CshCupIn + CshOctIn), 2),
           Round(to_number(CshPayOut + CshCardOut + CshChqOut + CshATPOut + CshPayIn + CshCupOut + CshOctOut), 2),
           Round(to_number(Round(CshRec + CshCard + CshChq + CshEps + CshATP + CshAdv + CshCupIn + CshOctIn, 2) + 
           Round(CshPayOut + CshCardOut + CshChqOut + CshATPOut + CshPayIn + CshCupOut + CshOctOut, 2)), 2)
    from cashier
    where CshCode = v_cashierCode;
    return outcur;
end NHS_LIS_SEARCHCASHIER;
/
