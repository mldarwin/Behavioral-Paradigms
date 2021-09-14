% ---Go/No-go Task Behavior Analysis---
% Calculate reaction times and response errors for a Go Nogo task
% Output a table with patient ID, reaction time, and accuracy
%
% Marielle L. Darwin | April 20 2021

function [OutTable] = GoNogoBehaviorAnalysis(SessionFolder)

% Indicate folder where behavioral session files are stored
cd(SessionFolder);
TempDir=dir('*.mat');   

% Extract file names into a cell array
DataFileName={TempDir.name};
FileParts=cellfun(@(x) strsplit(x,'_'),DataFileName,'UniformOutput',false);                       
PatientID=transpose(cellfun(@(x) x{1},FileParts,'UniformOutput',false));

% Results variables
ReactionTime=zeros(size(PatientID));
error_percentage=zeros(size(PatientID));

for j=1:numel(DataFileName)
    FileData=load(DataFileName{j});
    % Calculate reaction time
    reactiontimes=FileData.responsetime(FileData.conditionsrand==1)...
        -FileData.targettime(FileData.conditionsrand==1);
    meanRT=mean(reactiontimes);  
    ReactionTime(j)=meanRT;
    % Calculate accuracy
    errors_commission=length(find(FileData.buttonpressed(FileData.conditionsrand==2)==1));
    error_percentage(j)=(errors_commission/(FileData.nTrials-FileData.numbergo))*100;
end

% Output table with patient ID, reaction time, and percent error
OutTable=table(PatientID,ReactionTime,error_percentage,...
    'VariableNames',{'Patient_ID','MeanRT','Percent_Error'})
end
