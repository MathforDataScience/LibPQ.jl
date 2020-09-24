products = [
    LibraryProduct(prefix, ["libcrypto", "libcrypto-1_1", "libcrypto-1_1-x64"], :libcrypto),
    LibraryProduct(prefix, ["libssl", "libssl-1_1", "libssl-1_1-x64"], :libssl),
    ExecutableProduct(prefix, "openssl", :openssl),
]

# Download binaries from hosted location
bin_prefix = "https://github.com/JuliaBinaryWrappers/OpenSSL_jll.jl/releases/download/OpenSSL-v1.1.1+2"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    Linux(:aarch64, libc=:glibc) => ("$bin_prefix/OpenSSL.v1.1.1.aarch64-linux-gnu.tar.gz", "deae2e855536f8ca336870450c555335db94647e93d7150134269ee234b2f004"),
    Linux(:aarch64, libc=:musl) => ("$bin_prefix/OpenSSL.v1.1.1.aarch64-linux-musl.tar.gz", "385eedaafd409abf4114ee0b33c70a89145695984282c20ca7c4cede3ed62260"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf) => ("$bin_prefix/OpenSSL.v1.1.1.armv7l-linux-gnueabihf.tar.gz", "00e1413c4d5f022b20d8824eeb6e1d50b90cc938a2c5e179de64f815b2980e66"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf) => ("$bin_prefix/OpenSSL.v1.1.1.armv7l-linux-musleabihf.tar.gz", "c0ba637c8301834a0357aac7ef3cfe6c60254b95d62d06de7802dc2441185c66"),
    Linux(:i686, libc=:glibc) => ("$bin_prefix/OpenSSL.v1.1.1.i686-linux-gnu.tar.gz", "844a452a6a5dea681bb60dde94c67a880ae96aec97bbc5e111310a5be5bdbf89"),
    Linux(:i686, libc=:musl) => ("$bin_prefix/OpenSSL.v1.1.1.i686-linux-musl.tar.gz", "fd4beae0cb0d1cd17923985a219c1569346b7b32f5c579746919cb81971e37fb"),
    Windows(:i686) => ("$bin_prefix/OpenSSL.v1.1.1.i686-w64-mingw32.tar.gz", "3c942cd0a69ab5a4cef72042d2ba1562b92ceb58112a1d62ae8d324ff603da52"),
    Linux(:powerpc64le, libc=:glibc) => ("$bin_prefix/OpenSSL.v1.1.1.powerpc64le-linux-gnu.tar.gz", "07f1161572ccf1beaf1f7affb9996d6387f7417a4a7d8b128e4efaf7812f1927"),
    MacOS(:x86_64) => ("$bin_prefix/OpenSSL.v1.1.1.x86_64-apple-darwin14.tar.gz", "72a73b0015dd3116186197b3adeb6dfd1715974aff7cccc9cc0742f80f07678e"),
    Linux(:x86_64, libc=:glibc) => ("$bin_prefix/OpenSSL.v1.1.1.x86_64-linux-gnu.tar.gz", "77be5b30230b67396a691ba8be144824b515e8ea5070df7bd5b06026fdc5ca56"),
    Linux(:x86_64, libc=:musl) => ("$bin_prefix/OpenSSL.v1.1.1.x86_64-linux-musl.tar.gz", "5c40cef594c4126885e5409fcb5c18a354dd437d86c77f6be631ac704958e254"),
    FreeBSD(:x86_64) => ("$bin_prefix/OpenSSL.v1.1.1.x86_64-unknown-freebsd11.1.tar.gz", "6736ce1e2daa69ff443675ae3f784433b58bcebac3d084e510e44bba7f0fc026"),
    Windows(:x86_64) => ("$bin_prefix/OpenSSL.v1.1.1.x86_64-w64-mingw32.tar.gz", "c38348da07a449a96b767f782b053b150d7837aa0c7bd94a3f6f632886b26d93"),
)

# Install unsatisfied or updated dependencies:
unsatisfied = any(!satisfied(p; verbose=verbose) for p in products)
dl_info = choose_download(download_info, platform_key_abi())
if dl_info === nothing && unsatisfied
    # If we don't have a compatible .tar.gz to download, complain.
    # Alternatively, you could attempt to install from a separate provider,
    # build from source or something even more ambitious here.
    error("Your platform (\"$(Sys.MACHINE)\", parsed as \"$(triplet(platform_key_abi()))\") is not supported by this package!")
end

# If we have a download, and we are unsatisfied (or the version we're
# trying to install is not itself installed) then load it up!
if unsatisfied || !isinstalled(dl_info...; prefix=prefix)
    # Download and install binaries
    install(dl_info...; prefix=prefix, force=true, verbose=verbose)
end

# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps_OpenSSL.jl"), products, verbose=verbose)