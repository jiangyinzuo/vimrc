command -nargs=0 -buffer AICommitMessageStaged call ai#GitCommitMessage(system('git --no-pager diff --staged'))
command -nargs=0 -buffer AICommitMessageAmend call ai#GitCommitMessage(system('git --no-pager show HEAD'))
