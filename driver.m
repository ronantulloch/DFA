%Define Event Log
A = ["cf", "cfa", "cfa","cfab", "cfab"];

<<<<<<< HEAD
%Get DFA
get_DFA(A);
=======
%Define the event log.
Event_Log = ["b","ce", "ce", "cf", "cfa", "cfa"]

%Get the DFA from the event log.
[Q, Sigma, delta, q_0, F] = DFA_construct(Event_Log)

%Get the transition matrix from the DFA.
P = DFA_to_markov(delta,F ,Event_Log)
diary off
>>>>>>> parent of 73e245e (Added robustness)
