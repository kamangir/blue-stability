from setuptools import setup

from blue_stability import NAME, VERSION

setup(
    name="blue-stability",
    author="arash@kamangir.net",
    version=VERSION,
    description="bash cli for stability.ai API's stable diffusion inference",
    packages=[NAME],
)
