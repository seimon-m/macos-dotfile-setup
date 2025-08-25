function pubkey
    if test -f ~/.ssh/id_ed25519.pub
        cat ~/.ssh/id_ed25519.pub | pbcopy
        echo '=> Ed25519 Public key copied to pasteboard.'
    else if test -f ~/.ssh/id_rsa.pub
        cat ~/.ssh/id_rsa.pub | pbcopy
        echo '=> Public key copied to pasteboard.'
    else
        echo 'No public key file found (neither id_rsa.pub nor id_ed25519.pub).'
    end
end
