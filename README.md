# ROOT build recipes

Recipes for building releases of ROOT against Python 3 with pyenv

Building ROOT is one of the most frustrating and time consuming things I have to do on occasion.
I have [more experience with it than most people in HEP](https://gitlab.cern.ch/atlas-amglab/atlstats), but I still find it to be a process that can easily take hours of an evening to debug.
These recipes should be viewed as case studies of from source builds in a realistic end user environment that actually worked.

All recipes will build ROOT from source using checked out Git tags that correspond to "stable" releases.
ROOT doesn't actually follow SemVer though, so best of luck getting truly stable releases.
So go ahead and clone the [full project from GitHub](https://github.com/root-project/root) into your build area

```
git clone git@github.com:root-project/root.git
```
