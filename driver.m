%Define Event Log
A = ["a", "b", "B", "Bb5"];

% To demonstrate lack of cycles
%A = ["aaaaa","abbb"];

% To demonstrate one-to-one-ness
%A = ["aaaaa","abaaa"];


% Number of states: maximum case
%A = ["abc","def","ghi"];
% Number of states: minimum case
%A = ["a","a","a"];


% Number of final states
%A = ["abc","def","aef","abc"];


%Get DFA
get_DFA(A);

