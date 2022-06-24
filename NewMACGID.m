function varargout = NewMACGID(varargin)
% Miragem5modified or NewMACGID
% Input: first argument = vector containing six wavenumbers, 2 electrons
% number e 3 bond lengths.
% Input: second argument = number of strong bes in the higher region.
% Input: no argument = interactive mode.
% Output: 3 arguments = composition of the garnet, experimental wavenumbers,
% electrons number e bond lengths, calculated wavenumbers,
% electrons number e bond lengths.
% Output: 1 argument = composition of the garnet.
disp('#####################################################')
disp('Calculation with wavenumbers, electron numbers e bond lengths')
disp('#####################################################')
disp('######################################')
disp('ATTENTION!!! FIRST PEAK MUST NOT BE USED')
disp('######################################')
if nargin == 0
    freqExp(1) = input('peak at ~220: ');%
    freqExp(2) = input('peak at ~360: ');%
    disp('if peak at ~360 e peak ~370 are indistinguishable use the same value for both two peaks ')
    freqExp(3) = input('peak at ~370: ');
    freqExp(4) = input('peak at ~540: ');%
    freqExp(5) = input('first peak between 800 e 870: ');%
    freqExp(6) = input('peak at ~900: ');%
    freqExp(7) = input('number of electron in X-site: ')*30;%
    freqExp(8) = input('number of electron in Y-site: ')*20;%
    freqExp(9) = input('Si-O length : ')*100;%
    freqExp(10) = input('X-O length : ')*100;%
    freqExp(11) = input('Y-O length : ')*100;%
    highRegion = input('number of medium-strong peaks between 800 e 900 (1-3)');%
elseif nargin == 2
    freqExp = varargin{1};
    highRegion = varargin{2};
else
    error ('the number of arguments should be 0 or 2')
end

% WAVENUMBERS, ELECTRON NUMBERS(e.n.), BOND LENGTHS(b.l.) MATRIX
% rows = wavenumbers, e.n., electrons, b.l. ; columns = end members
% Almandine Pyrope Grossular Uvarovite Knorringite
freq = [216, 211, 247, 242, 242;%peak 1
    343, 363.3, 367, 368, 368;%peak 2
    371, 377, 373.3, 368, 368;%peak 3
    556, 563, 547.4, 526, 551;%peak 4
    863, 868, 825, 837.4, 866;%peak 5
    915, 926.2, 879.1, 877.5, 908;%peak 6
    26*3*10, 12*3*10, 20*3*10, 20*3*10, 12*3*10;%X-site e.n.
    13*2*10, 13*2*10, 13*2*10, 24*2*10, 24*2*10;%Y-site e.n.
    1.6337*100, 1.6268*100, 1.6461*100, 1.6433*100, 1.6332*100; %T-O b.l.
    2.2973*100, 2.27265*100, 2.4045*100, 2.4294*100, 2.2804*100;%X-O b.l.
    1.8938*100, 1.8890*100, 1.9258*100, 1.9847*100, 1.9489*100];%Y-O b.l.
%References for wavenumbers:
% Almandine, pyrope, grossular e uvarovite, Bersani et al. (2009);
% Knorringite, Bykova et al (2014).
%References for bond lengths:
% Almandine, Smith et al (1988);Pyrope, Zhang et al (1998);
% Grossular, Geiger et al (1997);Uvarovite, Novak et al (1971);
% Knorringite, Bykova et al (2014).
if freqExp(1) > 0 ee freqExp(5) > 0 ee freqExp(7) >0 ee freqExp(8) > 0
    disp ('11 bes fit')
elseif freqExp(1) > 0 ee freqExp(5) == 0 ee freqExp(7) >0 ee freqExp(8) > 0
    freqExp(5) = [];
    freq(5,:) = [];
    disp ('10 bes fit')
elseif freqExp(1) == 0 ee freqExp(5) > 0 ee freqExp(7) >0 ee freqExp(8) > 0
    freqExp(1) = [];
    freq(1,:) = [];
    disp ('10 bes fit')
elseif freqExp(1) > 0 ee freqExp(5) > 0 ee freqExp(7) == 0 ee freqExp(8) == 0
    freqExp(8) = [];
    freq(8,:) = [];
    freqExp(7) = [];
    freq(7,:) = [];
    disp ('9 bes fit')
elseif freqExp(1) == 0 ee freqExp(5) > 0 ee freqExp(7) == 0 ee freqExp(8) == 0
    freqExp(8) = [];
    freq(8,:) = [];
    freqExp(7) = [];
    freq(7,:) = [];
    freqExp(1) = [];
    freq(1,:) = [];
    disp ('8 bes fit')
else
    freqExp(5) = [];
    freq(5,:) = [];
    freqExp(1) = [];
    freq(1,:) = [];
    disp ('7 bes fit')
end
freqExp = freqExp';
if highRegion == 1
    x0 = [.3;.3;.3;.05;.05];
elseif highRegion == 2
    x0 = [.05;.05;.05;.3;.3];
elseif highRegion == 3
    x0 = [.05;.05;.05;.55;.02];
else disp('ambiguous number of hi-freq bes')
    x0 = [.2; .2; .2; .2; .2];
end
for t = 1:100, % several times for a better optimization
    for xout = fminsearch(@scarto,x0,[],freqExp,freq);
        x0 = xout;
    end
    xout = abs(xout);
    xout = xout/sum(xout);
    x=xout;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% OUTPUT %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('######################################')
freqOut = freq*xout;
disp(['freqExp' sprintf('\t') 'freqOut' sprintf('\t') 'freqExp-freqOut'])
disp(num2str([freqExp freqOut freqExp-freqOut],4))
disp('######################################')
disp(['Deviation: ' num2str(sqrt(sum((freqExp-freqOut).^2)/numel(freqExp)))])
disp('######################################')
lista = {
    'almeine : '
    'pyrope : '
    'grossular : '
    'uvarovite : '
    'knorringite: '};
for k=1:length(xout),
    if xout(k)*100>1
        output_str{k} = [num2str(xout(k)*100,3) '%'];
    else
        output_str{k} = '<1%';
    end
    disp([lista{k} sprintf('\t') output_str{k}]);
end
disp('######################################')
disp('Miscibility check:')
xpas=xout(1)+xout(2)+xout(3);
if xpas<0.28 || xpas>0.72-0.19*xout(4)
    disp ('Acceptable')
else
    disp ('Out of miscibility range')
end
disp('######################################')
if nargout == 0
    varargout = 'Error';
elseif nargout == 1
    varargout{1} = xout;
elseif nargout == 3
    varargout{1} = xout;
    varargout{2} = freqExp;
    varargout{3} = freqOut;
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% SUBS %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s = scarto(x,freqExp,freq)
fs = freq*abs(x); % x = column vector containing the composition
s = sum((fs-freqExp).^2);
end