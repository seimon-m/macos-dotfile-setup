function ggl -w "git pull origin main" -d "git pull origin <current branch>"
  git pull origin (__git.current_branch) $argv
end
