function ggp -w "git push origin main" -d "git push origin <current branch>"
  git push origin (__git.current_branch) $argv
end
