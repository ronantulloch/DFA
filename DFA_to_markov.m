function P = DFA_to_markov(delta, A)
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

    %Loop over all observations in the event log.
    for j = 1:length(A)
        %Get current observation from event log.
        current_obs = char(A(j));

        %Check if the length of the current observation is greater than the length of the current
        %string
        if length(current_obs) >= strlength(current_string)
            %If true grab only the first corresponding symbols.
            current_obs = current_obs(1:strlength(current_string));
        end
        %Get the prefix of the current observation.
        current_obs_pre = string(current_obs(1:end - 1));
        current_obs = string(current_obs); %Turn back to string.

        %Check if current observation matches string.
        if current_obs == current_string
            %If true increment counter.
            count_state = count_state + 1;
        end
        %Check if current observation(or prefix) matches the current prefix.
        if current_obs_pre == current_prefix || current_obs == current_prefix
            %If so increment count.
            count_prefix = count_prefix + 1;
        end
    end
        %Calculate the probability of going from prefix state to current state.
        P((str2double(delta(i,1)) + 1), (str2double(delta(i,4))+ 1 )) = count_state/count_prefix;
end

%Fix any missing transition probabilities
for i = 1:length(P)
    %If state is a final state loop back to the initial state.
    if sum(P(i,:)) == 0
        P(i,1) = 1;

    %Else if a prefix is also a final state calculate the probability it will stay there.
    elseif sum(P(i,:)) ~= 1
        P(i, i) = 1 - sum(P(i,:));
    end
end

end