#!/usr/bin/env zsh

# ============================================
# OpenCode Configuration Switcher (zsh optimized)
# ============================================
# Optimized for zsh + kitty + zellij environment
# ============================================

set -e

# Configuration
CONFIG_DIR="$HOME/.config/opencode"
CONFIG_FILE="$CONFIG_DIR/oh-my-opencode.json"
CONFIG_PATTERN="oh-my-opencode-*.json"

# Check if color output should be enabled
if [ -t 1 ] && [ "$TERM" != "dumb" ]; then
    # Use zsh print -P for colors (best for zsh)
    USE_COLOR=true
else
    USE_COLOR=false
fi

# ============================================
# Utility Functions
# ============================================

print_info() {
    if $USE_COLOR; then
        print -P '%F{blue}ℹ%f'"$1"
    else
        print "ℹ $1"
    fi
}

print_success() {
    if $USE_COLOR; then
        print -P '%F{green}✓%f'"$1"
    else
        print "✓ $1"
    fi
}

print_warning() {
    if $USE_COLOR; then
        print -P '%F{yellow}⚠%f'"$1"
    else
        print "⚠ $1"
    fi
}

print_error() {
    if $USE_COLOR; then
        print -P '%F{red}✗%f'"$1"
    else
        print "✗ $1"
    fi
}

print_header() {
    print ""
    if $USE_COLOR; then
        print -P '%B========================================%b'
        print -P '%B'"$1"'%b'
        print -P '%B========================================%b'
    else
        print "========================================"
        print "$1"
        print "========================================"
    fi
    print ""
}

# ============================================
# Configuration Discovery
# ============================================

discover_configs() {
    local configs=()

    # Use find to locate config files (more reliable across shells)
    while IFS= read -r config_file; do
        if [ -f "$config_file" ]; then
            local basename=$(basename "$config_file")
            local name="${basename#oh-my-opencode-}"
            name="${name%.json}"
            configs+=("$name|$basename")
        fi
    done < <(find "$CONFIG_DIR" -maxdepth 1 -name "$CONFIG_PATTERN" -type f 2>/dev/null | sort)

    if [ ${#configs[@]} -gt 0 ]; then
        printf '%s\n' "${configs[@]}"
    fi
}

get_config_description() {
    local config_file="$1"
    local description=""

    if [ -f "$config_file" ]; then
        # Try to extract description from JSON file (compatible with macOS grep)
        description=$(grep -o '"description"[[:space:]]*:[[:space:]]*"[^"]*"' "$config_file" 2>/dev/null | sed 's/.*"description"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/' | head -1)
    fi

    if [ -z "$description" ]; then
        local name=$(basename "$config_file" .json)
        case "$name" in
            *antigravity*)
                description="Antigravity priority - Claude Opus/Sonnet + Gemini 3"
                ;;
            *alibaba*)
                description="Alibaba priority - GLM-4.7 + QWen3 Code + MiniMax"
                ;;
            *)
                description="Custom configuration profile"
                ;;
        esac
    fi

    echo "$description"
}

# ============================================
# Current Configuration
# ============================================

get_current_config() {
    if [ -L "$CONFIG_FILE" ]; then
        local current_link=$(readlink "$CONFIG_FILE")
        basename "$current_link"
    elif [ -f "$CONFIG_FILE" ]; then
        echo "oh-my-opencode.json (not a symlink)"
    else
        echo "none"
    fi
}

is_managed_config() {
    local current=$(get_current_config)
    [[ "$current" == "oh-my-opencode-"*".json" ]] && [[ "$current" != "oh-my-opencode.json (not a symlink)" ]]
}

# ============================================
# Display Functions
# ============================================

show_help() {
    cat << EOF
OpenCode Configuration Switcher

USAGE:
    $(basename "$0") [COMMAND] [OPTIONS]

COMMANDS:
    status                      Show current configuration status
    list                        List all available configuration profiles
    switch [CONFIG]             Switch to specified configuration
                                If CONFIG is omitted, toggles between configs
    --help, -h                  Show this help message

ARGUMENTS:
    CONFIG                      Configuration name (e.g., antigravity, alibaba)
                                Use 'list' command to see available configs

EXAMPLES:
    # Show current status
    $(basename "$0") status

    # List all available configurations
    $(basename "$0") list

    # Switch to specific configuration
    $(basename "$0") switch antigravity
    $(basename "$0") switch alibaba

    # Toggle between configurations
    $(basename "$0") switch

NOTES:
    • Configuration files must follow pattern: oh-my-opencode-*.json
    • After switching, restart OpenCode to apply changes
    • Original configurations are automatically backed up

FILES:
    • Configurations: $CONFIG_DIR/$CONFIG_PATTERN
    • Active config:  $CONFIG_FILE
    • Script:         $(realpath "$0")

EOF
}

show_status() {
    local current=$(get_current_config)
    local is_managed=false

    if is_managed_config; then
        is_managed=true
    fi

    print_header "OpenCode Configuration Status"

    if $USE_COLOR; then
        print -P '%F{green}'"$current"'%f'
    else
        print "Current config: $current"
    fi
    print ""

    if $is_managed; then
        local config_file="$CONFIG_DIR/$current"
        local description=$(get_config_description "$config_file")
        if $USE_COLOR; then
            print -P '%F{cyan}'"$description"'%f'
        else
            print "Description: $description"
        fi
        print ""

        print -P "Active models:"
        if [[ "$current" == *"antigravity"* ]]; then
            if $USE_COLOR; then
                print -P "  • Reasoning agents: %F{green}Claude Opus 4.5 Thinking%f"
                print -P "  • Coding agents:    %F{green}Claude Sonnet 4.5 Thinking%f"
                print -P "  • UI/UX tasks:      %F{green}Gemini 3 Pro%f"
                print -P "  • Quick tasks:      %F{green}Gemini 3 Flash%f"
            else
                print -P "  • Reasoning agents: Claude Opus 4.5 Thinking"
                print -P "  • Coding agents:    Claude Sonnet 4.5 Thinking"
                print -P "  • UI/UX tasks:      Gemini 3 Pro"
                print -P "  • Quick tasks:      Gemini 3 Flash"
            fi
        elif [[ "$current" == *"alibaba"* ]]; then
            if $USE_COLOR; then
                print -P "  • Reasoning agents: %F{green}GLM-4.7%f"
                print -P "  • Coding agents:    %F{green}QWen3 Code%f"
                print -P "  • UI/UX tasks:      %F{green}QWen3 Code%f"
                print -P "  • Quick tasks:      %F{green}MiniMax-M2.1%f"
            else
                print -P "  • Reasoning agents: GLM-4.7"
                print -P "  • Coding agents:    QWen3 Code"
                print -P "  • UI/UX tasks:      QWen3 Code"
                print -P "  • Quick tasks:      MiniMax-M2.1"
            fi
        else
            print -P "  See configuration file for details"
        fi
        print -P ""
    else
        print_warning "Not using a managed configuration profile"
        print -P ""
        print_info "Use '$(basename "$0") list' to see available configurations"
        print -P ""
    fi
}

show_list() {
    local configs=($(discover_configs))
    local current=$(get_current_config)

    print_header "Available Configuration Profiles"

    if [ ${#configs[@]} -eq 0 ]; then
        print_warning "No configuration profiles found"
        print_info "Place configuration files in: $CONFIG_DIR"
        print_info "Files must match pattern: $CONFIG_PATTERN"
        print -P ""
        return 1
    fi

    if $USE_COLOR; then
        print -P '%F{green}'${#configs[@]}'%f configuration profile(s):'
    else
        print "Found ${#configs[@]} configuration profile(s):"
    fi
    print ""

    local index=1
    for config in "${configs[@]}"; do
        local name="${config%%|*}"
        local filename="${config##*|}"
        local config_file="$CONFIG_DIR/$filename"
        local description=$(get_config_description "$config_file")

        if [ "$filename" == "$current" ]; then
            if $USE_COLOR; then
                print -P "[$index] %B$name%b %F{green}(active)%f"
            else
                print "[$index] $name (active)"
            fi
        else
            print "[$index] $name"
        fi

        print "    File: $filename"
        print "    Desc: $description"
        print ""

        ((index++))
    done

    print -P ""
    print_info "Use '$(basename "$0") switch <name>' to switch configuration"
}

# ============================================
# Switch Configuration
# ============================================

switch_config() {
    local target_config="$1"
    local configs=($(discover_configs))

    if [ -z "$target_config" ]; then
        local current=$(get_current_config)

        if ! is_managed_config; then
            if [ ${#configs[@]} -gt 0 ]; then
                local first_config="${configs[0]##*|}"
                target_config="${first_config%.json}"
                target_config="${target_config#oh-my-opencode-}"
                print_info "Setting up first available configuration: $target_config"
            else
                print_error "No configuration profiles found"
                return 1
            fi
        else
            local found_current=false
            local next_config=""

            for config in "${configs[@]}"; do
                local filename="${config##*|}"
                if $found_current; then
                    next_config="${filename%.json}"
                    next_config="${next_config#oh-my-opencode-}"
                    break
                elif [ "$filename" == "$current" ]; then
                    found_current=true
                fi
            done

            if [ -z "$next_config" ] && $found_current; then
                local first_config="${configs[0]##*|}"
                next_config="${first_config%.json}"
                next_config="${next_config#oh-my-opencode-}"
            fi

            target_config="$next_config"
        fi
    fi

    local target_file="oh-my-opencode-${target_config}.json"
    if [ ! -f "$CONFIG_DIR/$target_file" ]; then
        print_error "Configuration not found: $target_config"
        print -P ""
        print_info "Available configurations:"
        for config in "${configs[@]}"; do
            local name="${config%%|*}"
            print -P "  • $name"
        done
        print -P ""
        print_info "Use '$(basename "$0") list' to see all configurations"
        return 1
    fi

    if [ -f "$CONFIG_FILE" ] && [ ! -L "$CONFIG_FILE" ]; then
        local backup_file="$CONFIG_DIR/oh-my-opencode.json.bak.$(date +%Y%m%d-%H%M%S)"
        print_warning "Backing up existing config to: $backup_file"
        cp "$CONFIG_FILE" "$backup_file"
    fi

    ln -sf "$CONFIG_DIR/$target_file" "$CONFIG_FILE"

    print_success "Configuration switched successfully!"
    print -P ""
    print -P "New config: $target_file"
    print -P ""

    local description=$(get_config_description "$CONFIG_DIR/$target_file")
    print -P "Description: $description"
    print -P ""

    print_info "Restart OpenCode to apply changes"
}

# ============================================
# Main Script Logic
# ============================================

main() {
    local command="${1:-}"
    local arg="${2:-}"

    case "$command" in
        --help|-h|help)
            show_help
            ;;
        status)
            show_status
            ;;
        list)
            show_list
            ;;
        switch)
            switch_config "$arg"
            if [ $? -eq 0 ]; then
                print -P ""
                show_status
            fi
            ;;
        "")
            show_help
            ;;
        *)
            if [ -z "$arg" ]; then
                print_error "Unknown command: $command"
                print -P ""
                print_info "Use '$(basename "$0") --help' for usage information"
                exit 1
            else
                switch_config "$command"
                if [ $? -eq 0 ]; then
                    print -P ""
                    show_status
                fi
            fi
            ;;
    esac
}

main "$@"