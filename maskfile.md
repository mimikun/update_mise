# Tasks for update_mise

Using [mask](https://github.com/jacobdeichert/mask)

## patch

> Create a patch and copy it to windows

```bash
mask clean
mask diff-patch
mask copy2win-patch
```

## gpg-patch

> Create a GPG-encrypted patch and copy it to Windows

```bash
mask clean
mask diff-patch --gpg
mask copy2win-patch --gpg
```

## diff-patch

> Create a patch

**OPTIONS**
* gpg
    * flags: --gpg
    * desc: Use GPG encrypt

```bash
PRODUCT_NAME="update_mise"
DEFAULT_REMOTE="origin"
DEFAULT_BRANCH="master"
TODAY=$(date +'%Y%m%d')
BRANCH_NAME=$(git branch --show-current)
GPG_PUB_KEY="CCAA9E0638DF9088BB624BC37C0F8AD3FB3938FC"

if [[ "$BRANCH_NAME" = "$DEFAULT_BRANCH" ]] || [[ "$BRANCH_NAME" = "patch-"* ]]; then
    echo "This branch is $DEFAULT_BRANCH or patch branch"

    for p in "$PRODUCT_NAME" "." "$TODAY" "." "patch"; do
        PATCH_NAME+=$p
    done
else
    echo "This branch is uniq feat branch"

    for p in "$PRODUCT_NAME" "_" "$BRANCH_NAME" "." "$TODAY" "." "patch"; do
        PATCH_NAME+=$p
    done
fi

if [[ "$gpg" == "true" ]]; then
    GPG_PATCH_NAME+=$PATCH_NAME
    GPG_PATCH_NAME+=".gpg"
    echo "gpg patch file name: $GPG_PATCH_NAME"
    git diff "$DEFAULT_REMOTE/$DEFAULT_BRANCH" | gpg --encrypt --recipient "$GPG_PUB_KEY" >"$GPG_PATCH_NAME"
else
    echo "patch file name: $PATCH_NAME"
    git diff "$DEFAULT_REMOTE/$DEFAULT_BRANCH" >"$PATCH_NAME"
fi
```

## patch-branch

> Create a patch branch

```bash
TODAY=$(date +'%Y%m%d')
git switch -c "patch-$TODAY"
```

## switch-master

> Switch to DEFAULT branch

```bash
DEFAULT_BRANCH="master"
git switch "$DEFAULT_BRANCH"
```

## delete-branch

> Delete patch branch

```bash
mask clean
mask switch-master
git branch --list "patch*" | xargs -n 1 git branch -D
```

## clean

> Run clean

```bash
# patch
rm -f ./*.patch
rm -f ./*.patch.gpg

# zip file
rm -f ./*.zip
```

## install

> Run install

```bash
mask clean
sudo cp ./update_mise.sh ~/.local/bin/update_mise
```

## copy2win-patch

> Copy patch to Windows

**OPTIONS**
* gpg
    * flags: --gpg
    * desc: Use GPG encrypt

```bash
if [[ "$gpg" == "true" ]]; then
    cp *.patch.gpg $$WIN_HOME/Downloads/
else
    cp *.patch $WIN_HOME/Downloads/
fi
```

## test

```bash
mask lint
```

## lint

> Run lints

```bash
mask textlint
mask typo-check
mask shell-lint
```

## textlint

> Run textlint

```bash
pnpm run textlint
```

## typo-check

> Run typos

```bash
typos .
```

## shell-lint

> Run shell lint (Linux only)

```bash
shellcheck --shell=bash --external-sources \
	utils/*

shfmt --language-dialect bash --diff \
	./**/*
```

## fmt

```bash
mask format
```

## format

> Run format

```bash
mask shell-format
```

## shell-format

> Run shfmt (Linux only)

```bash
shfmt --language-dialect bash --write \
	./**/*
```

```powershell
Write-Output "Windows is not support!"
```

## changelog

> Add commit message up to `origin/master` to CHANGELOG.md

```bash
TODAY=$(date "+%Y.%m.%d")
RESULT_FILE="CHANGELOG.md"
LATEST_GIT_TAG=$(git tag | head -n 1)
GIT_LOG=$(git log "$LATEST_GIT_TAG..HEAD" --pretty=format:"%B")

{
    echo "## run"
    echo ""
    echo "$GIT_LOG" | sed -e '/^$/d' | sed -e 's/^/- /g'
    echo ""
    echo '```bash'
    echo 'git commit -m "WIP:--------------------------------------------------------------------------" --allow-empty'
    echo 'git commit -m "WIP:--------------------------------------------------------------------------" --allow-empty'
    echo "$GIT_LOG" | sed -e '/^$/d' | sed -e 's/^/git commit -m "WIP:/g' | sed -e 's/$/" --allow-empty/g'
    echo '```'
    echo ""
    echo "## [v$TODAY]"
    echo ""
    echo "### Added - 新機能について"
    echo ""
    echo "なし"
    echo ""
    echo "### Changed - 既存機能の変更について"
    echo ""
    echo "なし"
    echo ""
    echo "### Removed - 今回で削除された機能について"
    echo ""
    echo "なし"
    echo ""
    echo "### Fixed - 不具合修正について"
    echo ""
    echo "なし"
    echo ""
} >>$RESULT_FILE
```

## pab

> Create a patch branch (alias)

```bash
mask patch-branch
```

## deleb

> Delete patch branch (alias)

```bash
mask delete-branch
```

