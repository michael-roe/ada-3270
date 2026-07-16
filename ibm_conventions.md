
# User Interface Conventions

## Panels

Panels are divided into:

- Title Area
- Application Data Area
- Message Area
- Function Key Area

### Title Area

The title area identifies the program that generated the panel. It contains
one or two lines of text.

### Application Data Area

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
can be panned left and ">" if it can be panned right. There is a space
between "+" and "-". If the terminal's character set supports it, then
arrow symbols can be used in place of +, -, < and >.

In addition to the "More: " field, a dynamic area can optionally include
"Lines nnn to mmm of ppp" or "Page nnn of mmm". The page or line number
can optionally be an input field, to allow the user to jump to that page
or line.

### Message Area

An panel can optionally have a meesage area of one or two lines for messages
from the application to the user.

#### Command Area

The Application Data Area may contain a Command Area that allows the user
to enter a command. The Command Area consists of the label "Command ===>"
followed by a text input field.

### Function Key Area

The Function Key Area shows which actions have been assigned to function
keys, for example "PF1=Help".

Keys that have their function engraved on them, such as Enter, are not shown
in the Function Key Area. On an IBM PC keyboard, Page Up and Page Dowm are
engraved with their function, but as some mainframe keyboards do not have
these keys, equivalent function keys (e.g. PF7 and PF8) can be shown in
the Function Key Area.

The actions that can be assigned to function keys include:

*Help* switches to a panel of help information about the current panel.
The destination of Help can depend on the current position of the cursor,
so that, for example, it can provide information about the field pointed
to by the cursor.

*Exit* exits from the application.

*Cancel* exits from the current panel back to the previous panel.

*Left* pans the scrollable area to the left.

*Right* pans the scrollable area to the right.

*Prev* scrolls up the scrollable area.

*Next* scrolls down the scrollable area.

*Mark* and *Unmark* are used to select a portion of text. When Mark is
pressed for the first time, it sets the start of the selection. When it
is pressed for the second time, it sets the end of the selection. Unmark
returns to a state where no text is selected.

If the Application Data Area contains a Command Area, then *Retrieve*
will fill the command field with the last command that was used. If
Retrieve is pressed a second time, it will retrieve the second to last
command that was used, up to some maxmimum. It is recommened that applications
remember at least the last 10 commands.

*Set 1* and *Set 2* can be used when there aren't enough function keys.
Set 2 switches the function key assignments to a second set, and Set 1 switches
it back.

The assignment of actions to function keys is specific to the particular panel,
but the following conventions are usually followed:

- PF1 - Help
- PF3 - Exit
- PF7 - Prev
- PF8 - Next
- PF12 - Cancel

## Keys handled by the Terminal

*Tab* moves the cursor to the start of the next entry field, and *Backtab*
(or shift+ + Tab if there is no backtab key) moves the cursor to that start
of the previous field. Tab is handled by the terminal, not the host operating
system.

