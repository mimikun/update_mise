function update_mise --description "Update mise tools"
    set -f PRODUCT_VERSION 0.7.0
    set -f PRODUCT_NAME update_mise
    set -f MISE_ZIG_BINDIR "$MISE_DATA_DIR/installs/zig"
    set -f BIN_ZIG bin/zig

    function __help_message
        echo "$PRODUCT_NAME(fish)"
        echo "Update mise tools"
        echo ""
        echo "Usage:"
        echo "    $PRODUCT_NAME <COMMAND> <SUBCOMMANDS>"
        echo ""
        echo "Commands:"
        echo "    paleovim-master           Run update mise paleovim master"
        echo "    paleovim-latest           Run update mise paleovim latest"
        echo "    zig_master                Run update_mise_zig_master"
        echo "    zig_master                Run update_mise_zig_latest"
        echo ""
        echo "Options:"
        echo "    --version, -v, version    print $PRODUCT_NAME version"
        echo "    --help, -h, help          print this help"
    end

    function __pvim_master
        set -l commit_hash_file = "$HOME/.cache/paleovim-master-commit-hash.txt"
        set -l commit_hash (cat "$commit_hash_file")
        set -l new_commit_hash (git ls-remote --heads --tags https://github.com/vim/vim.git | grep refs/heads/master | cut -f 1)

        if test $commit_hash != $new_commit_hash
            echo "paleovim (latest)master found!"
            echo "$new_commit_hash" >"$commit_hash_file"
            mise uninstall vim@ref:master
            mise install vim@ref:master
        else
            echo "paleovim (latest)master is already installed"
            echo "commit hash: $commit_hash"
        end
    end

    function __pvim_latest
        set -l version (mise current vim)
        set -l new_version (mise latest vim)

        if test $version != $new_version
            echo "paleovim latest version ( $new_version ) found!"
            mise uninstall "vim@$version"
            mise install "vim@$new_version"
        else
            echo "paleovim latest version ( $version ) is already installed"
        end
    end

    function __zig_master
        set -l zig_version_file "$HOME/.cache/zig-master-version.txt"
        set -l zig_version (cat "$zig_version_file")
        set -l new_zig_version (curl -sSL https://ziglang.org/download/index.json | jq .master.version --raw-output)

        if test $zig_version != $new_zig_version
            echo "zig (latest)master ( $new_zig_version ) found!"
            echo "$new_zig_version" >"$zig_version_file"
            mise uninstall zig@ref:master
            mise install zig@ref:master
        else
            echo "zig (latest)master ( $zig_version )is already installed"
            echo "version: $zig_version"
        end
    end

    function __zig_latest
        set -l version ("$MISE_ZIG_BINDIR/latest/$BIN_ZIG" version)
        set -l new_version (mise latest zig)

        if test $version != $new_version
            echo "zig (latest)version found!"
            mise uninstall "zig@$version"
            mise install "zig@$new_version"
        else
            echo "zig latest ( $version )is already installed"
        end
    end

    switch "$cmd"
        case -v --version version
            echo "$PRODUCT_NAME(fish) v$PRODUCT_VERSION"
        case "" -h --help help
            __help_message
        case paleovim_master
            __pvim_master
        case paleovim_latest
            __pvim_latest
        case zig_master
            __zig_master
        case zig_latest
            __zig_latest
        case \*
            echo "$PRODUCT_NAME: Unknown command: \"$cmd\"" >&2 && return 1
    end
end
