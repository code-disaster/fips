"""Raspberry Pi SDK support"""

import os

from mod import log, util
from mod.tools import git

#-------------------------------------------------------------------------------
def get_tools_url() :
    """returns the Raspberry Pi tools repository URL"""
    return 'https://github.com/raspberrypi/tools.git'

#-------------------------------------------------------------------------------
def get_firmware_url() :
    """returns the Raspberry Pi firmware repository URL"""
    return 'https://github.com/raspberrypi/firmware.git'

#-------------------------------------------------------------------------------
def get_sdk_dir(fips_dir) :
    """return the platform-specific SDK dir"""
    return util.get_workspace_dir(fips_dir) + '/fips-sdks/' + util.get_host_platform() + '/rpi'

#-------------------------------------------------------------------------------
def get_tools_dir(fips_dir) :
    """return the SDK tools path"""
    return get_sdk_dir(fips_dir) + '/tools'

#-------------------------------------------------------------------------------
def get_firmware_dir(fips_dir) :
    """return the SDK firmware path"""
    return get_sdk_dir(fips_dir) + '/firmware'

#-------------------------------------------------------------------------------
def ensure_sdk_dirs(fips_dir) :
    """make sure the sdk dir exists"""
    rpisdk_dir = get_sdk_dir(fips_dir)
    if not os.path.isdir(rpisdk_dir) :
        os.makedirs(rpisdk_dir)

#-------------------------------------------------------------------------------
def setup(fips_dir, proj_dir) :
    """main setup function"""
    log.colored(log.YELLOW, '=== setup Raspberry Pi SDK:')

    ensure_sdk_dirs(fips_dir)

    # clone SDK tools
    rpi_tools_dir = get_tools_dir(fips_dir)
    if not os.path.isdir(rpi_tools_dir) :
        git.clone(get_tools_url(), None, 'tools', get_sdk_dir(fips_dir))
    else :
        log.info("checking tools...")
        git.check_branch_out_of_sync(get_tools_dir(fips_dir), 'master')

    # clone SDK firmware
    rpi_firmware_dir = get_firmware_dir(fips_dir)
    if not os.path.isdir(rpi_firmware_dir) :
        git.clone(get_firmware_url(), None, 'firmware', get_sdk_dir(fips_dir))
    else :
        log.info("checking firmware...")
        git.check_branch_out_of_sync(get_firmware_dir(fips_dir), 'master')

    log.colored(log.GREEN, "done.")

#-------------------------------------------------------------------------------
def check_exists(fips_dir) :
    """check if rpi sdk is installed"""
    return os.path.isdir(get_sdk_dir(fips_dir))
