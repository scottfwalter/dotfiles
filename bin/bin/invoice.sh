#! /bin/bash
invoice generate --from 'Nikhil Vemu LLC' \
    --logo logo.png \
    --to 'SuperVPN, Inc.' \
    --date 'June 10, 2025' \
    --tax 0.18 \
    --discount 0.2 \
    --item 'Paid Article' \
    --quantity 5 \
    --rate 250 \
    --note 'Pleasure doing business with you.'
