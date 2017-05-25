#!/bin/zsh

(
cd ../home/zsh.d
for f in ../../zsh/zsh.d/*; do
    ln -s $f
done
)
