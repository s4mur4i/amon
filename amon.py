#!/usr/bin/env python
import os
import sys
import stat
from os import listdir
from os.path import isfile, join
import argparse
from subprocess import call
import time
import json

debug = False


def get_stacks(stacks_dir=None):
    stacks = []
    for f in listdir(stacks_dir):
        if isfile(join(stacks_dir, f)):
            stacks.append(f.split(".")[0])
    # add all stack option
    stacks.append("all")
    return stacks


def run_packer(stack=None, env_information=None):
    ret = call(["%s/packer" % (root_dir,), "build", "-var-file=%s" % (env_information,), "stacks/%s.json" % (stack,)])
    debug_msg("Ret is %s" % ret, )
    if ret != 0:
        raise Exception


def test_packer_is_executable(root_dir):
    for root, dirs, files in os.walk(root_dir):
        for filename in files:
            if filename.startswith("packer"):
                if is_exe(root_dir + "/" + filename):
                    debug_msg(message="File is executable: %s" % filename, )
                else:
                    debug_msg(message="File is not executable: %s" % filename, )
                    st = os.stat(root_dir + "/" + filename)
                    os.chmod(root_dir + "/" + filename, st.st_mode | stat.S_IEXEC | stat.S_IXOTH | stat.S_IXGRP)


def is_exe(fpath):
    return os.path.isfile(fpath) and os.access(fpath, os.X_OK)


def debug_msg(message):
    if debug:
        print message


def get_env(account, region, env_dir):
    ret = None
    if account is None or region is None:
        print "No account or region information given"
    for f in listdir(env_dir):
        if f == "%s_%s" % (account, region):
            ret = "%s/%s" % (env_dir, f)
    return ret


def ami_post_work(region, env_information, stack):
    debug_msg("Going to do post work on EC2 ami's %s" % (region,))
    hc.send_notification_to_devops(message="Running Tag cleanup", status="")
    with open(env_information) as env_file:
        env_info = json.load(env_file)
    from aws import aws
    aws = aws(region=region, access_key=env_info["access_key"], secret_key=env_info["secret_key"])
    aws.cleanup_stack_images(stack=stack)


if __name__ == '__main__':
    root_dir = os.path.dirname(os.path.realpath(sys.argv[0]))
    amon_lib_dir = "%s/lib" % (root_dir,)
    sys.path.append(amon_lib_dir)
    from Hipchat import hc

    amon_stacks_dir = "%s/stacks" % (root_dir,)
    stacks = get_stacks(stacks_dir=amon_stacks_dir)
    parser = argparse.ArgumentParser(description='packer tool for devops', usage='''packer.py [<args>]]''', prog="amon",
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('--stack', action='store', choices=stacks, default=None,
                        help="Stack to create, if all is given then all stack are going to be created")
    parser.add_argument('--debug', action='store_true', default=False, help="Should debug information be printed")
    parser.add_argument('--list', action='store_true', default=False, help="List available stacks")
    parser.add_argument('--account', action='store', default="dev", help="account to provision")
    parser.add_argument('--region', action='store', default="us-east-1", help="region to provision")
    args = parser.parse_args()
    debug = args.debug
    test_packer_is_executable(root_dir=root_dir)
    if args.list:
        for stack in stacks:
            print stack
        exit(23)
    if args.stack == "all":
        do_stack = stacks
    elif args.stack is not None:
        do_stack = [args.stack]
    else:
        print "No action requested."
        parser.print_help()
        exit(22)
    for st in do_stack:
        start = time.time()
        hc.send_notification_to_devops(
            message="Build has started for %s, in env %s, in region %s" % (st, args.account, args.region),
            status="start")
        try:
            amon_env_dir = "%s/envs" % (root_dir,)
            env_information = get_env(account=args.account, region=args.region, env_dir=amon_env_dir)
            run_packer(stack=st, env_information=env_information)
        except Exception:
            end = time.time()
            hc.send_notification_to_devops(message="Build has failed for %s, time: %s" % (st, end - start),
                                           status="error")
            exit(1)
        ami_post_work(region=args.region, env_information=env_information, stack=st)
        end = time.time()
        hc.send_notification_to_devops(message="Build has finished for %s, time: %s, env: %s, account: %s" % (
            st, end - start, args.account, args.region), status="finish")
