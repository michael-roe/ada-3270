
# Unit Tests

To build unit tests:

```
source setup_aunit.sh
gnatmake test_runner
```

To run unit tests:

```
./test_runner
```

# Coding Style

Use the GNAT coding style. The style of Ada programs can be checked with:

```
gcc -gnatyg -c <name>.adb
```

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

- IBM 3270 Protocol
  - IBM_3270
  - IBM_3270_Orders
  - IBM_3270.Input_Stream
  - IBM_3270.Output_Stream

- IBM Common User Access
  - Checkbox_Views
  - Json_Views
  - Lines
  - Line_Vectors
  - Login_Views
  - Markable_Views
  - Menu_Views
  - Numbered_Menu_Views
  - Pageable_Views
  - Paged_Views
  - Panel_Elements
  - Text_Views
  - Views

# References

## TELNET

Postel, J., and J. Reynolds, "Telnet Protocol Specification",
RFC 854, USC Information Sciences Institute, May 1983.

Postel, J. and J. Reynolds, "Telnet Binary Transmission"
RFC 856, USC Information Sciences Institute, May 1983.

Postel, J. and J. Reynolds, "Telnet Suppress Go Ahead Option",
RFC 858, USC Information Sciences Institute, May 1983.

Postel, J., "Telnet End Of Record Option",
RFC 885, USC Information Sciences Institute, May 1983.

VanBokkelen, J., "Telnet Terminal-Type Option",
RFC 1091, FTP Software, Inc., February 1989.

Alexander, S., "Telnet Environment Option",
RFC 1572, Lachman Technology, Inc., January 1994.

Murphy, T., P. Rieth and J. Stevens, "5250 Telnet Enhancements",
RFC 2877, IBM Corporation, July 2000.
