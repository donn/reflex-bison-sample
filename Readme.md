# Modern Reflex/Bison Parser Sample
This is a minimal example of a parser made with both [RE-flex](https://github.com/genivia/re-flex), my personal favorite C++ lexer, and good ol' GNU Bison.

It is based off of my work on [Phi](https://github.com/donn/Phi).

You can customize this project for a performant, modern, C++-based, Unicode-enabled LALR parser.


# Contributions
I'm mostly self-taught when it comes to compilers, so please, by all means, feel free to open issues or PRs for anything WTF-inducing. I'm not claiming this to be perfect by any stretch of the imagination.

# Mechanism
The Makefile compiles all RE-flex source files into objects, and from there links a RE-flex binary. The binary is then used to generate the scanner (`tokens.l`). The parser is generated using bison (`grammar.yy`). Finally, the scanner, generator and `main.cc` are all compiled and linked with a subset of the RE-flex object to form a final, static binary that has everything you need.

# Dependencies
* A C++17 compiler
* Git
* GNU Make 3.8.1+
* GNU Bison 3.0.4+

### macOS
Install Xcode 9.0 or higher from the App Store.

For the other dependencies, we recommend [Homebrew](https://brew.sh). Install it using the command in the link provided, then invoke:

```bash
    brew install bison
```

You will need to add bison to PATH, as brew won't. Do this however you want: a suggestion is to add this to your shell's profile:
```sh
export BISON="/usr/local/opt/bison/bin/bison"
```

### GNU/Linux
Install git, gcc, make and bison using your package manager.

If you have Clang and you want to use it, you can export and set the `CC` and `CXX` environment variables to `clang` and `clang++` respectively.

#### Debian-based OSes (incl. Ubuntu, elementary...)

Using apt...

```sh
    sudo apt-get install git build-essential bison
```

If you're into clang...

```sh
    sudo apt-get install clang lldb
```

### Windows with MSYS2
First, get [MSYS2-x86_64](https://www.msys2.org/) if you haven't already.

```sh
pacman -S git make mingw-w64-x86_64-gcc bison
```

You can still also use Clang and lldb if you're into that:

```sh
pacman -S mingw-w64-x86_64-clang lldb
```

# Build Instructions
## First Time
Run `git submodule update --init --recursive --depth 1`.

## From now on
`make`

# ⚖️ License
The 3-clause BSD license: check 'License'.

Note that as the final project will link against RE-flex, you will need to include the following acknowledgement in some form:

## RE-flex License
Copyright (c) 2016, Robert van Engelen, Genivia Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the copyright holder nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.