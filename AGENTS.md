
# Unit Tests

To build unit tests:

``
source setup_aunit.sh
gnatmake test_runner
``

To run unit tests:

``
./test_runner
``

# Coding Style

Use the GNAT coding style. The style of Ada programs can be checked with:

``
gcc -gnatyg -c <name>.adb
``
