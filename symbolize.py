#!/usr/bin/env python3

from __future__ import print_function
from __future__ import unicode_literals

import argparse
import glob
import os
import subprocess
import sys

if sys.version_info.major < 3:
    import codecs

    sys.stdout = codecs.getwriter("utf-8")(sys.stdout)


class Symbolizer:
    def __init__(self, path, binary_prefixes):
        self.__pipe = None
        self.__path = path
        self.__binary_prefixes = binary_prefixes
        self.__warnings = set()

    def __open_pipe(self):
        if not self.__pipe:
            opt = {}
            if sys.version_info.major > 2:
                opt['encoding'] = 'utf-8'
            self.__pipe = subprocess.Popen([self.__path, "--inlining", "--functions"],
                                           stdin=subprocess.PIPE, stdout=subprocess.PIPE,
                                           **opt)

    class __EOF(Exception):
        pass

    def print_stack(self, binary, addr, print_lines=10):
        result = None
        self.__open_pipe()
        if self.__pipe:
            try:
                print(binary + ":" + addr)
                result = subprocess.run(
                    [self.__path, "-obj", binary, addr, "--print-source-context-lines=" + str(print_lines)],
                    check=True, stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE, text=True, encoding='utf-8')
            except subprocess.CalledProcessError as e:
                print(e.returncode)
            except Exception as e:
                print(str(e))

        if result is not None:
            return result.stdout
        else:
            return None


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-sp', '--symbolizer_path', dest='symbolizer_path')
    parser.add_argument('-s', '--symbols', dest='symbols', required=True)
    parser.add_argument('-l', '--log_file', dest='log_file', required=True)
    parser.add_argument('-p', '--print_lines', dest='print_lines')
    parser.add_argument('args', nargs=argparse.REMAINDER)
    args = parser.parse_args()

    binary_prefixes = args.symbols
    if not binary_prefixes:
        if 'ANDROID_PRODUCT_OUT' in os.environ:
            product_out = os.path.join(os.environ['ANDROID_PRODUCT_OUT'], 'symbols')
            binary_prefixes.append(product_out)
        binary_prefixes.append('/')

    if not os.path.isdir(binary_prefixes):
        print("Symbols path does not exist or is not a directory:", binary_prefixes, file=sys.stderr)
        sys.exit(1)

    symbolizer_path = args.symbolizer_path
    if not symbolizer_path:
        if 'LLVM_SYMBOLIZER_PATH' in os.environ:
            symbolizer_path = os.environ['LLVM_SYMBOLIZER_PATH']
        elif 'HWASAN_SYMBOLIZER_PATH' in os.environ:
            symbolizer_path = os.environ['HWASAN_SYMBOLIZER_PATH']

    if not symbolizer_path:
        s = os.path.join(os.path.dirname(sys.argv[0]), 'llvm-symbolizer')
        if os.path.exists(s):
            symbolizer_path = s

    if not symbolizer_path:
        if 'ANDROID_BUILD_TOP' in os.environ:
            s = os.path.join(os.environ['ANDROID_BUILD_TOP'],
                             'prebuilts/clang/host/linux-x86/llvm-binutils-stable/llvm-symbolizer')
            if os.path.exists(s):
                symbolizer_path = s

    if not symbolizer_path:
        for path in os.environ["PATH"].split(os.pathsep):
            p = os.path.join(path, 'llvm-symbolizer')
            if os.path.exists(p):
                symbolizer_path = p
                break

    if not symbolizer_path:
        for path in os.environ["PATH"].split(os.pathsep):
            candidates = glob.glob(os.path.join(path, 'llvm-symbolizer-*'))
            if len(candidates) > 0:
                candidates.sort(key=extract_version, reverse=True)
                symbolizer_path = candidates[0]
                break

    if not args.symbolizer_path:
        print("set -sp or --symbolizer_path for symbolizer_path", file=sys.stderr)
        sys.exit(1)

    if not os.path.exists(symbolizer_path):
        print("Symbolizer path does not exist:", symbolizer_path, file=sys.stderr)
        sys.exit(1)

    if not args.print_lines:
        args.print_lines = 10

    symbolizer = Symbolizer(symbolizer_path, binary_prefixes)

    log_file = os.path.abspath(args.log_file)
    if not os.path.exists(log_file):
        print("Log file path does not exist:", log_file, file=sys.stderr)
        sys.exit(1)
    file_name, file_extension = os.path.splitext(os.path.basename(log_file))
    dir = os.path.dirname(log_file) + "/log"
    if not os.path.exists(dir):
        os.mkdir(dir)
    out_file = dir + "/" + file_name + "_result" + file_extension
    with open(out_file, 'w') as of:
        with open(log_file, 'r') as rf:
            lines = rf.readlines()
            for line in lines:
                tmp = line.split(" ")
                arr = line.split()
                if len(arr) > 9:
                    tag = arr[4]
                    if (tag == 'E' or tag == 'F') and arr[8] == 'pc':
                        tag = tmp[0:14]
                        frameno = arr[7]
                        addr = arr[9]
                        binary = binary_prefixes + arr[10]
                        buildid = arr[12]
                        # print(arr)
                        result = symbolizer.print_stack(binary, "0x" + addr, args.print_lines)
                        if result is not None:
                            arr = result.split("\n")
                            tag = " ".join(tag)
                            for item in arr:
                                of.write(tag + item + "\n")
                            print(result)
                    else:
                        of.write(line)
        print("out_file:" + out_file)


if __name__ == '__main__':
    main()
