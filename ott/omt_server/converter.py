import os
import inspect
import shutil

import logging
log = logging.getLogger(__file__)

# some directory globals
this_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
styles_dir = os.path.join(this_dir, 'raw_styles')


def copy_style_dir(style_name='basic', to_dir='../../web/gl-styles'):
    """
    copy style dir to web gl-styles dir
    """
    log.info(":")
    frm = os.path.join(styles_dir, style_name)
    to = os.path.join(this_dir, to_dir, style_name)
    shutil.copytree(frm, to)
