/* Notes:
 *      
 *      1. To begin with, I changed the given template. The first thing I modified was the assign predicate. I changed it so that 
 *         it uses tail-recursion which is a better technique. The template may resulted in a overflow stack since the recursion 
 *         was called in the beginning of the predicate. 
 * 
 *      2. In order for our assignments to satisfy the constraints I needed to modify the valid predicate as well. It now takes 
 *         as argument the maximum time and a current time which is initialized with the assigment's total time which we are 
 *         checking if it's valid or not. Furthermore, I added a constraint for the overlapping assignments which is represented by
 *         the calculation (Ab2-Ae1 >= 1 ; Ab1-Ae2 >= 1). The logic behind this is that two assignments in order not to overlapping each 
 *         other need to have at least one time unit difference. The beginning of the new one with the end of the previous one can check 
 *         this is exactly what I said. Also, this cover the case when an assignment with bigger start and end time was assigned first.
 *         In this case we need to check that the previous end with the new end time has one unit difference.
 * 
 *      3. After the creation of ASA, we were asked to make the ASP which is a list with elements <PId-APIds-T>. This means, we need to gather
 *         for every people their assignments and the total time that those assigmnets take. I created a helper predicate called sum_time. Given
 *         the APIds for a person it returns the total time that those assignments need. 
 * 
 * 
 * 
 *  
 * 
 *  
 * 
 * 
 */


:- compile(activity).

assignment(NP, MT, ASP, ASA):-
    findall(AId, activity(AId, _), AIds),
    assign(AIds, NP, MT, [], ASA),
    findall(PId-APIds-T, (between(1, NP, PId), findall(APId, member(APId-PId, ASA), APIds), sum_time(APIds, 0, T)), ASP).
    
sum_time([], S, S).
sum_time([APId|T], S0, S) :-
    activity(APId, act(Start, End)),
    S1 is S0 + (End - Start),
    sum_time(T, S1, S).

assign([], _, _, ASA, ASA).
assign([AId|AIds], NP, MT, SoFarASA, ASA) :-
    between(1, NP, PId), % Select a person PId for activity AId
    activity(AId, act(Ab, Ae)),
    findall(APId, member(APId-PId, SoFarASA), APIds), % Gather in list APIds so far activities of PId
    CT is Ae - Ab,
    valid(Ab, Ae, MT, CT, APIds),
    assign(AIds, NP, MT, [AId-PId|SoFarASA], ASA).

valid(_, _, _, _, []).
valid(Ab1, Ae1, MT, CT, [APId|APIds]):-
    activity(APId, act(Ab2, Ae2)),
    (Ab2-Ae1 >= 1 ; Ab1-Ae2 >= 1),
    CT1 is (CT+(Ae2-Ab2)),
    CT1 =< MT,
    valid(Ab1, Ae1, MT, CT1, APIds).

between(L, U, L) :-
    L=<U.
between(L, U, X) :-
    L<U,
    L1 is L+1,
    between(L1, U, X).