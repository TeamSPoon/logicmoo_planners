:- expects_dialect(lps).

% Some bureaucracy to deal with simulated calendar time:
:- include(system('date_utils.pl')).  % get us the end_of_day(Date) event
simulatedRealTimeBeginning('2020-09-21'). 
simulatedRealTimePerCycle(RTPC) :- minCycleTime(RTPC). 
%maxTime(3200). 
maxRealTime(T) :- T is 10*24*3600. % 10 days
minCycleTime(T) :- T is 6*3600. % 6 hour cycles 

events worked(_Hours), requestPayment(_Amount), approveWork(_LastHours).
actions pay(_Amount).

% Missing:
% ourAccount(...)
% consultant(consultantAccount).
% payment details, currency

fluents balanceOwed(_Amount), approved(_Hours). 
initially balanceOwed(0), approved(0).

agreedRate(140). % timeless rate, e.g. unchanged over the life of this contract; at some agreed currency/token

worked(Hours) updates Old to NewAmount in balanceOwed(Old) if agreedRate(R), NewAmount is Old + Hours*R. 
approveWork(Hours) updates Old to New in approved(Old) if New is Old + Hours. 
pay(Amount) updates Old to New in balanceOwed(Old) if New is Old-Amount.
pay(Amount) updates Old to NewHours in approved(Old) if agreedRate(R), NewHours is Old - Amount/R.


false worked(_) from T, pay(_) from T.
false requestPayment(Amount), balanceOwed(Owed), Amount>Owed.

if balanceOwed(Owed) at T, approved(Approved) at T, Approved>0 then 
	Hours is min(Owed,Approved), agreedRate(R), Payment is Hours*R,
	pay(Payment) from T.

observe worked(3) at '2020-09-23T18:00'.
observe worked(3) at '2020-09-24'.
observe requestPayment(2000) at '2020-09-25T11:00'.
observe requestPayment(5) at '2020-09-26T11:01'.
observe approveWork(4) at '2020-09-26T17:00'.


/** <examples> 
?- go(Timeline).
?- state_diagram(Diagram).
*/