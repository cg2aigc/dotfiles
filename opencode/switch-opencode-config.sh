#!/bin/bash

# ============================================
# OpenCode Configuration Switcher
# ============================================
# A flexible configuration manager for oh-my-opencode
# Supports multiple configuration profiles with easy switching
# ============================================

set -e

# Configuration
CONFIG_DIR="$HOME/.config/opencode"
CONFIG_FILE="$CONFIG_DIR/oh-my-opencode.json"
CONFIG_PATTERN="oh-my-opencode-*.json"

# Check if color output should be enabled
# Enable colors if:
# 1. Output is to a terminal (not piped)
# 2. TERM is not "dumb"
if [ -t 1 ] && [ "$TERM" != "dumb" ]; then
    # Use ANSI escape sequences (works with kitty, zellij, etc.)
    # Use $'...' syntax to ensure escape sequences are interpreted correctly
    RED=$'\033[0;31m'
    GREEN=$'\033[0;32m'
    YELLOW=$'\033[1;33m'
    BLUE=$'\033[0;34m'
    CYAN=$'\033[0;36m'
    BOLD=$'\033[1m'
    NC=$'\033[0m'
    USE_COLOR=true
else
    # No colors (piped output or dumb terminal)
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    CYAN=""
    BOLD=""
    NC=""
    USE_COLOR=false
fi

# ============================================
# Utility Functions
# ============================================

print_info() {
    printf "${BLUE}ℹ${NC} %s\n" "$1"
}

print_success() {
    printf "${GREEN}✓${NC} %s\n" "$1"
}

print_warning() {
    printf "${YELLOW}⚠${NC} %s\n" "$1"
}

print_error() {
    printf "${RED}✗${NC} %s\n" "$1"
}

print_header() {
    printf "\n"
    printf "${BOLD}========================================${NC}\n"
    printf "${BOLD}  %s${NC}\n" "$1"
    printf "${BOLD}========================================${NC}\n"
    printf "\n"
}

# ============================================
# Configuration Discovery
# ============================================

# Discover all available configuration files
discover_configs() {
    local configs=()
    for config_file in "$CONFIG_DIR"/$CONFIG_PATTERN; do
        if [ -f "$config_file" ]; then
            local basename=$(basename "$config_file")
            # Extract config name (remove prefix and extension)
            local name="${basename#oh-my-opencode-}"
            name="${name%.json}"
            configs+=("$name|$basename")
        fi
    done

    # Sort configs alphabetically
    IFS=$'\n' sorted=($(sort <<<"${configs[*]}"))
    unset IFS

    printf '%s\n' "${sorted[@]}"
}

# Get configuration description
get_config_description() {
    local config_file="$1"
    local description=""

    # Try to extract description from JSON file
    if [ -f "$config_file" ]; then
        description=$(grep -oP '(?<="description": ")[^"]*' "$config_file" 2>/dev/null | head -1)
    fi

    if [ -z "$description" ]; then
        # Fallback to filename-based description
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
    printf "\n"
    printf "${BOLD}OpenCode Configuration Switcher${NC}\n"
    printf "\n"
    printf "${BOLD}USAGE:${NC}\n"
    printf "    %s [COMMAND] [OPTIONS]\n" "$(basename "$0")"
    printf "\n"
    printf "${BOLD}COMMANDS:${NC}\n"
    printf "    status                      Show current configuration status\n"
    printf "    list                        List all available configuration profiles\n"
    printf "    switch [CONFIG]             Switch to specified configuration\n"
    printf "                                If CONFIG is omitted, toggles between configs\n"
    printf "    --help, -h                  Show this help message\n"
    printf "\n"
    printf "${BOLD}ARGUMENTS:${NC}\n"
    printf "    CONFIG                      Configuration name (e.g., antigravity, alibaba)\n"
    printf "                                Use 'list' command to see available configs\n"
    printf "\n"
    printf "${BOLD}EXAMPLES:${NC}\n"
    printf "    # Show current status\n"
    printf "    %s status\n" "$(basename "$0")"
    printf "\n"
    printf "    # List all available configurations\n"
    printf "    %s list\n" "$(basename "$0")"
    printf "\n"
    printf "    # Switch to specific configuration\n"
    printf "    %s switch antigravity\n" "$(basename "$0")"
    printf "    %s switch alibaba\n" "$(basename "$0")"
    printf "\n"
    printf "    # Toggle between configurations\n"
    printf "    %s switch\n" "$(basename "$0")"
    printf "\n"
    printf "${BOLD}NOTES:${NC}\n"
    printf "    • Configuration files must follow pattern: oh-my-opencode-*.json\n"
    printf "    • After switching, restart OpenCode to apply changes\n"
    printf "    • Original configurations are automatically backed up\n"
    printf "\n"
    printf "${BOLD}FILES:${NC}\n"
    printf "    • Configurations: %s\n" "$CONFIG_DIR/$CONFIG_PATTERN"
    printf "    • Active config:  %s\n" "$CONFIG_FILE"
    printf "    • Script:         %s\n" "$(realpath "$0")"
    printf "\n"
}

show_status() {
    local current=$(get_current_config)
    local is_managed=false

    if is_managed_config; then
        is_managed=true
    fi

    print_header "OpenCode Configuration Status"

    printf "Current config: ${GREEN}%s${NC}\n" "$current"
    printf "\n"

    if $is_managed; then
        local config_file="$CONFIG_DIR/$current"
        local description=$(get_config_description "$config_file")
        printf "Description: ${CYAN}%s${NC}\n" "$description"
        printf "\n"

        # Try to extract model information from config
        printf "Active models:\n"
        if [[ "$current" == *"antigravity"* ]]; then
            printf "  • Reasoning agents: ${GREEN}Claude Opus 4.5 Thinking${NC}\n"
            printf "  • Coding agents:    ${GREEN}Claude Sonnet 4.5 Thinking${NC}\n"
            printf "  • UI/UX tasks:      ${GREEN}Gemini 3 Pro${NC}\n"
            printf "  • Quick tasks:      ${GREEN}Gemini 3 Flash${NC}\n"
        elif [[ "$current" == *"alibaba"* ]]; then
            printf "  • Reasoning agents: ${GREEN}GLM-4.7${NC}\n"
            printf "  • Coding agents:    ${GREEN}QWen3 Code${NC}\n"
            printf "  • UI/UX tasks:      ${GREEN}QWen3 Code${NC}\n"
            printf "  • Quick tasks:      ${GREEN}MiniMax-M2.1${NC}\n"
        else
            printf "  ${YELLOW}See configuration file for details${NC}\n"
        fi
        printf "\n"
    else
        print_warning "Not using a managed configuration profile"
        printf "\n"
        print_info "Use '$(basename "$0") list' to see available configurations"
        printf "\n"
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
        printf "\n"
        return 1
    fi

    printf "Found ${GREEN}%d${NC} configuration profile(s):\n" "${#configs[@]}"
    printf "\n"

    local index=1
    for config in "${configs[@]}"; do
        local name="${config%%|*}"
        local filename="${config##*|}"
        local config_file="$CONFIG_DIR/$filename"
        local description=$(get_config_description "$config_file")

        # Mark current config
        if [ "$filename" == "$current" ]; then
            printf "${GREEN}[${index}]${NC} ${BOLD}%s${NC} ${GREEN}(active)${NC}\n" "$name"
        else
            printf "[${index}] %s\n" "$name"
        fi

        printf "    ${CYAN}File:${NC} %s\n" "$filename"
        printf "    ${CYAN}Desc:${NC} %s\n" "$description"
        printf "\n"

        ((index++))
    done

    echo ""
    print_info "Use '$(basename "$0") switch <name>' to switch configuration"
}

# ============================================
# Switch Configuration
# ============================================

switch_config() {
    local target_config="$1"
    local configs=($(discover_configs))

    # If no target specified, toggle between configs
    if [ -z "$target_config" ]; then
        local current=$(get_current_config)

        if ! is_managed_config; then
            # If not using managed config, switch to first available
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
            # Find next config in list
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

            # If we reached the end, wrap to first config
            if [ -z "$next_config" ] && $found_current; then
                local first_config="${configs[0]##*|}"
                next_config="${first_config%.json}"
                next_config="${next_config#oh-my-opencode-}"
            fi

            target_config="$next_config"
        fi
    fi

    # Validate target config
    local target_file="oh-my-opencode-${target_config}.json"
    if [ ! -f "$CONFIG_DIR/$target_file" ]; then
        print_error "Configuration not found: $target_config"
        echo ""
        print_info "Available configurations:"
        for config in "${configs[@]}"; do
            local name="${config%%|*}"
            echo "  • $name"
        done
        echo ""
        print_info "Use '$(basename "$0") list' to see all configurations"
        return 1
    fi

    # Backup existing config if it's not a symlink
    if [ -f "$CONFIG_FILE" ] && [ ! -L "$CONFIG_FILE" ]; then
        local backup_file="$CONFIG_DIR/oh-my-opencode.json.bak.$(date +%Y%m%d-%H%M%S)"
        print_warning "Backing up existing config to: $backup_file"
        cp "$CONFIG_FILE" "$backup_file"
    fi

    # Create or update symlink
    ln -sf "$CONFIG_DIR/$target_file" "$CONFIG_FILE"

    print_success "Configuration switched successfully!"
    printf "\n"
    printf "New config: ${GREEN}%s${NC}\n" "$target_file"
    printf "\n"

    local description=$(get_config_description "$CONFIG_DIR/$target_file")
    printf "Description: ${CYAN}%s${NC}\n" "$description"
    printf "\n"

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
                echo ""
                show_status
            fi
            ;;
        "")
            # Default: show help
            show_help
            ;;
        *)
            # Try to interpret as a config name for switch command
            if [ -z "$arg" ]; then
                print_error "Unknown command: $command"
                echo ""
                print_info "Use '$(basename "$0") --help' for usage information"
                exit 1
            else
                switch_config "$command"
                if [ $? -eq 0 ]; then
                    echo ""
                    show_status
                fi
            fi
            ;;
    esac
}

# Run main function
main "$@"