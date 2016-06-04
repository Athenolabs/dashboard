# -*- coding: utf-8 -*-
from setuptools import setup, find_packages
import os

version = '1.0.0'

setup(
    name='dashboard',
    version=version,
    description='Dashboard application for Frappe',
    author='Sanjay Kumar',
    author_email='sanjay.kumar001@gmail.com',
    packages=find_packages(),
    zip_safe=False,
    include_package_data=True,
    install_requires=("frappe",),
)
