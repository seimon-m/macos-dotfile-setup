## Defines abbreviations
function setup
    for abbreviation in (abbr -l)
        abbr -e $abbreviation
    end
    abbr gaa git add --all
    abbr gb git branch
    abbr gbd git branch -d
    abbr gcam git commit -am
    abbr gcb git checkout -b
    abbr gco git checkout
    abbr glg git log --stat
    abbr glgp git log --stat -p
    abbr glgg git log --graph
    abbr glgga git log --graph --decorate --all
    abbr glgm git log --graph --max-count=10
    abbr glo git log --oneline --decorate
    abbr glol git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'
    abbr glols git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --stat
    abbr glod git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'
    abbr glods git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short
    abbr glola git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --all
    abbr glog git log --oneline --decorate --graph
    abbr gloga git log --oneline --decorate --graph --all
    abbr gm git merge
    abbr gsb git status -sb
    abbr .. cd ..
    abbr ... cd ../..
    abbr .... cd ../../..
    abbr ..... cd ../../../..
    abbr ls ls $LS_OPTIONS -hFtr
    abbr ll ls $LS_OPTIONS -lAhFtr
    abbr l ls -lF
    abbr la ls -lAF
    abbr lsd ls -lF | grep --color=never '^d'
    abbr grep grep --color=auto
    abbr fgrep fgrep --color=auto
    abbr egrep egrep --color=auto
    abbr cgu composer global update
	abbr vs valet secure
end
