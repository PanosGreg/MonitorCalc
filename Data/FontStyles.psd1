
# Font style

# Note: only reason I have this file instead of using $PSStyle is for compatibility with PSv5

@{
    None         = "$([char]27)[0m"   # Reset format
    Normal       = ''                     
    Underline    = "$([char]27)[4m"   # Underline
    Italic       = "$([char]27)[3m"   # Italics
    NotUnderline = "$([char]27)[24m"  # No Underline
    NotItalic    = "$([char]27)[23m"  # No Italics
}