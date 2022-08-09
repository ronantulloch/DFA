function [Q, Sigma, delta, q_0, F] = DFA_construct(A)
%%This function accepts a finite event log formatted as a string array and outputs the 5 elements 
%%of a DFA. See read me for output formats.

%Check if the event log is in the correct format.
if isstring(A) == 0
    %Note if any input is a string it will force all array elements to be strings.
    error("Event Log must consist of strings only.")
end

%Generate the alphabet from the event log.
Sigma = (strjoin(A, ""));
Sigma = unique(split(Sigma, ""))';
Sigma = Sigma(Sigma ~= ""); %Remove the empty strings at the start and end of the alphabet.

%Define the initial and final state spaces. 
q_0 = ""; %Per convention the initial space is an empty string.
F = unique(A); %Final states are all unique outcomes of the event log.

%Get the intermediate steps of the DFA.
%The intermediate steps are the set of unique prefixes of the final states in F.
prefixes = "";
for i = 1:length(F)
    %Set the current final state as the current string.
    current_string = char(F(i));

    %Find all prefixes of current final state.
    for j = 1:(length(current_string) - 1)

        %Get prefix and append to collection of states
        current_prefix = string(current_string(1:j));
        prefixes = [prefixes, current_prefix];
    end
end

%Account for duplicate prefixes and grab unique elements.
prefixes = unique(prefixes);

%Define the full state space, the union of initial, intermediate(prefixes) and final states.
Q = unique([q_0, prefixes, F]); %Check in case a prefix is also a final state.

%Number the states in Q with q_0 = 0 as reference and append to state space.
state_names = string(num2cell(0:(length(Q)) - 1));
Q = vertcat(state_names, Q);

%Add the state number to the initial state.
q_0 = [0; q_0];

%Get state numbers of final states.
for i = 1:length(F)
    for j = 1:length(Q)
        %Find which state number selected final state is.
        if F(i) == Q(2,j)
            F_state(i) = j-1; %Account for reference state number = 0.
        end
    end
end

%Add the state numbers to F
F = vertcat(F_state, F);

%Obtain delta, the transitions.
delta = string([]);

%Set up the delta index.
delta_index = 1;

%Loop over each state in the DFA
for i = 1:length(Q)
    %Set the current state.
    current_string = Q(2,i);

    %Loop over the alphabet.
    for j=1:length(Sigma)

        %Add letter from alphabet to current state to form new possible state.
        new_string = strcat(current_string, Sigma(j));

        %Loop over all states in Q
        for k = 1:length(Q)
            %If new string matches another possible state in Q, create a transition entry.
            if new_string == Q(2,k)
                %If new string lies in Q add the transition to delta.
                delta(delta_index,:) = [Q(1,i), current_string , Sigma(j), Q(1,k), new_string];

                %Increment index to add next transition entry.
                delta_index = delta_index + 1;

                %Stop checking for match and consider new symbol from Sigma.
                break
                
            end
        end
    end
end

end