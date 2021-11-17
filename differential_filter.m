
% differential filter
clc; clear; close all;

newtaps = [0.000379010145648274,0.000215896601730940,4.99286831751281e-05,-0.000118030831795061,-0.000287090413044753,-0.000456333799677277,-0.000624824230319346,-0.000791608866006889,-0.000955723387914072,-0.00111619675100884,-0.00127205607362892,-0.00142233164195802,-0.00156606200744884,-0.00170229915439410,-0.00183011371409193,-0.00194860020139557,-0.00205688224888107,-0.00215411781341650,-0.00223950432957463,-0.00231228378410235,-0.00237174768554546,-0.00241724190313101,-0.00244817134913097,-0.00246400447917368,-0.00246427758533194,-0.00244859885730103,-0.00241665218758439,-0.00236820069732872,-0.00230308996029284,-0.00222125090339288,-0.00212270236333833,-0.00200755328005560,-0.00187600450888477,-0.00172835023492626,-0.00156497897440328,-0.00138637414948757,-0.00119311422470372,-0.000985872394776853,-0.000765415815610961,-0.000532604371975221,-0.000288388977425275,-3.38094039875946e-05,0.000230008358819662,0.000501855213975393,0.000780442532192984,0.00106440618652033,0.00135231103828254,0.00164265586421428,0.00193387871250500,0.00222436267337596,0.00251244204773249,0.00279640889539699,0.00307451994243827,0.00334500382517946,0.00360606864659902,0.00385590981904700,0.00409271816548992,0.00431468824988054,0.00452002690573299,0.00470696193057536,0.00487375091265989,0.00501869015514138,0.00514012366189498,0.00523645214824023,0.00530614203907586,0.00534773441631360,0.00535985387703440,0.00534121726348036,0.00529064222584445,0.00520705557882922,0.00508950141311890,0.00493714892324638,0.00474929991383909,0.00452539594689585,0.00426502509357900,0.00396792825500177,0.00363400501764770,0.00326331901037362,0.00285610273141775,0.00241276181545466,0.00193387871250500,0.00142021575241400,0.000872717570653486,0.000292512873368894,-0.000319084478119170,-0.000960575080750628,-0.00163027431598839,-0.00232631340120017,-0.00304664117577123,-0.00378902662880379,-0.00455106217243836,-0.00533016766195872,-0.00612359516092612,-0.00692843444664117,-0.00774161924826507,-0.00855993420695822,-0.00938002254442389,-0.0101983944232919,-0.0110114359798520,-0.0118154190067633,-0.0126065112605335,-0.0133807873657965,-0.0141342402857253,-0.0148627933253157,-0.0155623126317733,-0.0162286201538432,-0.0168575070196520,-0.0174447472904885,-0.0179861120459547,-0.0184773837540674,-0.0189143708782012,-0.0192929226712458,-0.0196089441059996,-0.0198584108896603,-0.0200373845092984,-0.0201420272544139,-0.0201686171620980,-0.0201135628299407,-0.0199734180416506,-0.0197448961503905,-0.0194248841650781,-0.0190104564853583,-0.0184988882316225,-0.0178876681173309,-0.0171745108119802,-0.0163573687443565,-0.0154344432972089,-0.0144041953461759,-0.0132653550976896,-0.0120169311826575,-0.0106582189649836,-0.00918880802642335,-0.00760858879186700,-0.00591775826190019,-0.00411682482239740,-0.00220661210394264,-0.000188261867040172,0.00193676410763881,0.00416668314134172,0.00649939180554360,0.00893246710681465,0.0114631687149612,0.0140884422374831,0.0168049235396790,0.0196089441059996,0.0224965374345008,0.0254634464525154,0.0285051319379346,0.0316167819268092,0.0347933220843359,0.0380294270127185,0.0413195324658891,0.0446578484376606,0.0480383730865710,0.0514549074574848,0.0549010709569480,0.0583703175363689,0.0618559525343213,0.0653511501266569,0.0688489713306794,0.0723423825073747,0.0758242743036479,0.0792874809746374,0.0827248000245615,0.0861290121030920,0.0894929010930713,0.0928092743243901,0.0960709828481146,0.0992709417044349,0.102402150117742,0.105457711552115,0.108430853560707,0.111314947362994,0.114103527084523,0.116790308594749,0.119369207879727,0.121834358887815,0.124180130788181,0.126401144583782,0.128492289022504,0.130448735752495,0.132265953670140,0.133939722411830,0.135466144943524,0.136841659205106,0.138063048769742,0.139127452481755,0.140032373040000,0.140775684497333,0.141355638650420,0.141770870297973,0.142020401349348,0.142103643769380,0.142020401349348,0.141770870297973,0.141355638650420,0.140775684497333,0.140032373040000,0.139127452481755,0.138063048769742,0.136841659205106,0.135466144943524,0.133939722411830,0.132265953670140,0.130448735752495,0.128492289022504,0.126401144583782,0.124180130788181,0.121834358887815,0.119369207879727,0.116790308594749,0.114103527084523,0.111314947362994,0.108430853560707,0.105457711552115,0.102402150117742,0.0992709417044349,0.0960709828481146,0.0928092743243901,0.0894929010930713,0.0861290121030920,0.0827248000245615,0.0792874809746374,0.0758242743036479,0.0723423825073747,0.0688489713306794,0.0653511501266569,0.0618559525343213,0.0583703175363689,0.0549010709569480,0.0514549074574848,0.0480383730865710,0.0446578484376606,0.0413195324658891,0.0380294270127185,0.0347933220843359,0.0316167819268092,0.0285051319379346,0.0254634464525154,0.0224965374345008,0.0196089441059996,0.0168049235396790,0.0140884422374831,0.0114631687149612,0.00893246710681465,0.00649939180554360,0.00416668314134172,0.00193676410763881,-0.000188261867040172,-0.00220661210394264,-0.00411682482239740,-0.00591775826190019,-0.00760858879186700,-0.00918880802642335,-0.0106582189649836,-0.0120169311826575,-0.0132653550976896,-0.0144041953461759,-0.0154344432972089,-0.0163573687443565,-0.0171745108119802,-0.0178876681173309,-0.0184988882316225,-0.0190104564853583,-0.0194248841650781,-0.0197448961503905,-0.0199734180416506,-0.0201135628299407,-0.0201686171620980,-0.0201420272544139,-0.0200373845092984,-0.0198584108896603,-0.0196089441059996,-0.0192929226712458,-0.0189143708782012,-0.0184773837540674,-0.0179861120459547,-0.0174447472904885,-0.0168575070196520,-0.0162286201538432,-0.0155623126317733,-0.0148627933253157,-0.0141342402857253,-0.0133807873657965,-0.0126065112605335,-0.0118154190067633,-0.0110114359798520,-0.0101983944232919,-0.00938002254442389,-0.00855993420695822,-0.00774161924826507,-0.00692843444664117,-0.00612359516092612,-0.00533016766195872,-0.00455106217243836,-0.00378902662880379,-0.00304664117577123,-0.00232631340120017,-0.00163027431598839,-0.000960575080750628,-0.000319084478119170,0.000292512873368894,0.000872717570653486,0.00142021575241400,0.00193387871250500,0.00241276181545466,0.00285610273141775,0.00326331901037362,0.00363400501764770,0.00396792825500177,0.00426502509357900,0.00452539594689585,0.00474929991383909,0.00493714892324638,0.00508950141311890,0.00520705557882922,0.00529064222584445,0.00534121726348036,0.00535985387703440,0.00534773441631360,0.00530614203907586,0.00523645214824023,0.00514012366189498,0.00501869015514138,0.00487375091265989,0.00470696193057536,0.00452002690573299,0.00431468824988054,0.00409271816548992,0.00385590981904700,0.00360606864659902,0.00334500382517946,0.00307451994243827,0.00279640889539699,0.00251244204773249,0.00222436267337596,0.00193387871250500,0.00164265586421428,0.00135231103828254,0.00106440618652033,0.000780442532192984,0.000501855213975393,0.000230008358819662,-3.38094039875946e-05,-0.000288388977425275,-0.000532604371975221,-0.000765415815610961,-0.000985872394776853,-0.00119311422470372,-0.00138637414948757,-0.00156497897440328,-0.00172835023492626,-0.00187600450888477,-0.00200755328005560,-0.00212270236333833,-0.00222125090339288,-0.00230308996029284,-0.00236820069732872,-0.00241665218758439,-0.00244859885730103,-0.00246427758533194,-0.00246400447917368,-0.00244817134913097,-0.00241724190313101,-0.00237174768554546,-0.00231228378410235,-0.00223950432957463,-0.00215411781341650,-0.00205688224888107,-0.00194860020139557,-0.00183011371409193,-0.00170229915439410,-0.00156606200744884,-0.00142233164195802,-0.00127205607362892,-0.00111619675100884,-0.000955723387914072,-0.000791608866006889,-0.000624824230319346,-0.000456333799677277,-0.000287090413044753,-0.000118030831795061,4.99286831751281e-05,0.000215896601730940,0.000379010145648274];

diff_filter = zeros(3,1);
    diff_filter(1) = -1;
    diff_filter(2) = 0;
    diff_filter(3) = 1;

%     float pwr = 0;
%     difftaps.clear();
    difftaps = [];
    difftaps = [difftaps, 0];
    for i= 1:length(newtaps)-3
        tap = 0;
        for j=1:length(diff_filter)
            tap = tap + diff_filter(j) * newtaps(i + j);
        end
        difftaps = [difftaps, tap];
%         pwr += fabsf(tap);
    end
    difftaps = [difftaps, 0];

%     // Normalize the taps
%     for (unsigned int i = 0; i < difftaps.size(); i++) {
%         difftaps[i] *= d_nfilters / pwr;
%         if (difftaps[i] != difftaps[i]) {
%             throw std::runtime_error(
%                 "pfb_clock_sync_fff::create_diff_taps produced NaN.");
%         }
%     }