function [Q, Sigma, delta, q_0, F] = DFA_construct(A)
%%This function accepts a finite event log formatted as a string array and outputs the 5 elements 
%%of a DFA.

%Check if the event log is in the correct format.
if isstring(A) == 0
    %Note if any input is a string it will force all other inputs to be strings also
    error("Event Log must consist of strings only.")
end

%First let's generate the alphabet from the event log.
Sigma = (strjoin(A, ""));
Sigma = unique(split(Sigma, ""))';
Sigma = Sigma(Sigma ~= ""); %Remove the empty string.

%Now let's initialise our initial and final state spaces.
q_0 = ""; %The initial state is determined by the empty string.
F = unique(A); %Final states are the unique events in the event log.

%Let's grab the prefixes of the event log.
%Initialise the prefixes array.
prefixes = [];
for i = 1:length(F)
    current_string = char(F(i)); %Set the current string.

    %Find all prefixes of current final state.
    for j = 1:(length(current_string) - 1)

        %Get prefix and add to collection of states
        current_prefix = string(current_string(1:j));
        prefixes = [prefixes, current_prefix];
    end
end

%Get the unique states
prefixes = unique(prefixes);

%Declare the entire state space
Q = [q_0,prefixes, F];

%Get the numbers of the states
state_names = string(num2cell(0:(length(Q))-1));

%Group the numbering of the states with the alphabetical states.
Q = vertcat(state_names, Q);

%Finally let's get delta, the transitions.
delta = string([]); %Initialise the transition
%Set up the delta index.
delta_index = 1;

%First loop over each state in the DFA
for i = 1:length(Q)

    %Initialise the current state
    current_string = Q(2,i);

    %Loop over the alphabet.
    for j=1:length(Sigma)

        %Add letter from alphabet to current state
        new_string = strcat(current_string, Sigma(j));

        %Compare new string to states in Q.
        for k = 1:length(Q)

            %Check if new string lies in Q.
            if new_string == Q(2,k)

                %If new string lies in Q add the transition to delta.
                delta(delta_index,:) = [Q(1,i), current_string , Sigma(j), Q(1,k), new_string];

                %Increment index to next entry in delta.
                delta_index = delta_index + 1;

                %Stop comparing new string to Q and try adding another
                %letter from the alphabet to current prefix.
                break
            end
        end
    end
end

%Get the state number of the initial state.
q_0 = [0; q_0];

%Get the state numbers of the final states.
for i = 1:length(F)
    for j = 1:length(Q)
        %Find which state number selected final state is.
        if F(i) == Q(2,j)
            F_state{i} = j-1;
        end
    end
end

%Add the state numbers to F
F = vertcat(F_state, F);

end