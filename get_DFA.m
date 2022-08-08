function [] = get_DFA(Event_Log)
clc;
%Just get the output of the DFA in a txt file.
dfile = 'output.txt';
if exist(dfile, 'file') ; delete(dfile); end
diary(dfile)
diary on

Event_Log

%Get the DFA from the event log.
[Q, Sigma, delta, q_0, F] = DFA_construct(Event_Log)

%Get the transition matrix from the DFA.
P = DFA_to_markov(delta,F ,Event_Log)
diary off
end
