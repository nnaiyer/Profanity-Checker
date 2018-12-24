%%% CREATE PROFANITY DICTIONARY %%%
profanity = []; %%%%%%%%%% Create an matrix of profanities, separate using commas,
                %%%%%%%%%% and make sure the words are embedded in double quotes,
                %%%%%%%%%% i.e. profanity = ["this", "is", "an", "example"];
%%% ----------

%%% READ CSV FILE %%%
path = ; %%%%%%%%%% Input csv file path here
T = readtable(path);
rows = size(T, 1);
%%% ----------

%%% GET INFO FROM TABLE %%%
S = T{1:rows,{'Episode'}}; % These two can be modified
B = T{1:rows, {'Line'}};   % based on how your csv file is structured
%%% --------- 

%%% FIND NUMBER OF EPISODES IN SEASON %%%
unique_episodes = 1;
for k = 1:rows-1
    if(S(k) ~= S(k+1))
       unique_episodes = unique_episodes + 1;
    end
end
E = zeros(1, unique_episodes); Q = E;
%%% ---------

%%% FIND NUMBER OF LINES PER EPISODE %%%
for k = 1:rows
    for i = 1:unique_episodes
        if(S(k) == i)
            E(i) = E(i) + 1;
        end
    end
end

Q(1) = E(1);
for j = 2:unique_episodes
    Q(j) = E(j) + Q(j-1);
end
%%% ---------

%%% CREATE MATRICES EQUAL TO NUMBER OF EPISODES %%%
S = cell(rows, 1);
for n = 1:rows
    S{n} = zeros(rows, 1);
end
%%% ---------

%%% ASSIGN LINES TO RESPECTIVE EPISODES %%%
S{1} = B(1:Q(1));
for n = 1:unique_episodes-1
    S{n+1} = B(Q(n)+1:Q(n+1));
end
%%% ---------

%%% ITERATE THROUGH THE EPISODES AND COUNT PROFANITY OCCURENCES %%%
profanity_count = 0;
profanityMatrix = zeros(1, unique_episodes);

% Since we're dealing with such small numbers, this nest shouldn't matter
for k = 1:unique_episodes
    for i = 1:E(k)
        str = lower(S{k}(i));
        for j = 1:size(profanity, 2)
            if(strfind(str{1}, profanity(j)) >= 0)
                x = strfind(str{1}, profanity(j));
                addby = size(x, 2);
                profanity_count = profanity_count + addby;
            end
        end
    end
    profanityMatrix(k) = profanity_count;
    profanity_count = 0;
end
%%% ----------

%%% PRINT THE NUMBER OF TIMES PROFANITY OCCURS %%%
for k = 1:unique_episodes
    sprintf('Episode %d has %d occurences of profanity', k, profanityMatrix(k))
end
%%% ----------