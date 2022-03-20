% differential filter
function difftaps = licz_diff (B_pol_dec, d_nfilters)

diff_filter = zeros(3,1);
    diff_filter(1) = -1;
    diff_filter(2) = 0;
    diff_filter(3) = 1;

    pwr = 0;
    difftaps = [];
    difftaps = [difftaps, 0];
    for i= 1:length(B_pol_dec)-3
        tap = 0;
        for j=1:length(diff_filter)
            tap = tap + diff_filter(j) * B_pol_dec(i + j);
        end
        difftaps = [difftaps, tap];
        pwr = pwr + abs(tap);
    end
    difftaps = [difftaps, 0];
    difftaps = (d_nfilters/pwr)*difftaps;

%     // Normalize the taps
%     for (unsigned int i = 0; i < difftaps.size(); i++) {
%         difftaps[i] *= d_nfilters / pwr;
%         if (difftaps[i] != difftaps[i]) {
%             throw std::runtime_error(
%                 "pfb_clock_sync_fff::create_diff_taps produced NaN.");
%         }
%     }
end
