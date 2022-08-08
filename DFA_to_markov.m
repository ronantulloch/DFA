function P = DFA_to_markov(delta, F, A)
%%This code takes a valid DFA and calculates a corresponding transition markov chain
%%transition matrix. See read me for output format.

%Initialise the transition matrix.
P = zeros((size(delta,1) + 1));

for i = 1:size(delta,1)
    %Set current state and it's corresponding prefix.
    current_string = delta(i, 5);
    current_prefix = delta(i, 2);

    %Initialise the counts of the observations and it's prefix.
    count_state = 0;
    count_prefix = 0;

    %Check if the prefix is the initial state.
    if current_prefix == ""
        %Loop over all elements in the event log.
        for j = 1:length(A)
            %Get the current observation of the event log and shorten to length of current
            %observation.
            current_observation = A(j);
            current_observation = char(current_observation);
            current_observation = string(current_observation(1:strlength(current_string)));

            %Check if the current observation matches the current element from Q.
            if current_observation == current_string
                %If matches increment the count.
                count_state = count_state + 1;
            end
        end

        %Calculate the probability as the number of observations of the current string divided by
        %the length of the event log. This is because the current observations are of length 1.
        P((str2double(delta(i,1)) + 1), (str2double(delta(i,4)) + 1)) = (count_state/length(A));

    %Check if current prefix is also a final state and get probability of staing in final state or
    %continuing to second final state.
    elseif any(matches(current_prefix, F))
        for j = 1:length(A)

            current_observation = A(j);

            if current_string == current_observation
                count_state = count_state + 1;
            end

            if current_prefix == current_observation
                count_prefix = count_prefix + 1;
            end
        end
        %Calculate the transition probability that a final state will continue to another final
        %state.
        P((str2double(delta(i,1)) + 1), (str2double(delta(i,4)) + 1)) = ...
            (count_state/(count_state+count_prefix));

        %Now consider the probability that the state will stay in it's final state.
        P((str2double(delta(i,1)) + 1), (str2double(delta(i,1)) + 1)) = ...
            1 - P((str2double(delta(i,1)) + 1), (str2double(delta(i,4)) + 1));
    %If the current prefix is not the initial state calculate the transition probability.
    else
        %Consider all elements of the event log.
        for j=1:length(A)
            %Get an observation of the event log and shorten to same length as the current state
            % and prefix respectively.
            current_observation = A(j);
            current_observation = char(current_observation);

            %Check if length of the current string is longer than that of the current observation.
            if strlength(current_string) <= length(current_observation)
                current_observation_prefix = string(current_observation(1:strlength(current_prefix)));
                current_observation = string(current_observation(1:strlength(current_string)));
            else
                current_observation_prefix = string(current_observation(1:...
                    (length(current_observation)-1)));
                current_observation = string(current_observation);
            end

            %Check if current observation matches the
            if current_observation == current_string
                %If matches increment the state count.
                count_state = count_state + 1;
            end

            %Check how many times the prefix is in the event log.
            if current_observation_prefix == current_prefix
                %If matches increment the prefix count
                count_prefix = count_prefix + 1;
            end
        end

        %Calculate the transition probability. It is the number of observations of the state divided
        %by the number of observations of the prefix.
        P((str2double(delta(i,1)) + 1), (str2double(delta(i,4)) + 1)) = (count_state/+count_prefix);
    end
end


%For the transition matrix to be valid the final states need to loop back to the initial state.
for i = 1:length(P)
    %Check if state is a final state.
    if sum(P(i,:)) == 0
        %If the state is final then connect to initial state with probability 1.
        P(i,1) = 1;
    end
end

end