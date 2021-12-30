#!/usr/bin/env python3

import argparse
import contextlib
import gzip
import json
import os
import shutil
import subprocess
import tarfile
import tempfile

import requests


ROOT_DIRECTORY = os.path.dirname(os.path.abspath(__file__))
SCRIPTS_DIRECTORY = os.path.join(ROOT_DIRECTORY, "scripts")

REPOSITORIES = [
    "inseven/elsewhere"
]


def download_file(url):
    local_filename = url.split('/')[-1]
    with requests.get(url, stream=True) as r:
        with open(local_filename, 'wb') as f:
            shutil.copyfileobj(r.raw, f)
    return os.path.abspath(local_filename)


def extract_tgz(source, destination, strip_components=0):
    with tempfile.TemporaryDirectory() as temporary_directory:
        tar_path = os.path.join(temporary_directory, "file.tar")
        
        with gzip.GzipFile(source) as gf:
            with open(tar_path, 'wb') as fh:
                shutil.copyfileobj(gf, fh)

        with tarfile.TarFile(tar_path, 'r') as tf:
            for member in tf.getmembers():
                if not member.isreg():
                    continue
                components = member.name.split(os.sep)
                member.name = os.path.join(*(components[strip_components:]))
            tf.extractall(destination)


@contextlib.contextmanager
def chdir(path):
    try:
        pwd = os.getcwd()
        os.chdir(path)
        yield
    finally:
        os.chdir(pwd)


def gh_release_assets(url, filter=lambda x: True):
    assets = requests.get(url).json()["assets"]
    urls = [asset["browser_download_url"] for asset in assets if filter(asset["name"])]
    return urls


def gh_releases(repository):
    return requests.get(f"https://api.github.com/repos/{repository}/releases").json()


def makedirs(path):
    if not os.path.isdir(path):
        os.makedirs(path)


def main():
    parser = argparse.ArgumentParser(description="Create a package repository from a collection of GitHub projects")
    parser.add_argument("repository", nargs="+", help="GitHub repository to fetch releases from")
    parser.add_argument("--output", default="packages", help="output directory (defaults to 'packages')")
    options = parser.parse_args()

    # TODO: Remove the packages directory.
    output_directory = os.path.abspath(options.output)
    try:
        os.makedirs(output_directory)
    except FileExistsError:
        shutil.rmtree(output_directory)
    makedirs(output_directory)

    for repository in options.repository:
        print(f"Updating '{repository}'...")
        for release in gh_releases(repository):
            with chdir(output_directory):
                urls = gh_release_assets(release["url"], filter=lambda name: name.endswith(".deb"))
                for url in urls:
                    print(f"Downloading release '{release['name']}'...")
                    download_file(url)

    print("Generating package index...")
    with chdir(output_directory):
        contents = subprocess.check_output(["dpkg-scanpackages", "--multiversion", "."]).decode('utf-8')
    with open(os.path.join(output_directory, "Packages"), 'w') as fh:
        fh.write(contents)
    # TODO: Create a gzip'd Packages file.


if __name__ == "__main__":
    main()
