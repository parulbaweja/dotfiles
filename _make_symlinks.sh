#!/bin/bash

set -e

# Install all the dotfiles in this directory (symlink them into place)
# When a file already exists, copy it to an "old_dotfiles" directory first
# When a symlink already exists, replace it

declare -a dotfile_whitelist=(
  .bash_profile_git\
  .bash_profile_shared\
  .gitignore\
  .vim\
  .vimrc\
  .git_prompt\
  .git_completion.sh\
  .fab_completion\
  .ssh_completion\
  .inputrc\
  .fdignore\
)

backup_dir="${HOME}/dotfiles.bak"

function create_symlink {
  echo "created symlink: $2 -> $1"
  ln -s $1 $2
}

cd `dirname $0`

for f in ${dotfile_whitelist[@]}; do
  # In the repo I don't include the leading dot so they're not all hidden
  if [[ $f =~ ^\. ]]
  then
    repo_filename=${f:1}
  else
    repo_filename=${f}
  fi
  repo_file=$(pwd)/${repo_filename}

  # if whitelisted file isn't actually in repo, skip
  if [ ! -f ${repo_file} -a ! -d ${repo_file} ]
  then
    continue
  fi

  dotfile=${HOME}/.${repo_filename}

  # if file or dir exists, back it up then create symlink
  if [ -f ${dotfile} -o -d ${dotfile} ] && [ ! -h ${dotfile} ]
  then
    if [ ! -d ${backup_dir} ]
    then
      echo "WARN: made backup directory ${backup_dir}"
      mkdir ${backup_dir}
    fi
    echo "WARN: moving existing ${dotfile} to ${backup_dir}" 1>&2
    mv ${dotfile} ${backup_dir}
    create_symlink "${repo_file}" "${dotfile}"
    continue
  fi

  # if symlink exists and is different, warn then create new symlink
  if [ -h "${dotfile}" ]
  then
    current_target=`ls -l ${dotfile} | awk '{print $11}'`
    if [ "${current_target}" != "${repo_file}" ]
    then
      echo "WARN: removed symlink: ${dotfile} -> ${current_target}" 1>&2
      rm "${dotfile}"
      create_symlink "${repo_file}" "${dotfile}"
    else
      echo "file ${dotfile} already set correctly" 1>&2
    fi
    continue
  fi

  # doesn't exist yet, create symlink
  if [ ! -a "${dotfile}" ]
  then
    create_symlink "${repo_file}" "${dotfile}"
    continue
  fi
done

mkdir -p "$HOME/.emacs.d"
# doesn't exist yet, create symlink
if [ -h "$HOME/.emacs.d/init.el" ]
then
  echo "file $HOME/.emacs.d/init.el already exists"
fi

mkdir -p "$HOME/bash_history_git"
if [ ! -a "$HOME/bash_history_git/remove_dups.sh" ]
then
  create_symlink "$(pwd)/bash_history/remove_dups.sh" "$HOME/bash_history_git/remove_dups.sh"
  mv "$HOME/.bash_history" "$HOME/bash_history_git" && create_symlink "$HOME/bash_history_git/.bash_history" "$HOME/.bash_history"
fi


if [ ! -a "$HOME/.emacs.d/init.el" ]
then
  create_symlink "$(pwd)/emacs.d/init.el" "$HOME/.emacs.d/init.el"
fi

if [ ! -d "$HOME/bin" ]; then
  mkdir -p "$HOME/bin"
fi

mkdir -p "$HOME/.vim_sessions"
touch "$HOME/.vimrc.local"
