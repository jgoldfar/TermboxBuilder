# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
Base.peek(io::Base.AbstractPipe) = Base.peek(Base.pipe_reader(io))

using BinaryBuilder

name = "TermboxBuilder"
version = v"1.1.0"

# Collection of sources required to build TermboxBuilder
sources = [
    "https://github.com/nsf/termbox/archive/v1.1.0.tar.gz" =>
    "2743ee4aeb0ff39fadbaf945b76c43e6f6bba544156f2576282b775a3067d748",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/termbox-1.1.0/
./waf configure --prefix=$prefix
./waf
./waf install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc, :eabihf),
    Linux(:powerpc64le, :glibc),
    Linux(:i686, :musl),
    Linux(:x86_64, :musl),
    Linux(:aarch64, :musl),
    Linux(:armv7l, :musl, :eabihf),
    MacOS(:x86_64),
    FreeBSD(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libtermbox", :libtermbox)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

