My Dotfiles
===========

This repo is for my personal dotfiles.

It is structured such that each profile is a top level directory, allowing for
host/os/context specific configuration.

So far, no tool for managing the symlinks or installation has been chosen, in
favor of just getting the configuration into source control.  Possible options
include Homemaker_, dotfiler_, `GNU Stow`_, or battleschool_.

** new option: Homeshick_

Current analysis
````````````````

Homemaker
  Requries a config file, kind of annoying, but much
  more powerful, as you can have commands.  Can check in an executable, so it
  actually is portable without requiring install

GNU Stow
  Requires install, but open source and widely available.  Very simple by
  comparison, may not support environments well due to how it merges
  directories.

battleschool
  External install via pip required.  Also very powerful.  And apparently
  abandoned.

dotfiler
  Can check out as part of the repo, downside is that it really wants to be the
  root directory.  So no git submodule, though forking it and adding my own
  content is possible.  It does support environments nicely.

Homeshick
  More portable version of homesick, all shell based.  Support for
  environments, need to learn the paradigm.  It also expects to be checked out
  separately, but in a way that is probably safe for submodules.

Verdict so far - either Homeshick or Homemaker.  Dotfiler seems great, but the
checkout issue is super annoying.  I don't like the external dependency of stow
or battleschool.  I'm not super thrilled about checking in an executable for
homemaker, so that leaves Homeshick, or maybe fixing Dotfiler.

Other idea: I can simply have an install script.  Anything with a git only
dependency could be managed that way, which puts dotfiler back into the mix
with Homeshick.

.. _dotfiler: https://github.com/svetlyak40wt/dotfiler
.. _Homemaker: https://github.com/FooSoft/homemaker
.. _GNU Stow: https://gnu.org/software/stow/
.. _battleschool: https://github.com/spencergibb/battleschool
.. _Homeshick: https://github.com/andsens/homeshick

The general layout should be something like this::

  build.yaml                   # Overall automation scripts for deployment
  profile/
          application/         # each application gets is own directory
                      apprc    # root level config
                      app.d/   # modular configuration files, source in the root

TODO List
---------

* Build out vim config
  * use a plugin manager - VimPlug for starters
* Build out gitconfig
* Build out tmux config
* Build out neovim config
* Extract out mac specific stuff, move to a separate profile
