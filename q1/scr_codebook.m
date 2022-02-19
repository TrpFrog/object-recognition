trp = get_img_fnames('trumpet');
trb = get_img_fnames('trombone');
tptb = [trp(:)', trb(:)'];
make_codebook(tptb, 'codebook_tptb');

frog = get_img_fnames('frog');
leek = get_img_fnames('leek');
frle = [frog(:)', leek(:)'];
make_codebook(frle, 'codebook_frle');
