function P = DFA_to_markov(delta, A)
%%This code takes a valid DFA and calculates a corresponding transition markov chain 
%%transition matrix.

%Initialise the transition matrix.
P = zeros((size(delta,1)+1));

%Calculate the transition matrix.
for i = 1:size(delta,1)
    %Initialise current state and it's corresponding prefix.
    current_string = delta(i, 5);
    current_prefix = delta(i, 2);

    %Initialise the observation counts of states and prefixes.
    count_state = 0;
    count_prefix = 0;

    %Check if the prefix is the initial state.
    if current_prefix == ""
        for j = 1:length(A)
            %Get the observations of the event logs of same length as the current state.
            current_observation = A(j);
            current_observation = char(current_observation);
            current_observation = string(current_observation(1:strlength(current_string)));

            %If the current observation matches the state then increase the count of state.
            if current_observation == current_string
                count_state = count_state + 1;
            end
        end

        %Get the probability matrix entry it is the number of prefix counts divided by event log
        %length.
        P((str2double(delta(i,1)) + 1), (str2double(delta(i,4)) + 1)) = (count_state/length(A));

    else
        %If not a final state or first prefix get
        for j=1:length(A)
            %Get the observations of the event logs of same length as the current state and prefix
            %respecitvally.
            current_observation = A(j);
            current_observation = char(current_observation);

            %Add some checking to add robustness to the algorithm
            if strlength(current_string) <= length(current_observation)
                current_observation_prefix = string(current_observation(1:strlength(current_prefix)));
                current_observation = string(current_observation(1:strlength(current_string)));
            else
                current_observation_prefix = string(current_observation(1:...
                    (strlength(current_observation)-1)));
                current_observation = string(current_observation);
            end

            %Count the number of times the event lies within the log.
            if current_observation == current_string
                count_state = count_state + 1;
            end

            %Check how many times the prefix is in the log.
            if current_observation_prefix == current_prefix
                count_prefix = count_prefix + 1;
            end
        end

        %Calculate the transition probability.
        P((str2double(delta(i,1)) + 1), (str2double(delta(i,4)) + 1)) = (count_state/count_prefix);
    end
end

%Now we need to loop final states back to the intial state.
for i = 1:length(P)
    if sum(P(i,:)) == 0
        P(i,1) = 1;
    end
end

end