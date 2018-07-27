% arguments (minimum 1): 
%       1. I : image to be calibrated ; if the only argument, it's assumed
%               it's a Macbeth color checker
%       2. ref_checker : Macbeth color checkerboard picture, taken under 
%                   the same conditions as the image to be calibrated.
%                   if only two arguments, this will be calibrated without
%                   normalization
%       3. 'normalized' : if present, RGB vectors are divided by their sum
%       in both the samples and in the reference values
function calib_img = colorCalib(varargin)

% storing variables for use within the function
I = double(varargin{1}); %img
norm = 0;
ref_checker = I;
if length(varargin) > 1
    ref_checker = varargin{2};
    if length(varargin) == 3
        if strcmp(lower(varargin{3}),'normalized')
            norm  = 1;
        end
    end
end

%% each begining of a 6-patch line on the checker is represented 
% in the comments of RGB_ref as  ----------- 
RGB_ref =  [115     82     68; %(1,:)dark skin (brown) ----------- 
            194    150    130; %    light skin
             98    122    157; %    blue sky
             87    108     67; %    foliage
            133    128    177; %    blue flower
            103    189    170; %(6,:)bluish green
            214    126     44; %(7,:)organge -----------
             80     91    166;
            193     90     99;
             94     60    108;
            157    188     64; 
            224    163     46; %(12,:)orange yellow
             56     61    150; %(13,:)blue -----------
             70    148     73;
            175     54     60;
            231    199     31;
            187     86    149; 
              8    133    161; %(18,:)cyan
            243    243    242; %%(19,:)white-----------
            200    200    200;
            160    160    160;
            122    122    121;
             85     85     85; 
             52     52     52];%(24,:)black
        
%% code co
calib_img = 1;
end