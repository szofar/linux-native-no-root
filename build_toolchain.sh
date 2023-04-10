######################################################################
# This is an example of how to create a native linux toolchain 
# when you don't have root and need a newer version of GLIBC
# 
# Author: https://github.com/szofar
#
# Note: I would advise *not* running this as a script the first time.
#  Instead, copy+paste step-by-step to verify everything is working.
#  Make changes as you go if necessary. This is not a
#  comprehensive guide like LFS. Merely a specific use case/example.
#
# TODO: I could probably avoid pass 2 of binutils/gcc.
# TODO: tzdata hard coded
# TODO: version 1.1 tool list is a dummy placeholder
# TODO: 4.0 CREATE DIRECTORIES - Probably don't need this for native
# TODO: git clone https://github.com/vim/vim.git
# TODO: usr tools like zlib to NTC/usr/local
# TODO: patches per version
# TODO: STD_STARTFILE_PREFIX_1 ignored for "cross" compilers!
#       even though this is technically native
# TODO: md5 sums
#
######################################################################


######################################################
# 0.0 NATIVE TOOLCHAIN FROM SCRATCH
######################################################

NTC="${NTC:-$PWD}"
NTC_NAME="$(uname -m)-tmp-linux-gnu"
NTC_VERSION=1.0.0
NTC_SOURCE="${NTC_SOURCE:-$NTC}/source"
NTC_TOOLS="${NTC}/tools"
NTC_MAKE_FLAGS=${NTC_MAKE_FLAGS:-"-j$(nproc)"}

# tell the user what's up
printf "\n\nCreating native toolchain without root...\n\n"
printf "Configuration:\n\n"
printf "\tLocation   : ${NTC}\n"
printf "\tTemp tools : ${NTC_TOOLS}\n"
printf "\tTemp name  : ${NTC_NAME}\n"
printf "\tMake flags : ${NTC_MAKE_FLAGS}\n"
printf "\tToolset    : v${NTC_VERSION}\n\n"

# give the user a chance to spot a mistake without going all interactive
sleep 5

# sanity check to create the required directory
mkdir -vp "${NTC}"
[[ -d "${NTC}" ]] || { 
    printf "Error! Unable to create the directory ${NTC}\n"; exit 1; 
}
mkdir -pv "${NTC_SOURCE}"
mkdir -pv "${NTC_TOOLS}"
mkdir -pv "${NTC}/usr"


######################################################
# 0.1 ENVIRONMENT
######################################################

printf "\n\n\n\n\n... 0.1 - Environment\n"

# localization
export LC_ALL=POSIX

# set path with preference to NTC/usr over NTC_TOOLS over original PATH
export PATH=${NTC}/usr/bin:${NTC}/usr/sbin:${NTC_TOOLS}/bin:${NTC_TOOLS}/sbin:${PATH}

# set permissions
umask 022

# turn off the command hash table
set +h

# automatic environment variable setting
set_env () {
    if [[ ! -z "$X" ]] && [[ ! -z "$Y" ]]; then
        $1=$2
        export $1
    fi
}

# these proxies may be necessary for corporate settings. Set in your environment before running
# note: some tools prefer without CAPS
set_env "HTTP_PROXY"  "${HTTP_PROXY}"
set_env "HTTPS_PROXY" "${HTTPS_PROXY}"
set_env "FTP_PROXY"   "${FTP_PROXY}"
set_env "http_proxy"  "${HTTP_PROXY}"
set_env "https_proxy" "${HTTPS_PROXY}"
set_env "ftp_proxy"   "${FTP_PROXY}"

# git proxy setup if required
# if [[ ! -z "${HTTP_PROXY}" ]]; then
#     git config --global http.proxy "${HTTP_PROXY}"
# fi
# if [[ ! -z "${HTTPS_PROXY}" ]]; then
#     git config --global https.proxy "${HTTPS_PROXY}"
# fi


######################################################
# 0.2 TOOL VERSIONS
######################################################

printf "\n\n\n\n\n... 0.2 - Setting Tool Versions\n"

# add tool versions to match the $NTC_VERSION as you like
if [[ $(echo $NTC_VERSION | cut -d'.' -f 1,2) = "1.0" ]]; then
    PATCHES="https://www.linuxfromscratch.org/patches/downloads/glibc/glibc-2.22-upstream_i386_fix-1.patch"$'\n'"https://web.archive.org/web/20210617235627/http://www.linuxfromscratch.org/patches/lfs/7.8/readline-6.3-upstream_fixes-3.patch"$'\n'"http://lfs.linux-sysadmin.com/patches/downloads/glibc/glibc-2.22-fhs-1.patch"
    TOOL_SHADOW_HASH="2bfafe7d4962682d31b5eba65dba4fc8"
    TOOL_LIBSTDCPP="libstdc++-v3"
    TOOL_BINUTILS="binutils-2.25.1"
    TOOL_GCC="gcc-5.2.0"
    TOOL_MAN_PAGES="man-pages-4.02"
    TOOL_LINUX="linux-4.2"
    TOOL_GLIBC="glibc-2.22"
    TOOL_ZLIB="zlib-1.2.8"
    TOOL_EXPECT="expect5.45"
    TOOL_DEJAGNU="dejagnu-1.5.3"
    TOOL_CHECK="check-0.10.0"
    TOOL_NCURSES="ncurses-6.0"
    TOOL_BASH="bash-4.3.30"
    TOOL_BZIP2="bzip2-1.0.6"
    TOOL_COREUTILS="coreutils-8.24"
    TOOL_DIFFUTILS="diffutils-3.3"
    TOOL_FILE="file-5.24"
    TOOL_FINDUTILS="findutils-4.4.2"
    TOOL_GAWK="gawk-4.1.3"
    TOOL_GETTEXT="gettext-0.19.5.1"
    TOOL_GREP="grep-2.21"
    TOOL_GZIP="gzip-1.6"
    TOOL_M4="m4-1.4.17"
    TOOL_MAKE="make-4.1"
    TOOL_PATCH="patch-2.7.5"
    TOOL_SED="sed-4.2.2"
    TOOL_TAR="tar-1.28"
    TOOL_READLINE="readline-6.3"
    TOOL_UTIL_LINUX="util-linux-2.27"
    TOOL_XZ="xz-5.2.1"
    TOOL_GMP="gmp-6.0.0a"
    TOOL_MPFR="mpfr-3.1.3"
    TOOL_MPC="mpc-1.0.3"
    TOOL_PKG_CONFIG="pkg-config-0.28"
    TOOL_ATTR="attr-2.4.47"
    TOOL_ACL="acl-2.2.52"
    TOOL_LIBCAP="libcap-2.24"
    TOOL_SHADOW="shadow-4.2.1"
    TOOL_TEXINFO="texinfo-6.0"
    TOOL_PERL="perl-5.22.0"
    TOOL_OPENSSL="openssl-3.0.8"
    TOOL_PYTHON="Python-3.10.10"
    TOOL_TCL="tcl8.6.13"
    TOOL_TK="tk8.6.13"
    TOOL_WGET="wget-1.21"
    TOOL_GNUTLS="gnutls-3.3.25"
    TOOL_NETTLE="nettle-3.4.1"
    TOOL_UNBOUND="unbound-1.7.0"
    TOOL_BISON="bison-3.0.4"
    TOOL_EXPAT="expat-2.1.0"
    TOOL_X11="libX11-1.6.8"
    TOOL_XEXTPROTO="xextproto-7.3.0"
    TOOL_XTRANS="xtrans-1.4.0"
    TOOL_XCB="libxcb-1.13"
    TOOL_KBPROTO="kbproto-1.0.7"
    TOOL_INPUTPROTO="inputproto-2.3.2"
    TOOL_XCB_PROTO="xcb-proto-1.15.2"
    TOOL_LIB_PTHREAD="libpthread-stubs-0.4"
    TOOL_XAU="libXau-1.0.9"
    TOOL_XPROTO="xproto-7.0.31"
    TOOL_CMAKE="cmake-3.26.1"
    TOOL_GDBM="gdbm-1.18"
    TOOL_LIBFFI="libffi-3.3"
    TOOL_WHICH="which-2.21"
    
elif [[ $(echo $NTC_VERSION | cut -d'.' -f 1,2) = "1.1" ]]; then
    PATCHES="https://www.linuxfromscratch.org/patches/downloads/glibc/glibc-2.22-upstream_i386_fix-1.patch"$'\n'"https://web.archive.org/web/20210617235627/http://www.linuxfromscratch.org/patches/lfs/7.8/readline-6.3-upstream_fixes-3.patch"$'\n'"http://lfs.linux-sysadmin.com/patches/downloads/glibc/glibc-2.22-fhs-1.patch"
    TOOL_SHADOW_HASH="2bfafe7d4962682d31b5eba65dba4fc8"
    TOOL_LIBSTDCPP="libstdc++-v3"
    TOOL_BINUTILS="binutils-2.25.1"
    TOOL_GCC="gcc-5.2.0"
    TOOL_MAN_PAGES="man-pages-4.02"
    TOOL_LINUX="linux-4.2"
    TOOL_GLIBC="glibc-2.22"
    TOOL_ZLIB="zlib-1.2.8"
    TOOL_EXPECT="expect5.45"
    TOOL_DEJAGNU="dejagnu-1.5.3"
    TOOL_CHECK="check-0.10.0"
    TOOL_NCURSES="ncurses-6.0"
    TOOL_BASH="bash-4.3.30"
    TOOL_BZIP2="bzip2-1.0.6"
    TOOL_COREUTILS="coreutils-8.24"
    TOOL_DIFFUTILS="diffutils-3.3"
    TOOL_FILE="file-5.24"
    TOOL_FINDUTILS="findutils-4.4.2"
    TOOL_GAWK="gawk-4.1.3"
    TOOL_GETTEXT="gettext-0.19.5.1"
    TOOL_GREP="grep-2.21"
    TOOL_GZIP="gzip-1.6"
    TOOL_M4="m4-1.4.17"
    TOOL_MAKE="make-4.1"
    TOOL_PATCH="patch-2.7.5"
    TOOL_SED="sed-4.2.2"
    TOOL_TAR="tar-1.28"
    TOOL_READLINE="readline-6.3"
    TOOL_UTIL_LINUX="util-linux-2.27"
    TOOL_XZ="xz-5.2.1"
    TOOL_GMP="gmp-6.0.0a"
    TOOL_MPFR="mpfr-3.1.3"
    TOOL_MPC="mpc-1.0.3"
    TOOL_PKG_CONFIG="pkg-config-0.28"
    TOOL_ATTR="attr-2.4.47"
    TOOL_ACL="acl-2.2.52"
    TOOL_LIBCAP="libcap-2.24"
    TOOL_SHADOW="shadow-4.2.1"
    TOOL_TEXINFO="texinfo-6.0"
    TOOL_PERL="perl-5.22.0"
    TOOL_OPENSSL="openssl-3.0.8"
    TOOL_PYTHON="Python-3.10.10"
    TOOL_TCL="tcl8.6.13"
    TOOL_TK="tk8.6.13"
    TOOL_WGET="wget-1.21"
    TOOL_GNUTLS="gnutls-3.3.25"
    TOOL_NETTLE="nettle-3.4.1"
    TOOL_UNBOUND="unbound-1.7.0"
    TOOL_BISON="bison-3.0.4"
    TOOL_EXPAT="expat-2.1.0"
    TOOL_X11="libX11-1.6.8"
    TOOL_XEXTPROTO="xextproto-7.3.0"
    TOOL_XTRANS="xtrans-1.4.0"
    TOOL_XCB="libxcb-1.13"
    TOOL_KBPROTO="kbproto-1.0.7"
    TOOL_INPUTPROTO="inputproto-2.3.2"
    TOOL_XCB_PROTO="xcb-proto-1.15.2"
    TOOL_LIB_PTHREAD="libpthread-stubs-0.4"
    TOOL_XAU="libXau-1.0.9"
    TOOL_XPROTO="xproto-7.0.31"
    TOOL_CMAKE="cmake-3.26.1"
    TOOL_GDBM="gdbm-1.18"
    TOOL_LIBFFI="libffi-3.3"
fi;

# we need the version for some downloads
TOOL_LINUX_MAJOR="$(echo ${TOOL_LINUX} | cut -d'.' -f 1 | cut -d'-' -f 2)"
TOOL_EXPECT_VERSION="$(echo ${TOOL_EXPECT} | sed 's/expect//')"
TOOL_CHECK_VERSION="$(echo ${TOOL_CHECK} | sed 's/check-//')"
TOOL_UTIL_LINUX_VERSION="$(echo ${TOOL_UTIL_LINUX} | cut -d'-' -f 3)"
TOOL_GCC_VERSION="$(echo ${TOOL_GCC} | cut -d'-' -f 2)"
TOOL_GMP_VERSION="$(echo ${TOOL_GMP} | sed 's/[a-zA-Z]$//')"
TOOL_PERL_MAJOR="$(echo ${TOOL_PERL} | cut -d'.' -f 1 | cut -d'-' -f 2)"
TOOL_PERL_VERSION="$(echo ${TOOL_PERL} | cut -d'-' -f 2)"
TOOL_PYTHON_VERSION="$(echo ${TOOL_PYTHON} | cut -d'-' -f 2)"
TOOL_EXPAT_VERSION="R_$(echo ${TOOL_EXPAT} | cut -d'-' -f 2 | sed 's/\./_/g')"
TOOL_GNUTLS_VERSION="$(echo ${TOOL_GNUTLS} | cut -d'-' -f 2 | sed 's/\.[0-9]*$//')"
TOOL_CMAKE_VERSION="$(echo ${TOOL_CMAKE} | cut -d'-' -f 2)"
TOOL_TCL_VERSION="$(echo ${TOOL_TCL} | sed 's/^tcl//')"
TOOL_TCL_LIB_VERSION="lib$(echo ${TOOL_TCL} | sed 's/\.[0-9]*$//')"
TOOL_TK_LIB_VERSION="lib$(echo ${TOOL_TK} | sed 's/\.[0-9]*$//')"
TOOL_BZIP2_VERSION="$(echo ${TOOL_BZIP2} | cut -d'-' -f 2)"
TOOL_BZIP2_MINOR_VERSION="$(echo ${TOOL_BZIP2} | cut -d'-' -f 2 | sed 's/\.[0-9]*$//')"
TOOL_BZIP2_MAJOR_VERSION="$(echo ${TOOL_BZIP2} | cut -d'.' -f 1 | cut -d'-' -f 2 )"
TOOL_LIBFFI_VERSION="$(echo ${TOOL_LIBFFI} | cut -d'-' -f 2)"
TOOL_NCURSES_VERSION="$(echo ${TOOL_NCURSES} | cut -d'-' -f 2 )"
TOOL_NCURSES_MAJOR_VERSION="$(echo ${TOOL_NCURSES} | cut -d'.' -f 1 | cut -d'-' -f 2 )"

# tool with extension
TOOL_BINUTILS_FILE="${TOOL_BINUTILS}.tar.bz2"
TOOL_GCC_FILE="${TOOL_GCC}.tar.bz2"
TOOL_LINUX_FILE="${TOOL_LINUX}.tar.xz"
TOOL_MAN_PAGES_FILE="${TOOL_MAN_PAGES}.tar.xz"
TOOL_GLIBC_FILE="${TOOL_GLIBC}.tar.xz"
TOOL_ZLIB_FILE="${TOOL_ZLIB}.tar.gz"
TOOL_TCL_CORE_FILE="tcl-core${TOOL_TCL_VERSION}-src.tar.gz"
TOOL_EXPECT_FILE="${TOOL_EXPECT}.tar.gz"
TOOL_DEJAGNU_FILE="${TOOL_DEJAGNU}.tar.gz"
TOOL_CHECK_FILE="${TOOL_CHECK}.tar.gz"
TOOL_NCURSES_FILE="${TOOL_NCURSES}.tar.gz"
TOOL_BASH_FILE="${TOOL_BASH}.tar.gz"
TOOL_BZIP2_FILE="${TOOL_BZIP2}.tar.gz"
TOOL_COREUTILS_FILE="${TOOL_COREUTILS}.tar.xz"
TOOL_DIFFUTILS_FILE="${TOOL_DIFFUTILS}.tar.xz"
TOOL_FILE_FILE="${TOOL_FILE}.tar.gz"
TOOL_FINDUTILS_FILE="${TOOL_FINDUTILS}.tar.gz"
TOOL_GAWK_FILE="${TOOL_GAWK}.tar.xz"
TOOL_GETTEXT_FILE="${TOOL_GETTEXT}.tar.gz"
TOOL_GREP_FILE="${TOOL_GREP}.tar.xz"
TOOL_GZIP_FILE="${TOOL_GZIP}.tar.xz"
TOOL_M4_FILE="${TOOL_M4}.tar.xz"
TOOL_MAKE_FILE="${TOOL_MAKE}.tar.bz2"
TOOL_PATCH_FILE="${TOOL_PATCH}.tar.xz"
TOOL_SED_FILE="${TOOL_SED}.tar.bz2"
TOOL_TAR_FILE="${TOOL_TAR}.tar.xz"
TOOL_READLINE_FILE="${TOOL_READLINE}.tar.gz"
TOOL_UTIL_LINUX_FILE="${TOOL_UTIL_LINUX}.tar.xz"
TOOL_XZ_FILE="${TOOL_XZ}.tar.xz"
TOOL_GMP_FILE="${TOOL_GMP}.tar.xz"
TOOL_TEXINFO_FILE="${TOOL_TEXINFO}.tar.xz"
TOOL_PERL_FILE="${TOOL_PERL}.tar.bz2"
TOOL_SHADOW_FILE="${TOOL_SHADOW}.tar.xz"
TOOL_LIBCAP_FILE="${TOOL_LIBCAP}.tar.xz"
TOOL_ACL_FILE="${TOOL_ACL}.src.tar.gz"
TOOL_ATTR_FILE="${TOOL_ATTR}.src.tar.gz"
TOOL_PKG_CONFIG_FILE="${TOOL_PKG_CONFIG}.tar.gz"
TOOL_MPC_FILE="${TOOL_MPC}.tar.gz"
TOOL_MPFR_FILE="${TOOL_MPFR}.tar.xz"
TOOL_OPENSSL_FILE="${TOOL_OPENSSL}.tar.gz"
TOOL_PYTHON_FILE="${TOOL_PYTHON}.tgz"
TOOL_TCL_FILE="${TOOL_TCL}-src.tar.gz"
TOOL_TK_FILE="${TOOL_TK}-src.tar.gz"
TOOL_WGET_FILE="${TOOL_WGET}.tar.gz"
TOOL_GNUTLS_FILE="${TOOL_GNUTLS}.tar.xz"
TOOL_NETTLE_FILE="${TOOL_NETTLE}.tar.gz"
TOOL_UNBOUND_FILE="${TOOL_UNBOUND}.tar.gz"
TOOL_BISON_FILE="${TOOL_BISON}.tar.xz"
TOOL_EXPAT_FILE="${TOOL_EXPAT}.tar.gz"
TOOL_X11_FILE="${TOOL_X11}.tar.gz"
TOOL_XEXTPROTO_FILE="${TOOL_XEXTPROTO}.tar.gz"
TOOL_XTRANS_FILE="${TOOL_XTRANS}.tar.gz"
TOOL_XCB_FILE="${TOOL_XCB}.tar.gz"
TOOL_KBPROTO_FILE="${TOOL_KBPROTO}.tar.gz"
TOOL_INPUTPROTO_FILE="${TOOL_INPUTPROTO}.tar.gz"
TOOL_XCB_PROTO_FILE="${TOOL_XCB_PROTO}.tar.gz"
TOOL_LIB_PTHREAD_FILE="${TOOL_LIB_PTHREAD}.tar.gz"
TOOL_XAU_FILE="${TOOL_XAU}.tar.gz"
TOOL_XPROTO_FILE="${TOOL_XPROTO}.tar.gz"
TOOL_CMAKE_FILE="${TOOL_CMAKE}.tar.gz"
TOOL_GDBM_FILE="${TOOL_GDBM}.tar.gz"
TOOL_LIBFFI_FILE="${TOOL_LIBFFI}.tar.gz"
TOOL_WHICH_FILE="${TOOL_WHICH}.tar.gz"

# all source directories
TOOL_SRC_BINUTILS="${NTC_SOURCE}/${TOOL_BINUTILS}"
TOOL_SRC_GCC="${NTC_SOURCE}/${TOOL_GCC}"
TOOL_SRC_LINUX="${NTC_SOURCE}/${TOOL_LINUX}"
TOOL_SRC_GLIBC="${NTC_SOURCE}/${TOOL_GLIBC}"
TOOL_SRC_ZLIB="${NTC_SOURCE}/${TOOL_ZLIB}"
TOOL_SRC_MAN_PAGES="${NTC_SOURCE}/${TOOL_MAN_PAGES}"
TOOL_SRC_TCL_CORE="${NTC_SOURCE}/${TOOL_TCL}"
TOOL_SRC_EXPECT="${NTC_SOURCE}/${TOOL_EXPECT}"
TOOL_SRC_DEJAGNU="${NTC_SOURCE}/${TOOL_DEJAGNU}"
TOOL_SRC_CHECK="${NTC_SOURCE}/${TOOL_CHECK}"
TOOL_SRC_NCURSES="${NTC_SOURCE}/${TOOL_NCURSES}"
TOOL_SRC_BASH="${NTC_SOURCE}/${TOOL_BASH}"
TOOL_SRC_BZIP2="${NTC_SOURCE}/${TOOL_BZIP2}"
TOOL_SRC_COREUTILS="${NTC_SOURCE}/${TOOL_COREUTILS}"
TOOL_SRC_DIFFUTILS="${NTC_SOURCE}/${TOOL_DIFFUTILS}"
TOOL_SRC_FILE="${NTC_SOURCE}/${TOOL_FILE}"
TOOL_SRC_FINDUTILS="${NTC_SOURCE}/${TOOL_FINDUTILS}"
TOOL_SRC_GAWK="${NTC_SOURCE}/${TOOL_GAWK}"
TOOL_SRC_GETTEXT="${NTC_SOURCE}/${TOOL_GETTEXT}"
TOOL_SRC_GREP="${NTC_SOURCE}/${TOOL_GREP}"
TOOL_SRC_GZIP="${NTC_SOURCE}/${TOOL_GZIP}"
TOOL_SRC_M4="${NTC_SOURCE}/${TOOL_M4}"
TOOL_SRC_MAKE="${NTC_SOURCE}/${TOOL_MAKE}"
TOOL_SRC_PATCH="${NTC_SOURCE}/${TOOL_PATCH}"
TOOL_SRC_SED="${NTC_SOURCE}/${TOOL_SED}"
TOOL_SRC_TAR="${NTC_SOURCE}/${TOOL_TAR}"
TOOL_SRC_READLINE="${NTC_SOURCE}/${TOOL_READLINE}"
TOOL_SRC_UTIL_LINUX="${NTC_SOURCE}/${TOOL_UTIL_LINUX}"
TOOL_SRC_XZ="${NTC_SOURCE}/${TOOL_XZ}"
TOOL_SRC_GMP="${NTC_SOURCE}/${TOOL_GMP_VERSION}"
TOOL_SRC_TEXINFO="${NTC_SOURCE}/${TOOL_TEXINFO}"
TOOL_SRC_PERL="${NTC_SOURCE}/${TOOL_PERL}"
TOOL_SRC_SHADOW="${NTC_SOURCE}/${TOOL_SHADOW}"
TOOL_SRC_LIBCAP="${NTC_SOURCE}/${TOOL_LIBCAP}"
TOOL_SRC_ACL="${NTC_SOURCE}/${TOOL_ACL}"
TOOL_SRC_ATTR="${NTC_SOURCE}/${TOOL_ATTR}"
TOOL_SRC_PKG_CONFIG="${NTC_SOURCE}/${TOOL_PKG_CONFIG}"
TOOL_SRC_MPC="${NTC_SOURCE}/${TOOL_MPC}"
TOOL_SRC_MPFR="${NTC_SOURCE}/${TOOL_MPFR}"
TOOL_SRC_OPENSSL="${NTC_SOURCE}/${TOOL_OPENSSL}"
TOOL_SRC_PYTHON="${NTC_SOURCE}/${TOOL_PYTHON}"
TOOL_SRC_TCL="${NTC_SOURCE}/${TOOL_TCL}"
TOOL_SRC_TK="${NTC_SOURCE}/${TOOL_TK}"
TOOL_SRC_WGET="${NTC_SOURCE}/${TOOL_WGET}"
TOOL_SRC_GNUTLS="${NTC_SOURCE}/${TOOL_GNUTLS}"
TOOL_SRC_NETTLE="${NTC_SOURCE}/${TOOL_NETTLE}"
TOOL_SRC_UNBOUND="${NTC_SOURCE}/${TOOL_UNBOUND}"
TOOL_SRC_BISON="${NTC_SOURCE}/${TOOL_BISON}"
TOOL_SRC_EXPAT="${NTC_SOURCE}/${TOOL_EXPAT}"
TOOL_SRC_X11="${NTC_SOURCE}/${TOOL_X11}"
TOOL_SRC_XEXTPROTO="${NTC_SOURCE}/${TOOL_XEXTPROTO}"
TOOL_SRC_XTRANS="${NTC_SOURCE}/${TOOL_XTRANS}"
TOOL_SRC_XCB="${NTC_SOURCE}/${TOOL_XCB}"
TOOL_SRC_KBPROTO="${NTC_SOURCE}/${TOOL_KBPROTO}"
TOOL_SRC_INPUTPROTO="${NTC_SOURCE}/${TOOL_INPUTPROTO}"
TOOL_SRC_XCB_PROTO="${NTC_SOURCE}/${TOOL_XCB_PROTO}"
TOOL_SRC_LIB_PTHREAD="${NTC_SOURCE}/${TOOL_LIB_PTHREAD}"
TOOL_SRC_XAU="${NTC_SOURCE}/${TOOL_XAU}"
TOOL_SRC_XPROTO="${NTC_SOURCE}/${TOOL_XPROTO}"
TOOL_SRC_CMAKE="${NTC_SOURCE}/${TOOL_CMAKE}"
TOOL_SRC_GDBM="${NTC_SOURCE}/${TOOL_GDBM}"
TOOL_SRC_LIBFFI="${NTC_SOURCE}/${TOOL_LIBFFI}"
TOOL_SRC_WHICH="${NTC_SOURCE}/${TOOL_WHICH}"


######################################################
# 0.3 GET TOOLS
######################################################

printf "\n\n\n\n\n... 0.3 - Getting Tools\n"

# create the sources list
cat << EOF > "${NTC_SOURCE}/sources.txt"
http://ftp.gnu.org/gnu/binutils/${TOOL_BINUTILS_FILE}
http://ftp.gnu.org/gnu/gcc/${TOOL_GCC}/${TOOL_GCC_FILE}
https://mirrors.edge.kernel.org/pub/linux/kernel/v${TOOL_LINUX_MAJOR}.x/${TOOL_LINUX_FILE}
http://ftp.gnu.org/gnu/glibc/${TOOL_GLIBC_FILE}
https://www.kernel.org/pub/linux/docs/man-pages/Archive/${TOOL_MAN_PAGES_FILE}
https://ftp.iana.org/tz/releases/tzdata2015f.tar.gz
https://www.zlib.net/fossils/${TOOL_ZLIB_FILE}
https://sourceforge.net/projects/tcl/files/Tcl/${TOOL_TCL_VERSION}/${TOOL_TCL_CORE_FILE}
https://sourceforge.net/projects/tcl/files/Tcl/${TOOL_TCL_VERSION}/${TOOL_TCL_FILE}
https://sourceforge.net/projects/expect/files/Expect/${TOOL_EXPECT_VERSION}/${TOOL_EXPECT_FILE}
https://ftp.gnu.org/gnu/dejagnu/${TOOL_DEJAGNU_FILE}
https://sourceforge.net/projects/check/files/check/${TOOL_CHECK_VERSION}/${TOOL_CHECK_FILE}
http://ftp.gnu.org/gnu//ncurses/${TOOL_NCURSES_FILE}
http://ftp.gnu.org/gnu/bash/${TOOL_BASH_FILE}
https://sourceware.org/pub/bzip2/${TOOL_BZIP2_FILE}
http://ftp.gnu.org/gnu/coreutils/${TOOL_COREUTILS_FILE}
http://ftp.gnu.org/gnu/diffutils/${TOOL_DIFFUTILS_FILE}
http://ftp.astron.com/pub/file/${TOOL_FILE_FILE}
http://ftp.gnu.org/gnu/findutils/${TOOL_FINDUTILS_FILE}
http://ftp.gnu.org/gnu/gawk/${TOOL_GAWK_FILE}
http://ftp.gnu.org/gnu/gettext/${TOOL_GETTEXT_FILE}
http://ftp.gnu.org/gnu/grep/${TOOL_GREP_FILE}
http://ftp.gnu.org/gnu/gzip/${TOOL_GZIP_FILE}
http://ftp.gnu.org/gnu/m4/${TOOL_M4_FILE}
http://ftp.gnu.org/gnu/make/${TOOL_MAKE_FILE}
http://ftp.gnu.org/gnu/patch/${TOOL_PATCH_FILE}
http://ftp.gnu.org/gnu/sed/${TOOL_SED_FILE}
http://ftp.gnu.org/gnu/tar/${TOOL_TAR_FILE}
http://ftp.gnu.org/gnu/readline/${TOOL_READLINE_FILE}
https://www.kernel.org/pub/linux/utils/util-linux/v${TOOL_UTIL_LINUX_VERSION}/${TOOL_UTIL_LINUX_FILE}
https://sourceforge.net/projects/lzmautils/files/${TOOL_XZ_FILE}
http://ftp.gnu.org/gnu//gmp/${TOOL_GMP_FILE}
http://www.mpfr.org/${TOOL_MPFR}/${TOOL_MPFR_FILE}
https://ftp.gnu.org/gnu/mpc/${TOOL_MPC_FILE}
http://pkgconfig.freedesktop.org/releases/${TOOL_PKG_CONFIG_FILE}
http://download.savannah.gnu.org/releases/attr/${TOOL_ATTR_FILE}
http://download.savannah.gnu.org/releases/acl/${TOOL_ACL_FILE}
https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/${TOOL_LIBCAP_FILE}
https://src.fedoraproject.org/repo/pkgs/shadow-utils/${TOOL_SHADOW_FILE}/${TOOL_SHADOW_HASH}/${TOOL_SHADOW_FILE}
http://ftp.gnu.org/gnu/texinfo/${TOOL_TEXINFO_FILE}
http://www.cpan.org/src/${TOOL_PERL_MAJOR}.0/${TOOL_PERL_FILE}
https://www.openssl.org/source/${TOOL_OPENSSL_FILE}
http://prdownloads.sourceforge.net/tcl/${TOOL_TK_FILE}
https://ftp.gnu.org/gnu/wget/${TOOL_WGET_FILE}
https://ftp.gnu.org/gnu/nettle/${TOOL_NETTLE_FILE}
https://nlnetlabs.nl/downloads/unbound/${TOOL_UNBOUND_FILE}
http://ftp.gnu.org/gnu/bison/${TOOL_BISON_FILE}
https://www.x.org/releases/individual/lib/${TOOL_X11_FILE}
https://www.x.org/archive/individual/proto/${TOOL_XEXTPROTO_FILE}
https://www.x.org/releases/individual/lib/${TOOL_XTRANS_FILE}
https://xcb.freedesktop.org/dist/${TOOL_XCB_FILE}
https://www.x.org/archive/individual/proto/${TOOL_KBPROTO_FILE}
https://www.x.org/archive/individual/proto/${TOOL_INPUTPROTO_FILE}
https://www.x.org/archive/individual/xcb/${TOOL_XCB_PROTO_FILE}
https://www.x.org/archive/individual/xcb/${TOOL_LIB_PTHREAD_FILE}
https://www.x.org/releases/individual/lib/${TOOL_XAU_FILE}
https://www.x.org/archive/individual/proto/${TOOL_XPROTO_FILE}
https://www.python.org/ftp/python/${TOOL_PYTHON_VERSION}/${TOOL_PYTHON_FILE}
https://github.com/libexpat/libexpat/releases/download/${TOOL_EXPAT_VERSION}/${TOOL_EXPAT_FILE}
https://www.gnupg.org/ftp/gcrypt/gnutls/v${TOOL_GNUTLS_VERSION}/${TOOL_GNUTLS_FILE}
https://github.com/Kitware/CMake/releases/download/v${TOOL_CMAKE_VERSION}/${TOOL_CMAKE_FILE}
https://ftp.gnu.org/gnu/gdbm/${TOOL_GDBM_FILE}
https://github.com/libffi/libffi/releases/download/v${TOOL_LIBFFI_VERSION}/${TOOL_LIBFFI_FILE}
https://ftp.gnu.org/gnu/which/${TOOL_WHICH_FILE}
$PATCHES
EOF

# options for wget
wget_opts=""
if [[ ! -z "${HTTP_PROXY}" && ! -z "${HTTPS_PROXY}" ]]; then
    wget_opts="-e use_proxy=on -e http_proxy=${HTTP_PROXY} -e https_proxy=${HTTPS_PROXY} --no-check-certificate"
elif [[ ! -z "${HTTP_PROXY}" ]]; then
    wget_opts="-e use_proxy=on -e http_proxy=${HTTP_PROXY} --no-check-certificate"
elif [[ ! -z "${HTTPS_PROXY}" ]]; then
    wget_opts="-e use_proxy=on -e https_proxy=${HTTPS_PROXY} --no-check-certificate"
fi

# options for gcc ./contrib/download_prerequisites
gcc_download_opts=""
if [[ ! -z "${HTTP_PROXY}" ]]; then
    gcc_download_opts="http_proxy=${HTTP_PROXY}"
fi
if [[ ! -z "${FTP_PROXY}" ]]; then
    gcc_download_opts="$gcc_download_opts ftp_proxy=${FTP_PROXY}"
fi

# unoptimized function to unzip some types of tarballs
untar () {
    case "$1" in 
        *.tar.gz|*.tgz)
            printf "Unzipping $1\n"
            tar -k --directory="${NTC_SOURCE}" -xzf "$1"
        ;;
        *.tar.bz2|*.xz)
            printf "Unzipping $1\n"
            tar -k --directory="${NTC_SOURCE}" -xf "$1"
        ;;
        *)
            printf "Skipping unzip of $1. Extension not recognized.\n"
        ;;
    esac
}

# wget the sources
wget -nc -i "${NTC_SOURCE}/sources.txt" --directory-prefix "${NTC_SOURCE}" ${wget_opts}

# md5 stuff
# pushd ${NTC_SOURCE}
# md5sum -c md5sums || exit 1
# popd


######################################################
# 1.0 INSTALL BINUTILS
######################################################

printf "\n\n\n\n\n... 1.0 - Installing Binutils\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_BINUTILS}"
untar "${NTC_SOURCE}/${TOOL_BINUTILS_FILE}"

# link 64 and 32
mkdir -vp "${NTC_TOOLS}/lib"
mkdir -vp "${NTC}/usr/lib"
case $(uname -m) in
  x86_64)
      ln -sv lib "${NTC_TOOLS}/lib64"
      ln -sv lib "${NTC}/usr/lib64"
  ;;
esac

# configure the build
rm -rf "${TOOL_SRC_BINUTILS}/build"     &&
mkdir -vp "${TOOL_SRC_BINUTILS}/build"  &&
cd "${TOOL_SRC_BINUTILS}/build"         &&
"${TOOL_SRC_BINUTILS}/configure"         \
    --target=${NTC_NAME}                 \
    --prefix=/tools                      \
    --disable-nls                        \
    --disable-werror                     \
    --with-lib-path="${NTC_TOOLS}/lib/" &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} DESTDIR=${NTC} install || exit 1

# --with-lib-path relative to --with-sysroot or --prefix? no
# --with-lib-path is used only for SEARCH_DIR for ld, and has no "=" in front of it
# (--with-lib-path is used to find libc.so and libm.so)


######################################################
# 1.1 INSTALL GCC
######################################################

printf "\n\n\n\n\n... 1.1 - Installing GCC\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_GCC}"
untar "${NTC_SOURCE}/${TOOL_GCC_FILE}"

# get the extra sources
cd "${TOOL_SRC_GCC}"
env ${gcc_download_opts} ./contrib/download_prerequisites

# clear out any previous changes (useful for debug)
for file in $(find gcc/config -name linux64.h.orig -o -name linux.h.orig -o -name sysv4.h.orig); do
    cp -fv $file $(echo $file | sed "s/.orig$//")
done

# avoid existing root, using LFS example code
for file in $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h); do
    cp -uv $file{,.orig}
    sed -e 's@/lib\(64\)\?\(32\)\?/ld@'"${NTC_TOOLS}"'&@g' \
        -e 's@/usr@'"/tools/"'@g' \
        $file.orig > $file
    echo "
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 \"/tools/lib/\"
#define STANDARD_STARTFILE_PREFIX_2 \"\"" >> $file
    touch $file.orig
done

# configure the build
rm -rf "${TOOL_SRC_GCC}/build"   &&
mkdir -p "${TOOL_SRC_GCC}/build" &&
cd "${TOOL_SRC_GCC}/build"       &&
"${TOOL_SRC_GCC}/configure"       \
    --target="${NTC_NAME}"        \
    --prefix="/tools"             \
    --with-glibc-version=2.11     \
    --with-newlib                 \
    --without-headers             \
    --disable-bootstrap           \
    --disable-nls                 \
    --disable-shared              \
    --disable-multilib            \
    --disable-decimal-float       \
    --disable-threads             \
    --disable-libatomic           \
    --disable-libgomp             \
    --disable-libquadmath         \
    --disable-libssp              \
    --disable-libvtv              \
    --disable-libstdcxx           \
    --enable-languages=c,c++      \
    --with-local-prefix="${NTC_TOOLS}" \
    --with-native-system-header-dir="${NTC_TOOLS}/include/" &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} DESTDIR="${NTC}" install || exit 1

# is wnshd relative to sysroot? yes!
# is prefix relative to sysroot? no!
# is --with-local-prefix relative to sysroot? no!
# final path provided to linker = sysroot + STANDARD_STARTFILE_PREFIX_1 + crti.o


######################################################
# 1.2 INSTALL LINUX HEADERS
######################################################

printf "\n\n\n\n\n... 1.2 - Installing Linux Kernel Headers\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_LINUX}"
untar "${NTC_SOURCE}/${TOOL_LINUX_FILE}"

# make the headers
mkdir -vp ${NTC_TOOLS}/include
cd "${TOOL_SRC_LINUX}"
make ${NTC_MAKE_FLAGS} mrproper &&
make ${NTC_MAKE_FLAGS} INSTALL_HDR_PATH=dest headers_install &&
cp -rv dest/include/* "${NTC_TOOLS}/include" || exit 1


######################################################
# 1.3 INSTALL GLIBC 
######################################################

printf "\n\n\n\n\n... 1.3 - Installing Glibc\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_GLIBC}"
untar "${NTC_SOURCE}/${TOOL_GLIBC_FILE}"

# apply patch
cd "${TOOL_SRC_GLIBC}"
patch -Np1 -i ../glibc-2.22-upstream_i386_fix-1.patch

# create the conf and cache to avoid install complaints
mkdir -vp "${NTC_TOOLS}/etc"
touch "${NTC_TOOLS}/etc/ld.so.conf"

# configure the tool
rm -rf "${TOOL_SRC_GLIBC}/build"                     &&
mkdir -vp "${TOOL_SRC_GLIBC}/build"                  &&
cd "${TOOL_SRC_GLIBC}/build"                         &&
"${TOOL_SRC_GLIBC}/configure"                         \
    --prefix="${NTC_TOOLS}"                           \
    --host="${NTC_NAME}"                              \
    --build=$(${TOOL_SRC_GLIBC}/scripts/config.guess) \
    --disable-profile                                 \
    --enable-kernel=2.6.32                            \
    --enable-obsolete-rpc                             \
    --with-headers="${NTC_TOOLS}/include/"            \
    libc_cv_forced_unwind=yes                         \
    libc_cv_ctors_header=yes                          \
    libc_cv_c_cleanup=yes                            && 

# make the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


######################################################
# 1.4 TEST PREVIOUS 
######################################################

printf "\n\n\n\n\n... 1.4 - Testing Previous\n\n"

cd "${TOOL_SRC_GLIBC}/build"

# check ld/crt* values
echo "int main() {}" > dummy.c
${NTC_NAME}-gcc -v dummy.c -B${NTC_TOOLS}/lib -I${NTC_TOOLS}/include -Wl,--verbose &> dummy.log
readelf -l a.out | grep "/ld-linux"
grep -o "/crt[1in].*succeeded" dummy.log
grep -B1 "^ .*/include" dummy.log 
grep "SEARCH.*/${NTC_NAME}/lib" dummy.log | sed 's|; |\n|g'
grep ".*libc.so.6 succeeded" dummy.log
grep "found ld-linux-.*.so.2 at .*/ld-linux-.*.so.2" dummy.log

# make sure it runs
./a.out || exit 1

# read specs
x86_64-tmp-linux-gnu-gcc -dumpspecs | grep crt* 

# check GLIBC version
cat > dummy.c << EOF
#include <stdio.h>
#include <stdlib.h>
#include <gnu/libc-version.h>

int main(int argc, char *argv[]) {
  printf("GNU libc version: %s\n", gnu_get_libc_version());
  exit(EXIT_SUCCESS);
}
EOF
${NTC_NAME}-gcc -v dummy.c -B${NTC_TOOLS}/lib -I${NTC_TOOLS}/include -Wl,--verbose &> dummy.log

# we can actually test whether it runs because technically this is just a native toolchain
./a.out || exit 1

rm -v dummy.c a.out dummy.log


######################################################
# 1.5 INSTALL LIBSTDC++ 
######################################################

printf "\n\n\n\n\n... 1.5 - Installing LIBSTDC++\n\n"

# reset
cd "${TOOL_SRC_GCC}"
for file in $(find gcc/config -name linux64.h.orig -o -name linux.h.orig -o -name sysv4.h.orig); do
    cp -fv $file $(echo $file | sed "s/.orig$//")
done

# configure the build
GXX_INCLUDE_DIR="/tools/${NTC_NAME}/include/c++/${TOOL_GCC_VERSION}"
rm -rf "${TOOL_SRC_GCC}/build"                                 &&
mkdir -p "${TOOL_SRC_GCC}/build"                               &&
cd "${TOOL_SRC_GCC}/build"                                     &&
CC="${NTC_NAME}-gcc -B${NTC_TOOLS}/lib -I${NTC_TOOLS}/include"  \
CXX="${NTC_NAME}-g++ -B${NTC_TOOLS}/lib -I${NTC_TOOLS}/include" \
"${TOOL_SRC_GCC}/libstdc++-v3/configure"         \
    --host="${NTC_NAME}"                         \
    --prefix=/tools                              \
    --disable-multilib                           \
    --disable-nls                                \
    --disable-libstdcxx-threads                  \
    --disable-libstdcxx-pch                      \
    --with-gxx-include-dir="${GXX_INCLUDE_DIR}" &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} DESTDIR=${NTC} install || exit 1


######################################################
# 2.0 INSTALL BINUTILS PASS 2
######################################################

printf "\n\n\n\n\n... 2.0 - Installing Binutils - Pass 2\n\n"

# configure the build
rm -rf "${TOOL_SRC_BINUTILS}/build"                            &&
mkdir -vp "${TOOL_SRC_BINUTILS}/build"                         &&
cd "${TOOL_SRC_BINUTILS}/build"                                &&
CC="${NTC_NAME}-gcc -B${NTC_TOOLS}/lib -I${NTC_TOOLS}/include"  \
CXX="${NTC_NAME}-g++ -B${NTC_TOOLS}/lib -I${NTC_TOOLS}/include" \
AR="${NTC_NAME}-ar"                   \
RANLIB="${NTC_NAME}-ranlib"           \
"${TOOL_SRC_BINUTILS}/configure"      \
    --prefix="${NTC_TOOLS}"           \
    --disable-werror                  \
    --enable-shared                   \
    --with-lib-path=${NTC_TOOLS}/lib &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1

# prepare to move to NTC from NTC/tools
make -C ld clean
make -C ld LIB_PATH=${NTC}/usr/lib:${NTC}/lib
cp -v ld/ld-new ${NTC_TOOLS}/bin/


######################################################
# 2.1 INSTALL GCC PASS 2
######################################################

printf "\n\n\n\n\n... 2.1 - Installing GCC - Pass 2\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_GCC}"
untar "${NTC_SOURCE}/${TOOL_GCC_FILE}"

# get the extra sources
cd "${TOOL_SRC_GCC}"
env ${gcc_download_opts} ./contrib/download_prerequisites

# clean up
for file in $(find gcc/config -name linux64.h.orig -o -name linux.h.orig -o -name sysv4.h.orig); do
    cp -fv $file $(echo $file | sed "s/.orig$//")
done

# avoid root before install || exit 1
for file in $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h); do
    cp -uv $file{,.orig}
    sed -e 's@/usr@'"${NTC_TOOLS}"'@g' \
        -e 's@/lib\(64\)\?\(32\)\?/ld@'"${NTC_TOOLS}"'&@g' $file.orig > $file
    echo "
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 \"${NTC_TOOLS}/lib/\"
#define STANDARD_STARTFILE_PREFIX_2 \"\"" >> $file
    touch $file.orig
done

# previous limits file might have been limited? Just following LFS instructions
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
    `dirname $("${NTC_NAME}-gcc" -print-libgcc-file-name)`/include-fixed/limits.h

# configure the build
TEMP_CFLAGS="-B${NTC_TOOLS}/lib -I${NTC_TOOLS}/include"
rm -rf "${TOOL_SRC_GCC}/build"      &&
mkdir -vp "${TOOL_SRC_GCC}/build"   &&
cd "${TOOL_SRC_GCC}/build"          &&
CFLAGS="${TEMP_CFLAGS}"              \
LDFLAGS="-L${NTC_TOOLS}/lib"         \
CXXFLAGS="${TEMP_CFLAGS}"            \
CC="${NTC_NAME}-gcc ${TEMP_CFLAGS}"  \
CXX="${NTC_NAME}-g++ ${TEMP_CFLAGS}" \
AR="${NTC_NAME}-ar"                  \
RANLIB="${NTC_NAME}-ranlib"          \
"${TOOL_SRC_GCC}/configure"          \
    --prefix="${NTC_TOOLS}"          \
    --disable-multilib               \
    --disable-bootstrap              \
    --disable-libcc1                 \
    --enable-languages=c,c++         \
    --with-local-prefix=${NTC_TOOLS} \
    --with-native-system-header-dir=${NTC_TOOLS}/include &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1

# test it
echo "int main() {}" > dummy.c
which gcc
gcc -v dummy.c
./a.out || exit 1


######################################################
# 3.0 INSTALL TCL
######################################################

printf "\n\n\n\n\n... 3.0 - Installing TCL Core\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_TCL_CORE}"
untar "${NTC_SOURCE}/${TOOL_TCL_CORE_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_TCL_CORE}/build" &&
cd "${TOOL_SRC_TCL_CORE}/build"        &&
"${TOOL_SRC_TCL_CORE}/unix/configure"   \
    --prefix=${NTC_TOOLS}              &&

TZ=UTC make "${NTC_MAKE_FLAGS}"
# TZ=UTC make "${NTC_MAKE_FLAGS}" test
make "${NTC_MAKE_FLAGS}" install                 &&
make "${NTC_MAKE_FLAGS}" install-private-headers &&

ln -sv tclsh8.6 "${NTC_TOOLS}/bin/tclsh" || exit 1


######################################################
# 3.1 INSTALL EXPECT
######################################################

printf "\n\n\n\n\n... 3.1 - Installing Expect\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_EXPECT}"
untar "${NTC_SOURCE}/${TOOL_EXPECT_FILE}"

cd "${TOOL_SRC_EXPECT}"
cp -v configure{,.orig}
sed "s:/usr/local/bin:${NTC_TOOLS}/bin:" configure.orig > configure

# configure the build
mkdir -vp "${TOOL_SRC_EXPECT}/build"         &&
cd "${TOOL_SRC_EXPECT}/build"                &&
"${TOOL_SRC_EXPECT}/configure"                \
    --prefix="${NTC_TOOLS}"                   \
    --with-tcl="${NTC_TOOLS}/lib"             \
    --with-tclinclude="${NTC_TOOLS}/include" &&

make "${NTC_MAKE_FLAGS}" &&
# TZ=UTC make "${NTC_MAKE_FLAGS}" test
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 3.2 INSTALL DEJAGNU
######################################################

printf "\n\n\n\n\n... 3.2 - Installing DejaGNU\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_DEJAGNU}"
untar "${NTC_SOURCE}/${TOOL_DEJAGNU_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_DEJAGNU}/build" &&
cd "${TOOL_SRC_DEJAGNU}/build"        &&
"${TOOL_SRC_DEJAGNU}/configure"        \
    --prefix="${NTC_TOOLS}"           &&

make "${NTC_MAKE_FLAGS}"         &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 3.3 INSTALL CHECK
######################################################

printf "\n\n\n\n\n... 3.3 - Installing Check\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_CHECK}"
untar "${NTC_SOURCE}/${TOOL_CHECK_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_CHECK}/build" &&
cd "${TOOL_SRC_CHECK}/build"        &&
PKG_CONFIG=""                        \
"${TOOL_SRC_CHECK}/configure"        \
    --prefix="${NTC_TOOLS}"         &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 3.4 INSTALL NCURSES
######################################################

printf "\n\n\n\n\n... 3.4 - Installing Ncurses\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_NCURSES}"
untar "${NTC_SOURCE}/${TOOL_NCURSES_FILE}"

cd "${TOOL_SRC_NCURSES}"
sed -i s/mawk// configure

# fix for 32bit toolchain sanity... 
ln -s libncursesw.so ${NTC_TOOLS}/lib/libncurses.so.5
ln -s libncursesw.a ${NTC_TOOLS}/lib/libncurses.a
ln -s libncurses++w.a ${NTC_TOOLS}/lib/libncurses++.a

# configure the build
mkdir -vp "${TOOL_SRC_NCURSES}/build" &&
cd "${TOOL_SRC_NCURSES}/build"        &&
"${TOOL_SRC_NCURSES}/configure"        \
    --prefix="${NTC_TOOLS}"            \
    --with-shared                      \
    --without-debug                    \
    --enable-widec                     \
    --enable-overwrite                &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 3.5 INSTALL BASH
######################################################
printf "\n\n\n\n\n... 3.5 - Installing Bash\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_BASH}"
untar "${NTC_SOURCE}/${TOOL_BASH_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_BASH}/build" &&
cd "${TOOL_SRC_BASH}/build"        &&
"${TOOL_SRC_BASH}/configure"        \
    --prefix="${NTC_TOOLS}"         \
    --without-bash-malloc          &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install &&

ln -sv bash "${NTC_TOOLS}/bin/sh" || exit 1


######################################################
# 3.6 INSTALL BZIP2
######################################################

printf "\n\n\n\n\n... 3.6 - Installing Bzip2\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_BZIP2}"
untar "${NTC_SOURCE}/${TOOL_BZIP2_FILE}"

# configure the build
cd "${TOOL_SRC_BZIP2}"   &&
make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" PREFIX="${NTC_TOOLS}" install || exit 1


######################################################
# 3.7 INSTALL COREUTILS
######################################################

printf "\n\n\n\n\n... 3.7 - Installing Coreutils\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_COREUTILS}"
untar "${NTC_SOURCE}/${TOOL_COREUTILS_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_COREUTILS}/build" &&
cd "${TOOL_SRC_COREUTILS}/build"        &&
"${TOOL_SRC_COREUTILS}/configure"        \
    --prefix="${NTC_TOOLS}"              \
    --enable-install-program=hostname   &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 3.8 INSTALL DIFFUTILS
######################################################

printf "\n\n\n\n\n... 3.8 - Installing Diffutils\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_DIFFUTILS}"
untar "${NTC_SOURCE}/${TOOL_DIFFUTILS_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_DIFFUTILS}/build" &&
cd "${TOOL_SRC_DIFFUTILS}/build"        &&
"${TOOL_SRC_DIFFUTILS}/configure"        \
    --prefix="${NTC_TOOLS}"             &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 3.9 INSTALL ZLIB
######################################################

printf "\n\n\n\n\n... 3.9 - Installing Zlib\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_ZLIB}"
untar "${NTC_SOURCE}/${TOOL_ZLIB_FILE}"

# configure the build
cd "${TOOL_SRC_ZLIB}"        &&
"${TOOL_SRC_ZLIB}/configure"  \
    --prefix="${NTC_TOOLS}"  &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 3.10 INSTALL FILE
######################################################

printf "\n\n\n\n\n... 3.10 - Installing File\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_FILE}"
untar "${NTC_SOURCE}/${TOOL_FILE_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_FILE}/build" &&
cd "${TOOL_SRC_FILE}/build"        &&
"${TOOL_SRC_FILE}/configure"        \
    --prefix="${NTC_TOOLS}"        &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 3.11 INSTALL FINDUTILS
######################################################

printf "\n\n\n\n\n... 3.11 - Installing Findutils\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_FINDUTILS}"
untar "${NTC_SOURCE}/${TOOL_FINDUTILS_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_FINDUTILS}/build" &&
cd "${TOOL_SRC_FINDUTILS}/build"        &&
"${TOOL_SRC_FINDUTILS}/configure"        \
    --prefix="${NTC_TOOLS}"             &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 3.12 INSTALL GAWK
######################################################

printf "\n\n\n\n\n... 3.12 - Installing Gawk\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_GAWK}"
untar "${NTC_SOURCE}/${TOOL_GAWK_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_GAWK}/build" &&
cd "${TOOL_SRC_GAWK}/build"        &&
"${TOOL_SRC_GAWK}/configure"        \
    --prefix="${NTC_TOOLS}"        &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 3.13 INSTALL GETTEXT
######################################################

printf "\n\n\n\n\n... 3.13 - Installing Gettext\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_GETTEXT}"
untar "${NTC_SOURCE}/${TOOL_GETTEXT_FILE}"

# configure the build
cd "${TOOL_SRC_GETTEXT}"       &&
EMACS="no"                      \
"${TOOL_SRC_GETTEXT}/configure" \
    --prefix="${NTC_TOOLS}"     \
    --disable-shared           &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 3.14 INSTALL GREP
######################################################

printf "\n\n\n\n\n... 3.14 - Installing Grep\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_GREP}"
untar "${NTC_SOURCE}/${TOOL_GREP_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_GREP}/build" &&
cd "${TOOL_SRC_GREP}/build"        &&
"${TOOL_SRC_GREP}/configure"        \
    --prefix="${NTC_TOOLS}"        &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 3.15 INSTALL GZIP
######################################################

printf "\n\n\n\n\n... 3.15 - Installing Gzip\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_GZIP}"
untar "${NTC_SOURCE}/${TOOL_GZIP_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_GZIP}/build" &&
cd "${TOOL_SRC_GZIP}/build"        &&
"${TOOL_SRC_GZIP}/configure"        \
    --prefix="${NTC_TOOLS}"        &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 3.16 INSTALL M4
######################################################

printf "\n\n\n\n\n... 3.16 - Installing M4\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_M4}"
untar "${NTC_SOURCE}/${TOOL_M4_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_M4}/build" &&
cd "${TOOL_SRC_M4}/build"        &&
"${TOOL_SRC_M4}/configure"        \
    --prefix="${NTC_TOOLS}"      &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 3.17 INSTALL MAKE
######################################################

printf "\n\n\n\n\n... 3.17 - Installing Make\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_MAKE}"
untar "${NTC_SOURCE}/${TOOL_MAKE_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_MAKE}/build" &&
cd "${TOOL_SRC_MAKE}/build"        &&
"${TOOL_SRC_MAKE}/configure"        \
    --prefix="${NTC_TOOLS}"         \
    --without-guile                &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 3.18 INSTALL PATCH
######################################################

printf "\n\n\n\n\n... 3.18 - Installing Patch\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_PATCH}"
untar "${NTC_SOURCE}/${TOOL_PATCH_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_PATCH}/build" &&
cd "${TOOL_SRC_PATCH}/build"        &&
"${TOOL_SRC_PATCH}/configure"        \
    --prefix="${NTC_TOOLS}"         &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 3.19 INSTALL SED
######################################################

printf "\n\n\n\n\n... 3.19 - Installing Sed\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_SED}"
untar "${NTC_SOURCE}/${TOOL_SED_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_SED}/build" &&
cd "${TOOL_SRC_SED}/build"        &&
"${TOOL_SRC_SED}/configure"        \
    --prefix="${NTC_TOOLS}"       &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 3.20 PERL
######################################################

printf "\n\n\n\n\n... 3.20 - Installing PERL\n\n"

rm -rf "${TOOL_SRC_PERL}"
untar "${NTC_SOURCE}/${TOOL_PERL_FILE}"

# configure the build
cd "${TOOL_SRC_PERL}" &&
sh Configure -des -Dprefix=${NTC_TOOLS} -Dlibs=-lm &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
cp -v perl cpan/podlators/pod2man ${NTC_TOOLS}/bin &&
mkdir -pv ${NTC_TOOLS}/lib/perl${TOOL_PERL_MAJOR}/${TOOL_PERL_VERSION} &&
cp -Rv lib/* ${NTC_TOOLS}/lib/perl${TOOL_PERL_MAJOR}/${TOOL_PERL_VERSION} || exit 1


######################################################
# 3.21 TEXINFO
######################################################

printf "\n\n\n\n\n... 3.21 - Installing Texinfo\n\n"

rm -rf "${TOOL_SRC_TEXINFO}"
untar "${NTC_SOURCE}/${TOOL_TEXINFO_FILE}"

# configure the build
rm -rf "${TOOL_SRC_TEXINFO}/build"    &&
mkdir -vp "${TOOL_SRC_TEXINFO}/build" &&
cd "${TOOL_SRC_TEXINFO}/build"        &&
"${TOOL_SRC_TEXINFO}/configure"        \
    --prefix="${NTC_TOOLS}"           &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


######################################################
# 3.22 INSTALL TAR
######################################################

printf "\n\n\n\n\n... 3.22 - Installing Tar\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_TAR}"
untar "${NTC_SOURCE}/${TOOL_TAR_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_TAR}/build" &&
cd "${TOOL_SRC_TAR}/build"        &&
"${TOOL_SRC_TAR}/configure"        \
    --prefix="${NTC_TOOLS}"       &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 3.23 INSTALL READLINE 
######################################################

printf "\n\n\n\n\n... 3.23 - Installing Readline\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_READLINE}"
untar "${NTC_SOURCE}/${TOOL_READLINE_FILE}"

# patch
cd "${TOOL_SRC_READLINE}"
patch -Np1 -i ../readline-6.3-upstream_fixes-3.patch

# configure the build
mkdir -vp "${TOOL_SRC_READLINE}/build"          &&
cd "${TOOL_SRC_READLINE}/build"                 &&
"${TOOL_SRC_READLINE}/configure"                 \
    --prefix="${NTC_TOOLS}"                      \
    --docdir=${NTC_TOOLS}/share/doc/readline-6.3 \
    --disable-static                            &&

make "${NTC_MAKE_FLAGS}" SHLIB_LIBS=-lncursesw &&
make "${NTC_MAKE_FLAGS}" SHLIB_LIBS=-lncursesw install || exit 1


######################################################
# 3.24 INSTALL UTIL-LINUX
######################################################

printf "\n\n\n\n\n... 3.24 - Installing Util-linux\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_UTIL_LINUX}"
untar "${NTC_SOURCE}/${TOOL_UTIL_LINUX_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_UTIL_LINUX}/build" &&
cd "${TOOL_SRC_UTIL_LINUX}/build"        &&
PKG_CONFIG=""                             \
"${TOOL_SRC_UTIL_LINUX}/configure"        \
    --prefix="${NTC_TOOLS}"               \
    --without-python                      \
    --disable-makeinstall-chown           \
    --without-systemdsystemunitdir       &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 3.25 INSTALL XZ
######################################################

printf "\n\n\n\n\n... 3.25 - Installing XZ\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_XZ}"
untar "${NTC_SOURCE}/${TOOL_XZ_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_XZ}/build" &&
cd "${TOOL_SRC_XZ}/build"        &&
"${TOOL_SRC_XZ}/configure"        \
    --prefix="${NTC_TOOLS}"      &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 4.0 CREATE DIRECTORIES
######################################################

printf "\n\n\n\n\n... 4.0 - Creating a few more directories\n\n"

mkdir -pv ${NTC}/{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt}
mkdir -pv ${NTC}/{media/{floppy,cdrom},sbin,srv,var}
mkdir -pv ${NTC}/usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv ${NTC}/usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -pv  ${NTC}/usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv  ${NTC}/usr/libexec
mkdir -pv ${NTC}/usr/{,local/}share/man/man{1..8}
mkdir -pv ${NTC}/var/{log,mail,spool}
mkdir -pv ${NTC}/var/{opt,cache,lib/{color,misc,locate},local}
install -dv -m 0750 ${NTC}/root
install -dv -m 1777 ${NTC}/tmp ${NTC}/var/tmp

# avoid x64/x32 split
case $(uname -m) in
    x86_64)
        ln -sv lib ${NTC}/lib64
        ln -sv lib ${NTC}/usr/lib64
        ln -sv lib ${NTC}/usr/local/lib64 ;;
esac

# sym links for various tools
ln -sv ${NTC}/run ${NTC}/var/run
ln -sv ${NTC}/run/lock ${NTC}/var/lock
ln -sv ${NTC_TOOLS}/bin/{bash,cat,echo,pwd,stty} ${NTC}/bin
ln -sv ${NTC_TOOLS}/bin/perl ${NTC}/usr/bin
ln -sv ${NTC_TOOLS}/lib/libgcc_s.so{,.1} ${NTC}/usr/lib
ln -sv ${NTC_TOOLS}/lib/libstdc++.so{,.6} ${NTC}/usr/lib
ln -sv bash ${NTC}/bin/sh
ln -sv ${NTC}/proc/self/mounts ${NTC}/etc/mtab

# point libstdc++ to usr directory and copy to said area
sed "s/tools/usr/" ${NTC_TOOLS}/lib/libstdc++.la > ${NTC}/usr/lib/libstdc++.la

# purge original host toolchain, leaving only our new tools and usr chains
export PATH=${NTC}/usr/local/bin:${NTC}/usr/local/sbin:${NTC}/usr/bin:${NTC}/usr/sbin:${NTC_TOOLS}/bin:${NTC_TOOLS}/sbin


######################################################
# 4.1 INSTALL LINUX HEADERS
######################################################

printf "\n\n\n\n\n... 4.1 - Installing Linux Kernel Headers\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_LINUX}"
untar "${NTC_SOURCE}/${TOOL_LINUX_FILE}"

# make the headers
mkdir -vp ${NTC}/usr/include
cd "${TOOL_SRC_LINUX}"
make ${NTC_MAKE_FLAGS} mrproper &&
make ${NTC_MAKE_FLAGS} INSTALL_HDR_PATH=dest headers_install &&
find dest/include \( -name .install -o -name ..install.cmd \) -delete &&
cp -rv dest/include/* "${NTC}/usr/include" || exit 1


######################################################
# 4.2 INSTALL MAN-PAGES 
######################################################

printf "\n\n\n\n\n... 4.2 - Installing Man Pages\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_MAN_PAGES}"
untar "${NTC_SOURCE}/${TOOL_MAN_PAGES_FILE}"

# install
cd "${TOOL_SRC_MAN_PAGES}"  &&
make ${NTC_MAKE_FLAGS} DESTDIR=${NTC} install || exit 1


######################################################
# 4.3.0 INSTALL GLIBC 
######################################################

printf "\n\n\n\n\n... 4.3.0 - Installing Glibc\n\n"

# clean build
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_GLIBC}" || mv "${TOOL_SRC_GLIBC}" "${TOOL_SRC_GLIBC}_" &&
    echo "Fixing weird NFS bug" && rm -rf "${TOOL_SRC_GLIBC}_"
untar "${NTC_SOURCE}/${TOOL_GLIBC_FILE}"

# patch
cd "${TOOL_SRC_GLIBC}"
patch -Np1 -i ../glibc-2.22-fhs-1.patch
patch -Np1 -i ../glibc-2.22-upstream_i386_fix-1.patch

# configure
rm -rf "${TOOL_SRC_GLIBC}/build"      &&
mkdir -vp "${TOOL_SRC_GLIBC}/build"   &&
cd "${TOOL_SRC_GLIBC}/build"          &&
"${TOOL_SRC_GLIBC}/configure"          \
    --prefix=${NTC}/usr                \
    --disable-profile                  \
    --enable-kernel=2.6.32             \
    --enable-obsolete-rpc             &&

make ${NTC_MAKE_FLAGS}                &&
# TZ=UTC make ${NTC_MAKE_FLAGS} check &&
mkdir -vp touch ${NTC}/usr/etc/       &&
touch ${NTC}/usr/etc/ld.so.conf       &&
make ${NTC_MAKE_FLAGS} install || exit 1


######################################################
# 4.3.1 CONFIGURE GLIBC 
######################################################

printf "\n\n\n\n\n... 4.3.1 - Configuring Glibc\n\n"

cp -v "${TOOL_SRC_GLIBC}/nscd/nscd.conf" "${NTC}/etc/nscd.conf"
mkdir -pv "${NTC}/var/cache/nscd"
mkdir -pv "${NTC}/usr/lib/locale"

localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i en_GB -f UTF-8 en_GB.UTF-8
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i it_IT -f UTF-8 it_IT.UTF-8
localedef -i ja_JP -f EUC-JP ja_JP
localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
localedef -i zh_CN -f GB18030 zh_CN.GB18030

# want to install every locale instead of just those few?
# make ${NTC_MAKE_FLAGS} localedata/install-locales

cp -rv "${NTC}/lib/locale" "${NTC}/usr/lib/locale"

# Glibc defaults don't work well in networked environments? Just following LFS verbatim
cat > "${NTC}/etc/nsswitch.conf" << EOF
# Begin ${NTC}/etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

EOF

# add time zone data
tar -zxf ${NTC_SOURCE}/tzdata2015f.tar.gz

ZONEINFO=${NTC}/usr/share/zoneinfo
mkdir -pv ${ZONEINFO}/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward pacificnew systemv; do
    zic -L /dev/null   -d ${ZONEINFO}       -y "sh yearistype.sh" ${tz}
    zic -L /dev/null   -d ${ZONEINFO}/posix -y "sh yearistype.sh" ${tz}
    zic -L leapseconds -d ${ZONEINFO}/right -y "sh yearistype.sh" ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab ${ZONEINFO}
zic -d ${ZONEINFO} -p America/New_York
unset ZONEINFO

TZ='America/Los_Angeles' # hardcoded result of running> tzselect
cp -v ${NTC}/usr/share/zoneinfo/${TZ} ${NTC}/etc/localtime


######################################################
# 4.3.2 CONFIGURE DYNAMIC LOADER 
######################################################

printf "\n\n\n\n\n... 4.3.2 - Configuring the Dynamic Loader\n\n"

cat > ${NTC}/usr/etc/ld.so.conf << EOF
# Begin ${NTC}/usr/etc/ld.so.conf
${NTC}/usr/local/lib
${NTC}/opt/lib

EOF

# If desired, the dynamic loader can also search a directory 
# and include the contents of files found there
# cat >> ${NTC}/etc/ld.so.conf << "EOF"
# # Add an include directory
# include ${NTC}/etc/ld.so.conf.d/*.conf
# 
# EOF
# mkdir -pv ${NTC}/etc/ld.so.conf.d


######################################################
# 4.3.3 Adjust the toolchain
######################################################

# some people use cc
ln -sv gcc ${NTC_TOOLS}/bin/cc

# apply the ld-new created earlier
mv -v ${NTC_TOOLS}/bin/{ld,ld-old}
mv -v ${NTC_TOOLS}/$(gcc -dumpmachine)/bin/{ld,ld-old}
mv -v ${NTC_TOOLS}/bin/{ld-new,ld}
ln -sv ${NTC_TOOLS}/bin/ld ${NTC_TOOLS}/$(gcc -dumpmachine)/bin/ld

# fix the specs to use usr
gcc -dumpspecs | sed -e 's@'"${NTC_TOOLS}"'@'"${NTC}"'/usr@g'     \
    -e '/\*startfile_prefix_spec:/{n;s@.*@'"${NTC}"'/usr/lib/ @}' \
    -e '/\*cpp:/{n;s@$@ -isystem '"${NTC}"'/usr/include@}' >      \
    `dirname $(gcc --print-libgcc-file-name)`/specs

# test
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep '/lib'
grep '/usr/lib.*/crt[1in].*succeeded' dummy.log
grep -B1 '^ '"${NTC}"'/usr/include' dummy.log
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
grep "/lib.*/libc.so.6 " dummy.log
grep found dummy.log
rm -v dummy.c a.out dummy.log


######################################################
# 4.4 INSTALL ZLIB
######################################################

printf "\n\n\n\n\n... 4.4 - Installing Zlib\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_ZLIB}"
untar "${NTC_SOURCE}/${TOOL_ZLIB_FILE}"

# configure the build
cd "${TOOL_SRC_ZLIB}"        &&
"${TOOL_SRC_ZLIB}/configure"  \
    --prefix="${NTC}/usr"    &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1

cp -v ${NTC}/usr/lib/libz.so.* ${NTC}/lib
ln -sfv ../../lib/$(readlink ${NTC}/usr/lib/libz.so) ${NTC}/usr/lib/libz.so


######################################################
# 4.5 INSTALL FILE
######################################################

printf "\n\n\n\n\n... 4.5 - Installing File\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_FILE}"
untar "${NTC_SOURCE}/${TOOL_FILE_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_FILE}/build" &&
cd "${TOOL_SRC_FILE}/build"        &&
"${TOOL_SRC_FILE}/configure"        \
    --prefix="${NTC}/usr"          &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 4.6 Binutils - Pass 3
######################################################

printf "\n\n\n\n\n... 4.6 - Installing Binutils - Pass 3\n\n"

# configure the build
rm -rf "${TOOL_SRC_BINUTILS}/build"    &&
mkdir -vp "${TOOL_SRC_BINUTILS}/build" &&
cd "${TOOL_SRC_BINUTILS}/build"        &&
"${TOOL_SRC_BINUTILS}/configure"        \
    --prefix="${NTC}/usr"               \
    --disable-werror                    \
    --with-lib-path=${NTC}/usr/lib      \
    --enable-shared                    &&

# make and install the tool
make ${NTC_MAKE_FLAGS} tooldir=${NTC}/usr &&
make ${NTC_MAKE_FLAGS} tooldir=${NTC}/usr install || exit 1


######################################################
# 4.7 GMP
######################################################

printf "\n\n\n\n\n... 4.7 - Installing GMP\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_GMP}"
untar "${NTC_SOURCE}/${TOOL_GMP_FILE}"

# configure the build
rm -rf "${TOOL_SRC_GMP}/build"                &&
mkdir -vp "${TOOL_SRC_GMP}/build"             &&
cd "${TOOL_SRC_GMP}/build"                    &&
"${TOOL_SRC_GMP}/configure"                    \
    --prefix="${NTC}/usr"                      \
    --enable-cxx                               \
    --disable-static                           \
    --docdir=${NTC}/usr/share/doc/${TOOL_GMP} &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} html &&
make ${NTC_MAKE_FLAGS} install &&
make ${NTC_MAKE_FLAGS} install-html || exit 1


######################################################
# 4.8 MPFR
######################################################

printf "\n\n\n\n\n... 4.8 - Installing MPFR\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_MPFR}"
untar "${NTC_SOURCE}/${TOOL_MPFR_FILE}"

# configure the build
rm -rf "${TOOL_SRC_MPFR}/build"                &&
mkdir -vp "${TOOL_SRC_MPFR}/build"             &&
cd "${TOOL_SRC_MPFR}/build"                    &&
"${TOOL_SRC_MPFR}/configure"                    \
    --prefix="${NTC}/usr"                       \
    --enable-thread-safe                        \
    --disable-static                            \
    --docdir=${NTC}/usr/share/doc/${TOOL_MPFR} &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} html &&
make ${NTC_MAKE_FLAGS} install &&
make ${NTC_MAKE_FLAGS} install-html || exit 1


######################################################
# 4.9 MPC
######################################################

printf "\n\n\n\n\n... 4.9 - Installing MPC\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_MPC}"
untar "${NTC_SOURCE}/${TOOL_MPC_FILE}"

# configure the build
rm -rf "${TOOL_SRC_MPC}/build"                &&
mkdir -vp "${TOOL_SRC_MPC}/build"             &&
cd "${TOOL_SRC_MPC}/build"                    &&
"${TOOL_SRC_MPC}/configure"                    \
    --prefix="${NTC}/usr"                      \
    --disable-static                           \
    --docdir=${NTC}/usr/share/doc/${TOOL_MPC} &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} html &&
make ${NTC_MAKE_FLAGS} install &&
make ${NTC_MAKE_FLAGS} install-html || exit 1


######################################################
# 4.10 GCC - PASS 3
######################################################

printf "\n\n\n\n\n... 4.10 - Installing GCC - Pass 3\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_GCC}"
untar "${NTC_SOURCE}/${TOOL_GCC_FILE}"

# avoid root before install || exit 1
cd "${TOOL_SRC_GCC}"
for file in $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h); do
    cp -uv $file{,.orig}
    sed -e 's@/usr@'"${NTC}"'&@g' \
        -e 's@/lib\(64\)\?\(32\)\?/ld@'"${NTC}"'/usr&@g' $file.orig > $file
    echo "
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 \"${NTC}/usr/lib/\"
#define STANDARD_STARTFILE_PREFIX_2 \"\"" >> $file
    touch $file.orig
done

# configure the build
rm -rf "${TOOL_SRC_GCC}/build"    &&
mkdir -vp "${TOOL_SRC_GCC}/build" &&
cd "${TOOL_SRC_GCC}/build"        &&
SED=sed                            \
"${TOOL_SRC_GCC}/configure"        \
    --prefix="${NTC}/usr"          \
    --enable-languages=c,c++       \
    --disable-multilib             \
    --disable-bootstrap            \
    --with-system-zlib             \
    --with-local-prefix=${NTC}/usr \
    --with-native-system-header-dir=${NTC}/usr/include &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
#     ulimit -s 32768 &&
#     make -k check &&
#     ../gcc-5.2.0/contrib/test_summary &&
make ${NTC_MAKE_FLAGS} install               &&
ln -sv ../usr/bin/cpp ${NTC}/lib             &&
ln -sv gcc ${NTC}/usr/bin/cc                 &&
install -v -dm755 ${NTC}/usr/lib/bfd-plugins &&
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/${TOOL_GCC_VERSION}/liblto_plugin.so \
    ${NTC}/usr/lib/bfd-plugins/ || exit 1

# test
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
grep -o "${NTC}/usr/lib.*/crt[1in].*succeeded" dummy.log
grep -B4 "^ ${NTC}/usr/include" dummy.log
grep "SEARCH.*${NTC}/usr/lib" dummy.log |sed 's|; |\n|g'
grep "/lib.*/libc.so.6 " dummy.log
grep found dummy.log
rm -v dummy.c a.out dummy.log

# fix out-of-place file
mkdir -pv ${NTC}/usr/share/gdb/auto-load/usr/lib
mv -v ${NTC}/usr/lib/*gdb.py ${NTC}/usr/share/gdb/auto-load/usr/lib

# Note: at this point you have a working compiler isolated from the host.
#   Install what you want. Here are some examples!


######################################################
# 5.0 OPENSSL
######################################################

printf "\n\n\n\n\n... 5.0 - Installing OpenSSL\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_OPENSSL}"
untar "${NTC_SOURCE}/${TOOL_OPENSSL_FILE}"

# configure the build
rm -rf "${TOOL_SRC_OPENSSL}/build"    &&
mkdir -vp "${TOOL_SRC_OPENSSL}/build" &&
cd "${TOOL_SRC_OPENSSL}/build"        &&
"${TOOL_SRC_OPENSSL}/Configure"        \
    --prefix=${NTC}/usr                \
    --openssldir=${NTC}/usr/ssl       &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


######################################################
# 5.1 PKGCONFIG 
######################################################

printf "\n\n\n\n\n... 5.1 - Installing Pkg Config\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_PKG_CONFIG}"
untar "${NTC_SOURCE}/${TOOL_PKG_CONFIG_FILE}"

# configure the build
rm -rf "${TOOL_SRC_PKG_CONFIG}/build"    &&
mkdir -vp "${TOOL_SRC_PKG_CONFIG}/build" &&
cd "${TOOL_SRC_PKG_CONFIG}/build"        &&
"${TOOL_SRC_PKG_CONFIG}/configure"        \
    --prefix=${NTC}/usr                   \
    --with-internal-glib                  \
    --disable-host-tool                   \
    --docdir=${NTC}/usr/share/doc/${TOOL_PKG_CONFIG} &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


######################################################
# 5.2 NETTLE 
######################################################

printf "\n\n\n\n\n... 5.2 - Installing Nettle\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_NETTLE}"
untar "${NTC_SOURCE}/${TOOL_NETTLE_FILE}"

# configure the build
rm -rf "${TOOL_SRC_NETTLE}/build"    &&
mkdir -vp "${TOOL_SRC_NETTLE}/build" &&
cd "${TOOL_SRC_NETTLE}/build"        &&
"${TOOL_SRC_NETTLE}/configure"        \
    --prefix=${NTC}/usr              &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


######################################################
# 5.3 BISON 
######################################################

printf "\n\n\n\n\n... 5.3 - Installing Bison\n\n"

ln -vs gawk ${NTC}/usr/bin/awk
ln -vs yacc ${NTC}/usr/bin/bison

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_BISON}"
untar "${NTC_SOURCE}/${TOOL_BISON_FILE}"

# configure the build
rm -rf "${TOOL_SRC_BISON}/build"    &&
mkdir -vp "${TOOL_SRC_BISON}/build" &&
cd "${TOOL_SRC_BISON}/build"        &&
"${TOOL_SRC_BISON}/configure"        \
    --prefix=${NTC}/usr              \
    --docdir=${NTC}/usr/share/doc/${TOOL_BISON} &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


######################################################
# 5.4 EXPAT
######################################################

printf "\n\n\n\n\n... 5.4 - Installing Expat\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_EXPAT}"
untar "${NTC_SOURCE}/${TOOL_EXPAT_FILE}"

# configure the build
rm -rf "${TOOL_SRC_EXPAT}/build"    &&
mkdir -vp "${TOOL_SRC_EXPAT}/build" &&
cd "${TOOL_SRC_EXPAT}/build"        &&
"${TOOL_SRC_EXPAT}/configure"        \
    --prefix=${NTC}/usr              \
    --disable-static                &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1

# install docs
cd "${TOOL_SRC_EXPAT}"
install -v -dm755 ${NTC}/usr/share/doc/${TOOL_EXPAT}
install -v -m644 doc/*.{html,png,css} ${NTC}/usr/share/doc/${TOOL_EXPAT}


######################################################
# 5.5 UNBOUND 
######################################################

printf "\n\n\n\n\n... 5.5 - Installing Unbound\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_UNBOUND}"
untar "${NTC_SOURCE}/${TOOL_UNBOUND_FILE}"

# configure the build
cd "${TOOL_SRC_UNBOUND}"                            &&
"${TOOL_SRC_UNBOUND}/configure"                      \
    --prefix=${NTC}/usr                              \
    --with-ssl=${NTC}/usr/                           \
    --with-rootkey-file=${NTC}/etc/unbound/root.key &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1

# configure
mkdir -vp ${NTC}/etc/unbound
touch ${NTC}/etc/unbound/root.key
unbound-anchor -a "${NTC}/etc/unbound/root.key"


######################################################
# 5.6 GNUTLS 
######################################################

printf "\n\n\n\n\n... 5.6 - Installing Gnutls\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_GNUTLS}"
untar "${NTC_SOURCE}/${TOOL_GNUTLS_FILE}"

# configure the build
rm -rf "${TOOL_SRC_GNUTLS}/build"    &&
mkdir -vp "${TOOL_SRC_GNUTLS}/build" &&
mkdir -vp "${NTC}/etc/ssl/certs/"    &&
mkdir -vp "${NTC}/etc/gnutls/"       &&
cd "${TOOL_SRC_GNUTLS}/build"        &&
"${TOOL_SRC_GNUTLS}/configure"                                         \
    --prefix=${NTC}/usr                                                \
    --with-default-trust-store-dir=${NTC}/etc/ssl/certs/               \
    --with-unbound-root-key-file=${NTC}/etc/unbound/root.key           \
    --with-system-priority-file=${NTC}/etc/gnutls/default-prioritites &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


######################################################
# 5.7 WGET 
######################################################

printf "\n\n\n\n\n... 5.7 - Installing Wget\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_WGET}"
untar "${NTC_SOURCE}/${TOOL_WGET_FILE}"

# configure the build
rm -rf "${TOOL_SRC_WGET}/build"    &&
mkdir -vp "${TOOL_SRC_WGET}/build" &&
cd "${TOOL_SRC_WGET}/build"        &&
"${TOOL_SRC_WGET}/configure"        \
    --prefix=${NTC}/usr            &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


######################################################
# 5.8 INSTALL NCURSES
######################################################

printf "\n\n\n\n\n... 5.8 - Installing Ncurses\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_NCURSES}"
untar "${NTC_SOURCE}/${TOOL_NCURSES_FILE}"

cd "${TOOL_SRC_NCURSES}"
sed -i s/mawk// configure

# configure the build
mkdir -vp "${TOOL_SRC_NCURSES}/build" &&
cd "${TOOL_SRC_NCURSES}/build"        &&
"${TOOL_SRC_NCURSES}/configure"        \
    --prefix="${NTC}/usr"              \
    --mandir="${NTC}/usr/share/man"    \
    --with-shared                      \
    --with-cxx-shared                  \
    --without-normal                   \
    --without-debug                    \
    --enable-pc-files                  \
    --enable-widec                     \
    --with-pkg-config-libdir="${NTC}/usr/lib/pkgconfig" &&

make "${NTC_MAKE_FLAGS}" &&

# avoid a crash
make DESTDIR=${PWD}/dest install || exit 1
install -vm755 dest/${NTC}/usr/lib/libncursesw.so.${TOOL_NCURSES_VERSION} ${NTC}/usr/lib
rm -v  dest/${NTC}/usr/lib/libncursesw.so.${TOOL_NCURSES_VERSION}
cp -av dest/${NTC}/* ${NTC}/

# apps expecting non-widec
for lib in ncurses form panel menu ; do
    rm -vf                    ${NTC}/usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > ${NTC}/usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc        ${NTC}/usr/lib/pkgconfig/${lib}.pc
done

rm -vf                     ${NTC}/usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > ${NTC}/usr/lib/libcursesw.so
ln -sfv libncurses.so      ${NTC}/usr/lib/libcurses.so


######################################################
# 5.9 INSTALL READLINE 
######################################################

printf "\n\n\n\n\n... 5.9 - Installing Readline\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_READLINE}"
untar "${NTC_SOURCE}/${TOOL_READLINE_FILE}"

# patch
cd "${TOOL_SRC_READLINE}"
patch -Np1 -i ../readline-6.3-upstream_fixes-3.patch

# configure the build
mkdir -vp "${TOOL_SRC_READLINE}/build"            &&
cd "${TOOL_SRC_READLINE}/build"                   &&
"${TOOL_SRC_READLINE}/configure"                   \
    --prefix="${NTC}/usr"                          \
    --docdir=${NTC}/usr/share/doc/${TOOL_READLINE} \
    --disable-static                              &&

make "${NTC_MAKE_FLAGS}" SHLIB_LIBS=-lncursesw &&
make "${NTC_MAKE_FLAGS}" SHLIB_LIBS=-lncursesw install || exit 1


######################################################
# 5.10 Python - Pass 1 
######################################################

printf "\n\n\n\n\n... 5.10 - Installing Python - Pass 1\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_PYTHON}"
untar "${NTC_SOURCE}/${TOOL_PYTHON_FILE}"

# configure the build
rm -rf "${TOOL_SRC_PYTHON}/build"    &&
mkdir -vp "${TOOL_SRC_PYTHON}/build" &&
cd "${TOOL_SRC_PYTHON}/build"        &&
LDFLAGS="-L${NTC}/usr/lib"           \
CFLAGS="-I${NTC}/usr/include -I${NTC}/usr/include/ncursesw"   \
CPPFLAGS="-I${NTC}/usr/include -I${NTC}/usr/include/ncursesw" \
"${TOOL_SRC_PYTHON}/configure"        \
    --prefix=${NTC}/usr               \
    --with-openssl=${NTC}/usr        &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1

ln -sv python3 ${NTC}/usr/bin/python


######################################################
# 5.11 X11
######################################################

printf "\n\n\n\n\n... 5.11 - Installing X11\n\n"

# -- proto
# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_XEXTPROTO}"
untar "${NTC_SOURCE}/${TOOL_XEXTPROTO_FILE}"

# configure the build
rm -rf "${TOOL_SRC_XEXTPROTO}/build"    &&
mkdir -vp "${TOOL_SRC_XEXTPROTO}/build" &&
cd "${TOOL_SRC_XEXTPROTO}/build"        &&
"${TOOL_SRC_XEXTPROTO}/configure"        \
    --prefix=${NTC}/usr                 &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


# -- xproto
# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_XPROTO}"
untar "${NTC_SOURCE}/${TOOL_XPROTO_FILE}"

# configure the build
rm -rf "${TOOL_SRC_XPROTO}/build"    &&
mkdir -vp "${TOOL_SRC_XPROTO}/build" &&
cd "${TOOL_SRC_XPROTO}/build"        &&
"${TOOL_SRC_XPROTO}/configure"        \
    --prefix=${NTC}/usr              &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


# -- xtrans
# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_XTRANS}"
untar "${NTC_SOURCE}/${TOOL_XTRANS_FILE}"

# configure the build
rm -rf "${TOOL_SRC_XTRANS}/build"    &&
mkdir -vp "${TOOL_SRC_XTRANS}/build" &&
cd "${TOOL_SRC_XTRANS}/build"        &&
"${TOOL_SRC_XTRANS}/configure"        \
    --prefix=${NTC}/usr              &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


# -- xcb proto
# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_XCB_PROTO}"
untar "${NTC_SOURCE}/${TOOL_XCB_PROTO_FILE}"

# configure the build
rm -rf "${TOOL_SRC_XCB_PROTO}/build"    &&
mkdir -vp "${TOOL_SRC_XCB_PROTO}/build" &&
cd "${TOOL_SRC_XCB_PROTO}/build"        &&
"${TOOL_SRC_XCB_PROTO}/configure"        \
    --prefix=${NTC}/usr                 &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


# -- xau
# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_XAU}"
untar "${NTC_SOURCE}/${TOOL_XAU_FILE}"

# configure the build
rm -rf "${TOOL_SRC_XAU}/build"    &&
mkdir -vp "${TOOL_SRC_XAU}/build" &&
cd "${TOOL_SRC_XAU}/build"        &&
"${TOOL_SRC_XAU}/configure"        \
    --prefix=${NTC}/usr           &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


# -- libpthread
# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_LIB_PTHREAD}"
untar "${NTC_SOURCE}/${TOOL_LIB_PTHREAD_FILE}"

# configure the build
rm -rf "${TOOL_SRC_LIB_PTHREAD}/build"    &&
mkdir -vp "${TOOL_SRC_LIB_PTHREAD}/build" &&
cd "${TOOL_SRC_LIB_PTHREAD}/build"        &&
"${TOOL_SRC_LIB_PTHREAD}/configure"        \
    --prefix=${NTC}/usr                   &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


# -- xcb
# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_XCB}"
untar "${NTC_SOURCE}/${TOOL_XCB_FILE}"

# configure the build
rm -rf "${TOOL_SRC_XCB}/build"    &&
mkdir -vp "${TOOL_SRC_XCB}/build" &&
cd "${TOOL_SRC_XCB}/build"        &&
"${TOOL_SRC_XCB}/configure"        \
    --prefix=${NTC}/usr           &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


# -- kbproto
# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_KBPROTO}"
untar "${NTC_SOURCE}/${TOOL_KBPROTO_FILE}"

# configure the build
rm -rf "${TOOL_SRC_KBPROTO}/build"    &&
mkdir -vp "${TOOL_SRC_KBPROTO}/build" &&
cd "${TOOL_SRC_KBPROTO}/build"        &&
"${TOOL_SRC_KBPROTO}/configure"        \
    --prefix=${NTC}/usr               &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


# -- inputproto
# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_INPUTPROTO}"
untar "${NTC_SOURCE}/${TOOL_INPUTPROTO_FILE}"

# configure the build
rm -rf "${TOOL_SRC_INPUTPROTO}/build"    &&
mkdir -vp "${TOOL_SRC_INPUTPROTO}/build" &&
cd "${TOOL_SRC_INPUTPROTO}/build"        &&
"${TOOL_SRC_INPUTPROTO}/configure"        \
    --prefix=${NTC}/usr                  &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


# -- libX11
# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_X11}"
untar "${NTC_SOURCE}/${TOOL_X11_FILE}"

# configure the build
rm -rf "${TOOL_SRC_X11}/build"    &&
mkdir -vp "${TOOL_SRC_X11}/build" &&
cd "${TOOL_SRC_X11}/build"        &&
"${TOOL_SRC_X11}/configure"        \
    --prefix=${NTC}/usr           &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


######################################################
# 5.12 TCL 
######################################################

printf "\n\n\n\n\n... 5.12 - Installing TCL\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_TCL}"
untar "${NTC_SOURCE}/${TOOL_TCL_FILE}"

# configure the build
rm -rf "${TOOL_SRC_TCL}/build"    &&
mkdir -vp "${TOOL_SRC_TCL}/build" &&
cd "${TOOL_SRC_TCL}/build"        &&
"${TOOL_SRC_TCL}/unix/configure"   \
    --prefix=${NTC}/usr           &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


######################################################
# 5.13 TK
######################################################

printf "\n\n\n\n\n... 5.13 - Installing TK\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_TK}"
untar "${NTC_SOURCE}/${TOOL_TK_FILE}"

# configure the build
rm -rf "${TOOL_SRC_TK}/build"                   &&
mkdir -vp "${TOOL_SRC_TK}/build"                &&
cd "${TOOL_SRC_TK}/build"                       &&
"${TOOL_SRC_TK}/unix/configure"                  \
    --prefix=${NTC}/usr                          \
    --with-tcl=${NTC_SOURCE}/${TOOL_TCL}/build/ &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


######################################################
# 5.14 INSTALL BZIP2
######################################################

printf "\n\n\n\n\n... 5.14 - Installing Bzip2\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_BZIP2}"
untar "${NTC_SOURCE}/${TOOL_BZIP2_FILE}"

# configure the build
cd "${TOOL_SRC_BZIP2}"   &&
make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" PREFIX="${NTC}/usr" install || exit 1

# redo for library
rm -rf "${TOOL_SRC_BZIP2}"
untar "${NTC_SOURCE}/${TOOL_BZIP2_FILE}"

# configure the build
cd "${TOOL_SRC_BZIP2}"             &&
make -f Makefile-libbz2_so         &&
make install PREFIX=${NTC}/usr/    &&
cp libbz2.so.${TOOL_BZIP2_VERSION} ${NTC}/usr/lib/ &&
ln -vs libbz2.so.${TOOL_BZIP2_VERSION} ${NTC}/usr/lib/libbz2.so.${TOOL_BZIP2_MINOR_VERSION} &&
ln -vs libbz2.so.${TOOL_BZIP2_MINOR_VERSION} ${NTC}/usr/lib/libbz2.so
ln -vs libbz2.so.${TOOL_BZIP2_MINOR_VERSION} ${NTC}/usr/lib/libbz2.so.1 || exit 1


######################################################
# 5.15 INSTALL GDBM
######################################################

printf "\n\n\n\n\n... 5.15 - Installing GDBM\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_GDBM}"
untar "${NTC_SOURCE}/${TOOL_GDBM_FILE}"

# configure the build
rm -rf "${TOOL_SRC_GDBM}/build"    &&
mkdir -vp "${TOOL_SRC_GDBM}/build" &&
cd "${TOOL_SRC_GDBM}/build"        &&
"${TOOL_SRC_GDBM}/configure"        \
    --prefix=${NTC}/usr             \
    --disable-static                \
    --enable-libgdbm-compat        &&

make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


######################################################
# 5.16 INSTALL LIBFFI
######################################################

printf "\n\n\n\n\n... 5.16 - Installing LIBFFI\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_LIBFFI}"
untar "${NTC_SOURCE}/${TOOL_LIBFFI_FILE}"

# configure the build
rm -rf "${TOOL_SRC_LIBFFI}/build"    &&
mkdir -vp "${TOOL_SRC_LIBFFI}/build" &&
cd "${TOOL_SRC_LIBFFI}/build"        &&
"${TOOL_SRC_LIBFFI}/configure"        \
    --prefix=${NTC}/usr              &&

make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


######################################################
# 5.17 INSTALL EXPECT
######################################################

printf "\n\n\n\n\n... 5.17 - Installing Expect\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_EXPECT}"
untar "${NTC_SOURCE}/${TOOL_EXPECT_FILE}"

cd "${TOOL_SRC_EXPECT}"
cp -v configure{,.orig}
sed "s:/usr/local/bin:${NTC}/usr/bin:" configure.orig > configure

# configure the build
mkdir -vp "${TOOL_SRC_EXPECT}/build"       &&
cd "${TOOL_SRC_EXPECT}/build"              &&
"${TOOL_SRC_EXPECT}/configure"              \
    --prefix="${NTC}/usr"                   \
    --with-tcl="${NTC}/usr/lib"             \
    --with-tclinclude="${NTC}/usr/include" &&

make "${NTC_MAKE_FLAGS}" &&
# TZ=UTC make "${NTC_MAKE_FLAGS}" test
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 5.18 INSTALL DEJAGNU
######################################################

printf "\n\n\n\n\n... 5.18 - Installing DejaGNU\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_DEJAGNU}"
untar "${NTC_SOURCE}/${TOOL_DEJAGNU_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_DEJAGNU}/build" &&
cd "${TOOL_SRC_DEJAGNU}/build"        &&
"${TOOL_SRC_DEJAGNU}/configure"        \
    --prefix="${NTC}/usr"             &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 5.19 INSTALL CHECK
######################################################

printf "\n\n\n\n\n... 5.19 - Installing Check\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_CHECK}"
untar "${NTC_SOURCE}/${TOOL_CHECK_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_CHECK}/build" &&
cd "${TOOL_SRC_CHECK}/build"        &&
PKG_CONFIG=""                        \
"${TOOL_SRC_CHECK}/configure"        \
    --prefix="${NTC}/usr"           &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 5.20 INSTALL BASH
######################################################
printf "\n\n\n\n\n... 5.20 - Installing Bash\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_BASH}"
untar "${NTC_SOURCE}/${TOOL_BASH_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_BASH}/build" &&
cd "${TOOL_SRC_BASH}/build"        &&
"${TOOL_SRC_BASH}/configure"        \
    --prefix="${NTC}/usr"           \
    --without-bash-malloc          &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install &&

ln -sv bash "${NTC}/usr/bin/sh" || exit 1


######################################################
# 5.21 INSTALL COREUTILS
######################################################

printf "\n\n\n\n\n... 5.21 - Installing Coreutils\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_COREUTILS}"
untar "${NTC_SOURCE}/${TOOL_COREUTILS_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_COREUTILS}/build" &&
cd "${TOOL_SRC_COREUTILS}/build"        &&
"${TOOL_SRC_COREUTILS}/configure"        \
    --prefix="${NTC}/usr"                \
    --enable-install-program=hostname   &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 5.22 INSTALL DIFFUTILS
######################################################

printf "\n\n\n\n\n... 5.22 - Installing Diffutils\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_DIFFUTILS}"
untar "${NTC_SOURCE}/${TOOL_DIFFUTILS_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_DIFFUTILS}/build" &&
cd "${TOOL_SRC_DIFFUTILS}/build"        &&
"${TOOL_SRC_DIFFUTILS}/configure"        \
    --prefix="${NTC}/usr"               &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 5.23 INSTALL FINDUTILS
######################################################

printf "\n\n\n\n\n... 5.23 - Installing Findutils\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_FINDUTILS}"
untar "${NTC_SOURCE}/${TOOL_FINDUTILS_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_FINDUTILS}/build" &&
cd "${TOOL_SRC_FINDUTILS}/build"        &&
"${TOOL_SRC_FINDUTILS}/configure"        \
    --prefix="${NTC}/usr"               &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 5.24 INSTALL GAWK
######################################################

printf "\n\n\n\n\n... 5.24 - Installing Gawk\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_GAWK}"
untar "${NTC_SOURCE}/${TOOL_GAWK_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_GAWK}/build" &&
cd "${TOOL_SRC_GAWK}/build"        &&
"${TOOL_SRC_GAWK}/configure"        \
    --prefix="${NTC}/usr"          &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 5.25 INSTALL GETTEXT
######################################################

printf "\n\n\n\n\n... 5.25 - Installing Gettext\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_GETTEXT}"
untar "${NTC_SOURCE}/${TOOL_GETTEXT_FILE}"

# configure the build
cd "${TOOL_SRC_GETTEXT}"       &&
EMACS="no"                      \
"${TOOL_SRC_GETTEXT}/configure" \
    --prefix="${NTC}/usr"      &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 5.26 INSTALL GREP
######################################################

printf "\n\n\n\n\n... 5.26 - Installing Grep\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_GREP}"
untar "${NTC_SOURCE}/${TOOL_GREP_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_GREP}/build" &&
cd "${TOOL_SRC_GREP}/build"        &&
"${TOOL_SRC_GREP}/configure"        \
    --prefix="${NTC}/usr"          &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 5.27 INSTALL GZIP
######################################################

printf "\n\n\n\n\n... 5.27 - Installing Gzip\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_GZIP}"
untar "${NTC_SOURCE}/${TOOL_GZIP_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_GZIP}/build" &&
cd "${TOOL_SRC_GZIP}/build"        &&
"${TOOL_SRC_GZIP}/configure"        \
    --prefix="${NTC}/usr"          &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 5.28 INSTALL M4
######################################################

printf "\n\n\n\n\n... 5.28 - Installing M4\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_M4}"
untar "${NTC_SOURCE}/${TOOL_M4_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_M4}/build" &&
cd "${TOOL_SRC_M4}/build"        &&
"${TOOL_SRC_M4}/configure"        \
    --prefix="${NTC}/usr"        &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 5.29 INSTALL MAKE
######################################################

printf "\n\n\n\n\n... 5.29 - Installing Make\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_MAKE}"
untar "${NTC_SOURCE}/${TOOL_MAKE_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_MAKE}/build" &&
cd "${TOOL_SRC_MAKE}/build"        &&
"${TOOL_SRC_MAKE}/configure"        \
    --prefix="${NTC}/usr"           \
    --without-guile                &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 5.30 INSTALL PATCH
######################################################

printf "\n\n\n\n\n... 5.30 - Installing Patch\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_PATCH}"
untar "${NTC_SOURCE}/${TOOL_PATCH_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_PATCH}/build" &&
cd "${TOOL_SRC_PATCH}/build"        &&
"${TOOL_SRC_PATCH}/configure"        \
    --prefix="${NTC}/usr"           &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 5.31 INSTALL SED
######################################################

printf "\n\n\n\n\n... 5.31 - Installing Sed\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_SED}"
untar "${NTC_SOURCE}/${TOOL_SED_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_SED}/build" &&
cd "${TOOL_SRC_SED}/build"        &&
"${TOOL_SRC_SED}/configure"        \
    --prefix="${NTC}/usr"         &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 5.32 PERL
######################################################

printf "\n\n\n\n\n... 5.32 - Installing PERL\n\n"

rm -rf "${TOOL_SRC_PERL}"
untar "${NTC_SOURCE}/${TOOL_PERL_FILE}"

# configure the build
cd "${TOOL_SRC_PERL}" &&
sh Configure -des -Dprefix=${NTC}/usr -Dlibs=-lm &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
cp -v perl cpan/podlators/pod2man ${NTC}/usr/bin &&
mkdir -pv ${NTC}/usr/lib/perl${TOOL_PERL_MAJOR}/${TOOL_PERL_VERSION} &&
cp -Rv lib/* ${NTC}/usr/lib/perl${TOOL_PERL_MAJOR}/${TOOL_PERL_VERSION} || exit 1


######################################################
# 5.33 TEXINFO
######################################################

printf "\n\n\n\n\n... 5.33 - Installing Texinfo\n\n"

rm -rf "${TOOL_SRC_TEXINFO}"
untar "${NTC_SOURCE}/${TOOL_TEXINFO_FILE}"

# configure the build
rm -rf "${TOOL_SRC_TEXINFO}/build"    &&
mkdir -vp "${TOOL_SRC_TEXINFO}/build" &&
cd "${TOOL_SRC_TEXINFO}/build"        &&
"${TOOL_SRC_TEXINFO}/configure"        \
    --prefix="${NTC}/usr"             &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


######################################################
# 5.34 INSTALL TAR
######################################################

printf "\n\n\n\n\n... 5.34 - Installing Tar\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_TAR}"
untar "${NTC_SOURCE}/${TOOL_TAR_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_TAR}/build" &&
cd "${TOOL_SRC_TAR}/build"        &&
"${TOOL_SRC_TAR}/configure"        \
    --prefix="${NTC}/usr"         &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 5.35 INSTALL READLINE 
######################################################

printf "\n\n\n\n\n... 5.35 - Installing Readline\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_READLINE}"
untar "${NTC_SOURCE}/${TOOL_READLINE_FILE}"

# patch
cd "${TOOL_SRC_READLINE}"
patch -Np1 -i ../readline-6.3-upstream_fixes-3.patch

# configure the build
mkdir -vp "${TOOL_SRC_READLINE}/build"          &&
cd "${TOOL_SRC_READLINE}/build"                 &&
"${TOOL_SRC_READLINE}/configure"                 \
    --prefix="${NTC}/usr"                        \
    --docdir=${NTC}/usr/share/doc/readline-6.3   \
    --disable-static                            &&

make "${NTC_MAKE_FLAGS}" SHLIB_LIBS=-lncursesw &&
make "${NTC_MAKE_FLAGS}" SHLIB_LIBS=-lncursesw install || exit 1


######################################################
# 5.36 INSTALL UTIL-LINUX
######################################################

printf "\n\n\n\n\n... 5.36 - Installing Util-linux\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_UTIL_LINUX}"
untar "${NTC_SOURCE}/${TOOL_UTIL_LINUX_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_UTIL_LINUX}/build" &&
cd "${TOOL_SRC_UTIL_LINUX}/build"        &&
"${TOOL_SRC_UTIL_LINUX}/configure"        \
    --prefix="${NTC}/usr"                 \
    --disable-makeinstall-chown           \
    --without-systemdsystemunitdir       &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 5.37 INSTALL XZ
######################################################

printf "\n\n\n\n\n... 5.37 - Installing XZ\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_XZ}"
untar "${NTC_SOURCE}/${TOOL_XZ_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_XZ}/build" &&
cd "${TOOL_SRC_XZ}/build"        &&
"${TOOL_SRC_XZ}/configure"        \
    --prefix="${NTC}/usr"        &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1


######################################################
# 5.38 Python - Pass 2
######################################################

printf "\n\n\n\n\n... 5.38 - Installing Python - Pass 2\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_PYTHON}"
untar "${NTC_SOURCE}/${TOOL_PYTHON_FILE}"

# configure the build
rm -rf "${TOOL_SRC_PYTHON}/build"    &&
mkdir -vp "${TOOL_SRC_PYTHON}/build" &&
cd "${TOOL_SRC_PYTHON}/build"        &&
LDFLAGS="-L${NTC}/usr/lib"           \
CFLAGS="-I${NTC}/usr/include -I${NTC}/usr/include/ncursesw"   \
CPPFLAGS="-I${NTC}/usr/include -I${NTC}/usr/include/ncursesw" \
"${TOOL_SRC_PYTHON}/configure"                   \
    --prefix=${NTC}/usr                          \
    --with-openssl=${NTC}/usr/                   \
    --with-dbmliborder=gdbm:ndbm:bdb             \
    --with-system-ffi                            \
    --with-tzpath=${NTC}/usr/share/zoneinfo      \
    --with-tcltk-includes="-I${NTC}/usr/include" \
    --with-tcltk-libs="${NTC}/usr/lib/${TOOL_TCL_LIB_VERSION}.so ${NTC}/usr/lib/${TOOL_TK_LIB_VERSION}.so" &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


######################################################
# 5.39 Cmake
######################################################

printf "\n\n\n\n\n... 5.39 - Installing Cmake\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_CMAKE}"
untar "${NTC_SOURCE}/${TOOL_CMAKE_FILE}"

cd "${TOOL_SRC_CMAKE}"
sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake

# configure the build
rm -rf "${TOOL_SRC_CMAKE}/build"    &&
mkdir -vp "${TOOL_SRC_CMAKE}/build" &&
cd "${TOOL_SRC_CMAKE}/build"        &&
"${TOOL_SRC_CMAKE}/configure"                          \
    --prefix=${NTC}/usr                                \
    --mandir=${NTC}/usr/share/man                      \
    --verbose                                          \
    --system-zlib                                      \
    --system-expat                                     \
    --system-bzip2                                     \
    --parallel=36                                      \
    --docdir=${NTC}/usr/share/doc/${TOOL_CMAKE}        \
    -- -DBUILD_CursesDialog=ON                         \
    -DZLIB_LIBRARY=${NTC}/usr/lib/libz.so              \
    -DBZIP2_LIBRARY=${NTC}/usr/lib/libbz2.so           \
    -DEXPAT_LIBRARY=${NTC}/usr/lib/libexpat.so         \
    -DCURSES_LIBRARY=${NTC}/usr/lib/libncursesw.so.${TOOL_NCURSES_MAJOR_VERSION} \
    -DCURSES_INCLUDE_PATH=${NTC}/usr/include/ncursesw &&

# make and install the tool
make ${NTC_MAKE_FLAGS} &&
make ${NTC_MAKE_FLAGS} install || exit 1


######################################################
# 5.40 INSTALL WHICH
######################################################

printf "\n\n\n\n\n... 5.40 - Installing WHICH\n\n"

# remove existing
printf "Removing existing source directory if it exists...\n"
rm -rf "${TOOL_SRC_WHICH}"
untar "${NTC_SOURCE}/${TOOL_WHICH_FILE}"

# configure the build
mkdir -vp "${TOOL_SRC_WHICH}/build" &&
cd "${TOOL_SRC_WHICH}/build"        &&
"${TOOL_SRC_WHICH}/configure"        \
    --prefix="${NTC}/usr"           &&

make "${NTC_MAKE_FLAGS}" &&
make "${NTC_MAKE_FLAGS}" install || exit 1

