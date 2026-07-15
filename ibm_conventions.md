
# User Interface Conventions

## Panels

Panels are divided into:

- Title Area
- Application Data Area
- Message Area

### Title Area

The title area identifies the program that generated the panel. It contains
one or two lines of text.

### Application Data Area

#### Command Area

The Application Data Area may contain a Command Area that allows the user
to enter a command. The Command Area consists of the label "Command ===>"
followed by a text input field.

#### Dynamic Area

The Application Data Area can contain a Dynamic Area of scrollable text.
Dynamic Areas can support up/down scrolling and/or left/right panning.
Up/down scrolling can be used to display documents that are too long to
fit on a single screen, while left/right panning can be used for tables
that are too wide for the screen.

If there is a dynamic area, there should be a scroll area, above it and to
the right, that indicates in which directions the dynamic area can be
scolled or panned. The scroll area starts with "More: " and is followed
by "+" if it can be scrolled down, "-" if it can scrolled up, "<" if it
can be panned left and ">" if it can be panned right.

If the Application Data Area contains both a Command Area and a Scroll Area,
they can be on the same line, with the Command Area on the left and the Scroll
Area on the right.

### Message Area

An panel can optionally have a meesage area of one or two lines for messages
from the application to the user.

## Function Keys

The action performed by a function key is specific to the particular panel,
but the following conventions are usually followed:

- PF1 - Help
- PF3 - Exit
- PF7 - Prev
- PF8 - Next
