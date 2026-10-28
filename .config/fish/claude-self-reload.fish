# Wraps claude so /self-reload (see .claude/skills/self-reload) can restart it with --resume.
function claude --wraps claude --description 'claude with self-reload support'
    set -l dir $HOME/.cache/claude-self-reload
    set -q CLAUDE_SELF_RELOAD_DIR; and set dir $CLAUDE_SELF_RELOAD_DIR
    rm -f $dir/$fish_pid
    command claude $argv
    set -l st $status
    while test -f $dir/$fish_pid
        set -l id (string trim < $dir/$fish_pid)
        rm -f $dir/$fish_pid
        test -n "$id"; or break
        command claude --resume $id
        set st $status
    end
    return $st
end
