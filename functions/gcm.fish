function gcm -w "git checkout main" -d "git checkout <current branch>"
  git checkout (__git.default_branch) $argv
end
