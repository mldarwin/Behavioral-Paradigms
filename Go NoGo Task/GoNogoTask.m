% ---Go/No-go Task---
% Press key if green circle is on screen, do not press if red circle is on screen
%
% Marielle L. Darwin | April 20 2021

clear all;
close all;
ska

% Enter participant ID
participantID=input('Please enter the participant number','s');

% Set up screen
Screen('Preference', 'VBLTimestampingMode', -1);
Screen('Preference', 'SkipSyncTests', 2);

[w1,rect]=Screen('OpenWindow',0,0);         % Open PTB window
[center(1),center(2)]=RectCenter(rect);     % Calculate center of screen from 'rect' coordinates
Priority(MaxPriority(w1));                  % Prioritize PTB window 'w1'
HideCursor();

% Parameter variables
nTrials=10;                                 % Define # of trials
numbergo=5;                                 % Define # of go trials

% Results variables  
buttonpressed=zeros(nTrials,1);             % Record 1=button pressed, 0=no button pressed
targettime=zeros(nTrials,1);                % Record time target was on screen/trial
responsetime=zeros(nTrials,1);              % Record time of button press

% Experimental conditions
conditions=[repmat(1,1,numbergo),repmat(2,1,nTrials-numbergo)]; % Specify trial condition 
rng('shuffle');                                                 % Randomize trial order
conditionsrand=conditions(randperm(length(conditions)));        % Randomize order of elements in conditions 

% Draw text on screen
Screen('DrawText',w1,'Press any key to begin',...
    center(1)-100,center(2)-10,255); % Text on screen given relative to center coordinates, white text
Screen('Flip',w1);     
KbStrokeWait                         % Stop script from running until a key is pressed
Screen('Flip',w1);     
WaitSecs(1);                         % Stay on this screen for 1 second before continuing 

% Define size of stimuli
circlesize=100;
circlecoordinates=[center(1)-circlesize,center(2)-circlesize,center(1)+circlesize,center(2)+circlesize];

% For loop to iterate through trials
for trialcount=1:nTrials    
    if conditionsrand(trialcount)==1                        % Determines if current trial=1 (go trial)
        Screen('FillOval',w1,[0 255 0],circlecoordinates);  % If 'go' trial, present green circle on screen
    elseif conditionsrand(trialcount)==2                    % If nogo trial...
        Screen('FillOval',w1,[255 0 0],circlecoordinates);  % ...present red circle
    end
    
    Screen('Flip',w1);                                     
    
    % Record stimulus times
    %
    % RxnTime=(Time of response-time of target presentation)
    % 'targettime' used to record time of target presentation on each trial
    targettime(trialcount)=GetSecs;     % Record time of target presentation
    
    % Detect and record responses                               
    tic;                                       % Set timer from 0 at this point, right before keypress responses
    while toc<1.5                              % How long we are looking for a response 
        [~,keysecs,keyCode]=KbCheck;           
        if keyCode(KbName('space'))==1         % If spacebar is pressed...
            responsetime(trialcount)=keysecs;  % Time of keypress into 'responsetime' variable at corresponding point for the current trial using 'trialcount'
            buttonpressed(trialcount)=1;       % Indicate that a 'go' response was made on this trial
        end
    end
    % Note: On Nogo trials, 'responsetime' and 'buttonpressed' values=0. Should be excluded when calculating rxn times
    Screen('Flip',w1);
    
    % Specify escape keys
    [~,~,keyCode]=KbCheck;          % Check for any specified key press
    if keyCode(KbName('q'))==1      % If 'q' is pressed, quit experiment while it's running
        break                       % Forces code to exit current loop 
    end
    
    % Include ITIs
    jitterinterval=1+(3-1)*rand;     
    WaitSecs(jitterinterval);       
end

% Save data
save(sprintf('%s_data_%dGo',participantID,numbergo));
   
Screen('Close',w1)
Priority(0);
ShowCursor();
