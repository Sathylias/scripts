#!/usr/bin/env bash
#
# Program: debinst.sh (Debian Installation Script)
# Author: Maxime Daraiche (maxiscoding@gmail.com)
#
# Description: Configure my Debian system exactly how I want it 

git_repos=(
  sathylias/dotfiles   # My own Dotfiles bundled with DWM
  lemnos/theme.sh      # Easily switch my Terminal's colorscheme 
  knqyf263/pet         # Command-line snippet manager
  nsxiv/nsxiv          # Simple image viewer since sxiv wasn't maintained anymore
)

packages=(
  
  ## Development Environment
  emacs            # Emacs is the greatest OS
  vim              # Vim is still king in the terminal
  git              # Git because sharing is caring
  kitty            # Preferred terminal
  python3-pip      # Python3 is already installed, pip isn't
  gcc              # C Compiler
  g++              # C++ Compiler
  make             # Build our C/C++ programs
  make             # Build our C programs
  cmake            # Build our C++ programs
  go               # Golang Compiler
    
  ## Desktop Environment (UI) 
  xorg             # X Window System Display Server
  libxinerama-dev  # Optional dependancy for DWM (Multiple displays)
  libxft-dev       # Font rendering library, required for DWM
  xinit            # Start DWM from the tty, loading .xinitrc file
  rofi             # Application launcher, dmenu replacement
  picom            # Our compositor for sweet & low-cost animations
  dunst            # Slick notification daemon
  dmenu            # Dynamic menu for DWM
  breeze-cursor-theme # Nice looking cursor theme

  ## Preferred fonts
  fonts-firacode   # Greatest looking font in my opinion
  fonts-terminus   # Used to be my number one, still use it for DWM & dmenu
  fonts-hack       # Nice fallback font when 

  ## Browser needs
  firefox-esr      # Great browser
  qutebrowser      # Trying to switch from Firefox to this one
  
  ## Misc
  ranger           # File manager for the terminal
  ueberzug         # For images preview in ranger
  cool-retro-term  # This is a great looking terminal for giggles
  mgba-sdl         # GBA Emulator for when it's time to play pokemon / Golden Sun
  unclutter        # Make the annoying cursor disappear when not needed
  redshift         # Protect your eyes with this color temperature thingy
  mupdf            # Minimal PDF Reader
  curl             # Always needed
  fzf              # Command-line fuzzy finder, very useful
  pulseaudio       # Sound server system 
  gpick            # Color picker & palette editor, great for theming
  graphicsmagick   # Useful image processing from the command-line
  weechat          # Favorite IRC client
)

homedir_skel=(
  devel
  devel/.repoman
  devel/scripts
  notes
  notes/org
  notes/diary
  roms
  music
)

dwm_install()
{
  pushd "$HOME/devel/dotfiles/dwm/"

  build_cmd=$(make && sudo make install)

  if [ "$build_cmd" ]; then
    printf "[Error] Building DWM failed, resuming next task.."
  fi
  
  popd
}

homedir_setup()
{
  for dir in "${homedir_skel[@]}"; do
    mkdir -p "$HOME/$dir" 
  done
}

pkg_install()
{
  printf "[INFO] Installing the github repositories.\n"

  for repo in "${git_repos[@]}"; do
    local reponame=$(cut -d '/' -f2 <<< "$repo")
    git clone "https://github.com/${repo}" "${HOME}/devel/.repoman/${reponame}"
  done

  apt install "${packages[@]}"
}

main() {
  pkg_install 

  homedir_setup
}

main "$@"
