function update_mise --description "Update mise tools"
    set product_version 0.1.0
    set product_name "update_mise"

    function __help_message
        echo "$product_name(fish)"
        echo "Update mise tools"
        echo ""
        echo "Usage:"
        echo "    $product_name <COMMAND> <SUBCOMMANDS>"
        echo ""
        echo "Commands:"
        echo "  neovim_master            Run update_asdf_neovim_master"
        echo "  neovim_stable            Run update_asdf_neovim_stable"
        echo "  neovim_nightly           Run update_asdf_neovim_nightly"
        echo "  zig_master               Run update_asdf_neovim_nightly"
        echo ""
        echo "Options:"
        echo "    --version, -v, version    print $product_name version"
        echo "    --help, -h, help          print this help"
    end

    function __neovim_master
        mise use neovim@ref:master
        mise reshim
        sleep 5

        set NVIM_MASTER_COMMIT_HASH_FILE "$HOME/.cache/neovim-master-commit-hash.txt"
        set NVIM_MASTER_COMMIT_HASH (cat "$NVIM_MASTER_COMMIT_HASH_FILE")
        set NVIM_MASTER_NEW_COMMIT_HASH=$(git ls-remote --heads --tags https://github.com/neovim/neovim.git | grep refs/heads/master | cut -f 1)
        if test $NVIM_MASTER_COMMIT_HASH != $NVIM_MASTER_NEW_COMMIT_HASH
            echo "neovim (latest)master found!"
            echo "$NVIM_MASTER_NEW_COMMIT_HASH" > "$NVIM_MASTER_COMMIT_HASH_FILE"
            mise uninstall neovim@ref:master
            mise install neovim@ref:master
        else
            echo "neovim (latest)master is already installed"
            echo "commit hash: $MASTER_COMMIT_HASH"
        end
    end

    function __neovim_nightly
        mise use neovim@nightly
        mise reshim
        sleep 5

        set VERSION (nvim --version | head -n 1 | string split ' ' | sed -n '2p')
        set NEW_VERSION (curl --silent https://api.github.com/repos/neovim/neovim/releases/tags/nightly | jq .body | string split ' ' | string split '\n' | sed -n '3p' | sed -e "s/%0ABuild//g")
        if test $VERSION != $NEW_VERSION
            echo "neovim (latest)nightly found!"
            mise uninstall neovim@nightly
            mise install neovim@nightly
        else
            echo "neovim (latest)nightly is already installed"
            echo "version: $VERSION"
        end
    end

    function __neovim_stable
        mise use neovim@stable
        mise reshim
        sleep 5

        set VERSION (nvim --version | head -n 1 | string split ' ' | sed -n '2p')
        set NEW_VERSION (curl --silent https://api.github.com/repos/neovim/neovim/releases/tags/stable | jq .body | tr " " "\n" | sed -n 2p | sed -e "s/\\\nBuild//g")
        if test $VERSION != $NEW_VERSION
            echo "neovim (latest)stable found!"
            mise uninstall neovim@stable
            mise install neovim@stable
        else
            echo "neovim (latest)nightly is already installed"
            echo "version: $VERSION"
        end
    end

    function __zig_master
        mise use zig@master
        mise reshim
        sleep 5

        set VERSION (zig version)
        set NEW_VERSION (curl -sSL https://ziglang.org/download/index.json | jq .master.version --raw-output)
        if test $VERSION != $NEW_VERSION
            echo "zig (latest)master found!"
            mise uninstall zig@master
            mise install zig@master
        else
            echo "zig (latest)master is already installed"
            echo "version: $VERSION"
        end
    end

    switch "$cmd"
        case -v --version version
            echo "$product_name(fish) v$product_version"
        case "" -h --help help
            __help_message
        case neovim_master
            __master
        case neovim_stable
            __stable
        case neovim_nightly
            __nightly
        case zig_master
            __zig_master
        case \*
            echo "$product_name: Unknown command: \"$cmd\"" >&2 && return 1
    end
end
