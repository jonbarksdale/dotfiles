My Dotfiles
===========

This repo is for my personal dotfiles.

It is structured such that each profile is a top level directory, allowing for
host/os/context specific configuration.

So far, no tool for managing the symlinks or installation has been chosen, in
favor of just getting the configuration into source control.  Possible options
include Homemaker_, dotfiler_, `GNU Stow`_, or battleschool_.

.. _dotfiler: https://github.com/svetlyak40wt/dotfiler
.. _Homemaker: https://github.com/FooSoft/homemaker
.. _GNU Stow: https://gnu.org/software/stow/
.. _battleschool: https://github.com/spencergibb/battleschool

The general layout should be something like this::

  build.yaml                   # Overall automation scripts for deployment
  profile/
          application/         # each application gets is own directory
                      apprc    # root level config
                      app.d/   # modular configuration files, source in the root

TODO List
---------

* Build out vim config
* Build out gitconfig
* Build out tmux config
* Build out neovim config
* Extract out mac specific stuff, move to a separate profile
