function Y_out = stand_RD(Y)

Y_out = (Y-nanmean(Y(:)))./nanstd(Y(:));
