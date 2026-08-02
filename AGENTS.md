
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

See style.md for a summary.

# Organization of Source Code

- Producer/Consumer
  - Buffer
  - Buffer_Queues
  - Byte_Queue_Interfaces
  - Byte_Text_IO
  - Byte_Vectors

- Character Set Conversion
  - Arrows
  - Block_Elements
  - Box_Drawing
  - Code_Page_310
  - Code_Page_500
  - Code_Page_870
  - Code_Pages
  - Emoji
  - Math_Operators

- TELNET
  - Telnet
  - Telnet.Environ
  - Telnet.Event_Handlers
  - Telnet.Negotiation
  - Telnet.Options
  - Telnet.Protocol
  - Telnet_Strings
  - Telnet.Terminal
  - Telnet.Workers
