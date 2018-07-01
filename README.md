GDScript performance tests
=============================

This project contains a bunch of tests to measure Godot and GDScript performance for multiple engine versions at once.

Test categories
------------------

There are two categories of tests:

- Micro benchmarks: these are run in batches and measure how fast GDScript performs specific operations. For example, how long it takes to assign a dictionary element.

- Scale benchmarks: these are run individually. They measure speed and memory for a given metric over time. For example, how many bunnies can Godot render before getting under 15 fps.


Running tests
---------------

All those tests can be run automatically by running the `run.py` script. This script contains some options at its top, which are described within the file.
The script will also run the tests for all Godot versions that you can provide. They are also listed in the script, but you may get them under a folder of yours before your start. You can also comment out versions you don't want to run.

Note that some tests may not be available for some Godot versions.


Displaying results
----------------------

Results can be shown by running the `viewer`. This is a Godot 3 application which will look into the results of previously-run tests and display a nice graph of the results over time.

Note that some results may not be viewable at the moment. Scale benchmarks need a visualizer.