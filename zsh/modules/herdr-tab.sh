# herdr sets HERDR_TAB_ID + HERDR_PANE_ID in every managed pane; preexec
# appends ".<agent>" to the focused tab's label (on top of any custom
# name) when an agent harness launches, and precmd strips back to the
# base name when the agent process exits.
#
# Uses the singular preexec / precmd functions instead of add-zsh-hook
# because zsh's preexec_functions[] callbacks receive no arguments —
# $1 is empty under add-zsh-hook preexec.
preexec() {
    emulate -L zsh
    [[ -z "$HERDR_TAB_ID" ]] && return 0
    local canonical
    case "${1%% *}" in
        claude|cl)    canonical=claude ;;
        opencode|oc)  canonical=opencode ;;
        codex|cx)     canonical=codex ;;
        *)            return 0 ;;
    esac
    local label
    label=$(herdr tab get "$HERDR_TAB_ID" 2>/dev/null \
        | jq -r '.result.tab.label // empty')
    local base="$label"
    if [[ "$label" =~ ^(.+)\.(claude|opencode|codex)$ ]]; then
        base="${match[1]}"
    fi
    herdr tab rename "$HERDR_TAB_ID" "${base}.${canonical}"
}

precmd() {
    emulate -L zsh
    [[ -z "$HERDR_TAB_ID" ]] && return 0
    [[ -z "$HERDR_PANE_ID" ]] && return 0
    local agent
    agent=$(herdr pane get "$HERDR_PANE_ID" 2>/dev/null \
        | jq -r '.result.pane.agent // empty')
    case "$agent" in
        claude|opencode|codex) return 0 ;;
    esac
    local label
    label=$(herdr tab get "$HERDR_TAB_ID" 2>/dev/null \
        | jq -r '.result.tab.label // empty')
    [[ "$label" =~ ^([0-9]+)\.(claude|opencode|codex)$ ]] || return 0
    herdr tab rename "$HERDR_TAB_ID" "${match[1]}"
}
