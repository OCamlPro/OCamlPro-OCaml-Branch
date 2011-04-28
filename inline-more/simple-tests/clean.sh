#!/bin/sh

find . -name '*.cm?' -exec rm -f {} \;
find . -name '*~' -exec rm -f {} \;
find . -name '*.log' -exec rm -f {} \;
find . -name '*.byte' -exec rm -f {} \;
find . -name '*.opt' -exec rm -f {} \;
find . -name '*.o' -exec rm -f {} \;
find . -name '*.exe' -exec rm -f {} \;
