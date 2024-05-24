from blue_stability import NAME, VERSION, DESCRIPTION, ICON
from blue_stability.logger import logger
from blueness.argparse.version import main

success, message = main(NAME, VERSION, DESCRIPTION, ICON)
if not success:
    logger.error(message)
