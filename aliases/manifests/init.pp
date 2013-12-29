class aliases {

  file_line { "/home/$::id/.bashrc":
    line  => "alias d='git diff --stat --color'",
  }

  file_line { "/home/$::id/.bashrc":
    line  => "alias s='git status --short'",
  }

}
