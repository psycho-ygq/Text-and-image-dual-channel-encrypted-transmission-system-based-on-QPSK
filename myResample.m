function  [y, h] = myResample(x)
bta = 5;
N = 10;
p = 40;
q = 1;

fc = 1/2/40;
L = 2*N*40 + 1;
tmp = firls(L-1, [0 2*fc 2*fc 1], [1 1 0 0]);
h = tmp.*kaiser(L,bta)' ;
h = p*h/sum(h);


Lhalf = (L-1)/2;
isvect = any(size(x)==1);
if isvect
    Lx = length(x);
else
    Lx = size(x, 1);
end

% Need to delay output so that downsampling by q hits center tap of filter.
nz = floor(q-mod(Lhalf,q));
z = zeros(1,nz);
h = [z h(:).'];  % ensure that h is a row vector.
Lhalf = Lhalf + nz;

% Number of samples removed from beginning of output sequence 
% to compensate for delay of linear phase filter:
delay = floor(ceil(Lhalf)/q);

% Need to zero-pad so output length is exactly ceil(Lx*p/q).
nz1 = 0;
while ceil( ((Lx-1)*p+length(h)+nz1 )/q ) - delay < ceil(Lx*p/q)
    nz1 = nz1+1;
end
h = [h zeros(1,nz1)];

% ----  HERE'S THE CALL TO UPFIRDN  ----------------------------
x = upsample(x, p);
x = x(1:end - 39);
y = conv(x, h);
% y = upfirdn(x,h,p,q);

% Get rid of trailing and leading data so input and output signals line up
% temporally:
Ly = ceil(Lx*p/q);  % output length
% Ly = floor((Lx-1)*p/q+1);  <-- alternately, to prevent "running-off" the
%                                data (extrapolation)

y(1:delay) = [];
y(Ly+1:end) = [];


h([1:nz (end-nz1+1):end]) = [];  % get rid of leading and trailing zeros 
                                 % in case filter is output