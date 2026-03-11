?: make function! [
    {Displays information about functions, values, objects, and datatypes.}
    'word [any-type!]
]
??: make function! [
    "Prints a word and the value it refers to (molded)"
    'value [word! path!]
]
a-an: make function! [
    {Returns the appropriate variant of a or an (simple, vs 100% grammatically correct)}
    str [string!]
    /pre "Prepend to str"
    /local tmp
]
about: make function! [
    "Print Red version information"
    /debug {Print full Red and OS version information suitable for submitting issues}
    /cc "Also copy to clipboard"
    /local git plt txt
]
absolute: make action! [
    "Returns the non-negative value"
    value [number! money! char! pair! time! any-point!]
    return: [number! money! char! pair! time! any-point!]
]
acos: make function! [
    {Returns the trigonometric arccosine in radians in range [0,pi]}
    cosine [float!] "in range [-1,1]"
]
action?: make function! ["Returns true if the value is this type" value [any-type!]]
add: make action! [
    "Returns the sum of the two values"
    value1 [scalar! vector!] "The augend"
    value2 [scalar! vector!] "The addend"
    return: [scalar! vector!] "The sum"
]
alert: make function! [
    {Displays an alert message in a pop-up modal window}
    msg [string! block!] "Message to display"
]
all: make native! [
    {Evaluates and returns the last value if all are truthy; else NONE}
    conds [block!]
]
all-word?: make function! ["Returns true if the value is any type of all-word" value [any-type!]]
also: make function! [
    {Returns the first value, but also evaluates the second}
    value1 [any-type!]
    value2 [any-type!]
]
alter: make function! [
    {If a value is not found in a series, append it; otherwise, remove it. Returns true if added}
    series [series!]
    value
]
and~: make action! [
    "Returns the first value ANDed with the second"
    value1 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
    value2 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
    return: [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
]
any: make native! [
    {Evaluates and returns the first truthy value, if any; else NONE}
    conds [block!]
]
any-block?: make function! [{Returns true if the value is any type of any-block} value [any-type!]]
any-function?: make function! [{Returns true if the value is any type of any-function} value [any-type!]]
any-interesting?: make function! [{Returns true if the value is any type of any-function} value [any-type!]]
any-list?: make function! ["Returns true if the value is any type of any-list" value [any-type!]]
any-object?: make function! [{Returns true if the value is any type of any-object} value [any-type!]]
any-path?: make function! ["Returns true if the value is any type of any-path" value [any-type!]]
any-point?: make function! [{Returns true if the value is any type of any-point} value [any-type!]]
any-string?: make function! [{Returns true if the value is any type of any-string} value [any-type!]]
any-word?: make function! ["Returns true if the value is any type of any-word" value [any-type!]]
append: make action! [
    {Inserts value(s) at series tail; returns series head}
    series [series! bitset! port!]
    value [any-type!]
    /part "Limit the number of values inserted"
    length [number! series!]
    /only {Insert block types as single values (overrides /part)}
    /dup "Duplicate the inserted values"
    count [integer!]
    return: [series! port! bitset!]
]
apply: make native! [
    "Apply a function to a reduced block of arguments"
    func [word! path! any-function!] "Function to apply, with eventual refinements"
    args [block!] "Block of args, reduced first"
    /all {Provide every argument in the function spec, in order, tail-completed with false/none.}
    /safer {Forces single refinement arguments, skip them when inactive instead of evaluating}
]
arccosine: make native! [
    {Returns the trigonometric arccosine in degrees in range [0,180]}
    cosine [float! integer!] "in range [-1,1]"
    /radians "DEPRECATED: use `acos` native instead"
    return: [float!]
]
arcsine: make native! [
    {Returns the trigonometric arcsine in degrees in range [-90,90]}
    sine [float! integer!] "in range [-1,1]"
    /radians "DEPRECATED: use `asin` native instead"
    return: [float!]
]
arctangent: make native! [
    {Returns the trigonometric arctangent in degrees in range [-90,90]}
    tangent [float! integer!] "in range [-inf,+inf]"
    /radians "DEPRECATED: use `atan` native instead"
    return: [float!]
]
arctangent2: make native! [
    {Returns the smallest angle between the vectors (1,0) and (x,y) in degrees (-180,180]}
    y [float! integer!]
    x [float! integer!]
    /radians "DEPRECATED: use `atan2` native instead"
    return: [float!]
]
as: make native! [
    {Coerce a series into a compatible datatype without copying it}
    type [datatype! block! paren! any-path! any-string!] "The datatype or example value"
    spec [block! paren! any-path! any-string!] "The series to coerce"
]
as-color: make routine! [
    "Combine R, G and B values into a tuple"
    r [integer!]
    g [integer!]
    b [integer!]
]
as-ipv4: make routine! [
    "Combine a, b, c and d values into a tuple"
    a [integer!]
    b [integer!]
    c [integer!]
    d [integer!]
]
as-money: make native! [
    {Combine currency code and amount into a monetary value}
    currency [word!]
    amount [integer! float!]
    return: [money!]
]
as-pair: make native! [
    "Combine X and Y values into a pair"
    x [integer! float!]
    y [integer! float!]
]
as-point2D: make native! [
    "Combine X and Y values into a 2D point"
    x [integer! float!]
    y [integer! float!]
]
as-point3D: make native! [
    "Combine X, Y and Z values into a 3D point"
    x [integer! float!]
    y [integer! float!]
    z [integer! float!]
]
as-rgba: make routine! [
    {Combine R, G, B and A color components into a tuple}
    r [integer!]
    g [integer!]
    b [integer!]
    a [integer!]
]
asin: make function! [
    {Returns the trigonometric arcsine in radians in range [-pi/2,pi/2])}
    sine [float!] "in range [-1,1]"
]
ask: make function! [
    "Prompt the user for input"
    question [string!]
    /hide
    /history "specify the history block"
    blk [block!]
    return: [string!]
    /local t? line
]
at: make action! [
    "Returns a series at a given index"
    series [series! port!]
    index [integer! pair!]
    return: [series! port!]
]
atan: make function! [
    {Returns the trigonometric arctangent in radians in range [-pi/2,+pi/2]}
    tangent [float!] "in range [-inf,+inf]"
]
atan2: make function! [
    {Returns the smallest angle between the vectors (1,0) and (x,y) in range (-pi,pi]}
    y [float! integer!]
    x [float! integer!]
    return: [float!]
]
attempt: make function! [
    {Tries to evaluate a block and returns result or NONE on error}
    code [block!]
    /safer "Capture all possible errors and exceptions"
    /local all result
]
average: make function! [
    "Returns the average of all values in a block"
    block [block! vector! paren! hash!]
]
back: make action! [
    "Returns a series at the previous index"
    series [series! port!]
    return: [series! port!]
]
binary?: make function! ["Returns true if the value is this type" value [any-type!]]
bind: make native! [
    "Bind words to a context; returns rebound words"
    word [block! any-word!]
    context [any-word! any-object! function!]
    /copy "Deep copy blocks before binding"
    return: [block! any-word!]
]
bitset?: make function! ["Returns true if the value is this type" value [any-type!]]
block?: make function! ["Returns true if the value is this type" value [any-type!]]
body-of: make function! [{Returns the body of a value that supports reflection} value]
break: make native! [
    {Breaks out of a loop, while, until, repeat, foreach, etc}
    /return "Forces the loop function to return a value"
    value [any-type!]
]
browse: make native! [
    {Opens the URL in a web browser or the file in the associated application}
    url [url! file!]
]
call: make native! [
    "Executes a shell command to run another process"
    cmd [string! file!] "A shell command or an executable file"
    /wait "Runs command and waits for exit"
    /show {Force the display of system's shell window (Windows only)}
    /console {Runs command with I/O redirected to console (CLI console only at present)}
    /shell "Forces command to be run from shell"
    /input in [string! file! binary!] "Redirects in to stdin"
    /output out [string! file! binary!] "Redirects stdout to out"
    /error err [string! file! binary!] "Redirects stderr to err"
    return: [integer!] "0 if success, -1 if error, or a process ID"
]
caret-to-offset: make function! [
    {Given a text position, returns the corresponding coordinate relative to the top-left of the layout box}
    face [object!]
    pos [integer!]
    /lower "lower end offset of the caret"
    return: [point2D!]
    /local opt
]
case: make native! [
    {Evaluates the block following the first truthy condition}
    cases [block!] "Block of condition-block pairs"
    /all {Test all conditions, evaluating the block following each truthy condition}
]
catch: make native! [
    {Catches a throw from a block and returns its value}
    block [block!] "Block to evaluate"
    /name "Catches a named throw"
    word [word! block!] "One or more names"
]
cause-error: make function! [
    {Causes an immediate error throw, with the provided information}
    err-type [word!]
    err-id [word!]
    args [block! string!]
]
cd: make function! [
    "Changes the active directory path"
    :dir [file! word! path!] {New active directory of relative path to the new one}
]
center-face: make function! [
    "Center a face inside its parent"
    face [object!] "Face to center"
    /x "Center horizontally only"
    /y "Center vertically only"
    /with {Provide a reference face for centering instead of parent face}
    parent [object!] "Reference face"
    return: [object!] "Returns the centered face"
    /local pos
]
change: make action! [
    {Changes a value in a series and returns the series after the change}
    series [series! port!] "Series at point to change"
    value [any-type!] "The new value"
    /part {Limits the amount to change to a given length or position}
    range [number! series!]
    /only "Changes a series as a series."
    /dup "Duplicates the change a specified number of times"
    count [number!]
]
change-dir: make function! [
    "Changes the active directory path"
    dir [file! word! path!] {New active directory of relative path to the new one}
]
char?: make function! ["Returns true if the value is this type" value [any-type!]]
charset: make function! [
    "Shortcut for `make bitset!`"
    spec [block! integer! char! string! bitset! binary!]
]
checksum: make native! [
    "Computes a checksum, CRC, hash, or HMAC"
    data [binary! string! file!]
    method [word!] {MD5 SHA1 SHA256 SHA384 SHA512 CRC32 TCP ADLER32 hash}
    /with {Extra value for HMAC key or hash table size; not compatible with TCP/CRC32/ADLER32 methods}
    spec [any-string! binary! integer!] {String or binary for MD5/SHA* HMAC key, integer for hash table size}
    return: [integer! binary!]
]
class-of: make function! ["Returns the class ID of an object" value]
clean-path: make function! [
    [no-trace]
    {Cleans-up '.' and '..' in path; returns the cleaned path}
    file [file! url! string!]
    /only "Do not prepend current directory"
    /dir "Add a trailing / if missing"
    /local out cnt f not-file? prot
]
clear: make action! [
    {Removes series values from current index to tail; returns new tail}
    series [series! port! bitset! map! none!]
    return: [series! port! bitset! map! none!]
]
clear-reactions: make function! ["Removes all reactive relations"]
clock: make function! [
    {Display execution time of code, returning result of it's evaluation}
    code [block!]
    /times n [integer! float!]
    {Repeat N times (default: once); displayed time is per iteration}
    /local result
    text dt unit
]
close: make action! [
    "Closes a port"
    port [port!]
]
collect: make function! [
    {Collect in a new block all the values passed to KEEP function from the body block}
    body [block!] "Block to evaluate"
    /into {Insert into a buffer instead (returns position after insert)}
    collected [series!] "The buffer series (modified)"
    /local keep rule pos
]
collect-calls: make routine! [blk [block!]]
comment: make function! ["Consume but don't evaluate the next value" 'value]
complement: make action! [
    {Returns the opposite (complementing) value of the input value}
    value [logic! integer! tuple! bitset! typeset! binary!]
    return: [logic! integer! tuple! bitset! typeset! binary!]
]
complement?: make native! [
    "Returns TRUE if the bitset is complemented"
    bits [bitset!]
]
compose: make native! [
    "Returns a copy of a block, evaluating only parens"
    value [block!]
    /deep "Compose nested blocks"
    /only {Compose nested blocks as blocks containing their values}
    /into {Put results in out block, instead of creating a new block}
    out [any-block!] "Target block for results, when /into is used"
]
compress: make native! [
    "Compresses data"
    data [any-string! binary!]
    method [word!] "zlib deflate gzip"
    return: [binary!]
]
construct: make native! [
    {Makes a new object from an unevaluated spec; standard logic words are evaluated}
    block [block!]
    /with "Use a prototype object"
    object [object!] "Prototype object"
    /only "Don't evaluate standard logic words"
]
context: make function! [
    "Makes a new object from an evaluated spec"
    spec [block!]
]
context?: make native! [
    "Returns the context to which a word is bound"
    word [any-word!] "Word to check"
    return: [object! function! none!]
]
continue: make native! [
    "Throws control back to top of loop"
]
copy: make action! [
    "Returns a copy of a non-scalar value"
    value [series! any-object! bitset! map!]
    /part "Limit the length of the result"
    length [number! series! pair!]
    /deep "Copy nested values"
    /types "Copy only specific types of non-scalar values"
    kind [datatype!]
    return: [series! any-object! bitset! map!]
]
cos: make function! [
    "Returns the trigonometric cosine"
    angle [float!] "Angle in radians"
]
cosine: make native! [
    "Returns the trigonometric cosine"
    angle [float! integer!]
    /radians "DEPRECATED: use `cos` native instead"
    return: [float!]
]
count-chars: make routine! [
    {Count UTF-8 encoded characters between two positions in a binary series}
    start [binary!]
    pos [binary!]
    return: [integer!]
]
create: make action! [
    "Send port a create request"
    port [port! file! url! block!]
]
create-dir: make routine! ["Create the given directory" path [file!]]
datatype?: make function! ["Returns true if the value is this type" value [any-type!]]
date?: make function! ["Returns true if the value is this type" value [any-type!]]
debase: make native! [
    {Decodes binary-coded string (BASE-64 default) to binary value}
    value [string!] "The string to decode"
    /base "Binary base to use"
    base-value [integer!] "The base to convert from: 64, 58, 16, or 2"
]
debug: make function! [
    {Runs argument code through an interactive debugger}
    code [any-type!] "Code to debug"
    /later {Enters the interactive debugger later, on reading @stop value}
]
debug-info?: make function! ["Internal use only" face [object!] return: [logic!]]
decode-url: make function! [
    {Decode a URL into an object containing its constituent parts}
    url [url! string!]
]
decompress: make native! [
    "Decompresses data"
    data [binary!]
    method [word!] "zlib deflate gzip"
    /size {Specify an uncompressed data size (ignored for GZIP)}
    sz [integer!] "Uncompressed data size; must not be negative"
    return: [binary!]
]
deep-reactor: make function! [spec [block!]]

dehex: make native! [
    "Converts URL-style hex encoded (%xx) strings"
    value [any-string!]
    return: [string!] "Always return a string"
]
delete: make action! [
    "Deletes the specified file or empty folder"
    file [file! port!]
]
difference: make native! [
    "Returns the special difference of two data sets"
    set1 [block! hash! string! bitset! typeset! date!]
    set2 [block! hash! string! bitset! typeset! date!]
    /case "Use case-sensitive comparison"
    /skip "Treat the series as fixed size records"
    size [integer!]
    return: [block! hash! string! bitset! typeset! time!]
]
dir: make function! [{Display a directory listing, for the current dir if none is given} 'dir [any-type!]]
dir?: make function! [{Returns TRUE if the value looks like a directory spec} file [file! url!]]
dirize: make function! [
    {Returns a copy of the path turned into a directory}
    path [file! string! url!]
]
distance?: make function! [
    {Returns the distance between 2 points or face centers}
    A [object! planar!] "First face or point"
    B [object! planar!] "Second face or point"
    return: [float!] "Distance between them"
    /local d
]
divide: make action! [
    "Returns the quotient of two values"
    value1 [number! money! char! pair! tuple! vector! time! any-point!] "The dividend (numerator)"
    value2 [number! money! char! pair! tuple! vector! time! any-point!] "The divisor (denominator)"
    return: [number! money! char! pair! tuple! vector! time! any-point!] "The quotient"
]
do: make native! [
    {Evaluates a value, returning the last evaluation result}
    value [any-type!]
    /expand "Expand directives before evaluation"
    /args {If value is a script, this will set its system/script/args}
    arg "Args passed to a script (normally a string)"
    /next {Do next expression only, return it, update block word}
    position [word!] "Word updated with new block position"
    /trace
    callback [function! [
        event [word!]
        code [any-block! none!]
        offset [integer!]
        value [any-type!]
        ref [any-type!]
        frame [pair!]
    ]]
]
do-actor: make function! ["Internal Use Only" face [object!] event [event! none!] type [word!] /local result
act name]
do-events: make function! [
    {Launch the event loop, blocks until all windows are closed}
    /no-wait "Process an event in the queue and returns at once"
    return: [logic! word!] "Returned value from last event"
    /local result screen win
]
do-file: make function! ["Internal Use Only" file [file! url!] callback [function! none!]
/local ws saved src found? code header? header new-path list c done?]
do-no-sync: make function! [
    "Evaluate CODE with view/auto-sync?: off"
    code [block!]
    /local r e old
]
do-safe: make function! ["Internal Use Only" code [block!] /local result error]
do-thru: make function! [
    {Evaluates a remote Red script through local disk cache}
    url [url!] "Remote file address"
    /update "Force a cache update"
]
does: make native! [
    {Defines a function with no arguments or local variables}
    body [block!]
]
draw: make function! [
    "Draws scalable vector graphics to an image"
    image [image! pair!] "Image or size for an image"
    cmd [block!] "Draw commands"
    /transparent "Make a transparent image, if pair! spec is used"
    return: [image!]
]
dt: make function! [
    "Returns the time required to evaluate a block"
    body [block!]
    return: [time!]
    /local t0
]
dump-face: make function! [
    {Display debugging info about a face and its children}
    face [object!] "Face to analyze"
    /local depth f
]
dump-reactions: make function! [
    {Outputs all the current reactive relations for debugging purpose}
    /local limit count obj field reaction target list
]
either: make native! [
    {If conditional expression is truthy, evaluate the first branch; else evaluate the alternative}
    cond [any-type!]
    true-blk [block!]
    false-blk [block!]
]
ellipsize-at: make function! [
    {Truncate and add ellipsis if str is longer than len}
    str [string!] "(modified)"
    len [integer!] "Max length"
]
email?: make function! ["Returns true if the value is this type" value [any-type!]]
empty?: make function! [
    {Returns true if data is a series at its tail or an empty map}
    data [series! none! map!]
    return: [logic!]
]
enbase: make native! [
    {Encodes a string into a binary-coded string (BASE-64 default)}
    value [binary! string!] "If string, will be UTF8 encoded"
    /base "Binary base to use"
    base-value [integer!] "The base to convert from: 64, 58, 16, or 2"
]
encode-url: make function! [url-obj [object!] "What you'd get from decode-url"
/local result]
enhex: make native! [
    "Encode URL-style hex encoded (%xx) strings"
    value [any-string!]
    return: [string!] "Always return a string"
]
equal?: make native! [
    "Returns TRUE if two values are equal"
    value1 [any-type!]
    value2 [any-type!]
]
error?: make function! ["Returns true if the value is this type" value [any-type!]]
eval-set-path: make function! ["Internal Use Only" value1]
even?: make action! [
    {Returns true if the number is evenly divisible by 2}
    number [number! money! char! time!]
    return: [logic!]
]
event?: make routine! ["Returns true if the value is this type" value [any-type!] return: [logic!]]
exclude: make native! [
    {Returns the first data set less the second data set}
    set1 [block! hash! string! bitset! typeset!]
    set2 [block! hash! string! bitset! typeset!]
    /case "Use case-sensitive comparison"
    /skip "Treat the series as fixed size records"
    size [integer!]
    return: [block! hash! string! bitset! typeset!]
]
exists-thru?: make function! [
    {Returns true if the remote file is present in the local disk cache}
    url [url! file!] "Remote file address"
]
exists?: make routine! ["Returns TRUE if the file exists" path [file!] return: [logic!]]
exit: make native! [
    "Exits a function, returning no value"
]
exp: make native! [
    {Raises E (the base of natural logarithm) to the power specified}
    value [float! integer! percent!]
    return: [float!]
]
expand: make function! [
    {Preprocess the argument block and display the output (console only)}
    blk [block!] "Block to expand"
]
expand-directives: make function! [
    {Invokes the preprocessor on argument list, modifying and returning it}
    code [block! paren!] "List of Red values to preprocess"
    /clean "Clear all previously created macros and words"
    /local job saved
]
extend: make native! [
    {Extend an object or map value with list of key and value pairs}
    obj [object! map!]
    spec [block! hash! map!]
    /case "Use case-sensitive comparison"
]
extract: make function! [
    {Extracts a value from a series at regular intervals}
    series [series!]
    width [integer!] "Size of each entry (the skip)"
    /index "Extract from an offset position"
    pos [integer!] "The position"
    /into {Provide an output series instead of creating a new one}
    output [series!] "Output series"
]
extract-boot-args: make function! [
    {Process command-line arguments and store values in system/options (internal usage)}
    /local args at-arg2 ws split-mode arg-end s' e' arg2-update s e
]
face: make object! [
    type: 'window
    offset: (559.2, 339.2)
    size: 839x654
    text: "Red Console"
    image: none
    color: none
    menu: none
    data: none
    enabled?: true
    visible?: false
    selected: make object! [
        type: 'rich-text
        offset: (0, 0)
        size: 840x655
        text: none
        image: none
        color: 22.22.22
        menu: none
        data: none
        enabled?: true
        visible?: true
        selected: none
        flags: [scrollable all-over]
        options: [cursor: I-beam]
        parent: make object! [...]
        pane: none
        state: [handle! 0 none false]
        rate: 10
        edge: none
        para: none
        font: make object! [
            name: "Consolas"
            size: 11
            style: none
            angle: 0
            color: 222.222.222
            anti-alias?: false
            shadow: none
            state: [handle! none none]
            parent: []
        ]
        actors: make object! [
            on-time: func [face [object!] event [event!]][
                if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                terminal/on-time
                'done
            ]
            on-drawing: func [face [object!] event [event!]][
                terminal/paint
            ]
            on-scroll: func [face [object!] event [event!]][
                terminal/scroll event
            ]
            on-wheel: func [face [object!] event [event!]][
                either event/ctrl? [
                    terminal/zoom event
                ] [
                    terminal/scroll event
                ]
            ]
            on-key: func [face [object!] event [event!]][
                terminal/press-key event
            ]
            on-key-down: func [face [object!] event [event!]][
                if all [1 = length? event/flags find event/flags 'alt] [
                    switch event/key [
                        #"A" [terminal/select-all]
                        #"O" [show-cfg-dialog]
                    ]
                ]
            ]
            on-ime: func [face [object!] event [event!]][
                terminal/process-ime-input event
            ]
            on-down: func [face [object!] event [event!]][
                terminal/mouse-down event
            ]
            on-up: func [face [object!] event [event!]][
                terminal/mouse-up event
            ]
            on-alt-down: func [face [object!] event [event!]][
                if cfg/mouse-paste? = 'true [
                    either terminal/text-selected? [
                        terminal/copy-selection
                        clear terminal/selects
                        system/view/platform/redraw face
                    ] [
                        terminal/paste
                    ]
                ]
            ]
            on-over: func [face [object!] event [event!]][
                terminal/mouse-move to-pair event/offset
            ]
            on-menu: func [face [object!] event [event!]][
                switch event/picked [
                    copy [terminal/copy-selection]
                    paste [terminal/paste]
                    select-all [terminal/select-all]
                ]
                'done
            ]
        ]
        extra: none
        draw: none
        tabs: none
        line-spacing: 'default
        handles: none
        init: func [/local box][
            terminal/windows: get in get-current-screen 'pane
            box: terminal/box
            box/data: make block! 200
            scroller: get-scroller self 'horizontal
            scroller/visible?: no
            scroller: get-scroller self 'vertical
            scroller/position: 1
            scroller/max-size: 2
        ]
    ]
    flags: [resize]
    options: none
    parent: make object! [
        type: 'screen
        offset: 0x0
        size: 2048x1152
        text: none
        image: none
        color: none
        menu: none
        data: 1.25
        enabled?: true
        visible?: true
        selected: none
        flags: none
        options: none
        parent: none
        pane: []
        state: [handle! 0 none [1]]
        rate: none
        edge: none
        para: none
        font: none
        actors: none
        extra: none
        draw: none
    ]
    pane: [make object! [
        type: 'rich-text
        offset: (0, 0)
        size: 840x655
        text: none
        image: none
        color: 22.22.22
        menu: none
        data: none
        enabled?: true
        visible?: true
        selected: none
        flags: [scrollable all-over]
        options: [cursor: I-beam]
        parent: make object! [...]
        pane: none
        state: [handle! 0 none false]
        rate: 10
        edge: none
        para: none
        font: make object! [
            name: "Consolas"
            size: 11
            style: none
            angle: 0
            color: 222.222.222
            anti-alias?: false
            shadow: none
            state: [handle! none none]
            parent: []
        ]
        actors: make object! [
            on-time: func [face [object!] event [event!]][
                if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                terminal/on-time
                'done
            ]
            on-drawing: func [face [object!] event [event!]][
                terminal/paint
            ]
            on-scroll: func [face [object!] event [event!]][
                terminal/scroll event
            ]
            on-wheel: func [face [object!] event [event!]][
                either event/ctrl? [
                    terminal/zoom event
                ] [
                    terminal/scroll event
                ]
            ]
            on-key: func [face [object!] event [event!]][
                terminal/press-key event
            ]
            on-key-down: func [face [object!] event [event!]][
                if all [1 = length? event/flags find event/flags 'alt] [
                    switch event/key [
                        #"A" [terminal/select-all]
                        #"O" [show-cfg-dialog]
                    ]
                ]
            ]
            on-ime: func [face [object!] event [event!]][
                terminal/process-ime-input event
            ]
            on-down: func [face [object!] event [event!]][
                terminal/mouse-down event
            ]
            on-up: func [face [object!] event [event!]][
                terminal/mouse-up event
            ]
            on-alt-down: func [face [object!] event [event!]][
                if cfg/mouse-paste? = 'true [
                    either terminal/text-selected? [
                        terminal/copy-selection
                        clear terminal/selects
                        system/view/platform/redraw face
                    ] [
                        terminal/paste
                    ]
                ]
            ]
            on-over: func [face [object!] event [event!]][
                terminal/mouse-move to-pair event/offset
            ]
            on-menu: func [face [object!] event [event!]][
                switch event/picked [
                    copy [terminal/copy-selection]
                    paste [terminal/paste]
                    select-all [terminal/select-all]
                ]
                'done
            ]
        ]
        extra: none
        draw: none
        tabs: none
        line-spacing: 'default
        handles: none
        init: func [/local box][
            terminal/windows: get in get-current-screen 'pane
            box: terminal/box
            box/data: make block! 200
            scroller: get-scroller self 'horizontal
            scroller/visible?: no
            scroller: get-scroller self 'vertical
            scroller/position: 1
            scroller/max-size: 2
        ]
    ] make object! [
        type: 'base
        offset: (0, 0)
        size: 1x17
        text: none
        image: none
        color: 222.222.222.1
        menu: none
        data: none
        enabled?: false
        visible?: true
        selected: none
        flags: none
        options: [caret make object! [
            type: 'rich-text
            offset: (0, 0)
            size: 840x655
            text: none
            image: none
            color: 22.22.22
            menu: none
            data: none
            enabled?: true
            visible?: true
            selected: none
            flags: [scrollable all-over]
            options: [cursor: I-beam]
            parent: make object! [...]
            pane: none
            state: [handle! 0 none false]
            rate: 10
            edge: none
            para: none
            font: make object! [
                name: "Consolas"
                size: 11
                style: none
                angle: 0
                color: 222.222.222
                anti-alias?: false
                shadow: none
                state: [handle! none none]
                parent: []
            ]
            actors: make object! [
                on-time: func [face [object!] event [event!]][
                    if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                    terminal/on-time
                    'done
                ]
                on-drawing: func [face [object!] event [event!]][
                    terminal/paint
                ]
                on-scroll: func [face [object!] event [event!]][
                    terminal/scroll event
                ]
                on-wheel: func [face [object!] event [event!]][
                    either event/ctrl? [
                        terminal/zoom event
                    ] [
                        terminal/scroll event
                    ]
                ]
                on-key: func [face [object!] event [event!]][
                    terminal/press-key event
                ]
                on-key-down: func [face [object!] event [event!]][
                    if all [1 = length? event/flags find event/flags 'alt] [
                        switch event/key [
                            #"A" [terminal/select-all]
                            #"O" [show-cfg-dialog]
                        ]
                    ]
                ]
                on-ime: func [face [object!] event [event!]][
                    terminal/process-ime-input event
                ]
                on-down: func [face [object!] event [event!]][
                    terminal/mouse-down event
                ]
                on-up: func [face [object!] event [event!]][
                    terminal/mouse-up event
                ]
                on-alt-down: func [face [object!] event [event!]][
                    if cfg/mouse-paste? = 'true [
                        either terminal/text-selected? [
                            terminal/copy-selection
                            clear terminal/selects
                            system/view/platform/redraw face
                        ] [
                            terminal/paste
                        ]
                    ]
                ]
                on-over: func [face [object!] event [event!]][
                    terminal/mouse-move to-pair event/offset
                ]
                on-menu: func [face [object!] event [event!]][
                    switch event/picked [
                        copy [terminal/copy-selection]
                        paste [terminal/paste]
                        select-all [terminal/select-all]
                    ]
                    'done
                ]
            ]
            extra: none
            draw: none
            tabs: none
            line-spacing: 'default
            handles: none
            init: func [/local box][
                terminal/windows: get in get-current-screen 'pane
                box: terminal/box
                box/data: make block! 200
                scroller: get-scroller self 'horizontal
                scroller/visible?: no
                scroller: get-scroller self 'vertical
                scroller/position: 1
                scroller/max-size: 2
            ]
        ] cursor: I-beam accelerated: yes]
        parent: make object! [...]
        pane: none
        state: [handle! 0 none false]
        rate: 0:00:00.53
        edge: none
        para: none
        font: none
        actors: make object! [
            on-time: func [face [object!] event [event!]][
                face/color: either face/color = caret-clr [255.255.255.254] [caret-clr]
                'done
            ]
        ]
        extra: none
        draw: none
    ] make object! [
        type: 'panel
        offset: (0, 0)
        size: 150x200
        text: none
        image: none
        color: 0.0.128
        menu: none
        data: none
        enabled?: true
        visible?: false
        selected: none
        flags: none
        options: none
        parent: make object! [...]
        pane: none
        state: [handle! 0 none false]
        rate: none
        edge: none
        para: none
        font: make object! [
            name: "Consolas"
            size: 11
            style: none
            angle: 0
            color: 255.255.255
            anti-alias?: false
            shadow: none
            state: [handle! none none]
            parent: [make object! [
                type: 'rich-text
                offset: none
                size: 820x655
                text: "XXXXXXXXXX"
                image: none
                color: none
                menu: none
                data: []
                enabled?: true
                visible?: true
                selected: none
                flags: none
                options: none
                parent: none
                pane: none
                state: none
                rate: none
                edge: none
                para: none
                font: make object! [
                    name: "Consolas"
                    size: 11
                    style: none
                    angle: 0
                    color: 222.222.222
                    anti-alias?: false
                    shadow: none
                    state: [handle! none none]
                    parent: [...]
                ]
                actors: none
                extra: none
                draw: none
                tabs: 32.4
                line-spacing: 17
                handles: [handle! handle! "XXXXXXXXXX" true]
            ]]
        ]
        actors: make object! [
            on-key-down: func [face [object!] event [event!]][
                probe event/key
            ]
        ]
        extra: none
        draw: none
    ]]
    state: [handle! 0 none false]
    rate: none
    edge: none
    para: none
    font: none
    actors: make object! [
        on-menu: func [face [object!] event [event!] /local ft f][
            switch event/picked [
                about-msg [display-about]
                shortcuts [show-shortcuts]
                quit [self/on-close face event]
                run-file [if f: request-file [terminal/run-file f]]
                choose-font [
                    if ft: request-font/font/mono font [
                        font: ft
                        console/font: font
                        terminal/zoom font
                    ]
                ]
                settings [show-cfg-dialog]
            ]
        ]
        on-close: func [face [object!] event [event!]][
            system/view/platform/exit-event-loop
            foreach screen system/view/screens [clear head screen/pane]
            quit
        ]
        on-resizing: func [face [object!] event [event!]
        /local new-sz][
            new-sz: to-pair event/offset + 1x1
            console/size: new-sz
            terminal/resize new-sz
            terminal/adjust-console-size new-sz
            unless system/view/auto-sync? [show face]
        ]
        on-resize: func [face [object!] event [event!]
        /local new-sz][
            new-sz: to-pair event/offset + 1x1
            console/size: new-sz
            terminal/resize new-sz
            terminal/adjust-console-size new-sz
            unless system/view/auto-sync? [show face]
        ]
        on-focus: func [face [object!] event [event!]][
            focused?: yes
            caret/color: caret-clr
            unless caret/enabled? [caret/enabled?: yes]
            caret/rate: caret-rate
            terminal/refresh/force
        ]
        on-unfocus: func [face [object!] event [event!]][
            focused?: no
            if caret/enabled? [caret/enabled?: no]
            caret/rate: none
        ]
        on-key-down: func [face [object!] event [event!]][
            if event/key = 'F12 [
                cfg/menu-bar?: to-word none? face/menu
                toggle-menu-bar
            ]
        ]
    ]
    extra: none
    draw: none
]

face?: make function! [
    "Returns TRUE if the value is a face! object"
    value "Value to test"
    return: [logic!]
]
fetch-help: make function! [
    {Returns information about functions, values, objects, and datatypes.}
    'word [any-type!] "Omit the word arg for HELP usage."
    /local ref-given? value
]
fifth: make function! ["Returns the fifth value in a series" s [series! tuple! date!]]
file?: make function! ["Returns true if the value is this type" value [any-type!]]
find: make action! [
    {Returns the series where a value is found, or NONE}
    series [series! bitset! typeset! port! map! none!]
    value [any-type!] {Typesets and datatypes can be used to search by datatype}
    /part "Limit the length of the search"
    length [number! series!]
    /only {Treat series and typeset value arguments as single values}
    /case "Perform a case-sensitive search"
    /same {Use "same?" as comparator}
    /any "TBD: Use * and ? wildcards in string searches"
    /with "TBD: Use custom wildcards in place of * and ?"
    wild [string!]
    /skip "Treat the series as fixed size records"
    size [integer!]
    /last "Find the last occurrence of value, from the tail"
    /reverse {Find the last occurrence of value, from the current index}
    /tail {Return the tail of the match found, rather than the head}
    /match "Match at current index only"
]
find-flag?: make routine! [
    "Checks a flag in a face object"
    facet [any-type!]
    flag [word!]
]
first: make function! ["Returns the first value in a series" s [series! tuple! pair! any-point! date! time!]]
flip-exe-flag: make function! [
    {Flip the sub-system for the red.exe between console and GUI modes (Windows only)}
    path [file!] "Path to the red.exe"
    /local file buffer flag
]
float?: make function! ["Returns true if the value is this type" value [any-type!]]

forall: make native! [
    "Evaluates body for all values in a series"
    'word [word!] "Word referring to series to iterate over"
    body [block!]
]
foreach: make native! [
    "Evaluates body for each value in a series"
    'word [word! block!] "Word, or words, to set on each iteration"
    series [series! map!]
    body [block!]
]
foreach-face: make function! [
    {Evaluates body for each face in a face tree matching the condition}
    face [object!] "Root face of the face tree"
    body [block! function!] {Body block (`face` object) or function `func [face [object!]]`}
    /with "Filter faces according to a condition"
    spec [block! none!] "Condition applied to face object"
    /post {Evaluates body for current face after processing its children}
    /sub post? "Do not rebind body and spec, internal use only"
    /local exec
]
forever: make native! [
    "Evaluates body repeatedly forever"
    body [block!]
]
form: make action! [
    {Returns a user-friendly string representation of a value}
    value [any-type!]
    /part "Limit the length of the result"
    limit [integer!]
    return: [string!]
]
fourth: make function! ["Returns the fourth value in a series" s [series! tuple! date!]]
frame-index?: make routine! [return: [integer!]]
func: make native! [
    "Defines a function with a given spec and body"
    spec [block!]
    body [block!]
]
function: make native! [
    {Defines a function, making all set-words found in body, local}
    spec [block!]
    body [block!]
    /extern "Exclude words that follow this refinement"
]
function?: make function! ["Returns true if the value is this type" value [any-type!]]
get: make native! [
    "Returns the value a word refers to"
    word [any-word! any-path! object!]
    /any {If word has no value, return UNSET rather than causing an error}
    /case "Use case-sensitive comparison (path only)"
    return: [any-type!]
]
get-caret-blink-time: make routine! [
    return: [integer!]
]
get-current-dir: make routine! [{Returns the platform's current directory for the process}]
get-current-screen: make function! [
    {Returns the screen face of the Display where the mouse cursor is currently located}
    return: [object!] "Screen face"
    /local handle screen
]
get-env: make native! [
    {Returns the value of an OS environment variable (for current process)}
    var [any-string! any-word!] "Variable to get"
    return: [string! none!]
]
get-face-pane: make function! [
    "Returns the list of a container children or none"
    face [object!] "Face container"
    return: [block! none!]
]
get-focusable: make function! [
    "Returns the next focusable face from a face tree"
    faces [block!] "Position to start from in a face's pane"
    /back "Search backward"
    /local origin checks flags f pane p
]
get-path?: make function! ["Returns true if the value is this type" value [any-type!]]
get-scroller: make function! [
    "return a scroller object from a face"
    face [object!]
    orientation [word!]
    return: [object!]
]
get-sys-words: make function! [test [function!]]
get-word?: make function! ["Returns true if the value is this type" value [any-type!]]
greater-or-equal?: make native! [
    {Returns TRUE if the first value is greater than or equal to the second}
    value1 [any-type!]
    value2 [any-type!]
]
greater?: make native! [
    {Returns TRUE if the first value is greater than the second}
    value1 [any-type!]
    value2 [any-type!]
]

halt: make function! ["Stops evaluation and returns to the input prompt"]
handle?: make function! ["Returns true if the value is this type" value [any-type!]]
has: make native! [
    {Defines a function with local variables, but no arguments}
    vars [block!]
    body [block!]
]
hash?: make function! ["Returns true if the value is this type" value [any-type!]]
head: make action! [
    "Returns a series at its first index"
    series [series! port!]
    return: [series! port!]
]
head?: make action! [
    "Returns true if a series is at its first index"
    series [series! port!]
    return: [logic!]
]
help: make function! [
    {Displays information about functions, values, objects, and datatypes.}
    'word [any-type!]
]

help-string: make function! [
    {Returns information about functions, values, objects, and datatypes.}
    'word [any-type!] "Omit the word arg for HELP usage."
    /local ref-given? value
]
hex-to-rgb: make function! [
    {Converts a color in hex format to a tuple value; returns NONE if it fails}
    hex [issue!] "Accepts #rgb, #rrggbb, #rrggbbaa"
    return: [tuple! none!]
    /local str bin
]

if: make native! [
    {If conditional expression is truthy, evaluate block; else return NONE}
    cond [any-type!]
    then-blk [block!]
]
image?: make function! ["Returns true if the value is this type" value [any-type!]]
immediate?: make function! [{Returns true if the value is any type of immediate} value [any-type!]]
in: make native! [
    {Returns the given word bound to the object's context}
    object [any-object! any-function!]
    word [any-word! refinement!]
]
index?: make action! [
    {Returns the current index of series relative to the head, or of word in a context}
    series [series! port! any-word!]
    return: [integer!]
]
input: make function! ["Wait for console user input" return: [string!]]
insert: make action! [
    {Inserts value(s) at series index; returns series past the insertion}
    series [series! port! bitset!]
    value [any-type!]
    /part "Limit the number of values inserted"
    length [number! series!]
    /only {Insert block types as single values (overrides /part)}
    /dup "Duplicate the inserted values"
    count [integer!]
    return: [series! port! bitset!]
]
insert-event-func: make function! [
    {Adds a function to monitor global events. Returns the function}
    name [word!]
    fun [block! function!] "A function or a function body block"
    /local svh
]
integer?: make function! ["Returns true if the value is this type" value [any-type!]]
intersect: make native! [
    "Returns the intersection of two data sets"
    set1 [block! hash! string! bitset! typeset!]
    set2 [block! hash! string! bitset! typeset!]
    /case "Use case-sensitive comparison"
    /skip "Treat the series as fixed size records"
    size [integer!]
    return: [block! hash! string! bitset! typeset!]
]
is: make function! []
issue?: make function! ["Returns true if the value is this type" value [any-type!]]
keys-of: make function! [{Returns the list of words of a value that supports reflection} value]
last: make function! ["Returns the last value in a series" s [series! tuple!]]
last-lf?: make routine! ["Internal Use Only"]
last?: make function! [
    "Returns TRUE if the series length is 1"
    series [series!]
]
layout: make function! [
    [no-trace]
    {Return a face with a pane built from a VID description}
    spec [block!] "Dialect block of styles, attributes, and layouts"
    /tight "Zero offset and origin"
    /options
    user-opts [block!] "Optional features in [name: value] format"
    /flags
    flgs [block! word!] "One or more window flags"
    /only "Returns only the pane block"
    /parent
    panel [object!]
    divides [integer! none!]
    /styles "Use an existing styles list"
    css [block!] "Styles list"
    /local axis anti
    background! list reactors local-styles pane-size direction align begin size max-sz current global? below? origin spacing top-left bound cursor opts opt-words re-align sz words reset focal-face svmp pad value anti2 at-offset later? name styling? style styled? st actors face h pos styled w blk vid-align prev mar divide? index dir pad2 image
]
length?: make action! [
    {Returns the number of values in the series, from the current index to the tail}
    series [series! port! bitset! map! tuple! none!]
    return: [integer! none!]
]
lesser-or-equal?: make native! [
    {Returns TRUE if the first value is less than or equal to the second}
    value1 [any-type!]
    value2 [any-type!]
]
lesser?: make native! [
    {Returns TRUE if the first value is less than the second}
    value1 [any-type!]
    value2 [any-type!]
]
link-sub-to-parent: make function! ["Internal Use Only" face [object!] type [word!] old new
/local parent]
link-tabs-to-parent: make function! [
    "Internal Use Only"
    face [object!]
    /init "Force /show of first tab"
    /local faces visible?
]
list-dir: make function! [
    {Displays a list of files and directories from given folder or current one}
    dir [any-type!] "Folder to list"
    /col "Forces the display in a given number of columns"
    n [integer!] "Number of columns"
    /local list limit max-sz name
]
list-env: make native! [
    {Returns a map of OS environment variables (for current process)}
    return: [map!]
]
lit-path?: make function! ["Returns true if the value is this type" value [any-type!]]
lit-word?: make function! ["Returns true if the value is this type" value [any-type!]]
ll: make function! [{Display a single column directory listing, for the current dir if none is given} 'dir [any-type!]]
load: make function! [
    {Returns a value or block of values by reading and evaluating a source}
    source [file! url! string! binary!]
    /header "TBD"
    /all {Load all values, returns a block. TBD: Don't evaluate Red header}
    /trap {Load all values, returns [[values] position error]}
    /next {Load the next value only, updates source series word}
    position [word!] "Word updated with new series position"
    /part "Limit to a length or position"
    length [integer! string!]
    /into {Put results in out block, instead of creating a new block}
    out [block!] "Target block for results"
    /as {Specify the type of data; use NONE to load as code}
    type [word! none!] "E.g. bmp, gif, jpeg, png, redbin, json, csv"
    /local codec suffix name mime pre-load
]
load-csv: make function! [
    {Converts CSV text to a block of rows, where each row is a block of fields.}
    data [string!] "Text CSV data to load"
    /with
    delimiter [char! string!] "Delimiter to use (default is comma)"
    /header {Treat first line as header; implies /as-columns if /as-records is not used}
    /as-columns {Returns named columns; default names if /header is not used}
    /as-records {Returns records instead of rows; default names if /header is not used}
    /flat {Returns a flat block; you need to know the number of fields}
    /trim "Ignore spaces between quotes and delimiter"
    /quote
    qt-char [char!] {Use different character for quotes than double quote (")}
    /local disallowed refs output out-map longest line value record newline quotchars valchars quoted-value char normal-value s e single-value values add-value add-line length index line-rule init parsed? mark key-index key
]
load-json: make function! [
    "Convert a JSON string to Red data"
    input [string!] "The JSON string"
]
load-thru: make function! [
    "Loads a remote file through local disk cache"
    url [url!] "Remote file address"
    /update "Force a cache update"
    /as {Specify the type of data; use NONE to load as code}
    type [word! none!] "E.g. bmp, gif, jpeg, png"
    /local path file
]
log-10: make native! [
    "Returns the base-10 logarithm"
    value [float! integer! percent!]
    return: [float!]
]
log-2: make native! [
    "Return the base-2 logarithm"
    value [float! integer! percent!]
    return: [float!]
]
log-e: make native! [
    {Returns the natural (base-E) logarithm of the given value}
    value [float! integer! percent!]
    return: [float!]
]
logic?: make function! ["Returns true if the value is this type" value [any-type!]]
loop: make native! [
    "Evaluates body a number of times"
    count [integer! float!]
    body [block!]
]
lowercase: make native! [
    "Converts string of characters to lowercase"
    string [any-string! char!] "Value to convert (modified when series)"
    /part "Limits to a given length or position"
    limit [number! any-string!]
    return: [any-string! char!]
]
ls: make function! [{Display a directory listing, for the current dir if none is given} 'dir [any-type!]]
make: make action! [
    {Returns a new value made from a spec for that value's type}
    type [any-type!] "The datatype, an example or prototype value"
    spec [any-type!] "The specification of the new value"
    return: [any-type!] "Returns the specified datatype"
]
make-dir: make function! [
    {Creates the specified directory. No error if already exists}
    path [file!]
    /deep "Create subdirectories too"
    /local dirs end created dir
]
make-face: make function! [
    {Make a face from a given style name or example face}
    style [word!] "A face type"
    /spec
    blk [block!] "Spec block of face options expressed in VID"
    /offset
    xy [pair!] "Offset of the face"
    /size
    wh [pair!] "Size of the face"
    /local
    svv face styles model opts css
]
map?: make function! ["Returns true if the value is this type" value [any-type!]]
math: make function! [
    "Evaluates expression using math precedence rules"
    datum [block! paren!] "Expression to evaluate"
    /safe "Returns NONE on error"
    /local match
    order infix tally enter recur count operator
]
max: make native! [
    "Returns the greater of the two values"
    value1 [scalar! series!]
    value2 [scalar! series!]
]
metrics?: make function! [
    {Returns a pair! value in the type metrics for the argument face}
    face [object!] "Face object to query"
    type [word!] "Metrics type: 'paddings or 'margins"
    /total "Return the addition of metrics along an axis"
    axis [word!] "Axis to use for addition: 'x or 'y"
    /local res
]
min: make native! [
    "Returns the lesser of the two values"
    value1 [scalar! series!]
    value2 [scalar! series!]
]
mod: make function! [
    "Compute a nonnegative remainder of A divided by B"
    a [number! money! char! pair! tuple! vector! time!]
    b [number! money! char! pair! tuple! vector! time!] "Must be nonzero"
    return: [number! money! char! pair! tuple! vector! time!]
    /local r
]
modify: make action! [
    "Change mode for target aggregate value"
    target [object! series! bitset!]
    field [word!]
    value [any-type!]
    /case "Perform a case-sensitive lookup"
]
modulo: make function! [
    {Wrapper for MOD that handles errors like REMAINDER. Negligible values (compared to A and B) are rounded to zero}
    a [number! money! char! pair! tuple! vector! time!]
    b [number! money! char! pair! tuple! vector! time!]
    return: [number! money! char! pair! tuple! vector! time!]
    /local r
]
mold: make action! [
    {Returns a source format string representation of a value}
    value [any-type!]
    /only "Exclude outer brackets if value is a block"
    /all "TBD: Return value in loadable format"
    /flat "Exclude all indentation"
    /part "Limit the length of the result"
    limit [integer!]
    return: [string!]
]
money?: make function! ["Returns true if the value is this type" value [any-type!]]
move: make action! [
    {Moves one or more elements from one series to another position or series}
    origin [series! port!]
    target [series! port!]
    /part "Limit the number of values inserted"
    length [integer!]
    return: [series! port!]
]
multiply: make action! [
    "Returns the product of two values"
    value1 [number! money! char! pair! tuple! vector! time! any-point!] "The multiplicand"
    value2 [number! money! char! pair! tuple! vector! time! any-point!] "The multiplier"
    return: [number! money! char! pair! tuple! vector! time! any-point!] "The product"
]
NaN?: make native! [
    "Returns TRUE if the number is Not-a-Number"
    value [number!]
    return: [logic!]
]
native?: make function! ["Returns true if the value is this type" value [any-type!]]
negate: make action! [
    "Returns the opposite (additive inverse) value"
    number [number! money! bitset! pair! time! any-point!]
    return: [number! money! bitset! pair! time! any-point!]
]
negative?: make native! [
    "Returns TRUE if the number is negative"
    number [number! money! time!]
    return: [logic!]
]
new-line: make native! [
    {Sets or clears the new-line marker within a list series}
    position [any-list!] "Position to change marker (modified)"
    value [logic!] "Set TRUE for newline"
    /all "Set/clear marker to end of series"
    /skip {Set/clear marker periodically to the end of the series}
    size [integer!]
    return: [any-list!]
]
new-line?: make native! [
    {Returns the state of the new-line marker within a list series}
    position [any-list!] "Position to check marker"
    return: [logic!]
]
next: make action! [
    "Returns a series at the next index"
    series [series! port!]
    return: [series! port!]
]
no-react: make function! [
    {Evaluates a block with all previously defined reactions disabled}
    body [block!] "Code block to evaluate"
    /local result
]
none?: make function! ["Returns true if the value is this type" value [any-type!]]
normalize-dir: make function! [
    "Returns an absolute directory spec"
    dir [file! word! path!]
]
not: make native! [
    {Returns the logical complement of a value (truthy or falsy)}
    value [any-type!]
]
not-equal?: make native! [
    "Returns TRUE if two values are not equal"
    value1 [any-type!]
    value2 [any-type!]
]
now: make native! [
    "Returns date and time"
    /year "Returns year only"
    /month "Returns month only"
    /day "Returns day of the month only"
    /time "Returns time only"
    /zone "Returns time zone offset from UTC (GMT) only"
    /date "Returns date only"
    /weekday {Returns day of the week as integer (Monday is day 1)}
    /yearday "Returns day of the year (Julian)"
    /precise "High precision time"
    /utc "Universal time (no zone)"
    return: [date! time! integer!]
]
number?: make function! ["Returns true if the value is any type of number" value [any-type!]]
object: make function! [
    "Makes a new object from an evaluated spec"
    spec [block!]
]
object?: make function! ["Returns true if the value is this type" value [any-type!]]
odd?: make action! [
    {Returns true if the number has a remainder of 1 when divided by 2}
    number [number! money! char! time!]
    return: [logic!]
]
offset-to-caret: make function! [
    {Given a coordinate, returns the corresponding caret position}
    face [object!]
    pt [planar!]
    return: [integer!]
]
offset-to-char: make function! [
    {Given a coordinate, returns the corresponding character position}
    face [object!]
    pt [planar!]
    return: [integer!]
]
offset?: make function! [
    "Returns the offset between two series positions"
    series1 [series!]
    series2 [series!]
]
on-face-deep-change*: make function! ["Internal use only" owner word target action new index part state forced?
/local w diff? faces face modal? screen pane]
op?: make function! ["Returns true if the value is this type" value [any-type!]]
open: make action! [
    {Opens a port; makes a new port from a specification if necessary}
    port [port! file! url! block!]
    /new "Create new file - if it exists, deletes it"
    /read "Open for read access"
    /write "Open for write access"
    /seek "Optimize for random access"
    /allow "Specificies right access attributes"
    access [block!]
]
open?: make action! [
    "Returns TRUE if port is open"
    port [port!]
]
or~: make action! [
    "Returns the first value ORed with the second"
    value1 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
    value2 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
    return: [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
]
os-info: make routine! [{Returns detailed operating system version information}]
overlap?: make function! [
    {Return TRUE if the two faces bounding boxes are overlapping}
    A [object!] "First face"
    B [object!] "Second face"
    return: [logic!] "TRUE if overlapping"
    /local A1 B1 A2 B2
]
pad: make function! [
    "Pad a FORMed value on right side with spaces"
    str "Value to pad, FORM it if not a string"
    n [integer!] "Total size (in characters) of the new string"
    /left "Pad the string on left side"
    /with "Pad with char"
    c [char!]
    return: [string!] "Modified input string at head"
]
pair?: make function! ["Returns true if the value is this type" value [any-type!]]

paren?: make function! ["Returns true if the value is this type" value [any-type!]]
parse: make native! [
    "Process a series using dialected grammar rules"
    input [binary! any-block! any-string!]
    rules [block!]
    /case "Uses case-sensitive comparison"
    /part "Limit to a length or position"
    length [number! series!]
    /trace
    callback [function! [
        event [word!]
        match? [logic!]
        rule [block!]
        input [series!]
        stack [block!]
        return: [logic!]
    ]]
    return: [logic! block!]
]
parse-trace: make function! [
    {Wrapper for parse/trace using the default event processor}
    input [series!]
    rules [block!]
    /case "Uses case-sensitive comparison"
    /part "Limit to a length or position"
    limit [integer!]
    return: [logic! block!]
]
path-thru: make function! [
    {Returns the local disk cache path of a remote file}
    url [url!] "Remote file address"
    return: [file!]
    /local so hash file path
]
path?: make function! ["Returns true if the value is this type" value [any-type!]]
percent?: make function! ["Returns true if the value is this type" value [any-type!]]
pick: make action! [
    "Returns the series value at a given index"
    series [series! port! bitset! pair! any-point! tuple! money! date! time! event!]
    index [scalar! any-string! any-word! block! logic! time!]
    return: [any-type!]
]
pick-stack: make routine! [
    idx [integer!]
]
planar?: make function! ["Returns true if the value is any type of planar" value [any-type!]]
point2D?: make function! ["Returns true if the value is this type" value [any-type!]]
point3D?: make function! ["Returns true if the value is this type" value [any-type!]]
poke: make action! [
    {Replaces the series value at a given index, and returns the new value}
    series [series! port! bitset!]
    index [scalar! any-string! any-word! block! logic!]
    value [any-type!]
    return: [series! port! bitset!]
]
positive?: make native! [
    "Returns TRUE if the number is positive"
    number [number! money! time!]
    return: [logic!]
]
power: make action! [
    {Returns a number raised to a given power (exponent)}
    number [number!] "Base value"
    exponent [integer! float!] "The power (index) to raise the base value by"
    return: [number!]
]
preprocessor: make object! [
    exec: make object! [
        config: make object! [
            config-name: 'Windows
            OS: 'Windows
            OS-version: 0
            ABI: none
            link?: true
            debug?: false
            encap?: false
            build-prefix: %""
            build-basename: %/home/dk/static.red-lang.org/dl/auto/win/red-view-06mar26-698eac0d8.exe
            build-suffix: none
            format: 'PE
            type: 'exe
            target: 'IA-32
            cpu-version: 6.0
            verbosity: 0
            sub-system: 'GUI
            runtime?: true
            use-natives?: false
            debug-safe?: true
            dev-mode?: false
            need-main?: false
            PIC?: false
            base-address: none
            dynamic-linker: none
            syscall: 'Linux
            export-ABI: none
            stack-align-16?: false
            literal-pool?: false
            unicode?: false
            red-pass?: true
            red-only?: false
            red-store-bodies?: true
            red-strict-check?: true
            red-tracing?: true
            red-help?: true
            redbin-compress?: false
            legacy: none
            gui-console?: true
            libRed?: false
            libRedRT?: false
            libRedRT-update?: false
            GUI-engine: 'native
            draw-engine: none
            modules: [View JSON CSV]
            show: none
            command-line: none
            show-func-map?: false
        ]
    ]
    protos: []
    macros: [<none>]
    stack: []
    syms: []
    depth: 0
    active?: true
    trace?: false
    s: none
    do-quit: func [][
        case [
            all [rebol system/options/args] [quit/return 1]
            all [not rebol system/console] [throw/name 'halt-request 'console]
            'else [halt]
        ]
    ]
    throw-error: func [error [error!] cmd [issue!] code [block!] /local w][
        prin ["*** Preprocessor Error in" mold cmd lf]
        error/where: new-line/all reduce [cmd] no
        print form :error
        either system/console [throw/name 'halt-request 'console] [halt]
    ]
    syntax-error: func [s [block! paren!] e [block! paren!]][
        print [
            "*** Preprocessor Error: Syntax error^/"
            "*** Where:" trim/head mold/only copy/part s next e
        ]
        do-quit
    ]
    do-safe: func [code [block! paren!] /manual /with cmd [issue!] /local res t? src][
        if t?: all [trace? not with] [
            print [
                "preproc: matched" mold/flat copy/part get code/2 get code/3 lf
                "preproc: eval macro" copy/part mold/flat body-of first code 80
            ]
        ]
        if error? set/any 'res try code [throw-error :res any [cmd #macro] code]
        if all [
            manual
            any [
                (type? src: get code/2) <> type? get/any 'res
                not same? head src head get/any 'res
            ]
        ] [
            print [
                {*** Macro Error: [manual] macro not returning a position^/}
                "*** Where:" mold code
            ]
            do-quit
        ]
        if t? [print ["preproc: ==" mold get/any 'res]]
        either unset? get/any 'res [[]] [:res]
    ]
    do-code: func [code [block! paren!] cmd [issue!] /local p][
        clear syms
        parse code [any [
            p: set-word! (unless in exec p/1 [append syms p/1])
            | skip
        ]]
        unless empty? syms [
            exec: make exec append syms none
            rebind-all
        ]
        do-safe/with bind to block! code exec cmd
    ]
    rebind-all: func [/local rule p][
        protos: bind protos exec
        parse macros rule: [
            any [p: function! (bind body-of first p exec) | p: [block! | paren!] :p into rule | skip]
        ]
    ]
    count-args: func [spec [block!] /block /local total pos][
        total: either block [copy []] [0]
        parse spec [
            any [
                pos: [word! | lit-word! | get-word!] (
                    either block [append total type? pos/1] [total: total + 1]
                )
                | refinement! (return total)
                | skip
            ]
        ]
        total
    ]
    arg-mode?: func [spec [block!] idx [integer!]][
        pick count-args/block spec idx
    ]
    func-arity?: func [spec [block!] /with path [path!] /block /local arity pos][
        arity: either block [count-args/block spec] [count-args spec]
        if path [
            foreach word next path [
                unless pos: find/tail spec to refinement! word [
                    print [
                        "*** Macro Error: unknown refinement^/"
                        "*** Where:" mold path
                    ]
                    do-quit
                ]
                either block
                [append arity count-args/block pos]
                [arity: arity + count-args pos]
            ]
        ]
        arity
    ]
    value-path?: func [path [path!] /local value i item selectable][
        selectable: make typeset! [
            block! paren! path! lit-path! set-path! get-path!
            object! port! error! map!
        ]
        repeat i length? path [
            set/any 'value either i = 1 [get/any first path] [
                set/any 'item pick path i
                case [
                    get-word? :item [set/any 'item get/any to word! item]
                    paren? :item [set/any 'item do item]
                ]
                either integer? :item [pick value item] [select value :item]
            ]
            unless find selectable type? get/any 'value [
                path: copy/part path i
                break
            ]
        ]
        reduce [path get/any 'value]
    ]
    fetch-next: func [code [block! paren!] /local i left item item2 value fn-spec path f-arity at-op? op-mode][
        left: reduce [yes]
        while [all [not tail? left not tail? code]] [
            either not left/1 [
                remove left
            ] [
                item: first code
                f-arity: any [
                    all [
                        word? :item
                        any-function? set/any 'value get/any :item
                        func-arity?/block fn-spec: spec-of get/any :item
                    ]
                    all [
                        path? :item
                        set/any [path value] value-path? :item
                        any-function? get/any 'value
                        func-arity?/block/with
                        fn-spec: spec-of :value
                        at :item length? :path
                    ]
                ]
                if at-op?: all [
                    1 < length? code
                    word? item2: second code
                    op? get/any :item2
                ] [
                    if all [f-arity 1 < length? f-arity] [
                        at-op?: word! = arg-mode? fn-spec 1
                    ]
                ]
                case [
                    at-op? [
                        code: next code
                        left/1: word! = arg-mode? spec-of get/any :item2 2
                    ]
                    f-arity [
                        if op? get/any 'value [return skip code 2]
                        remove left
                        repeat i length? f-arity [insert at left i word! = f-arity/:i]
                    ]
                    not find [set-word! set-path!] type?/word item [
                        remove left
                    ]
                ]
            ]
            code: next code
        ]
        code
    ]
    eval: func [code [block! paren!] cmd [issue!] /local after expr][
        after: fetch-next code
        expr: copy/part code after
        if trace? [print ["preproc:" mold cmd mold expr]]
        expr: do-code expr cmd
        if trace? [print ["preproc: ==" mold expr]]
        reduce [expr after]
    ]
    do-macro: func [name pos [block! paren!] arity [integer!] /local cmd saved p v res][
        depth: depth + 1
        saved: s
        parse next pos [arity [s: macros | skip]]
        cmd: make block! 1
        append cmd name
        insert/part tail cmd next pos arity
        if trace? [print ["preproc: eval macro" mold cmd]]
        p: next cmd
        forall p [
            switch type?/word v: p/1 [
                word! [change p to lit-word! v]
                path! [change/only p to lit-path! v]
            ]
        ]
        if unset? set/any 'res do bind cmd exec [
            print ["*** Macro Error: no value returned by" name "macro^/"]
            do-quit
        ]
        if trace? [print ["preproc: ==" mold :res]]
        s: saved
        s/1: :res
        if positive? depth: depth - 1 [
            saved: s
            parse s [s: macros]
            s: saved
        ]
        s/1
    ]
    register-macro: func [spec [block!] /local cnt rule p name macro pos valid? named?][
        named?: set-word? spec/1
        cnt: 0
        rule: make block! 10
        valid?: parse spec/3 [
            any [
                opt string!
                opt block!
                [word! (cnt: cnt + 1) | /local any word!]
                opt [
                    p: block! :p into [some word!]
                ]
            ]
        ]
        if any [
            not valid?
            all [
                not named?
                any [cnt <> 2 all [block? spec/1 empty? spec/1]]
            ]
        ] [
            print [
                "*** Macro Error: invalid specification^/"
                "*** Where:" mold copy/part spec 3
            ]
            do-quit
        ]
        either named? [
            repend rule [
                name: to lit-word! spec/1
                to-paren compose [change/part s do-macro (:name) s (cnt) (cnt + 1)]
                to get-word! 's
            ]
            append protos copy/part spec 4
        ] [
            macro: do bind copy/part next spec 3 exec
            repend rule [
                to set-word! 's
                spec/1
                to set-word! 'e
                to-paren compose/deep either all [
                    block? spec/3/1 find spec/3/1 'manual
                ] [
                    [s: do-safe/manual [(:macro) s e]]
                ] [
                    [s: change/part s do-safe [(:macro) s e] e]
                ]
                to get-word! 's
            ]
        ]
        pos: tail macros
        either tag? macros/1 [remove macros] [insert macros '|]
        insert macros rule
        new-line pos yes
        exec: make exec protos
        rebind-all
    ]
    reset: func [job [object! none!]][
        exec: do [context [config: job]]
        clear protos
        insert clear macros <none>
    ]
    expand: func [
        code [block! paren!] job [object! none!]
        /clean
        /local rule e pos cond value then else cases body keep? expr src saved file new
    ][
        either clean [reset job] [exec/config: job]
        rule: [
            any [
                s: macros
                | 'routine 2 skip
                | #system skip
                | #system-global skip
                | s: #include (
                    if active? [
                        either all [not Rebol system/state/interpreted?] [
                            saved: s
                            attempt [expand load s/2 job]
                            s: saved
                            s/1: 'do
                        ] [
                            attempt [
                                src: red/load-source/hidden clean-path join red/main-path s/2
                                expand src job
                            ]
                        ]
                    ]
                )
                | s: #include-binary [file! | string!] (
                    if active? [
                        either all [not Rebol system/state/interpreted?] [
                            s/1: 'read/binary
                            if string? s/2 [s/2: to-red-file s/2]
                        ] [
                            file: either string? s/2 [to-rebol-file s/2] [s/2]
                            file: clean-path join red/main-path file
                            change/part s read/binary file 2
                        ]
                    ]
                )
                | s: #if (set [cond e] eval next s s/1) :e [set then block! | (syntax-error s e)] e: (
                    if active? [either cond [change/part s then e] [remove/part s e]]
                ) :s
                | s: #either (set [cond e] eval next s s/1) :e
                [set then block! set else block! | (syntax-error s e)] e: (
                    if active? [either cond [change/part s then e] [change/part s else e]]
                ) :s
                | s: #switch (set [cond e] eval next s s/1) :e [set cases block! | (syntax-error s e)] e: (
                    if active? [
                        body: any [select cases cond select cases #default]
                        either body [change/part s body e] [remove/part s e]
                    ]
                ) :s
                | s: #case [set cases block! | e: (syntax-error s e)] e: (
                    if active? [
                        until [
                            set [cond cases] eval cases s/1
                            any [cond tail? cases: next cases]
                        ]
                        either cond [change/part s cases/1 e] [remove/part s e]
                    ]
                ) :s
                | s: #do (keep?: no) opt ['keep (keep?: yes)] [block! | (syntax-error s next s)] e: (
                    if active? [
                        pos: pick [3 2] keep?
                        if trace? [print ["preproc: eval" mold s/:pos]]
                        saved: s
                        expr: do-code s/:pos s/1
                        s: saved
                        if all [keep? trace?] [print ["preproc: ==" mold expr]]
                        either keep? [s: change/part s :expr e] [remove/part s e]
                    ]
                ) :s
                | s: #local [block! | (syntax-error s next s)] e: (
                    repend stack [negate length? macros tail protos]
                    saved: s
                    new: expand s/2 job
                    s: saved
                    change/part s new e
                    clear take/last stack
                    remove/part macros skip tail macros take/last stack
                    if tail? next macros [macros/1: <none>]
                ) :s
                | s: #reset (reset job remove s) :s
                | s: #trace [[
                    ['on (trace?: on) | 'off (trace?: off)] (remove/part s 2) :s
                ] | (syntax-error s next s)]
                | s: #process [[
                    'on (active?: yes remove/part s 2) :s
                    | 'off (active?: no remove/part s 2) :s [to #process | to end (active?: yes)]
                ] | (syntax-error s next s)]
                | s: #macro [
                    [set-word! | word! | lit-word! | block!] ['func | 'function] block! block!
                    | (syntax-error s skip s 4)
                ] e: (
                    register-macro next s
                    remove/part s e
                ) :s
                | pos: [block! | paren!] :pos into rule
                | skip
            ]
        ]
        unless Rebol [rule/1: 'while]
        parse code rule
        code
    ]
]
prin: make native! [
    "Outputs a value"
    value [any-type!]
]
print: make native! [
    "Outputs a value followed by a newline"
    value [any-type!]
]
probe: make function! [
    "Returns a value after printing its molded form"
    value [any-type!]
]
profile: make function! [
    {Profile the argument code, counting calls and their cumulative duration, then print a report}
    code [any-type!] "Code to profile"
    /by
    cat [word!] "Sort by: 'name, 'count, 'time"
    /local saved rank name cnt duration
]
put: make action! [
    {Replaces the value following a key, and returns the new value}
    series [series! port! map! object!]
    key [scalar! any-string! all-word! binary!]
    value [any-type!]
    /case "Perform a case-sensitive search"
    return: [series! port! map! object!]
]
pwd: make function! [{Displays the active directory path (Print Working Dir)}]
q: make function! [
    "Stops evaluation and exits the program"
    /return status [integer!] "Return an exit status"
]
query: make action! [
    "Returns information about a file"
    target [file! port!]
]
quit: make function! [
    "Stops evaluation and exits the program"
    /return status [integer!] "Return an exit status"
]
quit-return: make routine! [
    {Stops evaluation and exits the program with a given status}
    status [integer!] "Process termination value to return"
]
quote: make function! [
    "Return but don't evaluate the next value"
    :value [any-type!]
]
random: make action! [
    {Returns a random value of the same datatype; or shuffles series}
    value "Maximum value of result (modified when series)"
    /seed "Restart or randomize"
    /secure "Returns a cryptographically secure random number"
    /only "Pick a random value from a series"
    return: [any-type!]
]
react: make function! [
    {Defines a new reactive relation between two or more objects}
    reaction [block! function!] "Reactive relation"
    /link "Link objects together using a reactive relation"
    objects [block!] "Objects to link together"
    /unlink "Removes an existing reactive relation"
    src [word! object! block!] "'all word, or a reactor or a list of reactors"
    /later "Run the reaction on next change instead of now"
    /with "Specifies an optional face object (internal use)"
    ctx [object! set-word! none!] "Optional context for VID faces or target set-word"
    return: [block! function! none!] {The reactive relation or NONE if no relation was processed}
    /local objs found? rule item pos obj
]
react?: make function! [
    {Returns a reactive relation if an object's field is a reactive source}
    reactor [object!] "Object to check"
    field [word!] "Field to check"
    /target {Check if it's a target of an `is` reaction instead of a source}
    return: [block! function! word! none!] "Returns reaction, type or NONE"
    /local pos
]
reactor: make function! [spec [block!]]

read: make action! [
    "Reads from a file, URL, or other port"
    source [file! url! port!]
    /part {Partial read a given number of units (source relative)}
    length [number!]
    /seek "Read from a specific position (source relative)"
    index [number!]
    /binary "Preserves contents exactly"
    /lines "Convert to block of strings"
    /info
    /as {Read with the specified encoding, default is 'UTF-8}
    encoding [word!]
]
read-clipboard: make routine! [
    "Return the contents of the system clipboard"
    return: [any-type!] {false on failure, none if empty, otherwise: string!, block! of files!, or an image!}
]
read-thru: make function! [
    "Reads a remote file through local disk cache"
    url [url!] "Remote file address"
    /update "Force a cache update"
    /binary "Use binary mode"
    /local path data
]
recycle: make native! [
    {Recycles unused memory and returns memory amount still in use}
    /on "Turns on garbage collector; returns nothing"
    /off "Turns off garbage collector; returns nothing"
    /info "Returns the number of GC passes since beginning"
    return: [integer! unset!]
]

red-complete-input: make function! [
    str [string!]
    console? [logic!]
    /local
    word ptr result sys-word delim? len insert?
    start end delimiters d w change?
]
reduce: make native! [
    {Returns a copy of a block, evaluating all expressions}
    value [any-type!]
    /into {Put results in out block, instead of creating a new block}
    out [any-block!] "Target block for results, when /into is used"
]
ref?: make function! ["Returns true if the value is this type" value [any-type!]]
refinement?: make function! ["Returns true if the value is this type" value [any-type!]]
reflect: make action! [
    {Returns internal details about a value via reflection}
    value [any-type!]
    field [word!] {spec, body, words, etc. Each datatype defines its own reflectors}
]
register-scheme: make function! [
    "Registers a new scheme"
    spec [object!] "Scheme definition"
    /native
    dispatch [handle!]
]
rejoin: make function! [
    "Reduces and joins a block of values."
    block [block!] "Values to reduce and join"
]
relate: make function! [
    {Defines a reactive relation whose result is assigned to a word}
    'field [set-word!] {Set-word which will get set to the result of the reaction}
    reaction [block!] "Reactive relation"
    /local obj rule item
]
remainder: make action! [
    {Returns what is left over when one value is divided by another}
    value1 [number! money! char! pair! any-point! tuple! vector! time!] "The dividend (numerator)"
    value2 [number! money! char! pair! any-point! tuple! vector! time!] "The divisor (denominator)"
    return: [number! money! char! pair! any-point! tuple! vector! time!] "The remainder"
]
remove: make action! [
    {Returns the series at the same index after removing a value}
    series [series! port! bitset! map! none!]
    /part {Removes a number of values, or values up to the given series index}
    length [number! char! series!]
    /key "Removes a key in map"
    key-arg [scalar! any-string! any-word! binary! block!]
    return: [series! port! bitset! map! none!]
]
remove-each: make native! [
    {Removes values for each block that returns truthy value}
    'word [word! block!] "Word or block of words to set each time"
    data [series!] "The series to traverse (modified)"
    body [block!] "Block to evaluate (return truthy value to remove)"
]
remove-event-func: make function! [
    "Removes an event function previously added"
    id [word! function!] "Handler name or function reference"
    /local svh pos
]
rename: make action! [
    "Rename a file"
    from [port! file! url!]
    to [port! file! url!]
]
repeat: make native! [
    {Evaluates body a number of times, tracking iteration count}
    'word [word!] "Iteration counter; not local to loop"
    value [integer! float!] "Number of times to evaluate body"
    body [block!]
]
repend: make function! [
    {Appends a reduced value to a series and returns the series head}
    series [series!]
    value
    /only "Appends a block value as a block"
]
replace: make function! [
    "Replaces values in a series, in place"
    series [any-block! any-string! binary! vector!] "The series to be modified"
    pattern "Specific value or parse rule pattern to match"
    value "New value, replaces pattern in the series"
    /all "Replace all occurrences, not just the first"
    /deep "Replace pattern in all sub-lists as well"
    /case "Case-sensitive replacement"
    /local parse? form? quote? deep? rule many? size seek active?
]
request-dir: make function! [
    {Asks user to select a directory and returns full directory path (or block of paths)}
    /title "Window title"
    text [string!]
    /dir "Set starting directory"
    name [string! file!]
    /filter "TBD: Block of filters (filter-name filter)"
    list [block!]
    /keep "Keep previous directory path"
    /multi {TBD: Allows multiple file selection, returned as a block}
]
request-file: make function! [
    {Asks user to select a file and returns full file path (or block of paths)}
    /title "Window title"
    text [string!]
    /file "Default file name or directory"
    name [string! file!]
    /filter "Block of filters (filter-name filter)"
    list [block!]
    /save "File save mode"
    /multi {Allows multiple file selection, returned as a block}
]
request-font: make function! [
    "Requests a font object"
    /font "Sets the selected font"
    ft [object!]
    /mono "Show monospaced font only"
]
return: make native! [
    "Returns a value from a function"
    value [any-type!]
]
reverse: make action! [
    {Reverses the order of elements; returns at same position}
    series [series! port! pair! any-point! tuple!]
    /part "Limits to a given length or position"
    length [number! series!]
    /skip "Treat the series as fixed size records"
    size [integer!]
    return: [series! port! pair! any-point! tuple!]
]

round: make action! [
    {Returns the nearest integer. Halves round up (away from zero) by default}
    n [number! money! time! pair! any-point!]
    /to {Return the nearest multiple of the scale parameter}
    scale [number! money! time! pair! any-point!] "If zero, returns N unchanged"
    /even "Halves round toward even results"
    /down {Round toward zero, ignoring discarded digits. (truncate)}
    /half-down "Halves round toward zero"
    /floor "Round in negative direction"
    /ceiling "Round in positive direction"
    /half-ceiling "Halves round in positive direction"
]
routine: make function! [{Defines a function with a given Red spec and Red/System body} spec [block!] body [block!]]
routine?: make function! ["Returns true if the value is this type" value [any-type!]]
rtd-layout: make function! [
    "Returns a rich-text face from a RTD source code"
    spec [block!] "RTD source code"
    /only "Returns only [text data] facets"
    /with "Populate an existing face object"
    face [object!] "Face object to populate"
    return: [object! block!]
]
same?: make native! [
    "Returns TRUE if two values have the same identity"
    value1 [any-type!]
    value2 [any-type!]
]
save: make function! [
    {Saves a value, block, or other data to a file, URL, binary, or string}
    where [file! url! string! binary! none!] "Where to save"
    value [any-type!] "Value(s) to save"
    /header {Provide a Red header block (or output non-code datatypes)}
    header-data [block! object!]
    /all "TBD: Save in serialized format"
    /length {Save the length of the script content in the header}
    /as {Specify the format of data; use NONE to save as plain text}
    format [word! none!] "E.g. bmp, gif, jpeg, png, redbin, json, csv"
    /local dst codec data suffix find-encoder? name only pos header-str k v
]
scalar?: make function! ["Returns true if the value is any type of scalar" value [any-type!]]
scan: make function! [
    {Returns the guessed type of the first serialized value from the input}
    buffer [binary! string!] "Input UTF-8 buffer or string"
    /next {Returns both the type and the input after the value}
    /fast "Fast scanning, returns best guessed type"
    return: [datatype! none!] {Recognized or guessed type, or NONE on empty input}
]

second: make function! ["Returns the second value in a series" s [series! tuple! pair! any-point! date! time!]]
select: make action! [
    {Find a value in a series and return the next value, or NONE}
    series [series! any-object! map! none!]
    value [any-type!]
    /part "Limit the length of the search"
    length [number! series!]
    /only "Treat a series search value as a single value"
    /case "Perform a case-sensitive search"
    /same {Use "same?" as comparator}
    /any "TBD: Use * and ? wildcards in string searches"
    /with "TBD: Use custom wildcards in place of * and ?"
    wild [string!]
    /skip "Treat the series as fixed size records"
    size [integer!]
    /last "Find the last occurrence of value, from the tail"
    /reverse {Find the last occurrence of value, from the current index}
    return: [any-type!]
]
series?: make function! ["Returns true if the value is any type of series" value [any-type!]]
set: make native! [
    "Sets the value(s) one or more words refer to"
    word [any-word! block! object! any-path!] "Word, object, map path or block of words to set"
    value [any-type!] "Value or block of values to assign to words"
    /any {Allow UNSET as a value rather than causing an error}
    /case "Use case-sensitive comparison (path only)"
    /only {Block or object value argument is set as a single value}
    /some {None values in a block or object value argument, are not set}
    return: [any-type!]
]
set-current-dir: make routine! ["Sets the platform's current process directory" path [file!]]
set-env: make native! [
    {Sets the value of an operating system environment variable (for current process)}
    var [any-string! any-word!] "Variable to set"
    value [string! none!] "Value to set, or NONE to unset it"
]
set-flag: make function! [
    {Sets (or clears) a flag in a face object; Returns the /flags facet value}
    face [object!] "Face where flag to set/clear"
    flag [any-type!] "Flag to set/clear"
    /clear "Clears the flag instead of setting it"
    /toggle "Set it if unset, clears it otherwise"
    /local flags pos
]
set-focus: make function! [
    "Sets the focus on the argument face"
    face [object!]
    /local p
]
set-path?: make function! ["Returns true if the value is this type" value [any-type!]]
set-quiet: make routine! [
    {Set an object's field to a value without triggering eventual object's events}
    word [any-type!]
    value [any-type!]
    return: [any-type!]
]
set-slot-quiet: make routine! [
    {Set a value in series without triggering eventual owner's events}
    series [any-type!]
    value [any-type!]
]
set-word?: make function! ["Returns true if the value is this type" value [any-type!]]
shift: make native! [
    {Perform a bit shift operation. Right shift (decreasing) by default}
    data [integer!]
    bits [integer!]
    /left "Shift bits to the left (increasing)"
    /logical "Use logical shift (unsigned, fill with zero)"
    return: [integer!]
]
shift-left: make routine! ["Shift bits to the left" data [integer!] bits [integer!]]
shift-logical: make routine! ["Shift bits to the right (unsigned)" data [integer!] bits [integer!]]
shift-right: make routine! ["Shift bits to the right" data [integer!] bits [integer!]]
show: make function! [
    "Display a new face or update it"
    face [object! block!] "Face object to display"
    /with "Link the face to a parent face"
    parent [object!] "Parent face to link to"
    /force "For internal use only!"
    return: [logic!] "true if success"
    /local show? f pending owner word target action new index part state handle new? p field pane
]
show-memory-stats: make function! [data [block!]
/local class used total i c frm unit]
sign?: make native! [
    {Returns sign of N as 1, 0, or -1 (to use as a multiplier)}
    number [number! money! time!]
    return: [integer!]
]
sin: make function! [
    "Returns the trigonometric sine"
    angle [float!] "Angle in radians"
]
sine: make native! [
    "Returns the trigonometric sine"
    angle [float! integer!]
    /radians "DEPRECATED: use `sin` native instead"
    return: [float!]
]
single?: make function! [
    "Returns TRUE if the series length is 1"
    series [series!]
]
size-text: make function! [
    "Returns the area size of the text in a face"
    face [object!] "Face containing the text to size"
    /with "Provide a text string instead of face/text"
    text [string!] "Text to measure"
    return: [point2D! none!] "Return the text's size or NONE if failed"
    /local h
]
size?: make native! [
    "Returns the size of a file content"
    file [file!]
    return: [integer! none!]
]
skip: make action! [
    "Returns the series relative to the current index"
    series [series! port!]
    offset [integer! pair!]
    return: [series! port!]
]
sort: make action! [
    {Sorts a series (modified); default sort order is ascending}
    series [series! port!]
    /case "Perform a case-sensitive sort"
    /skip "Treat the series as fixed size records"
    size [integer!]
    /compare "Comparator offset, block (TBD) or function"
    comparator [integer! block! any-function!]
    /part "Sort only part of a series"
    length [number! series!]
    /all "Compare all fields (used with /skip)"
    /reverse "Reverse sort order"
    /stable "Stable sorting"
    return: [series!]
]
source: make function! [
    "Print the source of a function"
    'word [word! path!] "The name of the function"
    /local val
]
spec-of: make function! [{Returns the spec of a value that supports reflection} value]
split: make function! [
    {Break a string series into pieces using the provided delimiters}
    series [any-string!] dlm [string! char! bitset!] /local s
    num
]
split-path: make function! [
    [no-trace]
    {Splits a file or URL path. Returns a block containing path and target}
    target [file! url!]
    /local dir pos
]
sqrt: make function! [
    "Returns the square root of a number"
    number [float! integer! percent!]
    return: [float!]
]
square-root: make native! [
    "Returns the square root of a number"
    value [float! integer! percent!]
    return: [float!]
]
stack-size?: make routine! [return: [integer!]]
stats: make native! [
    "Returns interpreter statistics"
    /show "TBD:"
    /info {Return detailed info: nodes/series/big x free/used/total, total, low-level heap}
    return: [integer! block!]
]
stop-events: make function! [
    "Stop the last opened event loop"
]
stop-reactor: make function! [
    face [object!]
    /deep
    /local list pos f
]
strict-equal?: make native! [
    {Returns TRUE if two values are equal, and also the same datatype}
    value1 [any-type!]
    value2 [any-type!]
]
string?: make function! ["Returns true if the value is this type" value [any-type!]]
subtract: make action! [
    "Returns the difference between two values"
    value1 [scalar! vector!] "The minuend"
    value2 [scalar! vector!] "The subtrahend"
    return: [scalar! vector!] "The difference"
]
suffix?: make function! [
    {Returns the suffix (extension) of a filename or url, or NONE if there is no suffix}
    path [file! url! string! email!]
]
sum: make function! [
    "Returns the sum of all values in a block"
    values [block! vector! paren! hash!]
    /local result value
]
swap: make action! [
    {Swaps elements between two series or the same series}
    series1 [series! port!]
    series2 [series! port!]
    return: [series! port!]
]
switch: make native! [
    {Evaluates the first block following the value found in cases}
    value [any-type!] "The value to match"
    cases [block!]
    /default {Specify a default block, if value is not found in cases}
    case [block!] "Default block to evaluate"
]
system: make object! [
    version: 0.6.6
    build: make object! [
        date: 6-Mar-2026/15:03:29
        git: make object! [
            branch: "master"
            tag: #v0.6.6
            ahead: 166
            date: 6-Mar-2026/23:03:09+08:00
            commit: #698eac0d83bbba408c82efb29264ec1bfbe62b85
            message: "FIX: issue #5691 (Error when writing to file)"
        ]
        config: make object! [
            config-name: 'Windows
            OS: 'Windows
            OS-version: 0
            ABI: none
            link?: true
            debug?: false
            encap?: false
            build-prefix: %""
            build-basename: %/home/dk/static.red-lang.org/dl/auto/win/red-view-06mar26-698eac0d8.exe
            build-suffix: none
            format: 'PE
            type: 'exe
            target: 'IA-32
            cpu-version: 6.0
            verbosity: 0
            sub-system: 'GUI
            runtime?: true
            use-natives?: false
            debug-safe?: true
            dev-mode?: false
            need-main?: false
            PIC?: false
            base-address: none
            dynamic-linker: none
            syscall: 'Linux
            export-ABI: none
            stack-align-16?: false
            literal-pool?: false
            unicode?: false
            red-pass?: true
            red-only?: false
            red-store-bodies?: true
            red-strict-check?: true
            red-tracing?: true
            red-help?: true
            redbin-compress?: false
            legacy: none
            gui-console?: true
            libRed?: false
            libRedRT?: false
            libRedRT-update?: false
            GUI-engine: 'native
            draw-engine: none
            modules: [View JSON CSV]
            show: none
            command-line: none
            show-func-map?: false
        ]
    ]
    words: make object! [
        datatype!: datatype!
        unset!: unset!
        none!: none!
        logic!: logic!
        block!: block!
        paren!: paren!
        string!: string!
        file!: file!
        url!: url!
        char!: char!
        integer!: integer!
        float!: float!
        symbol!: unset
        context!: unset
        word!: word!
        set-word!: set-word!
        lit-word!: lit-word!
        get-word!: get-word!
        refinement!: refinement!
        issue!: issue!
        native!: native!
        action!: action!
        op!: op!
        function!: function!
        path!: path!
        lit-path!: lit-path!
        set-path!: set-path!
        get-path!: get-path!
        routine!: routine!
        bitset!: bitset!
        triple!: triple!
        object!: object!
        typeset!: typeset!
        error!: error!
        vector!: vector!
        hash!: hash!
        pair!: pair!
        percent!: percent!
        tuple!: tuple!
        map!: map!
        binary!: binary!
        series!: make typeset! [block! paren! string! file! url! path! lit-path! set-path! get-path! vector! hash! binary! tag! email! ref! image!]
        time!: time!
        tag!: tag!
        email!: email!
        handle!: handle!
        date!: date!
        port!: port!
        money!: money!
        ref!: ref!
        point2D!: point2D!
        point3D!: point3D!
        image!: image!
        Windows: unset
        Syllable: unset
        macOS: unset
        Linux: unset
        NetBSD: unset
        to: make action! [[
            "Converts to a specified datatype"
            type [any-type!] "The datatype or example value"
            spec [any-type!] "The attributes of the new value"
        ]]
        thru: unset
        not: make native! [[
            {Returns the logical complement of a value (truthy or falsy)}
            value [any-type!]
        ]]
        remove: make action! [[
            {Returns the series at the same index after removing a value}
            series [series! port! bitset! map! none!]
            /part {Removes a number of values, or values up to the given series index}
            length [number! char! series!]
            /key "Removes a key in map"
            key-arg [scalar! any-string! any-word! binary! block!]
            return: [series! port! bitset! map! none!]
        ]]
        while: make native! [[
            {Evaluates body as long as condition block evaluates to truthy value}
            cond [block!] "Condition block to evaluate on each iteration"
            body [block!] "Block to evaluate on each iteration"
        ]]
        collect: func [
            {Collect in a new block all the values passed to KEEP function from the body block}
            body [block!] "Block to evaluate"
            /into {Insert into a buffer instead (returns position after insert)}
            collected [series!] "The buffer series (modified)"
            /local keep rule pos
        ][
            keep: func [v /only] [append/:only collected v v]
            unless collected [collected: make block! 16]
            parse body rule: [
                any [pos: ['keep | 'collected] (pos/1: bind pos/1 'keep) | any-string! | binary! | into rule | skip]
            ]
            do body
            either into [collected] [head collected]
        ]
        keep: unset
        ahead: unset
        |: unset
        any: make native! [[
            {Evaluates and returns the first truthy value, if any; else NONE}
            conds [block!]
        ]]
        some: unset
        copy: make action! [[
            "Returns a copy of a non-scalar value"
            value [series! any-object! bitset! map!]
            /part "Limit the length of the result"
            length [number! series! pair!]
            /deep "Copy nested values"
            /types "Copy only specific types of non-scalar values"
            kind [datatype!]
            return: [series! any-object! bitset! map!]
        ]]
        opt: unset
        into: unset
        insert: make action! [[
            {Inserts value(s) at series index; returns series past the insertion}
            series [series! port! bitset!]
            value [any-type!]
            /part "Limit the number of values inserted"
            length [number! series!]
            /only {Insert block types as single values (overrides /part)}
            /dup "Duplicate the inserted values"
            count [integer!]
            return: [series! port! bitset!]
        ]]
        if: make native! [[
            {If conditional expression is truthy, evaluate block; else return NONE}
            cond [any-type!]
            then-blk [block!]
        ]]
        quote: func [
            "Return but don't evaluate the next value"
            :value [any-type!]
        ][
            :value
        ]
        set: make native! [[
            "Sets the value(s) one or more words refer to"
            word [any-word! block! object! any-path!] "Word, object, map path or block of words to set"
            value [any-type!] "Value or block of values to assign to words"
            /any {Allow UNSET as a value rather than causing an error}
            /case "Use case-sensitive comparison (path only)"
            /only {Block or object value argument is set as a single value}
            /some {None values in a block or object value argument, are not set}
            return: [any-type!]
        ]]
        case: make native! [[
            {Evaluates the block following the first truthy condition}
            cases [block!] "Block of condition-block pairs"
            /all {Test all conditions, evaluating the block following each truthy condition}
        ]]
        at: make action! [[
            "Returns a series at a given index"
            series [series! port!]
            index [integer! pair!]
            return: [series! port!]
        ]]
        back: make action! [[
            "Returns a series at the previous index"
            series [series! port!]
            return: [series! port!]
        ]]
        find: make action! [[
            {Returns the series where a value is found, or NONE}
            series [series! bitset! typeset! port! map! none!]
            value [any-type!] {Typesets and datatypes can be used to search by datatype}
            /part "Limit the length of the search"
            length [number! series!]
            /only {Treat series and typeset value arguments as single values}
            /case "Perform a case-sensitive search"
            /same {Use "same?" as comparator}
            /any "TBD: Use * and ? wildcards in string searches"
            /with "TBD: Use custom wildcards in place of * and ?"
            wild [string!]
            /skip "Treat the series as fixed size records"
            size [integer!]
            /last "Find the last occurrence of value, from the tail"
            /reverse {Find the last occurrence of value, from the current index}
            /tail {Return the tail of the match found, rather than the head}
            /match "Match at current index only"
        ]]
        head: make action! [[
            "Returns a series at its first index"
            series [series! port!]
            return: [series! port!]
        ]]
        head?: make action! [[
            "Returns true if a series is at its first index"
            series [series! port!]
            return: [logic!]
        ]]
        index?: make action! [[
            {Returns the current index of series relative to the head, or of word in a context}
            series [series! port! any-word!]
            return: [integer!]
        ]]
        length?: make action! [[
            {Returns the number of values in the series, from the current index to the tail}
            series [series! port! bitset! map! tuple! none!]
            return: [integer! none!]
        ]]
        next: make action! [[
            "Returns a series at the next index"
            series [series! port!]
            return: [series! port!]
        ]]
        pick: make action! [[
            "Returns the series value at a given index"
            series [series! port! bitset! pair! any-point! tuple! money! date! time! event!]
            index [scalar! any-string! any-word! block! logic! time!]
            return: [any-type!]
        ]]
        skip: make action! [[
            "Returns the series relative to the current index"
            series [series! port!]
            offset [integer! pair!]
            return: [series! port!]
        ]]
        select: make action! [[
            {Find a value in a series and return the next value, or NONE}
            series [series! any-object! map! none!]
            value [any-type!]
            /part "Limit the length of the search"
            length [number! series!]
            /only "Treat a series search value as a single value"
            /case "Perform a case-sensitive search"
            /same {Use "same?" as comparator}
            /any "TBD: Use * and ? wildcards in string searches"
            /with "TBD: Use custom wildcards in place of * and ?"
            wild [string!]
            /skip "Treat the series as fixed size records"
            size [integer!]
            /last "Find the last occurrence of value, from the tail"
            /reverse {Find the last occurrence of value, from the current index}
            return: [any-type!]
        ]]
        tail: make action! [[
            {Returns a series at the index after its last value}
            series [series! port!]
            return: [series! port!]
        ]]
        tail?: make action! [[
            "Returns true if a series is past its last value"
            series [series! port!]
            return: [logic!]
        ]]
        change: make action! [[
            {Changes a value in a series and returns the series after the change}
            series [series! port!] "Series at point to change"
            value [any-type!] "The new value"
            /part {Limits the amount to change to a given length or position}
            range [number! series!]
            /only "Changes a series as a series."
            /dup "Duplicates the change a specified number of times"
            count [number!]
        ]]
        changed: unset
        clear: make action! [[
            {Removes series values from current index to tail; returns new tail}
            series [series! port! bitset! map! none!]
            return: [series! port! bitset! map! none!]
        ]]
        cleared: unset
        set-path: unset
        append: make action! [[
            {Inserts value(s) at series tail; returns series head}
            series [series! bitset! port!]
            value [any-type!]
            /part "Limit the number of values inserted"
            length [number! series!]
            /only {Insert block types as single values (overrides /part)}
            /dup "Duplicate the inserted values"
            count [integer!]
            return: [series! port! bitset!]
        ]]
        appended: unset
        move: make action! [[
            {Moves one or more elements from one series to another position or series}
            origin [series! port!]
            target [series! port!]
            /part "Limit the number of values inserted"
            length [integer!]
            return: [series! port!]
        ]]
        moved: unset
        poke: make action! [[
            {Replaces the series value at a given index, and returns the new value}
            series [series! port! bitset!]
            index [scalar! any-string! any-word! block! logic!]
            value [any-type!]
            return: [series! port! bitset!]
        ]]
        poked: unset
        put: make action! [[
            {Replaces the value following a key, and returns the new value}
            series [series! port! map! object!]
            key [scalar! any-string! all-word! binary!]
            value [any-type!]
            /case "Perform a case-sensitive search"
            return: [series! port! map! object!]
        ]]
        put-ed: unset
        removed: unset
        random: make action! [[
            {Returns a random value of the same datatype; or shuffles series}
            value "Maximum value of result (modified when series)"
            /seed "Restart or randomize"
            /secure "Returns a cryptographically secure random number"
            /only "Pick a random value from a series"
            return: [any-type!]
        ]]
        randomized: unset
        reverse: make action! [[
            {Reverses the order of elements; returns at same position}
            series [series! port! pair! any-point! tuple!]
            /part "Limits to a given length or position"
            length [number! series!]
            /skip "Treat the series as fixed size records"
            size [integer!]
            return: [series! port! pair! any-point! tuple!]
        ]]
        reversed: unset
        sort: make action! [[
            {Sorts a series (modified); default sort order is ascending}
            series [series! port!]
            /case "Perform a case-sensitive sort"
            /skip "Treat the series as fixed size records"
            size [integer!]
            /compare "Comparator offset, block (TBD) or function"
            comparator [integer! block! any-function!]
            /part "Sort only part of a series"
            length [number! series!]
            /all "Compare all fields (used with /skip)"
            /reverse "Reverse sort order"
            /stable "Stable sorting"
            return: [series!]
        ]]
        sorted: unset
        swap: make action! [[
            {Swaps elements between two series or the same series}
            series1 [series! port!]
            series2 [series! port!]
            return: [series! port!]
        ]]
        swaped: unset
        take: make action! [[
            "Removes and returns one or more elements"
            series [series! port! none!]
            /part "Specifies a length or end position"
            length [number! series!]
            /deep "Copy nested values"
            /last "Take it from the tail end"
        ]]
        taken: unset
        trim: make action! [[
            "Removes space from a string or NONE from a block"
            series [series! port!]
            /head "Removes only from the head"
            /tail "Removes only from the tail"
            /auto "Auto indents lines relative to first line"
            /lines "Removes all line breaks and extra spaces"
            /all "Removes all whitespace"
            /with "Same as /all, but removes characters in 'str'"
            str [char! string! binary! integer!]
        ]]
        trimmed: unset
        inserted: unset
        uppercase: make native! [[
            "Converts string of characters to uppercase"
            string [any-string! char!] "Value to convert (modified when series)"
            /part "Limits to a given length or position"
            limit [number! any-string!]
            return: [any-string! char!]
        ]]
        lowercase: make native! [[
            "Converts string of characters to lowercase"
            string [any-string! char!] "Value to convert (modified when series)"
            /part "Limits to a given length or position"
            limit [number! any-string!]
            return: [any-string! char!]
        ]]
        checksum: make native! [[
            "Computes a checksum, CRC, hash, or HMAC"
            data [binary! string! file!]
            method [word!] {MD5 SHA1 SHA256 SHA384 SHA512 CRC32 TCP ADLER32 hash}
            /with {Extra value for HMAC key or hash table size; not compatible with TCP/CRC32/ADLER32 methods}
            spec [any-string! binary! integer!] {String or binary for MD5/SHA* HMAC key, integer for hash table size}
            return: [integer! binary!]
        ]]
        push: unset
        pop: unset
        fetch: unset
        match: unset
        iterate: unset
        paren: unset
        <anon>: unset
        <body>: unset
        <not-found>: unset
        end: unset
        add: make action! [[
            "Returns the sum of the two values"
            value1 [scalar! vector!] "The augend"
            value2 [scalar! vector!] "The addend"
            return: [scalar! vector!] "The sum"
        ]]
        subtract: make action! [[
            "Returns the difference between two values"
            value1 [scalar! vector!] "The minuend"
            value2 [scalar! vector!] "The subtrahend"
            return: [scalar! vector!] "The difference"
        ]]
        divide: make action! [[
            "Returns the quotient of two values"
            value1 [number! money! char! pair! tuple! vector! time! any-point!] "The dividend (numerator)"
            value2 [number! money! char! pair! tuple! vector! time! any-point!] "The divisor (denominator)"
            return: [number! money! char! pair! tuple! vector! time! any-point!] "The quotient"
        ]]
        on-parse-event: unset
        type: unset
        id: unset
        try: make native! [[
            {Tries to DO a block and returns its value or an error}
            block [block!]
            /all {Catch also BREAK, CONTINUE, RETURN, EXIT and THROW exceptions}
            /keep {Capture and save the call stack in the error object}
        ]]
        catch: make native! [[
            {Catches a throw from a block and returns its value}
            block [block!] "Block to evaluate"
            /name "Catches a named throw"
            word [word! block!] "One or more names"
        ]]
        name: unset
        multiply: make action! [[
            "Returns the product of two values"
            value1 [number! money! char! pair! tuple! vector! time! any-point!] "The multiplicand"
            value2 [number! money! char! pair! tuple! vector! time! any-point!] "The multiplier"
            return: [number! money! char! pair! tuple! vector! time! any-point!] "The product"
        ]]
        browse: make native! [[
            {Opens the URL in a web browser or the file in the associated application}
            url [url! file!]
        ]]
        open: make action! [[
            {Opens a port; makes a new port from a specification if necessary}
            port [port! file! url! block!]
            /new "Create new file - if it exists, deletes it"
            /read "Open for read access"
            /write "Open for write access"
            /seek "Optimize for random access"
            /allow "Specificies right access attributes"
            access [block!]
        ]]
        create: make action! [[
            "Send port a create request"
            port [port! file! url! block!]
        ]]
        close: make action! [[
            "Closes a port"
            port [port!]
        ]]
        delete: make action! [[
            "Deletes the specified file or empty folder"
            file [file! port!]
        ]]
        modify: make action! [[
            "Change mode for target aggregate value"
            target [object! series! bitset!]
            field [word!]
            value [any-type!]
            /case "Perform a case-sensitive lookup"
        ]]
        query: make action! [[
            "Returns information about a file"
            target [file! port!]
        ]]
        read: make action! [[
            "Reads from a file, URL, or other port"
            source [file! url! port!]
            /part {Partial read a given number of units (source relative)}
            length [number!]
            /seek "Read from a specific position (source relative)"
            index [number!]
            /binary "Preserves contents exactly"
            /lines "Convert to block of strings"
            /info
            /as {Read with the specified encoding, default is 'UTF-8}
            encoding [word!]
        ]]
        rename: make action! [[
            "Rename a file"
            from [port! file! url!]
            to [port! file! url!]
        ]]
        update: make action! [[
            {Updates external and internal states (normally after read/write)}
            port [port!]
        ]]
        write: make action! [[
            "Writes to a file, URL, or other port"
            destination [file! url! port!]
            data [any-type!]
            /binary "Preserves contents exactly"
            /lines "Write each value in a block as a separate line"
            /info
            /append "Write data at end of file"
            /part "Partial write a given number of units"
            length [number!]
            /seek "Write at a specific position"
            index [number!]
            /allow "Specifies protection attributes"
            access [block!]
            /as {Write with the specified encoding, default is 'UTF-8}
            encoding [word!]
        ]]
        prescan: unset
        scan: func [
            {Returns the guessed type of the first serialized value from the input}
            buffer [binary! string!] "Input UTF-8 buffer or string"
            /next {Returns both the type and the input after the value}
            /fast "Fast scanning, returns best guessed type"
            return: [datatype! none!] {Recognized or guessed type, or NONE on empty input}
        ][
            apply 'transcode/:next/:scan/:prescan [buffer :next not fast fast]
        ]
        load: func [
            {Returns a value or block of values by reading and evaluating a source}
            source [file! url! string! binary!]
            /header "TBD"
            /all {Load all values, returns a block. TBD: Don't evaluate Red header}
            /trap {Load all values, returns [[values] position error]}
            /next {Load the next value only, updates source series word}
            position [word!] "Word updated with new series position"
            /part "Limit to a length or position"
            length [integer! string!]
            /into {Put results in out block, instead of creating a new block}
            out [block!] "Target block for results"
            /as {Specify the type of data; use NONE to load as code}
            type [word! none!] "E.g. bmp, gif, jpeg, png, redbin, json, csv"
            /local codec suffix name mime pre-load
        ][
            if as [
                if word? type [
                    either codec: select system/codecs type [
                        if url? source [source: read/binary source]
                        return do [codec/decode source]
                    ] [
                        cause-error 'script 'invalid-refine-arg [/as type]
                    ]
                ]
            ]
            if part [
                case [
                    zero? length [return make block! 1]
                    string? length [
                        if (index? length) = index? source [
                            return make block! 1
                        ]
                    ]
                ]
            ]
            unless out [out: make block! 10]
            switch type?/word source [
                file! [
                    suffix: suffix? source
                    foreach [name codec] system/codecs [
                        if find codec/suffixes suffix [
                            return do [codec/decode source]
                        ]
                    ]
                    either dir? source [
                        return read source
                    ] [
                        source: read/binary source
                    ]
                ]
                url! [
                    source: read/info/binary source
                    either source/1 = 200 [
                        foreach [name codec] system/codecs [
                            foreach mime codec/mime-type [
                                if find source/2/Content-Type mold mime [
                                    return do [codec/decode source/3]
                                ]
                            ]
                        ]
                    ] [return none]
                    source: source/3
                ]
            ]
            if pre-load: :system/lexer/pre-load [do [pre-load source length]]
            set/any 'out case [
                part [transcode/part source length]
                into [transcode/into source out]
                next [
                    set position second set/any 'out transcode/next source
                    return either :all [reduce [out/1]] [out/1]
                ]
                'else [transcode source]
            ]
            either trap [:out] [
                unless :all [if 1 = length? :out [set/any 'out out/1]]
                :out
            ]
        ]
        error: unset
        comment: func ["Consume but don't evaluate the next value" 'value][]
        init: unset
        exec: unset
        call: make native! [[
            "Executes a shell command to run another process"
            cmd [string! file!] "A shell command or an executable file"
            /wait "Runs command and waits for exit"
            /show {Force the display of system's shell window (Windows only)}
            /console {Runs command with I/O redirected to console (CLI console only at present)}
            /shell "Forces command to be run from shell"
            /input in [string! file! binary!] "Redirects in to stdin"
            /output out [string! file! binary!] "Redirects stdout to out"
            /error err [string! file! binary!] "Redirects stderr to err"
            return: [integer!] "0 if success, -1 if error, or a process ID"
        ]]
        return: make native! [[
            "Returns a value from a function"
            value [any-type!]
        ]]
        enter: #"^M"
        exit: make native! [[
            "Exits a function, returning no value"
        ]]
        prolog: unset
        epilog: unset
        throw: make native! [[
            "Throws control back to a previous catch"
            value [any-type!] "Value returned from catch"
            /name "Throws to a named catch"
            word [word!]
        ]]
        expr: unset
        <interp-callback>: unset
        <lexer-callback>: unset
        <parse-callback>: unset
        <compare-callback>: unset
        note: unset
        syntax: unset
        script: unset
        math: func [
            "Evaluates expression using math precedence rules"
            datum [block! paren!] "Expression to evaluate"
            /safe "Returns NONE on error"
            /local match
            order infix tally enter recur count operator
        ][
            order: ['** ['* | quote / | quote % | quote //]]
            infix: [skip operator [enter | skip]]
            tally: [any [enter [fail] | recur [fail] | count [fail] | skip]]
            enter: [ahead paren! into tally]
            recur: [if (operator = '**) skip operator tally]
            count: [while ahead change only copy match infix (either safe [attempt match] [do match])]
            datum: copy/deep datum
            foreach operator order [parse datum tally]
            either safe [attempt datum] [do datum]
        ]
        access: unset
        user: unset
        internal: unset
        invalid-error: unset
        local: unset
        <applied>: unset
        event!: event!
        make: make action! [[
            {Returns a new value made from a spec for that value's type}
            type [any-type!] "The datatype, an example or prototype value"
            spec [any-type!] "The specification of the new value"
            return: [any-type!] "Returns the specified datatype"
        ]]
        any-type!: make typeset! [datatype! unset! none! logic! block! paren! string! file! url! char! integer! float! word! set-word! lit-word! get-word! refinement! issue! native! action! op! function! path! lit-path! set-path! get-path! routine! bitset! object! typeset! error! vector! hash! pair! percent! tuple! map! binary! time! tag! email! handle! date! port! money! ref! point2D! point3D! image! event!]
        spec: unset
        value: unset
        seed: unset
        secure: unset
        only: unset
        reflect: make action! [[
            {Returns internal details about a value via reflection}
            value [any-type!]
            field [word!] {spec, body, words, etc. Each datatype defines its own reflectors}
        ]]
        field: unset
        form: make action! [[
            {Returns a user-friendly string representation of a value}
            value [any-type!]
            /part "Limit the length of the result"
            limit [integer!]
            return: [string!]
        ]]
        part: unset
        limit: unset
        mold: make action! [[
            {Returns a source format string representation of a value}
            value [any-type!]
            /only "Exclude outer brackets if value is a block"
            /all "TBD: Return value in loadable format"
            /flat "Exclude all indentation"
            /part "Limit the length of the result"
            limit [integer!]
            return: [string!]
        ]]
        all: make native! [[
            {Evaluates and returns the last value if all are truthy; else NONE}
            conds [block!]
        ]]
        flat: unset
        target: unset
        absolute: make action! [[
            "Returns the non-negative value"
            value [number! money! char! pair! time! any-point!]
            return: [number! money! char! pair! time! any-point!]
        ]]
        number!: make typeset! [integer! float! percent!]
        any-point!: make typeset! [point2D! point3D!]
        value1: unset
        scalar!: make typeset! [char! integer! float! pair! percent! tuple! time! date! money! point2D! point3D!]
        value2: unset
        negate: make action! [[
            "Returns the opposite (additive inverse) value"
            number [number! money! bitset! pair! time! any-point!]
            return: [number! money! bitset! pair! time! any-point!]
        ]]
        number: unset
        power: make action! [[
            {Returns a number raised to a given power (exponent)}
            number [number!] "Base value"
            exponent [integer! float!] "The power (index) to raise the base value by"
            return: [number!]
        ]]
        exponent: unset
        remainder: make action! [[
            {Returns what is left over when one value is divided by another}
            value1 [number! money! char! pair! any-point! tuple! vector! time!] "The dividend (numerator)"
            value2 [number! money! char! pair! any-point! tuple! vector! time!] "The divisor (denominator)"
            return: [number! money! char! pair! any-point! tuple! vector! time!] "The remainder"
        ]]
        round: make action! [[
            {Returns the nearest integer. Halves round up (away from zero) by default}
            n [number! money! time! pair! any-point!]
            /to {Return the nearest multiple of the scale parameter}
            scale [number! money! time! pair! any-point!] "If zero, returns N unchanged"
            /even "Halves round toward even results"
            /down {Round toward zero, ignoring discarded digits. (truncate)}
            /half-down "Halves round toward zero"
            /floor "Round in negative direction"
            /ceiling "Round in positive direction"
            /half-ceiling "Halves round in positive direction"
        ]]
        n: unset
        scale: unset
        even: unset
        down: unset
        half-down: unset
        floor: unset
        ceiling: unset
        half-ceiling: unset
        even?: make action! [[
            {Returns true if the number is evenly divisible by 2}
            number [number! money! char! time!]
            return: [logic!]
        ]]
        odd?: make action! [[
            {Returns true if the number has a remainder of 1 when divided by 2}
            number [number! money! char! time!]
            return: [logic!]
        ]]
        and~: make action! [[
            "Returns the first value ANDed with the second"
            value1 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
            value2 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
            return: [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
        ]]
        complement: make action! [[
            {Returns the opposite (complementing) value of the input value}
            value [logic! integer! tuple! bitset! typeset! binary!]
            return: [logic! integer! tuple! bitset! typeset! binary!]
        ]]
        or~: make action! [[
            "Returns the first value ORed with the second"
            value1 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
            value2 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
            return: [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
        ]]
        xor~: make action! [[
            {Returns the first value exclusive ORed with the second}
            value1 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
            value2 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
            return: [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
        ]]
        series: unset
        length: unset
        dup: unset
        count: unset
        index: unset
        range: unset
        any-object!: make typeset! [object! error! port!]
        deep: unset
        types: make typeset! [native! action! function! routine! object!]
        kind: unset
        same: unset
        with: unset
        wild: unset
        size: unset
        last: func ["Returns the last value in a series" s [series! tuple!]][pick s length? s]
        any-word!: make typeset! [word! set-word! lit-word! get-word!]
        origin: unset
        any-string!: make typeset! [string! file! url! tag! email! ref!]
        key: unset
        all-word!: make typeset! [word! set-word! lit-word! get-word! refinement! issue!]
        key-arg: unset
        compare: unset
        comparator: unset
        any-function!: make typeset! [native! action! op! function! routine!]
        stable: unset
        offset: unset
        series1: unset
        series2: unset
        auto: unset
        lines: unset
        str: unset
        port: unset
        file: unset
        new: unset
        seek: unset
        allow: unset
        open?: make action! [[
            "Returns TRUE if port is open"
            port [port!]
        ]]
        source: func [
            "Print the source of a function"
            'word [word! path!] "The name of the function"
            /local val
        ][
            set/any 'val get/any word
            print case [
                find [op! function!] type?/word :val [[append mold word #":" mold :val]]
                routine? :val [[
                    ";" uppercase mold :word {is a routine! value; its body is Red/System code.^/}
                    append mold word #":" mold :val
                ]]
                'else [[uppercase mold word "is" a-an/pre mold type? :val "value, so source is not available."]]
            ]
        ]
        binary: unset
        info: unset
        as: make native! [[
            {Coerce a series into a compatible datatype without copying it}
            type [datatype! block! paren! any-path! any-string!] "The datatype or example value"
            spec [block! paren! any-path! any-string!] "The series to coerce"
        ]]
        encoding: unset
        from: unset
        destination: unset
        data: unset
        cond: unset
        then-blk: unset
        unless: make native! [[
            {If conditional expression is falsy, evaluate block; else return NONE}
            cond [any-type!]
            then-blk [block!]
        ]]
        either: make native! [[
            {If conditional expression is truthy, evaluate the first branch; else evaluate the alternative}
            cond [any-type!]
            true-blk [block!]
            false-blk [block!]
        ]]
        true-blk: unset
        false-blk: unset
        conds: unset
        body: unset
        until: make native! [[
            "Evaluates body until it is truthy"
            body [block!]
        ]]
        loop: make native! [[
            "Evaluates body a number of times"
            count [integer! float!]
            body [block!]
        ]]
        repeat: make native! [[
            {Evaluates body a number of times, tracking iteration count}
            'word [word!] "Iteration counter; not local to loop"
            value [integer! float!] "Number of times to evaluate body"
            body [block!]
        ]]
        word: 'system
        forever: make native! [[
            "Evaluates body repeatedly forever"
            body [block!]
        ]]
        foreach: make native! [[
            "Evaluates body for each value in a series"
            'word [word! block!] "Word, or words, to set on each iteration"
            series [series! map!]
            body [block!]
        ]]
        forall: make native! [[
            "Evaluates body for all values in a series"
            'word [word!] "Word referring to series to iterate over"
            body [block!]
        ]]
        remove-each: make native! [[
            {Removes values for each block that returns truthy value}
            'word [word! block!] "Word or block of words to set each time"
            data [series!] "The series to traverse (modified)"
            body [block!] "Block to evaluate (return truthy value to remove)"
        ]]
        func: make native! [[
            "Defines a function with a given spec and body"
            spec [block!]
            body [block!]
        ]]
        function: make native! [[
            {Defines a function, making all set-words found in body, local}
            spec [block!]
            body [block!]
            /extern "Exclude words that follow this refinement"
        ]]
        extern: unset
        does: make native! [[
            {Defines a function with no arguments or local variables}
            body [block!]
        ]]
        has: make native! [[
            {Defines a function with local variables, but no arguments}
            vars [block!]
            body [block!]
        ]]
        vars: unset
        switch: make native! [[
            {Evaluates the first block following the value found in cases}
            value [any-type!] "The value to match"
            cases [block!]
            /default {Specify a default block, if value is not found in cases}
            case [block!] "Default block to evaluate"
        ]]
        cases: unset
        default: unset
        do: make native! [[
            {Evaluates a value, returning the last evaluation result}
            value [any-type!]
            /expand "Expand directives before evaluation"
            /args {If value is a script, this will set its system/script/args}
            arg "Args passed to a script (normally a string)"
            /next {Do next expression only, return it, update block word}
            position [word!] "Word updated with new block position"
            /trace
            callback [function! [
                event [word!]
                code [any-block! none!]
                offset [integer!]
                value [any-type!]
                ref [any-type!]
                frame [pair!]
            ]]
        ]]
        expand: func [
            {Preprocess the argument block and display the output (console only)}
            blk [block!] "Block to expand"
        ][
            probe expand-directives/clean blk
        ]
        args: unset
        arg: unset
        position: unset
        trace: func [
            {Runs argument code and prints an evaluation trace; also turns on/off tracing}
            code [any-type!] "Code to trace or tracing mode (logic!)"
            /raw {Switch to raw interpreter events tracing (incompatible with other modes)}
            /deep "Trace into functions and natives"
            /all "Trace all sub-expressions of each expression"
            /debug {Used internally to debug the tracer itself (outputs all events)}
            /local bool
        ][
            either logic? :code [
                #system [
                    use [bool [red-logic!]] [
                        bool: as red-logic! ~code
                        assert TYPE_OF (bool) = TYPE_LOGIC
                        interpreter/tracing?: bool/value and interpreter/trace?
                    ]
                ]
            ] [
                either raw [
                    do-handler :code :tracers/dumper
                ] [
                    tracers/guided-trace :tracers/inspector/inspect :code all deep debug
                ]
            ]
        ]
        callback: unset
        event: unset
        code: unset
        any-block!: make typeset! [block! paren! path! lit-path! set-path! get-path! hash!]
        ref: unset
        frame: unset
        reduce: make native! [[
            {Returns a copy of a block, evaluating all expressions}
            value [any-type!]
            /into {Put results in out block, instead of creating a new block}
            out [any-block!] "Target block for results, when /into is used"
        ]]
        out: unset
        compose: make native! [[
            "Returns a copy of a block, evaluating only parens"
            value [block!]
            /deep "Compose nested blocks"
            /only {Compose nested blocks as blocks containing their values}
            /into {Put results in out block, instead of creating a new block}
            out [any-block!] "Target block for results, when /into is used"
        ]]
        get: make native! [[
            "Returns the value a word refers to"
            word [any-word! any-path! object!]
            /any {If word has no value, return UNSET rather than causing an error}
            /case "Use case-sensitive comparison (path only)"
            return: [any-type!]
        ]]
        any-path!: make typeset! [path! lit-path! set-path! get-path!]
        print: make native! [[
            "Outputs a value followed by a newline"
            value [any-type!]
        ]]
        prin: make native! [[
            "Outputs a value"
            value [any-type!]
        ]]
        equal?: make native! [[
            "Returns TRUE if two values are equal"
            value1 [any-type!]
            value2 [any-type!]
        ]]
        not-equal?: make native! [[
            "Returns TRUE if two values are not equal"
            value1 [any-type!]
            value2 [any-type!]
        ]]
        strict-equal?: make native! [[
            {Returns TRUE if two values are equal, and also the same datatype}
            value1 [any-type!]
            value2 [any-type!]
        ]]
        lesser?: make native! [[
            {Returns TRUE if the first value is less than the second}
            value1 [any-type!]
            value2 [any-type!]
        ]]
        greater?: make native! [[
            {Returns TRUE if the first value is greater than the second}
            value1 [any-type!]
            value2 [any-type!]
        ]]
        lesser-or-equal?: make native! [[
            {Returns TRUE if the first value is less than or equal to the second}
            value1 [any-type!]
            value2 [any-type!]
        ]]
        greater-or-equal?: make native! [[
            {Returns TRUE if the first value is greater than or equal to the second}
            value1 [any-type!]
            value2 [any-type!]
        ]]
        same?: make native! [[
            "Returns TRUE if two values have the same identity"
            value1 [any-type!]
            value2 [any-type!]
        ]]
        type?: make native! [[
            "Returns the datatype of a value"
            value [any-type!]
            /word "Return a word value, rather than a datatype value"
        ]]
        stats: make native! [[
            "Returns interpreter statistics"
            /show "TBD:"
            /info {Return detailed info: nodes/series/big x free/used/total, total, low-level heap}
            return: [integer! block!]
        ]]
        show: func [
            "Display a new face or update it"
            face [object! block!] "Face object to display"
            /with "Link the face to a parent face"
            parent [object!] "Parent face to link to"
            /force "For internal use only!"
            return: [logic!] "true if success"
            /local show? f pending owner word target action new index part state handle new? p field pane
        ][
            show?: yes
            if block? face [
                foreach f face [
                    if word? :f [f: get f]
                    either object? :f [show?: show f] [cause-error 'script 'face-type [:f]]
                ]
                return show?
            ]
            if debug-info? face [print ["show:" face/type " with?:" with]]
            either all [face/state face/state/1] [
                pending: face/state/3
                if all [pending not empty? pending] [
                    pending: copy pending
                    clear face/state/3
                    foreach [owner word target action new index part state] pending [
                        on-face-deep-change* owner word target action new index part state yes
                    ]
                    clear pending
                ]
                if face/state/2 <> 0 [system/view/platform/update-view face]
                handle: face/state/1
            ] [
                new?: yes
                either face/type <> 'screen [
                    if all [not force face/type <> 'window] [
                        unless parent [cause-error 'script 'not-linked []]
                        if all [object? face/parent face/parent/type <> 'tab-panel not with] [face/parent: none]
                    ]
                    if any [series? face/extra object? face/extra] [
                        modify face/extra 'owned none
                    ]
                    if all [object? face/actors in face/actors 'on-create] [
                        do-safe [face/actors/on-create face none]
                    ]
                    p: either with [parent/state/1] [null-handle]
                    handle: system/view/platform/make-view face p
                    if with [face/parent: parent]
                    face/state: reduce [handle 0 none false]
                    foreach field [para font] [
                        if all [field: face/:field p: in field 'parent] [
                            field/parent: tail either block? p: get p [
                                unless find/same head p face [append p face]
                                p
                            ] [
                                reduce [face]
                            ]
                        ]
                    ]
                    switch face/type [
                        tab-panel [link-tabs-to-parent face]
                        window [
                            face/parent: get-current-screen
                            if find-flag? face/flags 'modal [
                                pane: face/parent/pane
                                foreach f head pane [
                                    f/enabled?: no
                                    unless system/view/auto-sync? [show f]
                                ]
                            ]
                            append face/parent/pane face
                        ]
                    ]
                ] [face/state: reduce [handle 0 none false]]
            ]
            if face/pane [
                foreach f face/pane [
                    unless face? :f [cause-error 'script 'face-type [:f]]
                    show/with f face
                    unless face/state [return false]
                ]
                if face/type <> 'screen [system/view/platform/refresh-window face/state/1]
            ]
            if all [new? object? face/actors in face/actors 'on-created] [
                do-safe [face/actors/on-created face none]
            ]
            if all [face/type = 'window face/visible?] [system/view/platform/show-window handle]
            show?
        ]
        bind: make native! [[
            "Bind words to a context; returns rebound words"
            word [block! any-word!]
            context [any-word! any-object! function!]
            /copy "Deep copy blocks before binding"
            return: [block! any-word!]
        ]]
        context: func [
            "Makes a new object from an evaluated spec"
            spec [block!]
        ][
            make object! spec
        ]
        in: make native! [[
            {Returns the given word bound to the object's context}
            object [any-object! any-function!]
            word [any-word! refinement!]
        ]]
        object: func [
            "Makes a new object from an evaluated spec"
            spec [block!]
        ][
            make object! spec
        ]
        parse: make native! [[
            "Process a series using dialected grammar rules"
            input [binary! any-block! any-string!]
            rules [block!]
            /case "Uses case-sensitive comparison"
            /part "Limit to a length or position"
            length [number! series!]
            /trace
            callback [function! [
                event [word!]
                match? [logic!]
                rule [block!]
                input [series!]
                stack [block!]
                return: [logic!]
            ]]
            return: [logic! block!]
        ]]
        input: func ["Wait for console user input" return: [string!]][ask ""]
        rules: unset
        match?: unset
        rule: unset
        stack: unset
        union: make native! [[
            "Returns the union of two data sets"
            set1 [block! hash! string! bitset! typeset!]
            set2 [block! hash! string! bitset! typeset!]
            /case "Use case-sensitive comparison"
            /skip "Treat the series as fixed size records"
            size [integer!]
            return: [block! hash! string! bitset! typeset!]
        ]]
        set1: unset
        set2: unset
        unique: make native! [[
            "Returns the data set with duplicates removed"
            set [block! hash! string!]
            /case "Use case-sensitive comparison"
            /skip "Treat the series as fixed size records"
            size [integer!]
            return: [block! hash! string!]
        ]]
        intersect: make native! [[
            "Returns the intersection of two data sets"
            set1 [block! hash! string! bitset! typeset!]
            set2 [block! hash! string! bitset! typeset!]
            /case "Use case-sensitive comparison"
            /skip "Treat the series as fixed size records"
            size [integer!]
            return: [block! hash! string! bitset! typeset!]
        ]]
        difference: make native! [[
            "Returns the special difference of two data sets"
            set1 [block! hash! string! bitset! typeset! date!]
            set2 [block! hash! string! bitset! typeset! date!]
            /case "Use case-sensitive comparison"
            /skip "Treat the series as fixed size records"
            size [integer!]
            return: [block! hash! string! bitset! typeset! time!]
        ]]
        exclude: make native! [[
            {Returns the first data set less the second data set}
            set1 [block! hash! string! bitset! typeset!]
            set2 [block! hash! string! bitset! typeset!]
            /case "Use case-sensitive comparison"
            /skip "Treat the series as fixed size records"
            size [integer!]
            return: [block! hash! string! bitset! typeset!]
        ]]
        complement?: make native! [[
            "Returns TRUE if the bitset is complemented"
            bits [bitset!]
        ]]
        bits: unset
        dehex: make native! [[
            "Converts URL-style hex encoded (%xx) strings"
            value [any-string!]
            return: [string!] "Always return a string"
        ]]
        enhex: make native! [[
            "Encode URL-style hex encoded (%xx) strings"
            value [any-string!]
            return: [string!] "Always return a string"
        ]]
        negative?: make native! [[
            "Returns TRUE if the number is negative"
            number [number! money! time!]
            return: [logic!]
        ]]
        positive?: make native! [[
            "Returns TRUE if the number is positive"
            number [number! money! time!]
            return: [logic!]
        ]]
        max: make native! [[
            "Returns the greater of the two values"
            value1 [scalar! series!]
            value2 [scalar! series!]
        ]]
        min: make native! [[
            "Returns the lesser of the two values"
            value1 [scalar! series!]
            value2 [scalar! series!]
        ]]
        shift: make native! [[
            {Perform a bit shift operation. Right shift (decreasing) by default}
            data [integer!]
            bits [integer!]
            /left "Shift bits to the left (increasing)"
            /logical "Use logical shift (unsigned, fill with zero)"
            return: [integer!]
        ]]
        left: unset
        logical: unset
        to-hex: make native! [[
            {Converts numeric value to a hex issue! datatype (with leading # and 0's)}
            value [integer!]
            /size "Specify number of hex digits in result"
            length [integer!]
            return: [issue!]
        ]]
        sine: make native! [[
            "Returns the trigonometric sine"
            angle [float! integer!]
            /radians "DEPRECATED: use `sin` native instead"
            return: [float!]
        ]]
        angle: unset
        radians: unset
        cosine: make native! [[
            "Returns the trigonometric cosine"
            angle [float! integer!]
            /radians "DEPRECATED: use `cos` native instead"
            return: [float!]
        ]]
        tangent: make native! [[
            "Returns the trigonometric tangent"
            angle [float! integer!]
            /radians "DEPRECATED: use `tan` native instead"
            return: [float!]
        ]]
        arcsine: make native! [[
            {Returns the trigonometric arcsine in degrees in range [-90,90]}
            sine [float! integer!] "in range [-1,1]"
            /radians "DEPRECATED: use `asin` native instead"
            return: [float!]
        ]]
        arccosine: make native! [[
            {Returns the trigonometric arccosine in degrees in range [0,180]}
            cosine [float! integer!] "in range [-1,1]"
            /radians "DEPRECATED: use `acos` native instead"
            return: [float!]
        ]]
        arctangent: make native! [[
            {Returns the trigonometric arctangent in degrees in range [-90,90]}
            tangent [float! integer!] "in range [-inf,+inf]"
            /radians "DEPRECATED: use `atan` native instead"
            return: [float!]
        ]]
        arctangent2: make native! [[
            {Returns the smallest angle between the vectors (1,0) and (x,y) in degrees (-180,180]}
            y [float! integer!]
            x [float! integer!]
            /radians "DEPRECATED: use `atan2` native instead"
            return: [float!]
        ]]
        y: unset
        x: unset
        NaN?: make native! [[
            "Returns TRUE if the number is Not-a-Number"
            value [number!]
            return: [logic!]
        ]]
        zero?: make native! [[
            "Returns TRUE if the value is zero"
            value [number! money! pair! time! char! tuple! any-point!]
            return: [logic!]
        ]]
        log-2: make native! [[
            "Return the base-2 logarithm"
            value [float! integer! percent!]
            return: [float!]
        ]]
        log-10: make native! [[
            "Returns the base-10 logarithm"
            value [float! integer! percent!]
            return: [float!]
        ]]
        log-e: make native! [[
            {Returns the natural (base-E) logarithm of the given value}
            value [float! integer! percent!]
            return: [float!]
        ]]
        exp: make native! [[
            {Raises E (the base of natural logarithm) to the power specified}
            value [float! integer! percent!]
            return: [float!]
        ]]
        square-root: make native! [[
            "Returns the square root of a number"
            value [float! integer! percent!]
            return: [float!]
        ]]
        construct: make native! [[
            {Makes a new object from an unevaluated spec; standard logic words are evaluated}
            block [block!]
            /with "Use a prototype object"
            object [object!] "Prototype object"
            /only "Don't evaluate standard logic words"
        ]]
        block: unset
        value?: make native! [[
            "Returns TRUE if the word has a value"
            value [word!]
            return: [logic!]
        ]]
        string: unset
        as-pair: make native! [[
            "Combine X and Y values into a pair"
            x [integer! float!]
            y [integer! float!]
        ]]
        as-point2D: make native! [[
            "Combine X and Y values into a 2D point"
            x [integer! float!]
            y [integer! float!]
        ]]
        as-point3D: make native! [[
            "Combine X, Y and Z values into a 3D point"
            x [integer! float!]
            y [integer! float!]
            z [integer! float!]
        ]]
        z: unset
        as-money: make native! [[
            {Combine currency code and amount into a monetary value}
            currency [word!]
            amount [integer! float!]
            return: [money!]
        ]]
        currency: unset
        amount: unset
        break: make native! [[
            {Breaks out of a loop, while, until, repeat, foreach, etc}
            /return "Forces the loop function to return a value"
            value [any-type!]
        ]]
        continue: make native! [[
            "Throws control back to top of loop"
        ]]
        extend: make native! [[
            {Extend an object or map value with list of key and value pairs}
            obj [object! map!]
            spec [block! hash! map!]
            /case "Use case-sensitive comparison"
        ]]
        obj: unset
        debase: make native! [[
            {Decodes binary-coded string (BASE-64 default) to binary value}
            value [string!] "The string to decode"
            /base "Binary base to use"
            base-value [integer!] "The base to convert from: 64, 58, 16, or 2"
        ]]
        base: unset
        base-value: unset
        enbase: make native! [[
            {Encodes a string into a binary-coded string (BASE-64 default)}
            value [binary! string!] "If string, will be UTF8 encoded"
            /base "Binary base to use"
            base-value [integer!] "The base to convert from: 64, 58, 16, or 2"
        ]]
        to-local-file: make native! [[
            {Converts a Red file path to the local system file path}
            path [file! string!]
            /full {Prepends current dir for full path (for relative paths only)}
            return: [string!]
        ]]
        path: unset
        full: unset
        wait: make native! [[
            "Waits for a duration in seconds or specified time"
            value [number! time! block! none!]
            /all "Returns all events in a block"
        ]]
        method: unset
        unset: make native! [[
            "Unsets the value of a word in its current context"
            word [word! block!] "Word or block of words"
        ]]
        new-line: make native! [[
            {Sets or clears the new-line marker within a list series}
            position [any-list!] "Position to change marker (modified)"
            value [logic!] "Set TRUE for newline"
            /all "Set/clear marker to end of series"
            /skip {Set/clear marker periodically to the end of the series}
            size [integer!]
            return: [any-list!]
        ]]
        any-list!: make typeset! [block! paren! hash!]
        new-line?: make native! [[
            {Returns the state of the new-line marker within a list series}
            position [any-list!] "Position to check marker"
            return: [logic!]
        ]]
        context?: make native! [[
            "Returns the context to which a word is bound"
            word [any-word!] "Word to check"
            return: [object! function! none!]
        ]]
        set-env: make native! [[
            {Sets the value of an operating system environment variable (for current process)}
            var [any-string! any-word!] "Variable to set"
            value [string! none!] "Value to set, or NONE to unset it"
        ]]
        var: unset
        get-env: make native! [[
            {Returns the value of an OS environment variable (for current process)}
            var [any-string! any-word!] "Variable to get"
            return: [string! none!]
        ]]
        list-env: make native! [[
            {Returns a map of OS environment variables (for current process)}
            return: [map!]
        ]]
        now: make native! [[
            "Returns date and time"
            /year "Returns year only"
            /month "Returns month only"
            /day "Returns day of the month only"
            /time "Returns time only"
            /zone "Returns time zone offset from UTC (GMT) only"
            /date "Returns date only"
            /weekday {Returns day of the week as integer (Monday is day 1)}
            /yearday "Returns day of the year (Julian)"
            /precise "High precision time"
            /utc "Universal time (no zone)"
            return: [date! time! integer!]
        ]]
        year: unset
        month: unset
        day: unset
        time: unset
        zone: unset
        date: unset
        weekday: unset
        yearday: unset
        precise: unset
        utc: unset
        sign?: make native! [[
            {Returns sign of N as 1, 0, or -1 (to use as a multiplier)}
            number [number! money! time!]
            return: [integer!]
        ]]
        cmd: unset
        console: unset
        shell: unset
        output: unset
        err: unset
        size?: make native! [[
            "Returns the size of a file content"
            file [file!]
            return: [integer! none!]
        ]]
        url: unset
        compress: make native! [[
            "Compresses data"
            data [any-string! binary!]
            method [word!] "zlib deflate gzip"
            return: [binary!]
        ]]
        decompress: make native! [[
            "Decompresses data"
            data [binary!]
            method [word!] "zlib deflate gzip"
            /size {Specify an uncompressed data size (ignored for GZIP)}
            sz [integer!] "Uncompressed data size; must not be negative"
            return: [binary!]
        ]]
        sz: unset
        recycle: make native! [[
            {Recycles unused memory and returns memory amount still in use}
            /on "Turns on garbage collector; returns nothing"
            /off "Turns off garbage collector; returns nothing"
            /info "Returns the number of GC passes since beginning"
            return: [integer! unset!]
        ]]
        on: true
        off: false
        transcode: make native! [[
            {Translates UTF-8 binary source to values. Returns one or several values in a block}
            src [binary! string!] {UTF-8 input buffer; string argument will be UTF-8 encoded}
            /next {Translate next complete value (blocks as single value)}
            /one {Translate next complete value, returns the value only}
            /prescan {Prescans only, do not load values. Returns guessed type.}
            /scan {Scans only, do not load values. Returns recognized type.}
            /part "Translates only part of the input buffer"
            length [integer! binary!] "Length in bytes or tail position"
            /into "Optionally provides an output block"
            dst [block!]
            /trace
            callback [
                function! [
                    event [word!]
                    input [binary! string!]
                    type [word! datatype!]
                    line [integer!]
                    token
                    return: [logic!]
                ]
                routine! [
                    event [word!]
                    input [binary! string!]
                    type [word! datatype!]
                    line [integer!]
                    token
                    return: [logic!]
                ]
            ]
            return: [block!]
        ]]
        src: unset
        one: unset
        dst: unset
        line: unset
        token: unset
        apply: make native! [[
            "Apply a function to a reduced block of arguments"
            func [word! path! any-function!] "Function to apply, with eventual refinements"
            args [block!] "Block of args, reduced first"
            /all {Provide every argument in the function spec, in order, tail-completed with false/none.}
            /safer {Forces single refinement arguments, skip them when inactive instead of evaluating}
        ]]
        safer: unset
        status: unset
        quit: func [
            "Stops evaluation and exits the program"
            /return status [integer!] "Return an exit status"
        ][
            if system/console [do [_save-cfg]]
            quit-return any [status 0]
        ]
        TYPE_OF: unset
        ANY_WORD?: unset
        ERR_EXPECT_ARGUMENT: unset
        w: unset
        red-word!: unset
        node: unset
        ctx: unset
        _context: unset
        set-in: unset
        arguments: unset
        +: make op! [[
            "Returns the sum of the two values"
            value1 [scalar! vector!] "The augend"
            value2 [scalar! vector!] "The addend"
            return: [scalar! vector!] "The sum"
        ]]
        TO_CTX: unset
        no: false
        SET_RETURN: unset
        ANY_BLOCK_STRICT?: unset
        TYPE_BLOCK: unset
        blk: unset
        red-block!: unset
        rs-tail?: unset
        copy-cell: unset
        rs-head: unset
        natives: unset
        shift*: unset
        bool: unset
        red-logic!: unset
        header: unset
        TYPE_LOGIC: unset
        last-lf?: routine ["Internal Use Only"][
            bool: as red-logic! stack/arguments
            bool/header: TYPE_LOGIC
            bool/value: natives/last-lf?
        ]
        set-last: unset
        red-value!: unset
        get-current-dir: routine [{Returns the platform's current directory for the process}][
            stack/set-last as red-value! file/get-current-dir
        ]
        dir: func [{Display a directory listing, for the current dir if none is given} 'dir [any-type!]][list-dir :dir]
        red-file!: unset
        platform: unset
        set-current-dir: routine ["Sets the platform's current process directory" path [file!]][
            dir: as red-file! stack/arguments
            unless platform/set-current-dir file/to-OS-path dir [
                fire [TO_ERROR (access cannot-open) dir]
            ]
        ]
        to-OS-path: unset
        fire: unset
        TO_ERROR: unset
        cannot-open: unset
        simple-io: unset
        make-dir: func [
            {Creates the specified directory. No error if already exists}
            path [file!]
            /deep "Create subdirectories too"
            /local dirs end created dir
        ][
            if empty? path [return path]
            if slash <> last path [path: dirize path]
            if exists? path [
                if dir? path [return path]
                cause-error 'access 'cannot-open path
            ]
            if any [not deep url? path] [
                create-dir path
                return path
            ]
            path: copy path
            dirs: copy []
            while [
                all [
                    not empty? path
                    not exists? path
                    remove back tail path
                ]
            ] [
                end: any [find/last/tail path slash path]
                insert dirs copy end
                clear end
            ]
            created: copy []
            foreach dir dirs [
                path: either empty? path [dir] [path/:dir]
                append path slash
                if error? try [make-dir path] [
                    foreach dir created [attempt [delete dir]]
                    cause-error 'access 'cannot-open path
                ]
                insert created path
            ]
            path
        ]
        no-create: unset
        file-exists?: unset
        __get-OS-info: unset
        r: unset
        g: unset
        b: unset
        <: make op! [[
            {Returns TRUE if the first value is less than the second}
            value1 [any-type!]
            value2 [any-type!]
        ]]
        true: true
        <>: make op! [[
            "Returns TRUE if two values are not equal"
            value1 [any-type!]
            value2 [any-type!]
        ]]
        invalid-arg: unset
        integer: unset
        arr1: unset
        %: make op! [[
            {Returns what is left over when one value is divided by another}
            value1 [number! money! char! pair! any-point! tuple! vector! time!] "The dividend (numerator)"
            value2 [number! money! char! pair! any-point! tuple! vector! time!] "The divisor (denominator)"
            return: [number! money! char! pair! any-point! tuple! vector! time!] "The remainder"
        ]]
        <<: make op! [["Shift bits to the left" data [integer!] bits [integer!]]]
        or: make op! [[
            "Returns the first value ORed with the second"
            value1 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
            value2 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
            return: [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
        ]]
        tuple: unset
        a: unset
        c: unset
        d: unset
        as-ipv4: routine [
            "Combine a, b, c and d values into a tuple"
            a [integer!]
            b [integer!]
            c [integer!]
            d [integer!]
        ][
            err: case [
                a < 0 [a]
                b < 0 [b]
                c < 0 [c]
                d < 0 [d]
                true [0]
            ]
            if err <> 0 [fire [TO_ERROR (script invalid-arg) integer/push err]]
            arr1: (d << 24) or (c << 16) or (b << 8) or a
            stack/set-last as red-value! tuple/push 4 arr1 0 0
        ]
        start: unset
        pos: unset
        s: unset
        GET_BUFFER: unset
        p: unset
        byte-ptr!: unset
        len: unset
        unicode: unset
        fast-decode-utf8-char: unset
        as-integer: unset
        top: unset
        -: make op! [[
            "Returns the difference between two values"
            value1 [scalar! vector!] "The minuend"
            value2 [scalar! vector!] "The subtrahend"
            return: [scalar! vector!] "The difference"
        ]]
        bottom: unset
        >>: make op! [["Shift bits to the right" data [integer!] bits [integer!]]]
        idx: unset
        >: make op! [[
            {Returns TRUE if the first value is greater than the second}
            value1 [any-type!]
            value2 [any-type!]
        ]]
        stack-size?: routine [return: [integer!]][
            (as-integer stack/top - stack/bottom) >> 4
        ]
        none-value: unset
        collect-calls: routine [blk [block!]][stack/collect-calls blk]
        logic: unset
        interpreter: unset
        tracing?: routine [][logic/push interpreter/tracing?]
        clipboard: unset
        null: #"^@"
        cause-error: func [
            {Causes an immediate error throw, with the provided information}
            err-type [word!]
            err-id [word!]
            args [block! string!]
        ][
            args: reduce either block? args [args] [[args]]
            do make error! [
                type: err-type
                id: err-id
                arg1: first args
                arg2: second args
                arg3: third args
            ]
        ]
        routines: unset
        result: unset
        system: make object! [...]
        _save-cfg: func [][
            gui-console-ctx/save-cfg
        ]
        quit-return: routine [
            {Stops evaluation and exits the program with a given status}
            status [integer!] "Process termination value to return"
        ][
            quit status
        ]
        path?: func ["Returns true if the value is this type" value [any-type!]][path! = type? :value]
        words: unset
        class: unset
        values: unset
        =: make op! [[
            "Returns TRUE if two values are equal"
            value1 [any-type!]
            value2 [any-type!]
        ]]
        immediate!: make typeset! [datatype! none! logic! char! integer! float! word! set-word! lit-word! get-word! refinement! issue! typeset! pair! percent! tuple! time! handle! date! money! point2D! point3D!]
        planar!: make typeset! [pair! point2D!]
        none?: func ["Returns true if the value is this type" value [any-type!]][none! = type? :value]
        any-block?: func [{Returns true if the value is any type of any-block} value [any-type!]][find any-block! type? :value]
        pattern: unset
        parse?: unset
        form?: unset
        quote?: unset
        deep?: unset
        many?: unset
        active?: unset
        any-list?: func ["Returns true if the value is any type of any-list" value [any-type!]][find
        any-list! type? :value]
        binary?: func ["Returns true if the value is this type" value [any-type!]][binary! = type? :value]
        any-string?: func [{Returns true if the value is any type of any-string} value [any-type!]][find any-string! type? :value]
        block?: func ["Returns true if the value is this type" value [any-type!]][block! = type? :value]
        bitset?: func ["Returns true if the value is this type" value [any-type!]][
            bitset! = type? :value
        ]
        tag?: func ["Returns true if the value is this type" value [any-type!]][tag! = type? :value]
        else: unset
        also: func [
            {Returns the first value, but also evaluates the second}
            value1 [any-type!]
            value2 [any-type!]
        ][
            :value1
        ]
        series?: func ["Returns true if the value is any type of series" value [any-type!]][find
        series! type? :value]
        any-function?: func [{Returns true if the value is any type of any-function} value [any-type!]][find any-function! type? :value]
        datum: unset
        safe: unset
        order: unset
        infix: unset
        tally: unset
        recur: unset
        operator: unset
        **: make op! [[
            {Returns a number raised to a given power (exponent)}
            number [number!] "Base value"
            exponent [integer! float!] "The power (index) to raise the base value by"
            return: [number!]
        ]]
        *: make op! [[
            "Returns the product of two values"
            value1 [number! money! char! pair! tuple! vector! time! any-point!] "The multiplicand"
            value2 [number! money! char! pair! tuple! vector! time! any-point!] "The multiplier"
            return: [number! money! char! pair! tuple! vector! time! any-point!] "The product"
        ]]
        /: make op! [[
            "Returns the quotient of two values"
            value1 [number! money! char! pair! tuple! vector! time! any-point!] "The dividend (numerator)"
            value2 [number! money! char! pair! tuple! vector! time! any-point!] "The divisor (denominator)"
            return: [number! money! char! pair! tuple! vector! time! any-point!] "The quotient"
        ]]
        //: make op! func [
            {Wrapper for MOD that handles errors like REMAINDER. Negligible values (compared to A and B) are rounded to zero}
            a [number! money! char! pair! tuple! vector! time!]
            b [number! money! char! pair! tuple! vector! time!]
            return: [number! money! char! pair! tuple! vector! time!]
            /local r
        ][
            r: mod a absolute b
            either any [a - r = a r + b = b] [0] [r]
        ]
        fail: unset
        attempt: func [
            {Tries to evaluate a block and returns result or NONE on error}
            code [block!]
            /safer "Capture all possible errors and exceptions"
            /local all result
        ][
            set 'all safer
            try/:all [set/any 'result do code]
            :result
        ]
        newline: #"^/"
        buffer: {?: make function! [^/    {Displays information about functions, values, objects, and datatypes.}^/    'word [any-type!]^/]^/??: make function! [^/    "Prints a word and the value it refers to (molded)"^/    'value [word! path!]^/]^/a-an: make function! [^/    {Returns the appropriate variant of a or an (simple, vs 100% grammatically correct)}^/    str [string!]^/    /pre "Prepend to str"^/    /local tmp^/]^/about: make function! [^/    "Print Red version information"^/    /debug {Print full Red and OS version information suitable for submitting issues}^/    /cc "Also copy to clipboard"^/    /local git plt txt^/]^/absolute: make action! [^/    "Returns the non-negative value"^/    value [number! money! char! pair! time! any-point!]^/    return: [number! money! char! pair! time! any-point!]^/]^/acos: make function! [^/    {Returns the trigonometric arccosine in radians in range [0,pi]}^/    cosine [float!] "in range [-1,1]"^/]^/action?: make function! ["Returns true if the value is this type" value [any-type!]]^/add: make action! [^/    "Returns the sum of the two values"^/    value1 [scalar! vector!] "The augend"^/    value2 [scalar! vector!] "The addend"^/    return: [scalar! vector!] "The sum"^/]^/alert: make function! [^/    {Displays an alert message in a pop-up modal window}^/    msg [string! block!] "Message to display"^/]^/all: make native! [^/    {Evaluates and returns the last value if all are truthy; else NONE}^/    conds [block!]^/]^/all-word?: make function! ["Returns true if the value is any type of all-word" value [any-type!]]^/also: make function! [^/    {Returns the first value, but also evaluates the second}^/    value1 [any-type!]^/    value2 [any-type!]^/]^/alter: make function! [^/    {If a value is not found in a series, append it; otherwise, remove it. Returns true if added}^/    series [series!]^/    value^/]^/and~: make action! [^/    "Returns the first value ANDed with the second"^/    value1 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]^/    value2 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]^/    return: [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]^/]^/any: make native! [^/    {Evaluates and returns the first truthy value, if any; else NONE}^/    conds [block!]^/]^/any-block?: make function! [{Returns true if the value is any type of any-block} value [any-type!]]^/any-function?: make function! [{Returns true if the value is any type of any-function} value [any-type!]]^/any-interesting?: make function! [{Returns true if the value is any type of any-function} value [any-type!]]^/any-list?: make function! ["Returns true if the value is any type of any-list" value [any-type!]]^/any-object?: make function! [{Returns true if the value is any type of any-object} value [any-type!]]^/any-path?: make function! ["Returns true if the value is any type of any-path" value [any-type!]]^/any-point?: make function! [{Returns true if the value is any type of any-point} value [any-type!]]^/any-string?: make function! [{Returns true if the value is any type of any-string} value [any-type!]]^/any-word?: make function! ["Returns true if the value is any type of any-word" value [any-type!]]^/append: make action! [^/    {Inserts value(s) at series tail; returns series head}^/    series [series! bitset! port!]^/    value [any-type!]^/    /part "Limit the number of values inserted"^/    length [number! series!]^/    /only {Insert block types as single values (overrides /part)}^/    /dup "Duplicate the inserted values"^/    count [integer!]^/    return: [series! port! bitset!]^/]^/apply: make native! [^/    "Apply a function to a reduced block of arguments"^/    func [word! path! any-function!] "Function to apply, with eventual refinements"^/    args [block!] "Block of args, reduced first"^/    /all {Provide every argument in the function spec, in order, tail-completed with false/none.}^/    /safer {Forces single refinement arguments, skip them when inactive instead of evaluating}^/]^/arccosine: make native! [^/    {Returns the trigonometric arccosine in degrees in range [0,180]}^/    cosine [float! integer!] "in range [-1,1]"^/    /radians "DEPRECATED: use `acos` native instead"^/    return: [float!]^/]^/arcsine: make native! [^/    {Returns the trigonometric arcsine in degrees in range [-90,90]}^/    sine [float! integer!] "in range [-1,1]"^/    /radians "DEPRECATED: use `asin` native instead"^/    return: [float!]^/]^/arctangent: make native! [^/    {Returns the trigonometric arctangent in degrees in range [-90,90]}^/    tangent [float! integer!] "in range [-inf,+inf]"^/    /radians "DEPRECATED: use `atan` native instead"^/    return: [float!]^/]^/arctangent2: make native! [^/    {Returns the smallest angle between the vectors (1,0) and (x,y) in degrees (-180,180]}^/    y [float! integer!]^/    x [float! integer!]^/    /radians "DEPRECATED: use `atan2` native instead"^/    return: [float!]^/]^/as: make native! [^/    {Coerce a series into a compatible datatype without copying it}^/    type [datatype! block! paren! any-path! any-string!] "The datatype or example value"^/    spec [block! paren! any-path! any-string!] "The series to coerce"^/]^/as-color: make routine! [^/    "Combine R, G and B values into a tuple"^/    r [integer!]^/    g [integer!]^/    b [integer!]^/]^/as-ipv4: make routine! [^/    "Combine a, b, c and d values into a tuple"^/    a [integer!]^/    b [integer!]^/    c [integer!]^/    d [integer!]^/]^/as-money: make native! [^/    {Combine currency code and amount into a monetary value}^/    currency [word!]^/    amount [integer! float!]^/    return: [money!]^/]^/as-pair: make native! [^/    "Combine X and Y values into a pair"^/    x [integer! float!]^/    y [integer! float!]^/]^/as-point2D: make native! [^/    "Combine X and Y values into a 2D point"^/    x [integer! float!]^/    y [integer! float!]^/]^/as-point3D: make native! [^/    "Combine X, Y and Z values into a 3D point"^/    x [integer! float!]^/    y [integer! float!]^/    z [integer! float!]^/]^/as-rgba: make routine! [^/    {Combine R, G, B and A color components into a tuple}^/    r [integer!]^/    g [integer!]^/    b [integer!]^/    a [integer!]^/]^/asin: make function! [^/    {Returns the trigonometric arcsine in radians in range [-pi/2,pi/2])}^/    sine [float!] "in range [-1,1]"^/]^/ask: make function! [^/    "Prompt the user for input"^/    question [string!]^/    /hide^/    /history "specify the history block"^/    blk [block!]^/    return: [string!]^/    /local t? line^/]^/at: make action! [^/    "Returns a series at a given index"^/    series [series! port!]^/    index [integer! pair!]^/    return: [series! port!]^/]^/atan: make function! [^/    {Returns the trigonometric arctangent in radians in range [-pi/2,+pi/2]}^/    tangent [float!] "in range [-inf,+inf]"^/]^/atan2: make function! [^/    {Returns the smallest angle between the vectors (1,0) and (x,y) in range (-pi,pi]}^/    y [float! integer!]^/    x [float! integer!]^/    return: [float!]^/]^/attempt: make function! [^/    {Tries to evaluate a block and returns result or NONE on error}^/    code [block!]^/    /safer "Capture all possible errors and exceptions"^/    /local all result^/]^/average: make function! [^/    "Returns the average of all values in a block"^/    block [block! vector! paren! hash!]^/]^/back: make action! [^/    "Returns a series at the previous index"^/    series [series! port!]^/    return: [series! port!]^/]^/binary?: make function! ["Returns true if the value is this type" value [any-type!]]^/bind: make native! [^/    "Bind words to a context; returns rebound words"^/    word [block! any-word!]^/    context [any-word! any-object! function!]^/    /copy "Deep copy blocks before binding"^/    return: [block! any-word!]^/]^/bitset?: make function! ["Returns true if the value is this type" value [any-type!]]^/block?: make function! ["Returns true if the value is this type" value [any-type!]]^/body-of: make function! [{Returns the body of a value that supports reflection} value]^/break: make native! [^/    {Breaks out of a loop, while, until, repeat, foreach, etc}^/    /return "Forces the loop function to return a value"^/    value [any-type!]^/]^/browse: make native! [^/    {Opens the URL in a web browser or the file in the associated application}^/    url [url! file!]^/]^/call: make native! [^/    "Executes a shell command to run another process"^/    cmd [string! file!] "A shell command or an executable file"^/    /wait "Runs command and waits for exit"^/    /show {Force the display of system's shell window (Windows only)}^/    /console {Runs command with I/O redirected to console (CLI console only at present)}^/    /shell "Forces command to be run from shell"^/    /input in [string! file! binary!] "Redirects in to stdin"^/    /output out [string! file! binary!] "Redirects stdout to out"^/    /error err [string! file! binary!] "Redirects stderr to err"^/    return: [integer!] "0 if success, -1 if error, or a process ID"^/]^/caret-to-offset: make function! [^/    {Given a text position, returns the corresponding coordinate relative to the top-left of the layout box}^/    face [object!]^/    pos [integer!]^/    /lower "lower end offset of the caret"^/    return: [point2D!]^/    /local opt^/]^/case: make native! [^/    {Evaluates the block following the first truthy condition}^/    cases [block!] "Block of condition-block pairs"^/    /all {Test all conditions, evaluating the block following each truthy condition}^/]^/catch: make native! [^/    {Catches a throw from a block and returns its value}^/    block [block!] "Block to evaluate"^/    /name "Catches a named throw"^/    word [word! block!] "One or more names"^/]^/cause-error: make function! [^/    {Causes an immediate error throw, with the provided information}^/    err-type [word!]^/    err-id [word!]^/    args [block! string!]^/]^/cd: make function! [^/    "Changes the active directory path"^/    :dir [file! word! path!] {New active directory of relative path to the new one}^/]^/center-face: make function! [^/    "Center a face inside its parent"^/    face [object!] "Face to center"^/    /x "Center horizontally only"^/    /y "Center vertically only"^/    /with {Provide a reference face for centering instead of parent face}^/    parent [object!] "Reference face"^/    return: [object!] "Returns the centered face"^/    /local pos^/]^/change: make action! [^/    {Changes a value in a series and returns the series after the change}^/    series [series! port!] "Series at point to change"^/    value [any-type!] "The new value"^/    /part {Limits the amount to change to a given length or position}^/    range [number! series!]^/    /only "Changes a series as a series."^/    /dup "Duplicates the change a specified number of times"^/    count [number!]^/]^/change-dir: make function! [^/    "Changes the active directory path"^/    dir [file! word! path!] {New active directory of relative path to the new one}^/]^/char?: make function! ["Returns true if the value is this type" value [any-type!]]^/charset: make function! [^/    "Shortcut for `make bitset!`"^/    spec [block! integer! char! string! bitset! binary!]^/]^/checksum: make native! [^/    "Computes a checksum, CRC, hash, or HMAC"^/    data [binary! string! file!]^/    method [word!] {MD5 SHA1 SHA256 SHA384 SHA512 CRC32 TCP ADLER32 hash}^/    /with {Extra value for HMAC key or hash table size; not compatible with TCP/CRC32/ADLER32 methods}^/    spec [any-string! binary! integer!] {String or binary for MD5/SHA* HMAC key, integer for hash table size}^/    return: [integer! binary!]^/]^/class-of: make function! ["Returns the class ID of an object" value]^/clean-path: make function! [^/    [no-trace]^/    {Cleans-up '.' and '..' in path; returns the cleaned path}^/    file [file! url! string!]^/    /only "Do not prepend current directory"^/    /dir "Add a trailing / if missing"^/    /local out cnt f not-file? prot^/]^/clear: make action! [^/    {Removes series values from current index to tail; returns new tail}^/    series [series! port! bitset! map! none!]^/    return: [series! port! bitset! map! none!]^/]^/clear-reactions: make function! ["Removes all reactive relations"]^/clock: make function! [^/    {Display execution time of code, returning result of it's evaluation}^/    code [block!]^/    /times n [integer! float!]^/    {Repeat N times (default: once); displayed time is per iteration}^/    /local result^/    text dt unit^/]^/close: make action! [^/    "Closes a port"^/    port [port!]^/]^/collect: make function! [^/    {Collect in a new block all the values passed to KEEP function from the body block}^/    body [block!] "Block to evaluate"^/    /into {Insert into a buffer instead (returns position after insert)}^/    collected [series!] "The buffer series (modified)"^/    /local keep rule pos^/]^/collect-calls: make routine! [blk [block!]]^/comment: make function! ["Consume but don't evaluate the next value" 'value]^/complement: make action! [^/    {Returns the opposite (complementing) value of the input value}^/    value [logic! integer! tuple! bitset! typeset! binary!]^/    return: [logic! integer! tuple! bitset! typeset! binary!]^/]^/complement?: make native! [^/    "Returns TRUE if the bitset is complemented"^/    bits [bitset!]^/]^/compose: make native! [^/    "Returns a copy of a block, evaluating only parens"^/    value [block!]^/    /deep "Compose nested blocks"^/    /only {Compose nested blocks as blocks containing their values}^/    /into {Put results in out block, instead of creating a new block}^/    out [any-block!] "Target block for results, when /into is used"^/]^/compress: make native! [^/    "Compresses data"^/    data [any-string! binary!]^/    method [word!] "zlib deflate gzip"^/    return: [binary!]^/]^/construct: make native! [^/    {Makes a new object from an unevaluated spec; standard logic words are evaluated}^/    block [block!]^/    /with "Use a prototype object"^/    object [object!] "Prototype object"^/    /only "Don't evaluate standard logic words"^/]^/context: make function! [^/    "Makes a new object from an evaluated spec"^/    spec [block!]^/]^/context?: make native! [^/    "Returns the context to which a word is bound"^/    word [any-word!] "Word to check"^/    return: [object! function! none!]^/]^/continue: make native! [^/    "Throws control back to top of loop"^/]^/copy: make action! [^/    "Returns a copy of a non-scalar value"^/    value [series! any-object! bitset! map!]^/    /part "Limit the length of the result"^/    length [number! series! pair!]^/    /deep "Copy nested values"^/    /types "Copy only specific types of non-scalar values"^/    kind [datatype!]^/    return: [series! any-object! bitset! map!]^/]^/cos: make function! [^/    "Returns the trigonometric cosine"^/    angle [float!] "Angle in radians"^/]^/cosine: make native! [^/    "Returns the trigonometric cosine"^/    angle [float! integer!]^/    /radians "DEPRECATED: use `cos` native instead"^/    return: [float!]^/]^/count-chars: make routine! [^/    {Count UTF-8 encoded characters between two positions in a binary series}^/    start [binary!]^/    pos [binary!]^/    return: [integer!]^/]^/create: make action! [^/    "Send port a create request"^/    port [port! file! url! block!]^/]^/create-dir: make routine! ["Create the given directory" path [file!]]^/datatype?: make function! ["Returns true if the value is this type" value [any-type!]]^/date?: make function! ["Returns true if the value is this type" value [any-type!]]^/debase: make native! [^/    {Decodes binary-coded string (BASE-64 default) to binary value}^/    value [string!] "The string to decode"^/    /base "Binary base to use"^/    base-value [integer!] "The base to convert from: 64, 58, 16, or 2"^/]^/debug: make function! [^/    {Runs argument code through an interactive debugger}^/    code [any-type!] "Code to debug"^/    /later {Enters the interactive debugger later, on reading @stop value}^/]^/debug-info?: make function! ["Internal use only" face [object!] return: [logic!]]^/decode-url: make function! [^/    {Decode a URL into an object containing its constituent parts}^/    url [url! string!]^/]^/decompress: make native! [^/    "Decompresses data"^/    data [binary!]^/    method [word!] "zlib deflate gzip"^/    /size {Specify an uncompressed data size (ignored for GZIP)}^/    sz [integer!] "Uncompressed data size; must not be negative"^/    return: [binary!]^/]^/deep-reactor: make function! [spec [block!]]^/^/dehex: make native! [^/    "Converts URL-style hex encoded (%xx) strings"^/    value [any-string!]^/    return: [string!] "Always return a string"^/]^/delete: make action! [^/    "Deletes the specified file or empty folder"^/    file [file! port!]^/]^/difference: make native! [^/    "Returns the special difference of two data sets"^/    set1 [block! hash! string! bitset! typeset! date!]^/    set2 [block! hash! string! bitset! typeset! date!]^/    /case "Use case-sensitive comparison"^/    /skip "Treat the series as fixed size records"^/    size [integer!]^/    return: [block! hash! string! bitset! typeset! time!]^/]^/dir: make function! [{Display a directory listing, for the current dir if none is given} 'dir [any-type!]]^/dir?: make function! [{Returns TRUE if the value looks like a directory spec} file [file! url!]]^/dirize: make function! [^/    {Returns a copy of the path turned into a directory}^/    path [file! string! url!]^/]^/distance?: make function! [^/    {Returns the distance between 2 points or face centers}^/    A [object! planar!] "First face or point"^/    B [object! planar!] "Second face or point"^/    return: [float!] "Distance between them"^/    /local d^/]^/divide: make action! [^/    "Returns the quotient of two values"^/    value1 [number! money! char! pair! tuple! vector! time! any-point!] "The dividend (numerator)"^/    value2 [number! money! char! pair! tuple! vector! time! any-point!] "The divisor (denominator)"^/    return: [number! money! char! pair! tuple! vector! time! any-point!] "The quotient"^/]^/do: make native! [^/    {Evaluates a value, returning the last evaluation result}^/    value [any-type!]^/    /expand "Expand directives before evaluation"^/    /args {If value is a script, this will set its system/script/args}^/    arg "Args passed to a script (normally a string)"^/    /next {Do next expression only, return it, update block word}^/    position [word!] "Word updated with new block position"^/    /trace^/    callback [function! [^/        event [word!]^/        code [any-block! none!]^/        offset [integer!]^/        value [any-type!]^/        ref [any-type!]^/        frame [pair!]^/    ]]^/]^/do-actor: make function! ["Internal Use Only" face [object!] event [event! none!] type [word!] /local result^/act name]^/do-events: make function! [^/    {Launch the event loop, blocks until all windows are closed}^/    /no-wait "Process an event in the queue and returns at once"^/    return: [logic! word!] "Returned value from last event"^/    /local result screen win^/]^/do-file: make function! ["Internal Use Only" file [file! url!] callback [function! none!]^//local ws saved src found? code header? header new-path list c done?]^/do-no-sync: make function! [^/    "Evaluate CODE with view/auto-sync?: off"^/    code [block!]^/    /local r e old^/]^/do-safe: make function! ["Internal Use Only" code [block!] /local result error]^/do-thru: make function! [^/    {Evaluates a remote Red script through local disk cache}^/    url [url!] "Remote file address"^/    /update "Force a cache update"^/]^/does: make native! [^/    {Defines a function with no arguments or local variables}^/    body [block!]^/]^/draw: make function! [^/    "Draws scalable vector graphics to an image"^/    image [image! pair!] "Image or size for an image"^/    cmd [block!] "Draw commands"^/    /transparent "Make a transparent image, if pair! spec is used"^/    return: [image!]^/]^/dt: make function! [^/    "Returns the time required to evaluate a block"^/    body [block!]^/    return: [time!]^/    /local t0^/]^/dump-face: make function! [^/    {Display debugging info about a face and its children}^/    face [object!] "Face to analyze"^/    /local depth f^/]^/dump-reactions: make function! [^/    {Outputs all the current reactive relations for debugging purpose}^/    /local limit count obj field reaction target list^/]^/either: make native! [^/    {If conditional expression is truthy, evaluate the first branch; else evaluate the alternative}^/    cond [any-type!]^/    true-blk [block!]^/    false-blk [block!]^/]^/ellipsize-at: make function! [^/    {Truncate and add ellipsis if str is longer than len}^/    str [string!] "(modified)"^/    len [integer!] "Max length"^/]^/email?: make function! ["Returns true if the value is this type" value [any-type!]]^/empty?: make function! [^/    {Returns true if data is a series at its tail or an empty map}^/    data [series! none! map!]^/    return: [logic!]^/]^/enbase: make native! [^/    {Encodes a string into a binary-coded string (BASE-64 default)}^/    value [binary! string!] "If string, will be UTF8 encoded"^/    /base "Binary base to use"^/    base-value [integer!] "The base to convert from: 64, 58, 16, or 2"^/]^/encode-url: make function! [url-obj [object!] "What you'd get from decode-url"^//local result]^/enhex: make native! [^/    "Encode URL-style hex encoded (%xx) strings"^/    value [any-string!]^/    return: [string!] "Always return a string"^/]^/equal?: make native! [^/    "Returns TRUE if two values are equal"^/    value1 [any-type!]^/    value2 [any-type!]^/]^/error?: make function! ["Returns true if the value is this type" value [any-type!]]^/eval-set-path: make function! ["Internal Use Only" value1]^/even?: make action! [^/    {Returns true if the number is evenly divisible by 2}^/    number [number! money! char! time!]^/    return: [logic!]^/]^/event?: make routine! ["Returns true if the value is this type" value [any-type!] return: [logic!]]^/exclude: make native! [^/    {Returns the first data set less the second data set}^/    set1 [block! hash! string! bitset! typeset!]^/    set2 [block! hash! string! bitset! typeset!]^/    /case "Use case-sensitive comparison"^/    /skip "Treat the series as fixed size records"^/    size [integer!]^/    return: [block! hash! string! bitset! typeset!]^/]^/exists-thru?: make function! [^/    {Returns true if the remote file is present in the local disk cache}^/    url [url! file!] "Remote file address"^/]^/exists?: make routine! ["Returns TRUE if the file exists" path [file!] return: [logic!]]^/exit: make native! [^/    "Exits a function, returning no value"^/]^/exp: make native! [^/    {Raises E (the base of natural logarithm) to the power specified}^/    value [float! integer! percent!]^/    return: [float!]^/]^/expand: make function! [^/    {Preprocess the argument block and display the output (console only)}^/    blk [block!] "Block to expand"^/]^/expand-directives: make function! [^/    {Invokes the preprocessor on argument list, modifying and returning it}^/    code [block! paren!] "List of Red values to preprocess"^/    /clean "Clear all previously created macros and words"^/    /local job saved^/]^/extend: make native! [^/    {Extend an object or map value with list of key and value pairs}^/    obj [object! map!]^/    spec [block! hash! map!]^/    /case "Use case-sensitive comparison"^/]^/extract: make function! [^/    {Extracts a value from a series at regular intervals}^/    series [series!]^/    width [integer!] "Size of each entry (the skip)"^/    /index "Extract from an offset position"^/    pos [integer!] "The position"^/    /into {Provide an output series instead of creating a new one}^/    output [series!] "Output series"^/]^/extract-boot-args: make function! [^/    {Process command-line arguments and store values in system/options (internal usage)}^/    /local args at-arg2 ws split-mode arg-end s' e' arg2-update s e^/]^/face: make object! [^/    type: 'window^/    offset: (559.2, 339.2)^/    size: 839x654^/    text: "Red Console"^/    image: none^/    color: none^/    menu: none^/    data: none^/    enabled?: true^/    visible?: false^/    selected: make object! [^/        type: 'rich-text^/        offset: (0, 0)^/        size: 840x655^/        text: none^/        image: none^/        color: 22.22.22^/        menu: none^/        data: none^/        enabled?: true^/        visible?: true^/        selected: none^/        flags: [scrollable all-over]^/        options: [cursor: I-beam]^/        parent: make object! [...]^/        pane: none^/        state: [handle! 0 none false]^/        rate: 10^/        edge: none^/        para: none^/        font: make object! [^/            name: "Consolas"^/            size: 11^/            style: none^/            angle: 0^/            color: 222.222.222^/            anti-alias?: false^/            shadow: none^/            state: [handle! none none]^/            parent: []^/        ]^/        actors: make object! [^/            on-time: func [face [object!] event [event!]][^/                if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]^/                terminal/on-time^/                'done^/            ]^/            on-drawing: func [face [object!] event [event!]][^/                terminal/paint^/            ]^/            on-scroll: func [face [object!] event [event!]][^/                terminal/scroll event^/            ]^/            on-wheel: func [face [object!] event [event!]][^/                either event/ctrl? [^/                    terminal/zoom event^/                ] [^/                    terminal/scroll event^/                ]^/            ]^/            on-key: func [face [object!] event [event!]][^/                terminal/press-key event^/            ]^/            on-key-down: func [face [object!] event [event!]][^/                if all [1 = length? event/flags find event/flags 'alt] [^/                    switch event/key [^/                        #"A" [terminal/select-all]^/                        #"O" [show-cfg-dialog]^/                    ]^/                ]^/            ]^/            on-ime: func [face [object!] event [event!]][^/                terminal/process-ime-input event^/            ]^/            on-down: func [face [object!] event [event!]][^/                terminal/mouse-down event^/            ]^/            on-up: func [face [object!] event [event!]][^/                terminal/mouse-up event^/            ]^/            on-alt-down: func [face [object!] event [event!]][^/                if cfg/mouse-paste? = 'true [^/                    either terminal/text-selected? [^/                        terminal/copy-selection^/                        clear terminal/selects^/                        system/view/platform/redraw face^/                    ] [^/                        terminal/paste^/                    ]^/                ]^/            ]^/            on-over: func [face [object!] event [event!]][^/                terminal/mouse-move to-pair event/offset^/            ]^/            on-menu: func [face [object!] event [event!]][^/                switch event/picked [^/                    copy [terminal/copy-selection]^/                    paste [terminal/paste]^/                    select-all [terminal/select-all]^/                ]^/                'done^/            ]^/        ]^/        extra: none^/        draw: none^/        tabs: none^/        line-spacing: 'default^/        handles: none^/        init: func [/local box][^/            terminal/windows: get in get-current-screen 'pane^/            box: terminal/box^/            box/data: make block! 200^/            scroller: get-scroller self 'horizontal^/            scroller/visible?: no^/            scroller: get-scroller self 'vertical^/            scroller/position: 1^/            scroller/max-size: 2^/        ]^/    ]^/    flags: [resize]^/    options: none^/    parent: make object! [^/        type: 'screen^/        offset: 0x0^/        size: 2048x1152^/        text: none^/        image: none^/        color: none^/        menu: none^/        data: 1.25^/        enabled?: true^/        visible?: true^/        selected: none^/        flags: none^/        options: none^/        parent: none^/        pane: []^/        state: [handle! 0 none [1]]^/        rate: none^/        edge: none^/        para: none^/        font: none^/        actors: none^/        extra: none^/        draw: none^/    ]^/    pane: [make object! [^/        type: 'rich-text^/        offset: (0, 0)^/        size: 840x655^/        text: none^/        image: none^/        color: 22.22.22^/        menu: none^/        data: none^/        enabled?: true^/        visible?: true^/        selected: none^/        flags: [scrollable all-over]^/        options: [cursor: I-beam]^/        parent: make object! [...]^/        pane: none^/        state: [handle! 0 none false]^/        rate: 10^/        edge: none^/        para: none^/        font: make object! [^/            name: "Consolas"^/            size: 11^/            style: none^/            angle: 0^/            color: 222.222.222^/            anti-alias?: false^/            shadow: none^/            state: [handle! none none]^/            parent: []^/        ]^/        actors: make object! [^/            on-time: func [face [object!] event [event!]][^/                if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]^/                terminal/on-time^/                'done^/            ]^/            on-drawing: func [face [object!] event [event!]][^/                terminal/paint^/            ]^/            on-scroll: func [face [object!] event [event!]][^/                terminal/scroll event^/            ]^/            on-wheel: func [face [object!] event [event!]][^/                either event/ctrl? [^/                    terminal/zoom event^/                ] [^/                    terminal/scroll event^/                ]^/            ]^/            on-key: func [face [object!] event [event!]][^/                terminal/press-key event^/            ]^/            on-key-down: func [face [object!] event [event!]][^/                if all [1 = length? event/flags find event/flags 'alt] [^/                    switch event/key [^/                        #"A" [terminal/select-all]^/                        #"O" [show-cfg-dialog]^/                    ]^/                ]^/            ]^/            on-ime: func [face [object!] event [event!]][^/                terminal/process-ime-input event^/            ]^/            on-down: func [face [object!] event [event!]][^/                terminal/mouse-down event^/            ]^/            on-up: func [face [object!] event [event!]][^/                terminal/mouse-up event^/            ]^/            on-alt-down: func [face [object!] event [event!]][^/                if cfg/mouse-paste? = 'true [^/                    either terminal/text-selected? [^/                        terminal/copy-selection^/                        clear terminal/selects^/                        system/view/platform/redraw face^/                    ] [^/                        terminal/paste^/                    ]^/                ]^/            ]^/            on-over: func [face [object!] event [event!]][^/                terminal/mouse-move to-pair event/offset^/            ]^/            on-menu: func [face [object!] event [event!]][^/                switch event/picked [^/                    copy [terminal/copy-selection]^/                    paste [terminal/paste]^/                    select-all [terminal/select-all]^/                ]^/                'done^/            ]^/        ]^/        extra: none^/        draw: none^/        tabs: none^/        line-spacing: 'default^/        handles: none^/        init: func [/local box][^/            terminal/windows: get in get-current-screen 'pane^/            box: terminal/box^/            box/data: make block! 200^/            scroller: get-scroller self 'horizontal^/            scroller/visible?: no^/            scroller: get-scroller self 'vertical^/            scroller/position: 1^/            scroller/max-size: 2^/        ]^/    ] make object! [^/        type: 'base^/        offset: (0, 0)^/        size: 1x17^/        text: none^/        image: none^/        color: 222.222.222.1^/        menu: none^/        data: none^/        enabled?: false^/        visible?: true^/        selected: none^/        flags: none^/        options: [caret make object! [^/            type: 'rich-text^/            offset: (0, 0)^/            size: 840x655^/            text: none^/            image: none^/            color: 22.22.22^/            menu: none^/            data: none^/            enabled?: true^/            visible?: true^/            selected: none^/            flags: [scrollable all-over]^/            options: [cursor: I-beam]^/            parent: make object! [...]^/            pane: none^/            state: [handle! 0 none false]^/            rate: 10^/            edge: none^/            para: none^/            font: make object! [^/                name: "Consolas"^/                size: 11^/                style: none^/                angle: 0^/                color: 222.222.222^/                anti-alias?: false^/                shadow: none^/                state: [handle! none none]^/                parent: []^/            ]^/            actors: make object! [^/                on-time: func [face [object!] event [event!]][^/                    if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]^/                    terminal/on-time^/                    'done^/                ]^/                on-drawing: func [face [object!] event [event!]][^/                    terminal/paint^/                ]^/                on-scroll: func [face [object!] event [event!]][^/                    terminal/scroll event^/                ]^/                on-wheel: func [face [object!] event [event!]][^/                    either event/ctrl? [^/                        terminal/zoom event^/                    ] [^/                        terminal/scroll event^/                    ]^/                ]^/                on-key: func [face [object!] event [event!]][^/                    terminal/press-key event^/                ]^/                on-key-down: func [face [object!] event [event!]][^/                    if all [1 = length? event/flags find event/flags 'alt] [^/                        switch event/key [^/                            #"A" [terminal/select-all]^/                            #"O" [show-cfg-dialog]^/                        ]^/                    ]^/                ]^/                on-ime: func [face [object!] event [event!]][^/                    terminal/process-ime-input event^/                ]^/                on-down: func [face [object!] event [event!]][^/                    terminal/mouse-down event^/                ]^/                on-up: func [face [object!] event [event!]][^/                    terminal/mouse-up event^/                ]^/                on-alt-down: func [face [object!] event [event!]][^/                    if cfg/mouse-paste? = 'true [^/                        either terminal/text-selected? [^/                            terminal/copy-selection^/                            clear terminal/selects^/                            system/view/platform/redraw face^/                        ] [^/                            terminal/paste^/                        ]^/                    ]^/                ]^/                on-over: func [face [object!] event [event!]][^/                    terminal/mouse-move to-pair event/offset^/                ]^/                on-menu: func [face [object!] event [event!]][^/                    switch event/picked [^/                        copy [terminal/copy-selection]^/                        paste [terminal/paste]^/                        select-all [terminal/select-all]^/                    ]^/                    'done^/                ]^/            ]^/            extra: none^/            draw: none^/            tabs: none^/            line-spacing: 'default^/            handles: none^/            init: func [/local box][^/                terminal/windows: get in get-current-screen 'pane^/                box: terminal/box^/                box/data: make block! 200^/                scroller: get-scroller self 'horizontal^/                scroller/visible?: no^/                scroller: get-scroller self 'vertical^/                scroller/position: 1^/                scroller/max-size: 2^/            ]^/        ] cursor: I-beam accelerated: yes]^/        parent: make object! [...]^/        pane: none^/        state: [handle! 0 none false]^/        rate: 0:00:00.53^/        edge: none^/        para: none^/        font: none^/        actors: make object! [^/            on-time: func [face [object!] event [event!]][^/                face/color: either face/color = caret-clr [255.255.255.254] [caret-clr]^/                'done^/            ]^/        ]^/        extra: none^/        draw: none^/    ] make object! [^/        type: 'panel^/        offset: (0, 0)^/        size: 150x200^/        text: none^/        image: none^/        color: 0.0.128^/        menu: none^/        data: none^/        enabled?: true^/        visible?: false^/        selected: none^/        flags: none^/        options: none^/        parent: make object! [...]^/        pane: none^/        state: [handle! 0 none false]^/        rate: none^/        edge: none^/        para: none^/        font: make object! [^/            name: "Consolas"^/            size: 11^/            style: none^/            angle: 0^/            color: 255.255.255^/            anti-alias?: false^/            shadow: none^/            state: [handle! none none]^/            parent: [make object! [^/                type: 'rich-text^/                offset: none^/                size: 820x655^/                text: "XXXXXXXXXX"^/                image: none^/                color: none^/                menu: none^/                data: []^/                enabled?: true^/                visible?: true^/                selected: none^/                flags: none^/                options: none^/                parent: none^/                pane: none^/                state: none^/                rate: none^/                edge: none^/                para: none^/                font: make object! [^/                    name: "Consolas"^/                    size: 11^/                    style: none^/                    angle: 0^/                    color: 222.222.222^/                    anti-alias?: false^/                    shadow: none^/                    state: [handle! none none]^/                    parent: [...]^/                ]^/                actors: none^/                extra: none^/                draw: none^/                tabs: 32.4^/                line-spacing: 17^/                handles: [handle! handle! "XXXXXXXXXX" true]^/            ]]^/        ]^/        actors: make object! [^/            on-key-down: func [face [object!] event [event!]][^/                probe event/key^/            ]^/        ]^/        extra: none^/        draw: none^/    ]]^/    state: [handle! 0 none false]^/    rate: none^/    edge: none^/    para: none^/    font: none^/    actors: make object! [^/        on-menu: func [face [object!] event [event!] /local ft f][^/            switch event/picked [^/                about-msg [display-about]^/                shortcuts [show-shortcuts]^/                quit [self/on-close face event]^/                run-file [if f: request-file [terminal/run-file f]]^/                choose-font [^/                    if ft: request-font/font/mono font [^/                        font: ft^/                        console/font: font^/                        terminal/zoom font^/                    ]^/                ]^/                settings [show-cfg-dialog]^/            ]^/        ]^/        on-close: func [face [object!] event [event!]][^/            system/view/platform/exit-event-loop^/            foreach screen system/view/screens [clear head screen/pane]^/            quit^/        ]^/        on-resizing: func [face [object!] event [event!]^/        /local new-sz][^/            new-sz: to-pair event/offset + 1x1^/            console/size: new-sz^/            terminal/resize new-sz^/            terminal/adjust-console-size new-sz^/            unless system/view/auto-sync? [show face]^/        ]^/        on-resize: func [face [object!] event [event!]^/        /local new-sz][^/            new-sz: to-pair event/offset + 1x1^/            console/size: new-sz^/            terminal/resize new-sz^/            terminal/adjust-console-size new-sz^/            unless system/view/auto-sync? [show face]^/        ]^/        on-focus: func [face [object!] event [event!]][^/            focused?: yes^/            caret/color: caret-clr^/            unless caret/enabled? [caret/enabled?: yes]^/            caret/rate: caret-rate^/            terminal/refresh/force^/        ]^/        on-unfocus: func [face [object!] event [event!]][^/            focused?: no^/            if caret/enabled? [caret/enabled?: no]^/            caret/rate: none^/        ]^/        on-key-down: func [face [object!] event [event!]][^/            if event/key = 'F12 [^/                cfg/menu-bar?: to-word none? face/menu^/                toggle-menu-bar^/            ]^/        ]^/    ]^/    extra: none^/    draw: none^/]^/^/face?: make function! [^/    "Returns TRUE if the value is a face! object"^/    value "Value to test"^/    return: [logic!]^/]^/fetch-help: make function! [^/    {Returns information about functions, values, objects, and datatypes.}^/    'word [any-type!] "Omit the word arg for HELP usage."^/    /local ref-given? value^/]^/fifth: make function! ["Returns the fifth value in a series" s [series! tuple! date!]]^/file?: make function! ["Returns true if the value is this type" value [any-type!]]^/find: make action! [^/    {Returns the series where a value is found, or NONE}^/    series [series! bitset! typeset! port! map! none!]^/    value [any-type!] {Typesets and datatypes can be used to search by datatype}^/    /part "Limit the length of the search"^/    length [number! series!]^/    /only {Treat series and typeset value arguments as single values}^/    /case "Perform a case-sensitive search"^/    /same {Use "same?" as comparator}^/    /any "TBD: Use * and ? wildcards in string searches"^/    /with "TBD: Use custom wildcards in place of * and ?"^/    wild [string!]^/    /skip "Treat the series as fixed size records"^/    size [integer!]^/    /last "Find the last occurrence of value, from the tail"^/    /reverse {Find the last occurrence of value, from the current index}^/    /tail {Return the tail of the match found, rather than the head}^/    /match "Match at current index only"^/]^/find-flag?: make routine! [^/    "Checks a flag in a face object"^/    facet [any-type!]^/    flag [word!]^/]^/first: make function! ["Returns the first value in a series" s [series! tuple! pair! any-point! date! time!]]^/flip-exe-flag: make function! [^/    {Flip the sub-system for the red.exe between console and GUI modes (Windows only)}^/    path [file!] "Path to the red.exe"^/    /local file buffer flag^/]^/float?: make function! ["Returns true if the value is this type" value [any-type!]]^/^/forall: make native! [^/    "Evaluates body for all values in a series"^/    'word [word!] "Word referring to series to iterate over"^/    body [block!]^/]^/foreach: make native! [^/    "Evaluates body for each value in a series"^/    'word [word! block!] "Word, or words, to set on each iteration"^/    series [series! map!]^/    body [block!]^/]^/foreach-face: make function! [^/    {Evaluates body for each face in a face tree matching the condition}^/    face [object!] "Root face of the face tree"^/    body [block! function!] {Body block (`face` object) or function `func [face [object!]]`}^/    /with "Filter faces according to a condition"^/    spec [block! none!] "Condition applied to face object"^/    /post {Evaluates body for current face after processing its children}^/    /sub post? "Do not rebind body and spec, internal use only"^/    /local exec^/]^/forever: make native! [^/    "Evaluates body repeatedly forever"^/    body [block!]^/]^/form: make action! [^/    {Returns a user-friendly string representation of a value}^/    value [any-type!]^/    /part "Limit the length of the result"^/    limit [integer!]^/    return: [string!]^/]^/fourth: make function! ["Returns the fourth value in a series" s [series! tuple! date!]]^/frame-index?: make routine! [return: [integer!]]^/func: make native! [^/    "Defines a function with a given spec and body"^/    spec [block!]^/    body [block!]^/]^/function: make native! [^/    {Defines a function, making all set-words found in body, local}^/    spec [block!]^/    body [block!]^/    /extern "Exclude words that follow this refinement"^/]^/function?: make function! ["Returns true if the value is this type" value [any-type!]]^/get: make native! [^/    "Returns the value a word refers to"^/    word [any-word! any-path! object!]^/    /any {If word has no value, return UNSET rather than causing an error}^/    /case "Use case-sensitive comparison (path only)"^/    return: [any-type!]^/]^/get-caret-blink-time: make routine! [^/    return: [integer!]^/]^/get-current-dir: make routine! [{Returns the platform's current directory for the process}]^/get-current-screen: make function! [^/    {Returns the screen face of the Display where the mouse cursor is currently located}^/    return: [object!] "Screen face"^/    /local handle screen^/]^/get-env: make native! [^/    {Returns the value of an OS environment variable (for current process)}^/    var [any-string! any-word!] "Variable to get"^/    return: [string! none!]^/]^/get-face-pane: make function! [^/    "Returns the list of a container children or none"^/    face [object!] "Face container"^/    return: [block! none!]^/]^/get-focusable: make function! [^/    "Returns the next focusable face from a face tree"^/    faces [block!] "Position to start from in a face's pane"^/    /back "Search backward"^/    /local origin checks flags f pane p^/]^/get-path?: make function! ["Returns true if the value is this type" value [any-type!]]^/get-scroller: make function! [^/    "return a scroller object from a face"^/    face [object!]^/    orientation [word!]^/    return: [object!]^/]^/get-sys-words: make function! [test [function!]]^/get-word?: make function! ["Returns true if the value is this type" value [any-type!]]^/greater-or-equal?: make native! [^/    {Returns TRUE if the first value is greater than or equal to the second}^/    value1 [any-type!]^/    value2 [any-type!]^/]^/greater?: make native! [^/    {Returns TRUE if the first value is greater than the second}^/    value1 [any-type!]^/    value2 [any-type!]^/]^/^/halt: make function! ["Stops evaluation and returns to the input prompt"]^/handle?: make function! ["Returns true if the value is this type" value [any-type!]]^/has: make native! [^/    {Defines a function with local variables, but no arguments}^/    vars [block!]^/    body [block!]^/]^/hash?: make function! ["Returns true if the value is this type" value [any-type!]]^/head: make action! [^/    "Returns a series at its first index"^/    series [series! port!]^/    return: [series! port!]^/]^/head?: make action! [^/    "Returns true if a series is at its first index"^/    series [series! port!]^/    return: [logic!]^/]^/help: make function! [^/    {Displays information about functions, values, objects, and datatypes.}^/    'word [any-type!]^/]^/^/help-string: make function! [^/    {Returns information about functions, values, objects, and datatypes.}^/    'word [any-type!] "Omit the word arg for HELP usage."^/    /local ref-given? value^/]^/hex-to-rgb: make function! [^/    {Converts a color in hex format to a tuple value; returns NONE if it fails}^/    hex [issue!] "Accepts #rgb, #rrggbb, #rrggbbaa"^/    return: [tuple! none!]^/    /local str bin^/]^/^/if: make native! [^/    {If conditional expression is truthy, evaluate block; else return NONE}^/    cond [any-type!]^/    then-blk [block!]^/]^/image?: make function! ["Returns true if the value is this type" value [any-type!]]^/immediate?: make function! [{Returns true if the value is any type of immediate} value [any-type!]]^/in: make native! [^/    {Returns the given word bound to the object's context}^/    object [any-object! any-function!]^/    word [any-word! refinement!]^/]^/index?: make action! [^/    {Returns the current index of series relative to the head, or of word in a context}^/    series [series! port! any-word!]^/    return: [integer!]^/]^/input: make function! ["Wait for console user input" return: [string!]]^/insert: make action! [^/    {Inserts value(s) at series index; returns series past the insertion}^/    series [series! port! bitset!]^/    value [any-type!]^/    /part "Limit the number of values inserted"^/    length [number! series!]^/    /only {Insert block types as single values (overrides /part)}^/    /dup "Duplicate the inserted values"^/    count [integer!]^/    return: [series! port! bitset!]^/]^/insert-event-func: make function! [^/    {Adds a function to monitor global events. Returns the function}^/    name [word!]^/    fun [block! function!] "A function or a function body block"^/    /local svh^/]^/integer?: make function! ["Returns true if the value is this type" value [any-type!]]^/intersect: make native! [^/    "Returns the intersection of two data sets"^/    set1 [block! hash! string! bitset! typeset!]^/    set2 [block! hash! string! bitset! typeset!]^/    /case "Use case-sensitive comparison"^/    /skip "Treat the series as fixed size records"^/    size [integer!]^/    return: [block! hash! string! bitset! typeset!]^/]^/is: make function! []^/issue?: make function! ["Returns true if the value is this type" value [any-type!]]^/keys-of: make function! [{Returns the list of words of a value that supports reflection} value]^/last: make function! ["Returns the last value in a series" s [series! tuple!]]^/last-lf?: make routine! ["Internal Use Only"]^/last?: make function! [^/    "Returns TRUE if the series length is 1"^/    series [series!]^/]^/layout: make function! [^/    [no-trace]^/    {Return a face with a pane built from a VID description}^/    spec [block!] "Dialect block of styles, attributes, and layouts"^/    /tight "Zero offset and origin"^/    /options^/    user-opts [block!] "Optional features in [name: value] format"^/    /flags^/    flgs [block! word!] "One or more window flags"^/    /only "Returns only the pane block"^/    /parent^/    panel [object!]^/    divides [integer! none!]^/    /styles "Use an existing styles list"^/    css [block!] "Styles list"^/    /local axis anti^/    background! list reactors local-styles pane-size direction align begin size max-sz current global? below? origin spacing top-left bound cursor opts opt-words re-align sz words reset focal-face svmp pad value anti2 at-offset later? name styling? style styled? st actors face h pos styled w blk vid-align prev mar divide? index dir pad2 image^/]^/length?: make action! [^/    {Returns the number of values in the series, from the current index to the tail}^/    series [series! port! bitset! map! tuple! none!]^/    return: [integer! none!]^/]^/lesser-or-equal?: make native! [^/    {Returns TRUE if the first value is less than or equal to the second}^/    value1 [any-type!]^/    value2 [any-type!]^/]^/lesser?: make native! [^/    {Returns TRUE if the first value is less than the second}^/    value1 [any-type!]^/    value2 [any-type!]^/]^/link-sub-to-parent: make function! ["Internal Use Only" face [object!] type [word!] old new^//local parent]^/link-tabs-to-parent: make function! [^/    "Internal Use Only"^/    face [object!]^/    /init "Force /show of first tab"^/    /local faces visible?^/]^/list-dir: make function! [^/    {Displays a list of files and directories from given folder or current one}^/    dir [any-type!] "Folder to list"^/    /col "Forces the display in a given number of columns"^/    n [integer!] "Number of columns"^/    /local list limit max-sz name^/]^/list-env: make native! [^/    {Returns a map of OS environment variables (for current process)}^/    return: [map!]^/]^/lit-path?: make function! ["Returns true if the value is this type" value [any-type!]]^/lit-word?: make function! ["Returns true if the value is this type" value [any-type!]]^/ll: make function! [{Display a single column directory listing, for the current dir if none is given} 'dir [any-type!]]^/load: make function! [^/    {Returns a value or block of values by reading and evaluating a source}^/    source [file! url! string! binary!]^/    /header "TBD"^/    /all {Load all values, returns a block. TBD: Don't evaluate Red header}^/    /trap {Load all values, returns [[values] position error]}^/    /next {Load the next value only, updates source series word}^/    position [word!] "Word updated with new series position"^/    /part "Limit to a length or position"^/    length [integer! string!]^/    /into {Put results in out block, instead of creating a new block}^/    out [block!] "Target block for results"^/    /as {Specify the type of data; use NONE to load as code}^/    type [word! none!] "E.g. bmp, gif, jpeg, png, redbin, json, csv"^/    /local codec suffix name mime pre-load^/]^/load-csv: make function! [^/    {Converts CSV text to a block of rows, where each row is a block of fields.}^/    data [string!] "Text CSV data to load"^/    /with^/    delimiter [char! string!] "Delimiter to use (default is comma)"^/    /header {Treat first line as header; implies /as-columns if /as-records is not used}^/    /as-columns {Returns named columns; default names if /header is not used}^/    /as-records {Returns records instead of rows; default names if /header is not used}^/    /flat {Returns a flat block; you need to know the number of fields}^/    /trim "Ignore spaces between quotes and delimiter"^/    /quote^/    qt-char [char!] {Use different character for quotes than double quote (")}^/    /local disallowed refs output out-map longest line value record newline quotchars valchars quoted-value char normal-value s e single-value values add-value add-line length index line-rule init parsed? mark key-index key^/]^/load-json: make function! [^/    "Convert a JSON string to Red data"^/    input [string!] "The JSON string"^/]^/load-thru: make function! [^/    "Loads a remote file through local disk cache"^/    url [url!] "Remote file address"^/    /update "Force a cache update"^/    /as {Specify the type of data; use NONE to load as code}^/    type [word! none!] "E.g. bmp, gif, jpeg, png"^/    /local path file^/]^/log-10: make native! [^/    "Returns the base-10 logarithm"^/    value [float! integer! percent!]^/    return: [float!]^/]^/log-2: make native! [^/    "Return the base-2 logarithm"^/    value [float! integer! percent!]^/    return: [float!]^/]^/log-e: make native! [^/    {Returns the natural (base-E) logarithm of the given value}^/    value [float! integer! percent!]^/    return: [float!]^/]^/logic?: make function! ["Returns true if the value is this type" value [any-type!]]^/loop: make native! [^/    "Evaluates body a number of times"^/    count [integer! float!]^/    body [block!]^/]^/lowercase: make native! [^/    "Converts string of characters to lowercase"^/    string [any-string! char!] "Value to convert (modified when series)"^/    /part "Limits to a given length or position"^/    limit [number! any-string!]^/    return: [any-string! char!]^/]^/ls: make function! [{Display a directory listing, for the current dir if none is given} 'dir [any-type!]]^/make: make action! [^/    {Returns a new value made from a spec for that value's type}^/    type [any-type!] "The datatype, an example or prototype value"^/    spec [any-type!] "The specification of the new value"^/    return: [any-type!] "Returns the specified datatype"^/]^/make-dir: make function! [^/    {Creates the specified directory. No error if already exists}^/    path [file!]^/    /deep "Create subdirectories too"^/    /local dirs end created dir^/]^/make-face: make function! [^/    {Make a face from a given style name or example face}^/    style [word!] "A face type"^/    /spec^/    blk [block!] "Spec block of face options expressed in VID"^/    /offset^/    xy [pair!] "Offset of the face"^/    /size^/    wh [pair!] "Size of the face"^/    /local^/    svv face styles model opts css^/]^/map?: make function! ["Returns true if the value is this type" value [any-type!]]^/math: make function! [^/    "Evaluates expression using math precedence rules"^/    datum [block! paren!] "Expression to evaluate"^/    /safe "Returns NONE on error"^/    /local match^/    order infix tally enter recur count operator^/]^/max: make native! [^/    "Returns the greater of the two values"^/    value1 [scalar! series!]^/    value2 [scalar! series!]^/]^/metrics?: make function! [^/    {Returns a pair! value in the type metrics for the argument face}^/    face [object!] "Face object to query"^/    type [word!] "Metrics type: 'paddings or 'margins"^/    /total "Return the addition of metrics along an axis"^/    axis [word!] "Axis to use for addition: 'x or 'y"^/    /local res^/]^/min: make native! [^/    "Returns the lesser of the two values"^/    value1 [scalar! series!]^/    value2 [scalar! series!]^/]^/mod: make function! [^/    "Compute a nonnegative remainder of A divided by B"^/    a [number! money! char! pair! tuple! vector! time!]^/    b [number! money! char! pair! tuple! vector! time!] "Must be nonzero"^/    return: [number! money! char! pair! tuple! vector! time!]^/    /local r^/]^/modify: make action! [^/    "Change mode for target aggregate value"^/    target [object! series! bitset!]^/    field [word!]^/    value [any-type!]^/    /case "Perform a case-sensitive lookup"^/]^/modulo: make function! [^/    {Wrapper for MOD that handles errors like REMAINDER. Negligible values (compared to A and B) are rounded to zero}^/    a [number! money! char! pair! tuple! vector! time!]^/    b [number! money! char! pair! tuple! vector! time!]^/    return: [number! money! char! pair! tuple! vector! time!]^/    /local r^/]^/mold: make action! [^/    {Returns a source format string representation of a value}^/    value [any-type!]^/    /only "Exclude outer brackets if value is a block"^/    /all "TBD: Return value in loadable format"^/    /flat "Exclude all indentation"^/    /part "Limit the length of the result"^/    limit [integer!]^/    return: [string!]^/]^/money?: make function! ["Returns true if the value is this type" value [any-type!]]^/move: make action! [^/    {Moves one or more elements from one series to another position or series}^/    origin [series! port!]^/    target [series! port!]^/    /part "Limit the number of values inserted"^/    length [integer!]^/    return: [series! port!]^/]^/multiply: make action! [^/    "Returns the product of two values"^/    value1 [number! money! char! pair! tuple! vector! time! any-point!] "The multiplicand"^/    value2 [number! money! char! pair! tuple! vector! time! any-point!] "The multiplier"^/    return: [number! money! char! pair! tuple! vector! time! any-point!] "The product"^/]^/NaN?: make native! [^/    "Returns TRUE if the number is Not-a-Number"^/    value [number!]^/    return: [logic!]^/]^/native?: make function! ["Returns true if the value is this type" value [any-type!]]^/negate: make action! [^/    "Returns the opposite (additive inverse) value"^/    number [number! money! bitset! pair! time! any-point!]^/    return: [number! money! bitset! pair! time! any-point!]^/]^/negative?: make native! [^/    "Returns TRUE if the number is negative"^/    number [number! money! time!]^/    return: [logic!]^/]^/new-line: make native! [^/    {Sets or clears the new-line marker within a list series}^/    position [any-list!] "Position to change marker (modified)"^/    value [logic!] "Set TRUE for newline"^/    /all "Set/clear marker to end of series"^/    /skip {Set/clear marker periodically to the end of the series}^/    size [integer!]^/    return: [any-list!]^/]^/new-line?: make native! [^/    {Returns the state of the new-line marker within a list series}^/    position [any-list!] "Position to check marker"^/    return: [logic!]^/]^/next: make action! [^/    "Returns a series at the next index"^/    series [series! port!]^/    return: [series! port!]^/]^/no-react: make function! [^/    {Evaluates a block with all previously defined reactions disabled}^/    body [block!] "Code block to evaluate"^/    /local result^/]^/none?: make function! ["Returns true if the value is this type" value [any-type!]]^/normalize-dir: make function! [^/    "Returns an absolute directory spec"^/    dir [file! word! path!]^/]^/not: make native! [^/    {Returns the logical complement of a value (truthy or falsy)}^/    value [any-type!]^/]^/not-equal?: make native! [^/    "Returns TRUE if two values are not equal"^/    value1 [any-type!]^/    value2 [any-type!]^/]^/now: make native! [^/    "Returns date and time"^/    /year "Returns year only"^/    /month "Returns month only"^/    /day "Returns day of the month only"^/    /time "Returns time only"^/    /zone "Returns time zone offset from UTC (GMT) only"^/    /date "Returns date only"^/    /weekday {Returns day of the week as integer (Monday is day 1)}^/    /yearday "Returns day of the year (Julian)"^/    /precise "High precision time"^/    /utc "Universal time (no zone)"^/    return: [date! time! integer!]^/]^/number?: make function! ["Returns true if the value is any type of number" value [any-type!]]^/object: make function! [^/    "Makes a new object from an evaluated spec"^/    spec [block!]^/]^/object?: make function! ["Returns true if the value is this type" value [any-type!]]^/odd?: make action! [^/    {Returns true if the number has a remainder of 1 when divided by 2}^/    number [number! money! char! time!]^/    return: [logic!]^/]^/offset-to-caret: make function! [^/    {Given a coordinate, returns the corresponding caret position}^/    face [object!]^/    pt [planar!]^/    return: [integer!]^/]^/offset-to-char: make function! [^/    {Given a coordinate, returns the corresponding character position}^/    face [object!]^/    pt [planar!]^/    return: [integer!]^/]^/offset?: make function! [^/    "Returns the offset between two series positions"^/    series1 [series!]^/    series2 [series!]^/]^/on-face-deep-change*: make function! ["Internal use only" owner word target action new index part state forced?^//local w diff? faces face modal? screen pane]^/op?: make function! ["Returns true if the value is this type" value [any-type!]]^/open: make action! [^/    {Opens a port; makes a new port from a specification if necessary}^/    port [port! file! url! block!]^/    /new "Create new file - if it exists, deletes it"^/    /read "Open for read access"^/    /write "Open for write access"^/    /seek "Optimize for random access"^/    /allow "Specificies right access attributes"^/    access [block!]^/]^/open?: make action! [^/    "Returns TRUE if port is open"^/    port [port!]^/]^/or~: make action! [^/    "Returns the first value ORed with the second"^/    value1 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]^/    value2 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]^/    return: [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]^/]^/os-info: make routine! [{Returns detailed operating system version information}]^/overlap?: make function! [^/    {Return TRUE if the two faces bounding boxes are overlapping}^/    A [object!] "First face"^/    B [object!] "Second face"^/    return: [logic!] "TRUE if overlapping"^/    /local A1 B1 A2 B2^/]^/pad: make function! [^/    "Pad a FORMed value on right side with spaces"^/    str "Value to pad, FORM it if not a string"^/    n [integer!] "Total size (in characters) of the new string"^/    /left "Pad the string on left side"^/    /with "Pad with char"^/    c [char!]^/    return: [string!] "Modified input string at head"^/]^/pair?: make function! ["Returns true if the value is this type" value [any-type!]]^/^/paren?: make function! ["Returns true if the value is this type" value [any-type!]]^/parse: make native! [^/    "Process a series using dialected grammar rules"^/    input [binary! any-block! any-string!]^/    rules [block!]^/    /case "Uses case-sensitive comparison"^/    /part "Limit to a length or position"^/    length [number! series!]^/    /trace^/    callback [function! [^/        event [word!]^/        match? [logic!]^/        rule [block!]^/        input [series!]^/        stack [block!]^/        return: [logic!]^/    ]]^/    return: [logic! block!]^/]^/parse-trace: make function! [^/    {Wrapper for parse/trace using the default event processor}^/    input [series!]^/    rules [block!]^/    /case "Uses case-sensitive comparison"^/    /part "Limit to a length or position"^/    limit [integer!]^/    return: [logic! block!]^/]^/path-thru: make function! [^/    {Returns the local disk cache path of a remote file}^/    url [url!] "Remote file address"^/    return: [file!]^/    /local so hash file path^/]^/path?: make function! ["Returns true if the value is this type" value [any-type!]]^/percent?: make function! ["Returns true if the value is this type" value [any-type!]]^/pick: make action! [^/    "Returns the series value at a given index"^/    series [series! port! bitset! pair! any-point! tuple! money! date! time! event!]^/    index [scalar! any-string! any-word! block! logic! time!]^/    return: [any-type!]^/]^/pick-stack: make routine! [^/    idx [integer!]^/]^/planar?: make function! ["Returns true if the value is any type of planar" value [any-type!]]^/point2D?: make function! ["Returns true if the value is this type" value [any-type!]]^/point3D?: make function! ["Returns true if the value is this type" value [any-type!]]^/poke: make action! [^/    {Replaces the series value at a given index, and returns the new value}^/    series [series! port! bitset!]^/    index [scalar! any-string! any-word! block! logic!]^/    value [any-type!]^/    return: [series! port! bitset!]^/]^/positive?: make native! [^/    "Returns TRUE if the number is positive"^/    number [number! money! time!]^/    return: [logic!]^/]^/power: make action! [^/    {Returns a number raised to a given power (exponent)}^/    number [number!] "Base value"^/    exponent [integer! float!] "The power (index) to raise the base value by"^/    return: [number!]^/]^/preprocessor: make object! [^/    exec: make object! [^/        config: make object! [^/            config-name: 'Windows^/            OS: 'Windows^/            OS-version: 0^/            ABI: none^/            link?: true^/            debug?: false^/            encap?: false^/            build-prefix: %""^/            build-basename: %/home/dk/static.red-lang.org/dl/auto/win/red-view-06mar26-698eac0d8.exe^/            build-suffix: none^/            format: 'PE^/            type: 'exe^/            target: 'IA-32^/            cpu-version: 6.0^/            verbosity: 0^/            sub-system: 'GUI^/            runtime?: true^/            use-natives?: false^/            debug-safe?: true^/            dev-mode?: false^/            need-main?: false^/            PIC?: false^/            base-address: none^/            dynamic-linker: none^/            syscall: 'Linux^/            export-ABI: none^/            stack-align-16?: false^/            literal-pool?: false^/            unicode?: false^/            red-pass?: true^/            red-only?: false^/            red-store-bodies?: true^/            red-strict-check?: true^/            red-tracing?: true^/            red-help?: true^/            redbin-compress?: false^/            legacy: none^/            gui-console?: true^/            libRed?: false^/            libRedRT?: false^/            libRedRT-update?: false^/            GUI-engine: 'native^/            draw-engine: none^/            modules: [View JSON CSV]^/            show: none^/            command-line: none^/            show-func-map?: false^/        ]^/    ]^/    protos: []^/    macros: [<none>]^/    stack: []^/    syms: []^/    depth: 0^/    active?: true^/    trace?: false^/    s: none^/    do-quit: func [][^/        case [^/            all [rebol system/options/args] [quit/return 1]^/            all [not rebol system/console] [throw/name 'halt-request 'console]^/            'else [halt]^/        ]^/    ]^/    throw-error: func [error [error!] cmd [issue!] code [block!] /local w][^/        prin ["*** Preprocessor Error in" mold cmd lf]^/        error/where: new-line/all reduce [cmd] no^/        print form :error^/        either system/console [throw/name 'halt-request 'console] [halt]^/    ]^/    syntax-error: func [s [block! paren!] e [block! paren!]][^/        print [^/            "*** Preprocessor Error: Syntax error^^/"^/            "*** Where:" trim/head mold/only copy/part s next e^/        ]^/        do-quit^/    ]^/    do-safe: func [code [block! paren!] /manual /with cmd [issue!] /local res t? src][^/        if t?: all [trace? not with] [^/            print [^/                "preproc: matched" mold/flat copy/part get code/2 get code/3 lf^/                "preproc: eval macro" copy/part mold/flat body-of first code 80^/            ]^/        ]^/        if error? set/any 'res try code [throw-error :res any [cmd #macro] code]^/        if all [^/            manual^/            any [^/                (type? src: get code/2) <> type? get/any 'res^/                not same? head src head get/any 'res^/            ]^/        ] [^/            print [^/                {*** Macro Error: [manual] macro not returning a position^^/}^/                "*** Where:" mold code^/            ]^/            do-quit^/        ]^/        if t? [print ["preproc: ==" mold get/any 'res]]^/        either unset? get/any 'res [[]] [:res]^/    ]^/    do-code: func [code [block! paren!] cmd [issue!] /local p][^/        clear syms^/        parse code [any [^/            p: set-word! (unless in exec p/1 [append syms p/1])^/            | skip^/        ]]^/        unless empty? syms [^/            exec: make exec append syms none^/            rebind-all^/        ]^/        do-safe/with bind to block! code exec cmd^/    ]^/    rebind-all: func [/local rule p][^/        protos: bind protos exec^/        parse macros rule: [^/            any [p: function! (bind body-of first p exec) | p: [block! | paren!] :p into rule | skip]^/        ]^/    ]^/    count-args: func [spec [block!] /block /local total pos][^/        total: either block [copy []] [0]^/        parse spec [^/            any [^/                pos: [word! | lit-word! | get-word!] (^/                    either block [append total type? pos/1] [total: total + 1]^/                )^/                | refinement! (return total)^/                | skip^/            ]^/        ]^/        total^/    ]^/    arg-mode?: func [spec [block!] idx [integer!]][^/        pick count-args/block spec idx^/    ]^/    func-arity?: func [spec [block!] /with path [path!] /block /local arity pos][^/        arity: either block [count-args/block spec] [count-args spec]^/        if path [^/            foreach word next path [^/                unless pos: find/tail spec to refinement! word [^/                    print [^/                        "*** Macro Error: unknown refinement^^/"^/                        "*** Where:" mold path^/                    ]^/                    do-quit^/                ]^/                either block^/                [append arity count-args/block pos]^/                [arity: arity + count-args pos]^/            ]^/        ]^/        arity^/    ]^/    value-path?: func [path [path!] /local value i item selectable][^/        selectable: make typeset! [^/            block! paren! path! lit-path! set-path! get-path!^/            object! port! error! map!^/        ]^/        repeat i length? path [^/            set/any 'value either i = 1 [get/any first path] [^/                set/any 'item pick path i^/                case [^/                    get-word? :item [set/any 'item get/any to word! item]^/                    paren? :item [set/any 'item do item]^/                ]^/                either integer? :item [pick value item] [select value :item]^/            ]^/            unless find selectable type? get/any 'value [^/                path: copy/part path i^/                break^/            ]^/        ]^/        reduce [path get/any 'value]^/    ]^/    fetch-next: func [code [block! paren!] /local i left item item2 value fn-spec path f-arity at-op? op-mode][^/        left: reduce [yes]^/        while [all [not tail? left not tail? code]] [^/            either not left/1 [^/                remove left^/            ] [^/                item: first code^/                f-arity: any [^/                    all [^/                        word? :item^/                        any-function? set/any 'value get/any :item^/                        func-arity?/block fn-spec: spec-of get/any :item^/                    ]^/                    all [^/                        path? :item^/                        set/any [path value] value-path? :item^/                        any-function? get/any 'value^/                        func-arity?/block/with^/                        fn-spec: spec-of :value^/                        at :item length? :path^/                    ]^/                ]^/                if at-op?: all [^/                    1 < length? code^/                    word? item2: second code^/                    op? get/any :item2^/                ] [^/                    if all [f-arity 1 < length? f-arity] [^/                        at-op?: word! = arg-mode? fn-spec 1^/                    ]^/                ]^/                case [^/                    at-op? [^/                        code: next code^/                        left/1: word! = arg-mode? spec-of get/any :item2 2^/                    ]^/                    f-arity [^/                        if op? get/any 'value [return skip code 2]^/                        remove left^/                        repeat i length? f-arity [insert at left i word! = f-arity/:i]^/                    ]^/                    not find [set-word! set-path!] type?/word item [^/                        remove left^/                    ]^/                ]^/            ]^/            code: next code^/        ]^/        code^/    ]^/    eval: func [code [block! paren!] cmd [issue!] /local after expr][^/        after: fetch-next code^/        expr: copy/part code after^/        if trace? [print ["preproc:" mold cmd mold expr]]^/        expr: do-code expr cmd^/        if trace? [print ["preproc: ==" mold expr]]^/        reduce [expr after]^/    ]^/    do-macro: func [name pos [block! paren!] arity [integer!] /local cmd saved p v res][^/        depth: depth + 1^/        saved: s^/        parse next pos [arity [s: macros | skip]]^/        cmd: make block! 1^/        append cmd name^/        insert/part tail cmd next pos arity^/        if trace? [print ["preproc: eval macro" mold cmd]]^/        p: next cmd^/        forall p [^/            switch type?/word v: p/1 [^/                word! [change p to lit-word! v]^/                path! [change/only p to lit-path! v]^/            ]^/        ]^/        if unset? set/any 'res do bind cmd exec [^/            print ["*** Macro Error: no value returned by" name "macro^^/"]^/            do-quit^/        ]^/        if trace? [print ["preproc: ==" mold :res]]^/        s: saved^/        s/1: :res^/        if positive? depth: depth - 1 [^/            saved: s^/            parse s [s: macros]^/            s: saved^/        ]^/        s/1^/    ]^/    register-macro: func [spec [block!] /local cnt rule p name macro pos valid? named?][^/        named?: set-word? spec/1^/        cnt: 0^/        rule: make block! 10^/        valid?: parse spec/3 [^/            any [^/                opt string!^/                opt block!^/                [word! (cnt: cnt + 1) | /local any word!]^/                opt [^/                    p: block! :p into [some word!]^/                ]^/            ]^/        ]^/        if any [^/            not valid?^/            all [^/                not named?^/                any [cnt <> 2 all [block? spec/1 empty? spec/1]]^/            ]^/        ] [^/            print [^/                "*** Macro Error: invalid specification^^/"^/                "*** Where:" mold copy/part spec 3^/            ]^/            do-quit^/        ]^/        either named? [^/            repend rule [^/                name: to lit-word! spec/1^/                to-paren compose [change/part s do-macro (:name) s (cnt) (cnt + 1)]^/                to get-word! 's^/            ]^/            append protos copy/part spec 4^/        ] [^/            macro: do bind copy/part next spec 3 exec^/            repend rule [^/                to set-word! 's^/                spec/1^/                to set-word! 'e^/                to-paren compose/deep either all [^/                    block? spec/3/1 find spec/3/1 'manual^/                ] [^/                    [s: do-safe/manual [(:macro) s e]]^/                ] [^/                    [s: change/part s do-safe [(:macro) s e] e]^/                ]^/                to get-word! 's^/            ]^/        ]^/        pos: tail macros^/        either tag? macros/1 [remove macros] [insert macros '|]^/        insert macros rule^/        new-line pos yes^/        exec: make exec protos^/        rebind-all^/    ]^/    reset: func [job [object! none!]][^/        exec: do [context [config: job]]^/        clear protos^/        insert clear macros <none>^/    ]^/    expand: func [^/        code [block! paren!] job [object! none!]^/        /clean^/        /local rule e pos cond value then else cases body keep? expr src saved file new^/    ][^/        either clean [reset job] [exec/config: job]^/        rule: [^/            any [^/                s: macros^/                | 'routine 2 skip^/                | #system skip^/                | #system-global skip^/                | s: #include (^/                    if active? [^/                        either all [not Rebol system/state/interpreted?] [^/                            saved: s^/                            attempt [expand load s/2 job]^/                            s: saved^/                            s/1: 'do^/                        ] [^/                            attempt [^/                                src: red/load-source/hidden clean-path join red/main-path s/2^/                                expand src job^/                            ]^/                        ]^/                    ]^/                )^/                | s: #include-binary [file! | string!] (^/                    if active? [^/                        either all [not Rebol system/state/interpreted?] [^/                            s/1: 'read/binary^/                            if string? s/2 [s/2: to-red-file s/2]^/                        ] [^/                            file: either string? s/2 [to-rebol-file s/2] [s/2]^/                            file: clean-path join red/main-path file^/                            change/part s read/binary file 2^/                        ]^/                    ]^/                )^/                | s: #if (set [cond e] eval next s s/1) :e [set then block! | (syntax-error s e)] e: (^/                    if active? [either cond [change/part s then e] [remove/part s e]]^/                ) :s^/                | s: #either (set [cond e] eval next s s/1) :e^/                [set then block! set else block! | (syntax-error s e)] e: (^/                    if active? [either cond [change/part s then e] [change/part s else e]]^/                ) :s^/                | s: #switch (set [cond e] eval next s s/1) :e [set cases block! | (syntax-error s e)] e: (^/                    if active? [^/                        body: any [select cases cond select cases #default]^/                        either body [change/part s body e] [remove/part s e]^/                    ]^/                ) :s^/                | s: #case [set cases block! | e: (syntax-error s e)] e: (^/                    if active? [^/                        until [^/                            set [cond cases] eval cases s/1^/                            any [cond tail? cases: next cases]^/                        ]^/                        either cond [change/part s cases/1 e] [remove/part s e]^/                    ]^/                ) :s^/                | s: #do (keep?: no) opt ['keep (keep?: yes)] [block! | (syntax-error s next s)] e: (^/                    if active? [^/                        pos: pick [3 2] keep?^/                        if trace? [print ["preproc: eval" mold s/:pos]]^/                        saved: s^/                        expr: do-code s/:pos s/1^/                        s: saved^/                        if all [keep? trace?] [print ["preproc: ==" mold expr]]^/                        either keep? [s: change/part s :expr e] [remove/part s e]^/                    ]^/                ) :s^/                | s: #local [block! | (syntax-error s next s)] e: (^/                    repend stack [negate length? macros tail protos]^/                    saved: s^/                    new: expand s/2 job^/                    s: saved^/                    change/part s new e^/                    clear take/last stack^/                    remove/part macros skip tail macros take/last stack^/                    if tail? next macros [macros/1: <none>]^/                ) :s^/                | s: #reset (reset job remove s) :s^/                | s: #trace [[^/                    ['on (trace?: on) | 'off (trace?: off)] (remove/part s 2) :s^/                ] | (syntax-error s next s)]^/                | s: #process [[^/                    'on (active?: yes remove/part s 2) :s^/                    | 'off (active?: no remove/part s 2) :s [to #process | to end (active?: yes)]^/                ] | (syntax-error s next s)]^/                | s: #macro [^/                    [set-word! | word! | lit-word! | block!] ['func | 'function] block! block!^/                    | (syntax-error s skip s 4)^/                ] e: (^/                    register-macro next s^/                    remove/part s e^/                ) :s^/                | pos: [block! | paren!] :pos into rule^/                | skip^/            ]^/        ]^/        unless Rebol [rule/1: 'while]^/        parse code rule^/        code^/    ]^/]^/prin: make native! [^/    "Outputs a value"^/    value [any-type!]^/]^/print: make native! [^/    "Outputs a value followed by a newline"^/    value [any-type!]^/]^/probe: make function! [^/    "Returns a value after printing its molded form"^/    value [any-type!]^/]^/profile: make function! [^/    {Profile the argument code, counting calls and their cumulative duration, then print a report}^/    code [any-type!] "Code to profile"^/    /by^/    cat [word!] "Sort by: 'name, 'count, 'time"^/    /local saved rank name cnt duration^/]^/put: make action! [^/    {Replaces the value following a key, and returns the new value}^/    series [series! port! map! object!]^/    key [scalar! any-string! all-word! binary!]^/    value [any-type!]^/    /case "Perform a case-sensitive search"^/    return: [series! port! map! object!]^/]^/pwd: make function! [{Displays the active directory path (Print Working Dir)}]^/q: make function! [^/    "Stops evaluation and exits the program"^/    /return status [integer!] "Return an exit status"^/]^/query: make action! [^/    "Returns information about a file"^/    target [file! port!]^/]^/quit: make function! [^/    "Stops evaluation and exits the program"^/    /return status [integer!] "Return an exit status"^/]^/quit-return: make routine! [^/    {Stops evaluation and exits the program with a given status}^/    status [integer!] "Process termination value to return"^/]^/quote: make function! [^/    "Return but don't evaluate the next value"^/    :value [any-type!]^/]^/random: make action! [^/    {Returns a random value of the same datatype; or shuffles series}^/    value "Maximum value of result (modified when series)"^/    /seed "Restart or randomize"^/    /secure "Returns a cryptographically secure random number"^/    /only "Pick a random value from a series"^/    return: [any-type!]^/]^/react: make function! [^/    {Defines a new reactive relation between two or more objects}^/    reaction [block! function!] "Reactive relation"^/    /link "Link objects together using a reactive relation"^/    objects [block!] "Objects to link together"^/    /unlink "Removes an existing reactive relation"^/    src [word! object! block!] "'all word, or a reactor or a list of reactors"^/    /later "Run the reaction on next change instead of now"^/    /with "Specifies an optional face object (internal use)"^/    ctx [object! set-word! none!] "Optional context for VID faces or target set-word"^/    return: [block! function! none!] {The reactive relation or NONE if no relation was processed}^/    /local objs found? rule item pos obj^/]^/react?: make function! [^/    {Returns a reactive relation if an object's field is a reactive source}^/    reactor [object!] "Object to check"^/    field [word!] "Field to check"^/    /target {Check if it's a target of an `is` reaction instead of a source}^/    return: [block! function! word! none!] "Returns reaction, type or NONE"^/    /local pos^/]^/reactor: make function! [spec [block!]]^/^/read: make action! [^/    "Reads from a file, URL, or other port"^/    source [file! url! port!]^/    /part {Partial read a given number of units (source relative)}^/    length [number!]^/    /seek "Read from a specific position (source relative)"^/    index [number!]^/    /binary "Preserves contents exactly"^/    /lines "Convert to block of strings"^/    /info^/    /as {Read with the specified encoding, default is 'UTF-8}^/    encoding [word!]^/]^/read-clipboard: make routine! [^/    "Return the contents of the system clipboard"^/    return: [any-type!] {false on failure, none if empty, otherwise: string!, block! of files!, or an image!}^/]^/read-thru: make function! [^/    "Reads a remote file through local disk cache"^/    url [url!] "Remote file address"^/    /update "Force a cache update"^/    /binary "Use binary mode"^/    /local path data^/]^/recycle: make native! [^/    {Recycles unused memory and returns memory amount still in use}^/    /on "Turns on garbage collector; returns nothing"^/    /off "Turns off garbage collector; returns nothing"^/    /info "Returns the number of GC passes since beginning"^/    return: [integer! unset!]^/]^/^/red-complete-input: make function! [^/    str [string!]^/    console? [logic!]^/    /local^/    word ptr result sys-word delim? len insert?^/    start end delimiters d w change?^/]^/reduce: make native! [^/    {Returns a copy of a block, evaluating all expressions}^/    value [any-type!]^/    /into {Put results in out block, instead of creating a new block}^/    out [any-block!] "Target block for results, when /into is used"^/]^/ref?: make function! ["Returns true if the value is this type" value [any-type!]]^/refinement?: make function! ["Returns true if the value is this type" value [any-type!]]^/reflect: make action! [^/    {Returns internal details about a value via reflection}^/    value [any-type!]^/    field [word!] {spec, body, words, etc. Each datatype defines its own reflectors}^/]^/register-scheme: make function! [^/    "Registers a new scheme"^/    spec [object!] "Scheme definition"^/    /native^/    dispatch [handle!]^/]^/rejoin: make function! [^/    "Reduces and joins a block of values."^/    block [block!] "Values to reduce and join"^/]^/relate: make function! [^/    {Defines a reactive relation whose result is assigned to a word}^/    'field [set-word!] {Set-word which will get set to the result of the reaction}^/    reaction [block!] "Reactive relation"^/    /local obj rule item^/]^/remainder: make action! [^/    {Returns what is left over when one value is divided by another}^/    value1 [number! money! char! pair! any-point! tuple! vector! time!] "The dividend (numerator)"^/    value2 [number! money! char! pair! any-point! tuple! vector! time!] "The divisor (denominator)"^/    return: [number! money! char! pair! any-point! tuple! vector! time!] "The remainder"^/]^/remove: make action! [^/    {Returns the series at the same index after removing a value}^/    series [series! port! bitset! map! none!]^/    /part {Removes a number of values, or values up to the given series index}^/    length [number! char! series!]^/    /key "Removes a key in map"^/    key-arg [scalar! any-string! any-word! binary! block!]^/    return: [series! port! bitset! map! none!]^/]^/remove-each: make native! [^/    {Removes values for each block that returns truthy value}^/    'word [word! block!] "Word or block of words to set each time"^/    data [series!] "The series to traverse (modified)"^/    body [block!] "Block to evaluate (return truthy value to remove)"^/]^/remove-event-func: make function! [^/    "Removes an event function previously added"^/    id [word! function!] "Handler name or function reference"^/    /local svh pos^/]^/rename: make action! [^/    "Rename a file"^/    from [port! file! url!]^/    to [port! file! url!]^/]^/repeat: make native! [^/    {Evaluates body a number of times, tracking iteration count}^/    'word [word!] "Iteration counter; not local to loop"^/    value [integer! float!] "Number of times to evaluate body"^/    body [block!]^/]^/repend: make function! [^/    {Appends a reduced value to a series and returns the series head}^/    series [series!]^/    value^/    /only "Appends a block value as a block"^/]^/replace: make function! [^/    "Replaces values in a series, in place"^/    series [any-block! any-string! binary! vector!] "The series to be modified"^/    pattern "Specific value or parse rule pattern to match"^/    value "New value, replaces pattern in the series"^/    /all "Replace all occurrences, not just the first"^/    /deep "Replace pattern in all sub-lists as well"^/    /case "Case-sensitive replacement"^/    /local parse? form? quote? deep? rule many? size seek active?^/]^/request-dir: make function! [^/    {Asks user to select a directory and returns full directory path (or block of paths)}^/    /title "Window title"^/    text [string!]^/    /dir "Set starting directory"^/    name [string! file!]^/    /filter "TBD: Block of filters (filter-name filter)"^/    list [block!]^/    /keep "Keep previous directory path"^/    /multi {TBD: Allows multiple file selection, returned as a block}^/]^/request-file: make function! [^/    {Asks user to select a file and returns full file path (or block of paths)}^/    /title "Window title"^/    text [string!]^/    /file "Default file name or directory"^/    name [string! file!]^/    /filter "Block of filters (filter-name filter)"^/    list [block!]^/    /save "File save mode"^/    /multi {Allows multiple file selection, returned as a block}^/]^/request-font: make function! [^/    "Requests a font object"^/    /font "Sets the selected font"^/    ft [object!]^/    /mono "Show monospaced font only"^/]^/return: make native! [^/    "Returns a value from a function"^/    value [any-type!]^/]^/reverse: make action! [^/    {Reverses the order of elements; returns at same position}^/    series [series! port! pair! any-point! tuple!]^/    /part "Limits to a given length or position"^/    length [number! series!]^/    /skip "Treat the series as fixed size records"^/    size [integer!]^/    return: [series! port! pair! any-point! tuple!]^/]^/^/round: make action! [^/    {Returns the nearest integer. Halves round up (away from zero) by default}^/    n [number! money! time! pair! any-point!]^/    /to {Return the nearest multiple of the scale parameter}^/    scale [number! money! time! pair! any-point!] "If zero, returns N unchanged"^/    /even "Halves round toward even results"^/    /down {Round toward zero, ignoring discarded digits. (truncate)}^/    /half-down "Halves round toward zero"^/    /floor "Round in negative direction"^/    /ceiling "Round in positive direction"^/    /half-ceiling "Halves round in positive direction"^/]^/routine: make function! [{Defines a function with a given Red spec and Red/System body} spec [block!] body [block!]]^/routine?: make function! ["Returns true if the value is this type" value [any-type!]]^/rtd-layout: make function! [^/    "Returns a rich-text face from a RTD source code"^/    spec [block!] "RTD source code"^/    /only "Returns only [text data] facets"^/    /with "Populate an existing face object"^/    face [object!] "Face object to populate"^/    return: [object! block!]^/]^/same?: make native! [^/    "Returns TRUE if two values have the same identity"^/    value1 [any-type!]^/    value2 [any-type!]^/]^/save: make function! [^/    {Saves a value, block, or other data to a file, URL, binary, or string}^/    where [file! url! string! binary! none!] "Where to save"^/    value [any-type!] "Value(s) to save"^/    /header {Provide a Red header block (or output non-code datatypes)}^/    header-data [block! object!]^/    /all "TBD: Save in serialized format"^/    /length {Save the length of the script content in the header}^/    /as {Specify the format of data; use NONE to save as plain text}^/    format [word! none!] "E.g. bmp, gif, jpeg, png, redbin, json, csv"^/    /local dst codec data suffix find-encoder? name only pos header-str k v^/]^/scalar?: make function! ["Returns true if the value is any type of scalar" value [any-type!]]^/scan: make function! [^/    {Returns the guessed type of the first serialized value from the input}^/    buffer [binary! string!] "Input UTF-8 buffer or string"^/    /next {Returns both the type and the input after the value}^/    /fast "Fast scanning, returns best guessed type"^/    return: [datatype! none!] {Recognized or guessed type, or NONE on empty input}^/]^/^/second: make function! ["Returns the second value in a series" s [series! tuple! pair! any-point! date! time!]]^/select: make action! [^/    {Find a value in a series and return the next value, or NONE}^/    series [series! any-object! map! none!]^/    value [any-type!]^/    /part "Limit the length of the search"^/    length [number! series!]^/    /only "Treat a series search value as a single value"^/    /case "Perform a case-sensitive search"^/    /same {Use "same?" as comparator}^/    /any "TBD: Use * and ? wildcards in string searches"^/    /with "TBD: Use custom wildcards in place of * and ?"^/    wild [string!]^/    /skip "Treat the series as fixed size records"^/    size [integer!]^/    /last "Find the last occurrence of value, from the tail"^/    /reverse {Find the last occurrence of value, from the current index}^/    return: [any-type!]^/]^/series?: make function! ["Returns true if the value is any type of series" value [any-type!]]^/set: make native! [^/    "Sets the value(s) one or more words refer to"^/    word [any-word! block! object! any-path!] "Word, object, map path or block of words to set"^/    value [any-type!] "Value or block of values to assign to words"^/    /any {Allow UNSET as a value rather than causing an error}^/    /case "Use case-sensitive comparison (path only)"^/    /only {Block or object value argument is set as a single value}^/    /some {None values in a block or object value argument, are not set}^/    return: [any-type!]^/]^/set-current-dir: make routine! ["Sets the platform's current process directory" path [file!]]^/set-env: make native! [^/    {Sets the value of an operating system environment variable (for current process)}^/    var [any-string! any-word!] "Variable to set"^/    value [string! none!] "Value to set, or NONE to unset it"^/]^/set-flag: make function! [^/    {Sets (or clears) a flag in a face object; Returns the /flags facet value}^/    face [object!] "Face where flag to set/clear"^/    flag [any-type!] "Flag to set/clear"^/    /clear "Clears the flag instead of setting it"^/    /toggle "Set it if unset, clears it otherwise"^/    /local flags pos^/]^/set-focus: make function! [^/    "Sets the focus on the argument face"^/    face [object!]^/    /local p^/]^/set-path?: make function! ["Returns true if the value is this type" value [any-type!]]^/set-quiet: make routine! [^/    {Set an object's field to a value without triggering eventual object's events}^/    word [any-type!]^/    value [any-type!]^/    return: [any-type!]^/]^/set-slot-quiet: make routine! [^/    {Set a value in series without triggering eventual owner's events}^/    series [any-type!]^/    value [any-type!]^/]^/set-word?: make function! ["Returns true if the value is this type" value [any-type!]]^/shift: make native! [^/    {Perform a bit shift operation. Right shift (decreasing) by default}^/    data [integer!]^/    bits [integer!]^/    /left "Shift bits to the left (increasing)"^/    /logical "Use logical shift (unsigned, fill with zero)"^/    return: [integer!]^/]^/shift-left: make routine! ["Shift bits to the left" data [integer!] bits [integer!]]^/shift-logical: make routine! ["Shift bits to the right (unsigned)" data [integer!] bits [integer!]]^/shift-right: make routine! ["Shift bits to the right" data [integer!] bits [integer!]]^/show: make function! [^/    "Display a new face or update it"^/    face [object! block!] "Face object to display"^/    /with "Link the face to a parent face"^/    parent [object!] "Parent face to link to"^/    /force "For internal use only!"^/    return: [logic!] "true if success"^/    /local show? f pending owner word target action new index part state handle new? p field pane^/]^/show-memory-stats: make function! [data [block!]^//local class used total i c frm unit]^/sign?: make native! [^/    {Returns sign of N as 1, 0, or -1 (to use as a multiplier)}^/    number [number! money! time!]^/    return: [integer!]^/]^/sin: make function! [^/    "Returns the trigonometric sine"^/    angle [float!] "Angle in radians"^/]^/sine: make native! [^/    "Returns the trigonometric sine"^/    angle [float! integer!]^/    /radians "DEPRECATED: use `sin` native instead"^/    return: [float!]^/]^/single?: make function! [^/    "Returns TRUE if the series length is 1"^/    series [series!]^/]^/size-text: make function! [^/    "Returns the area size of the text in a face"^/    face [object!] "Face containing the text to size"^/    /with "Provide a text string instead of face/text"^/    text [string!] "Text to measure"^/    return: [point2D! none!] "Return the text's size or NONE if failed"^/    /local h^/]^/size?: make native! [^/    "Returns the size of a file content"^/    file [file!]^/    return: [integer! none!]^/]^/skip: make action! [^/    "Returns the series relative to the current index"^/    series [series! port!]^/    offset [integer! pair!]^/    return: [series! port!]^/]^/sort: make action! [^/    {Sorts a series (modified); default sort order is ascending}^/    series [series! port!]^/    /case "Perform a case-sensitive sort"^/    /skip "Treat the series as fixed size records"^/    size [integer!]^/    /compare "Comparator offset, block (TBD) or function"^/    comparator [integer! block! any-function!]^/    /part "Sort only part of a series"^/    length [number! series!]^/    /all "Compare all fields (used with /skip)"^/    /reverse "Reverse sort order"^/    /stable "Stable sorting"^/    return: [series!]^/]^/source: make function! [^/    "Print the source of a function"^/    'word [word! path!] "The name of the function"^/    /local val^/]^/spec-of: make function! [{Returns the spec of a value that supports reflection} value]^/split: make function! [^/    {Break a string series into pieces using the provided delimiters}^/    series [any-string!] dlm [string! char! bitset!] /local s^/    num^/]^/split-path: make function! [^/    [no-trace]^/    {Splits a file or URL path. Returns a block containing path and target}^/    target [file! url!]^/    /local dir pos^/]^/sqrt: make function! [^/    "Returns the square root of a number"^/    number [float! integer! percent!]^/    return: [float!]^/]^/square-root: make native! [^/    "Returns the square root of a number"^/    value [float! integer! percent!]^/    return: [float!]^/]^/stack-size?: make routine! [return: [integer!]]^/stats: make native! [^/    "Returns interpreter statistics"^/    /show "TBD:"^/    /info {Return detailed info: nodes/series/big x free/used/total, total, low-level heap}^/    return: [integer! block!]^/]^/stop-events: make function! [^/    "Stop the last opened event loop"^/]^/stop-reactor: make function! [^/    face [object!]^/    /deep^/    /local list pos f^/]^/strict-equal?: make native! [^/    {Returns TRUE if two values are equal, and also the same datatype}^/    value1 [any-type!]^/    value2 [any-type!]^/]^/string?: make function! ["Returns true if the value is this type" value [any-type!]]^/subtract: make action! [^/    "Returns the difference between two values"^/    value1 [scalar! vector!] "The minuend"^/    value2 [scalar! vector!] "The subtrahend"^/    return: [scalar! vector!] "The difference"^/]^/suffix?: make function! [^/    {Returns the suffix (extension) of a filename or url, or NONE if there is no suffix}^/    path [file! url! string! email!]^/]^/sum: make function! [^/    "Returns the sum of all values in a block"^/    values [block! vector! paren! hash!]^/    /local result value^/]^/swap: make action! [^/    {Swaps elements between two series or the same series}^/    series1 [series! port!]^/    series2 [series! port!]^/    return: [series! port!]^/]^/switch: make native! [^/    {Evaluates the first block following the value found in cases}^/    value [any-type!] "The value to match"^/    cases [block!]^/    /default {Specify a default block, if value is not found in cases}^/    case [block!] "Default block to evaluate"^/]^/system: }
        fast: unset
        trap: unset
        codec: unset
        suffix: unset
        mime: unset
        pre-load: unset
        word?: func ["Returns true if the value is this type" value [any-type!]][word! = type? :value]
        codecs: unset
        url?: func ["Returns true if the value is this type" value [any-type!]][url! = type? :value]
        decode: unset
        invalid-refine-arg: unset
        string?: func ["Returns true if the value is this type" value [any-type!]][string! = type? :value]
        suffix?: func [
            {Returns the suffix (extension) of a filename or url, or NONE if there is no suffix}
            path [file! url! string! email!]
        ][
            if all [
                path: find/last path #"."
                not find path #"/"
            ] [to file! path]
        ]
        suffixes: unset
        dir?: func [{Returns TRUE if the value looks like a directory spec} file [file! url!]][#"/" = last file]
        mime-type: unset
        Content-Type: unset
        none: none
        lexer: unset
        second: func ["Returns the second value in a series" s [series! tuple! pair! any-point! date! time!]][pick s 2]
        where: unset
        header-data: unset
        format: unset
        find-encoder?: unset
        header-str: unset
        k: unset
        v: unset
        file?: func ["Returns true if the value is this type" value [any-type!]][file! = type? :value]
        encode: unset
        object?: func ["Returns true if the value is this type" value [any-type!]][object! = type? :value]
        body-of: func [{Returns the body of a value that supports reflection} value][reflect :value 'body]
        yes: true
        err-type: unset
        err-id: unset
        arg1: unset
        first: func ["Returns the first value in a series" s [series! tuple! pair! any-point! date! time!]][pick s 1]
        arg2: unset
        arg3: unset
        third: func ["Returns the third value in a series" s [series! tuple! date! point3D! time!]][pick s 3]
        mod: func [
            "Compute a nonnegative remainder of A divided by B"
            a [number! money! char! pair! tuple! vector! time!]
            b [number! money! char! pair! tuple! vector! time!] "Must be nonzero"
            return: [number! money! char! pair! tuple! vector! time!]
            /local r
        ][
            if (r: a % b) < 0 [r: r + b]
            a: absolute a
            either all [a + r = (a + b) r + r - b > 0] [r - b] [r]
        ]
        colon?: unset
        slash?: unset
        i: unset
        <=: make op! [[
            {Returns TRUE if the first value is less than or equal to the second}
            value1 [any-type!]
            value2 [any-type!]
        ]]
        slash: #"/"
        clean-path: func [
            [no-trace]
            {Cleans-up '.' and '..' in path; returns the cleaned path}
            file [file! url! string!]
            /only "Do not prepend current directory"
            /dir "Add a trailing / if missing"
            /local out cnt f not-file? prot
        ][
            not-file?: not file? file
            if url? file [parse file [copy prot to #"/"]]
            file: case [
                any [only not-file?] [
                    copy file
                ]
                #"/" = first file [
                    file: next file
                    out: next what-dir
                    while [
                        all [
                            #"/" = first file
                            do [f: find/tail out #"/"]
                        ]
                    ] [
                        file: next file
                        out: f
                    ]
                    append clear out file
                ]
                'else [append what-dir file]
            ]
            if all [dir not dir? file] [append file #"/"]
            if only [return file]
            out: make type? file length? file
            cnt: 0
            parse reverse file [
                some [
                    "../" (cnt: cnt + 1)
                    | "./"
                    | #"/" (if any [not-file? not dir? out] [append out #"/"])
                    | copy f thru #"/" (
                        either cnt > 0 [cnt: cnt - 1] [
                            unless find ["" "." ".."] as string! f [append out f]
                        ]
                    )
                ]
            ]
            if prot [append out reverse prot]
            if all [dir? out #"/" <> last file] [take/last out]
            reverse out
        ]
        options: unset
        to-red-file: func [
            {Converts a local system file path to a Red file path}
            path [file! string!]
            return: [file!]
            /local colon? slash? len i c dst
        ][
            len: length? path
            dst: make file! len
            if zero? len [return dst]
            i: 1
            until [
                c: pick path i
                i: i + 1
                case [
                    c = #":" [
                        if any [colon? slash?] [return dst]
                        colon?: yes
                        if i <= len [
                            c: pick path i
                            if any [c = #"\" c = #"/"] [i: i + 1]
                        ]
                        c: #"/"
                    ]
                    any [c = #"\" c = #"/"] [
                        if slash? [continue]
                        c: #"/"
                        slash?: yes
                    ]
                    true [slash?: no]
                ]
                append dst c
                i > len
            ]
            if colon? [insert dst #"/"]
            dst
        ]
        exists?: routine ["Returns TRUE if the file exists" path [file!] return: [logic!]][
            simple-io/file-exists? file/to-OS-path path
        ]
        normalize-dir: func [
            "Returns an absolute directory spec"
            dir [file! word! path!]
        ][
            unless file? dir [dir: to file! mold dir]
            if slash <> first dir [dir: clean-path append copy system/options/path dir]
            if find dir #"\" [dir: to-red-file dir]
            unless dir? dir [dir: append copy dir slash]
            dir
        ]
        dirs: unset
        created: unset
        empty?: func [
            {Returns true if data is a series at its tail or an empty map}
            data [series! none! map!]
            return: [logic!]
        ][
            either data [zero? length? data] [true]
        ]
        dirize: func [
            {Returns a copy of the path turned into a directory}
            path [file! string! url!]
        ][
            either #"/" <> pick path length? path [append copy path #"/"] [copy path]
        ]
        create-dir: routine ["Create the given directory" path [file!]][
            unless simple-io/make-dir file/to-OS-path path [
                fire [TO_ERROR (access no-create) path]
            ]
        ]
        error?: func ["Returns true if the value is this type" value [any-type!]][error! = type? :value]
        width: unset
        at-arg2: unset
        ws: unset
        split-mode: unset
        arg-end: unset
        s': unset
        e': unset
        arg2-update: unset
        e: unset
        charset: func [
            "Shortcut for `make bitset!`"
            spec [block! integer! char! string! bitset! binary!]
        ][
            make bitset! spec
        ]
        boot: unset
        collected: unset
        flag: unset
        dlm: unset
        num: unset
        no-trace: unset
        cnt: unset
        f: unset
        not-file?: unset
        prot: unset
        what-dir: func [
            "Returns the active directory path"
            /local path
        ][
            path: copy system/options/path
            unless dir? path [append path #"/"]
            path
        ]
        saved: unset
        found?: unset
        header?: unset
        new-path: unset
        list: unset
        done?: unset
        no-header: unset
        Red: 255.0.0
        red-system: unset
        expand-directives: func [
            {Invokes the preprocessor on argument list, modifying and returning it}
            code [block! paren!] "List of Red values to preprocess"
            /clean "Clear all previously created macros and words"
            /local job saved
        ][
            saved: s
            job: system/build/config
            also
            either clean [expand/clean code job] [expand code job]
            s: saved
        ]
        standard: unset
        split-path: func [
            [no-trace]
            {Splits a file or URL path. Returns a block containing path and target}
            target [file! url!]
            /local dir pos
        ][
            parse target [
                [#"/" | 1 2 #"." opt #"/"] end (dir: dirize target) |
                pos: any [thru #"/" [end | pos:]] (
                    all [empty? dir: copy/part target at head target index? pos dir: %./]
                    all [find [%. %..] pos: to file! pos insert tail pos #"/"]
                )
            ]
            reduce [dir pos]
        ]
        change-dir: func [
            "Changes the active directory path"
            dir [file! word! path!] {New active directory of relative path to the new one}
        ][
            unless exists? dir: normalize-dir dir [cause-error 'access 'cannot-open [dir]]
            system/options/path: dir
        ]
        state: unset
        source-files: unset
        currencies: unset
        locale: unset
        halt-request: unset
        so: unset
        hash: unset
        thru-cache: unset
        cache: unset
        MD5: unset
        path-thru: func [
            {Returns the local disk cache path of a remote file}
            url [url!] "Remote file address"
            return: [file!]
            /local so hash file path
        ][
            so: system/options
            unless so/thru-cache [make-dir/deep so/thru-cache: append copy so/cache %cache/]
            hash: checksum form url 'MD5
            file: head (remove back tail remove remove (form hash))
            path: dirize append copy so/thru-cache copy/part file 2
            unless exists? path [make-dir path]
            append path file
        ]
        save: func [
            {Saves a value, block, or other data to a file, URL, binary, or string}
            where [file! url! string! binary! none!] "Where to save"
            value [any-type!] "Value(s) to save"
            /header {Provide a Red header block (or output non-code datatypes)}
            header-data [block! object!]
            /all "TBD: Save in serialized format"
            /length {Save the length of the script content in the header}
            /as {Specify the format of data; use NONE to save as plain text}
            format [word! none!] "E.g. bmp, gif, jpeg, png, redbin, json, csv"
            /local dst codec data suffix find-encoder? name only pos header-str k v
        ][
            dst: either any [file? where url? where] [where] [none]
            either system/words/all [as word? format] [
                either codec: select system/codecs format [
                    data: do [codec/encode :value dst]
                    if same? data dst [exit]
                ] [cause-error 'script 'invalid-refine-arg [/as format]]
            ] [
                if length [header: true header-data: any [header-data copy []]]
                if header [
                    if object? :header-data [header-data: body-of header-data]
                ]
                if find [file! url!] type?/word where [
                    suffix: suffix? where
                    find-encoder?: no
                    foreach [name codec] system/codecs [
                        if (find codec/suffixes suffix) [
                            data: do [codec/encode :value dst]
                            if same? data dst [exit]
                            find-encoder?: yes
                        ]
                    ]
                ]
                unless find-encoder? [
                    only: block? :value
                    data: either all [
                        append mold/all/:only :value newline
                    ] [
                        mold/:only :value
                    ]
                    case/all [
                        not binary? data [data: to binary! data]
                        length [
                            either pos: find/tail header-data 'length [
                                insert remove pos length? data
                            ] [
                                append header-data compose [length: (length? data)]
                            ]
                        ]
                        header-data [
                            header-str: copy "Red [^/"
                            foreach [k v] header-data [
                                append header-str reduce [#"^-" mold k #" " mold v newline]
                            ]
                            append header-str "]^/^/"
                            insert data header-str
                        ]
                    ]
                ]
            ]
            case [
                file? where [write where data]
                url? where [write where data]
                none? where [data]
                'else [append where data]
            ]
        ]
        load-thru: func [
            "Loads a remote file through local disk cache"
            url [url!] "Remote file address"
            /update "Force a cache update"
            /as {Specify the type of data; use NONE to load as code}
            type [word! none!] "E.g. bmp, gif, jpeg, png"
            /local path file
        ][
            path: path-thru url
            if all [not update exists? path] [url: path]
            file: either as [load/as url type] [load url]
            if url? url [attempt [save/:as path file type]]
            file
        ]
        cosine*: unset
        sine*: unset
        tangent*: unset
        arccosine*: unset
        arcsine*: unset
        arctangent*: unset
        arctangent2*: unset
        square-root*: unset
        timezone: unset
        used: unset
        total: unset
        frm: unset
        unit: unset
        lf: #"^/"
        pad: func [
            "Pad a FORMed value on right side with spaces"
            str "Value to pad, FORM it if not a string"
            n [integer!] "Total size (in characters) of the new string"
            /left "Pad the string on left side"
            /with "Pad with char"
            c [char!]
            return: [string!] "Modified input string at head"
        ][
            unless string? str [str: form str]
            insert/dup
            any [all [left str] tail str]
            any [c #" "]
            (n - length? str)
            str
        ]
        Nodes: unset
        tracer: unset
        sum: func [
            "Returns the sum of all values in a block"
            values [block! vector! paren! hash!]
            /local result value
        ][
            result: make any [values/1 0] 0
            foreach value values [result: result + value]
            result
        ]
        t0: unset
        times: unset
        text: unset
        dt: func [
            "Returns the time required to evaluate a block"
            body [block!]
            return: [time!]
            /local t0
        ][
            t0: now/precise/utc
            do body
            difference now/precise/utc t0
        ]
        time-it: func [
            "Returns the time required to evaluate a block"
            body [block!]
            return: [time!]
            /local t0
        ][
            t0: now/precise/utc
            do body
            difference now/precise/utc t0
        ]
        JSON: unset
        CSV: unset
        hour: unset
        minute: unset
        week: unset
        isoweek: unset
        julian: unset
        host: unset
        face: make object! [
            type: 'window
            offset: (559.2, 339.2)
            size: 839x654
            text: "Red Console"
            image: none
            color: none
            menu: none
            data: none
            enabled?: true
            visible?: false
            selected: make object! [
                type: 'rich-text
                offset: (0, 0)
                size: 840x655
                text: none
                image: none
                color: 22.22.22
                menu: none
                data: none
                enabled?: true
                visible?: true
                selected: none
                flags: [scrollable all-over]
                options: [cursor: I-beam]
                parent: make object! [...]
                pane: none
                state: [handle! 0 none false]
                rate: 10
                edge: none
                para: none
                font: make object! [
                    name: "Consolas"
                    size: 11
                    style: none
                    angle: 0
                    color: 222.222.222
                    anti-alias?: false
                    shadow: none
                    state: [handle! none none]
                    parent: []
                ]
                actors: make object! [
                    on-time: func [face [object!] event [event!]][
                        if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                        terminal/on-time
                        'done
                    ]
                    on-drawing: func [face [object!] event [event!]][
                        terminal/paint
                    ]
                    on-scroll: func [face [object!] event [event!]][
                        terminal/scroll event
                    ]
                    on-wheel: func [face [object!] event [event!]][
                        either event/ctrl? [
                            terminal/zoom event
                        ] [
                            terminal/scroll event
                        ]
                    ]
                    on-key: func [face [object!] event [event!]][
                        terminal/press-key event
                    ]
                    on-key-down: func [face [object!] event [event!]][
                        if all [1 = length? event/flags find event/flags 'alt] [
                            switch event/key [
                                #"A" [terminal/select-all]
                                #"O" [show-cfg-dialog]
                            ]
                        ]
                    ]
                    on-ime: func [face [object!] event [event!]][
                        terminal/process-ime-input event
                    ]
                    on-down: func [face [object!] event [event!]][
                        terminal/mouse-down event
                    ]
                    on-up: func [face [object!] event [event!]][
                        terminal/mouse-up event
                    ]
                    on-alt-down: func [face [object!] event [event!]][
                        if cfg/mouse-paste? = 'true [
                            either terminal/text-selected? [
                                terminal/copy-selection
                                clear terminal/selects
                                system/view/platform/redraw face
                            ] [
                                terminal/paste
                            ]
                        ]
                    ]
                    on-over: func [face [object!] event [event!]][
                        terminal/mouse-move to-pair event/offset
                    ]
                    on-menu: func [face [object!] event [event!]][
                        switch event/picked [
                            copy [terminal/copy-selection]
                            paste [terminal/paste]
                            select-all [terminal/select-all]
                        ]
                        'done
                    ]
                ]
                extra: none
                draw: none
                tabs: none
                line-spacing: 'default
                handles: none
                init: func [/local box][
                    terminal/windows: get in get-current-screen 'pane
                    box: terminal/box
                    box/data: make block! 200
                    scroller: get-scroller self 'horizontal
                    scroller/visible?: no
                    scroller: get-scroller self 'vertical
                    scroller/position: 1
                    scroller/max-size: 2
                ]
            ]
            flags: [resize]
            options: none
            parent: make object! [
                type: 'screen
                offset: 0x0
                size: 2048x1152
                text: none
                image: none
                color: none
                menu: none
                data: 1.25
                enabled?: true
                visible?: true
                selected: none
                flags: none
                options: none
                parent: none
                pane: []
                state: [handle! 0 none [1]]
                rate: none
                edge: none
                para: none
                font: none
                actors: none
                extra: none
                draw: none
            ]
            pane: [make object! [
                type: 'rich-text
                offset: (0, 0)
                size: 840x655
                text: none
                image: none
                color: 22.22.22
                menu: none
                data: none
                enabled?: true
                visible?: true
                selected: none
                flags: [scrollable all-over]
                options: [cursor: I-beam]
                parent: make object! [...]
                pane: none
                state: [handle! 0 none false]
                rate: 10
                edge: none
                para: none
                font: make object! [
                    name: "Consolas"
                    size: 11
                    style: none
                    angle: 0
                    color: 222.222.222
                    anti-alias?: false
                    shadow: none
                    state: [handle! none none]
                    parent: []
                ]
                actors: make object! [
                    on-time: func [face [object!] event [event!]][
                        if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                        terminal/on-time
                        'done
                    ]
                    on-drawing: func [face [object!] event [event!]][
                        terminal/paint
                    ]
                    on-scroll: func [face [object!] event [event!]][
                        terminal/scroll event
                    ]
                    on-wheel: func [face [object!] event [event!]][
                        either event/ctrl? [
                            terminal/zoom event
                        ] [
                            terminal/scroll event
                        ]
                    ]
                    on-key: func [face [object!] event [event!]][
                        terminal/press-key event
                    ]
                    on-key-down: func [face [object!] event [event!]][
                        if all [1 = length? event/flags find event/flags 'alt] [
                            switch event/key [
                                #"A" [terminal/select-all]
                                #"O" [show-cfg-dialog]
                            ]
                        ]
                    ]
                    on-ime: func [face [object!] event [event!]][
                        terminal/process-ime-input event
                    ]
                    on-down: func [face [object!] event [event!]][
                        terminal/mouse-down event
                    ]
                    on-up: func [face [object!] event [event!]][
                        terminal/mouse-up event
                    ]
                    on-alt-down: func [face [object!] event [event!]][
                        if cfg/mouse-paste? = 'true [
                            either terminal/text-selected? [
                                terminal/copy-selection
                                clear terminal/selects
                                system/view/platform/redraw face
                            ] [
                                terminal/paste
                            ]
                        ]
                    ]
                    on-over: func [face [object!] event [event!]][
                        terminal/mouse-move to-pair event/offset
                    ]
                    on-menu: func [face [object!] event [event!]][
                        switch event/picked [
                            copy [terminal/copy-selection]
                            paste [terminal/paste]
                            select-all [terminal/select-all]
                        ]
                        'done
                    ]
                ]
                extra: none
                draw: none
                tabs: none
                line-spacing: 'default
                handles: none
                init: func [/local box][
                    terminal/windows: get in get-current-screen 'pane
                    box: terminal/box
                    box/data: make block! 200
                    scroller: get-scroller self 'horizontal
                    scroller/visible?: no
                    scroller: get-scroller self 'vertical
                    scroller/position: 1
                    scroller/max-size: 2
                ]
            ] make object! [
                type: 'base
                offset: (0, 0)
                size: 1x17
                text: none
                image: none
                color: 222.222.222.1
                menu: none
                data: none
                enabled?: false
                visible?: true
                selected: none
                flags: none
                options: [caret make object! [
                    type: 'rich-text
                    offset: (0, 0)
                    size: 840x655
                    text: none
                    image: none
                    color: 22.22.22
                    menu: none
                    data: none
                    enabled?: true
                    visible?: true
                    selected: none
                    flags: [scrollable all-over]
                    options: [cursor: I-beam]
                    parent: make object! [...]
                    pane: none
                    state: [handle! 0 none false]
                    rate: 10
                    edge: none
                    para: none
                    font: make object! [
                        name: "Consolas"
                        size: 11
                        style: none
                        angle: 0
                        color: 222.222.222
                        anti-alias?: false
                        shadow: none
                        state: [handle! none none]
                        parent: []
                    ]
                    actors: make object! [
                        on-time: func [face [object!] event [event!]][
                            if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                            terminal/on-time
                            'done
                        ]
                        on-drawing: func [face [object!] event [event!]][
                            terminal/paint
                        ]
                        on-scroll: func [face [object!] event [event!]][
                            terminal/scroll event
                        ]
                        on-wheel: func [face [object!] event [event!]][
                            either event/ctrl? [
                                terminal/zoom event
                            ] [
                                terminal/scroll event
                            ]
                        ]
                        on-key: func [face [object!] event [event!]][
                            terminal/press-key event
                        ]
                        on-key-down: func [face [object!] event [event!]][
                            if all [1 = length? event/flags find event/flags 'alt] [
                                switch event/key [
                                    #"A" [terminal/select-all]
                                    #"O" [show-cfg-dialog]
                                ]
                            ]
                        ]
                        on-ime: func [face [object!] event [event!]][
                            terminal/process-ime-input event
                        ]
                        on-down: func [face [object!] event [event!]][
                            terminal/mouse-down event
                        ]
                        on-up: func [face [object!] event [event!]][
                            terminal/mouse-up event
                        ]
                        on-alt-down: func [face [object!] event [event!]][
                            if cfg/mouse-paste? = 'true [
                                either terminal/text-selected? [
                                    terminal/copy-selection
                                    clear terminal/selects
                                    system/view/platform/redraw face
                                ] [
                                    terminal/paste
                                ]
                            ]
                        ]
                        on-over: func [face [object!] event [event!]][
                            terminal/mouse-move to-pair event/offset
                        ]
                        on-menu: func [face [object!] event [event!]][
                            switch event/picked [
                                copy [terminal/copy-selection]
                                paste [terminal/paste]
                                select-all [terminal/select-all]
                            ]
                            'done
                        ]
                    ]
                    extra: none
                    draw: none
                    tabs: none
                    line-spacing: 'default
                    handles: none
                    init: func [/local box][
                        terminal/windows: get in get-current-screen 'pane
                        box: terminal/box
                        box/data: make block! 200
                        scroller: get-scroller self 'horizontal
                        scroller/visible?: no
                        scroller: get-scroller self 'vertical
                        scroller/position: 1
                        scroller/max-size: 2
                    ]
                ] cursor: I-beam accelerated: yes]
                parent: make object! [...]
                pane: none
                state: [handle! 0 none false]
                rate: 0:00:00.53
                edge: none
                para: none
                font: none
                actors: make object! [
                    on-time: func [face [object!] event [event!]][
                        face/color: either face/color = caret-clr [255.255.255.254] [caret-clr]
                        'done
                    ]
                ]
                extra: none
                draw: none
            ] make object! [
                type: 'panel
                offset: (0, 0)
                size: 150x200
                text: none
                image: none
                color: 0.0.128
                menu: none
                data: none
                enabled?: true
                visible?: false
                selected: none
                flags: none
                options: none
                parent: make object! [...]
                pane: none
                state: [handle! 0 none false]
                rate: none
                edge: none
                para: none
                font: make object! [
                    name: "Consolas"
                    size: 11
                    style: none
                    angle: 0
                    color: 255.255.255
                    anti-alias?: false
                    shadow: none
                    state: [handle! none none]
                    parent: [make object! [
                        type: 'rich-text
                        offset: none
                        size: 820x655
                        text: "XXXXXXXXXX"
                        image: none
                        color: none
                        menu: none
                        data: []
                        enabled?: true
                        visible?: true
                        selected: none
                        flags: none
                        options: none
                        parent: none
                        pane: none
                        state: none
                        rate: none
                        edge: none
                        para: none
                        font: make object! [
                            name: "Consolas"
                            size: 11
                            style: none
                            angle: 0
                            color: 222.222.222
                            anti-alias?: false
                            shadow: none
                            state: [handle! none none]
                            parent: [...]
                        ]
                        actors: none
                        extra: none
                        draw: none
                        tabs: 32.4
                        line-spacing: 17
                        handles: [handle! handle! "XXXXXXXXXX" true]
                    ]]
                ]
                actors: make object! [
                    on-key-down: func [face [object!] event [event!]][
                        probe event/key
                    ]
                ]
                extra: none
                draw: none
            ]]
            state: [handle! 0 none false]
            rate: none
            edge: none
            para: none
            font: none
            actors: make object! [
                on-menu: func [face [object!] event [event!] /local ft f][
                    switch event/picked [
                        about-msg [display-about]
                        shortcuts [show-shortcuts]
                        quit [self/on-close face event]
                        run-file [if f: request-file [terminal/run-file f]]
                        choose-font [
                            if ft: request-font/font/mono font [
                                font: ft
                                console/font: font
                                terminal/zoom font
                            ]
                        ]
                        settings [show-cfg-dialog]
                    ]
                ]
                on-close: func [face [object!] event [event!]][
                    system/view/platform/exit-event-loop
                    foreach screen system/view/screens [clear head screen/pane]
                    quit
                ]
                on-resizing: func [face [object!] event [event!]
                /local new-sz][
                    new-sz: to-pair event/offset + 1x1
                    console/size: new-sz
                    terminal/resize new-sz
                    terminal/adjust-console-size new-sz
                    unless system/view/auto-sync? [show face]
                ]
                on-resize: func [face [object!] event [event!]
                /local new-sz][
                    new-sz: to-pair event/offset + 1x1
                    console/size: new-sz
                    terminal/resize new-sz
                    terminal/adjust-console-size new-sz
                    unless system/view/auto-sync? [show face]
                ]
                on-focus: func [face [object!] event [event!]][
                    focused?: yes
                    caret/color: caret-clr
                    unless caret/enabled? [caret/enabled?: yes]
                    caret/rate: caret-rate
                    terminal/refresh/force
                ]
                on-unfocus: func [face [object!] event [event!]][
                    focused?: no
                    if caret/enabled? [caret/enabled?: no]
                    caret/rate: none
                ]
                on-key-down: func [face [object!] event [event!]][
                    if event/key = 'F12 [
                        cfg/menu-bar?: to-word none? face/menu
                        toggle-menu-bar
                    ]
                ]
            ]
            extra: none
            draw: none
        ]
        window: unset
        picked: unset
        flags: unset
        orientation: unset
        away?: unset
        down?: unset
        mid-down?: unset
        alt-down?: unset
        aux-down?: unset
        ctrl?: unset
        shift?: unset
        argb: unset
        rgb: unset
        alpha: unset
        box: unset
        eval?: unset
        old: unset
        integer?: func ["Returns true if the value is this type" value [any-type!]][
            integer! = type? :value
        ]
        set-quiet: routine [
            {Set an object's field to a value without triggering eventual object's events}
            word [any-type!]
            value [any-type!]
            return: [any-type!]
        ][
            type: TYPE_OF (word)
            unless ANY_WORD? (type) [ERR_EXPECT_ARGUMENT (type 0)]
            w: as red-word! word
            node: w/ctx
            _context/set-in w stack/arguments + 1 TO_CTX (node) no
            SET_RETURN (value)
        ]
        and: make op! [[
            "Returns the first value ANDed with the second"
            value1 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
            value2 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
            return: [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
        ]]
        AED: unset
        AFN: unset
        AMD: unset
        ANG: unset
        AOA: unset
        ARS: unset
        AUD: unset
        AWG: unset
        AZN: unset
        BAM: unset
        BBD: unset
        BDT: unset
        BTC: unset
        BGN: unset
        BHD: unset
        BIF: unset
        BMD: unset
        BND: unset
        BOB: unset
        BRL: unset
        BSD: unset
        BTN: unset
        BWP: unset
        BYN: unset
        BZD: unset
        CAD: unset
        CDF: unset
        CHF: unset
        CKD: unset
        CLP: unset
        CNY: unset
        COP: unset
        CRC: unset
        CUC: unset
        CUP: unset
        CVE: unset
        CZK: unset
        DJF: unset
        DKK: unset
        DOP: unset
        DZD: unset
        EGP: unset
        ERN: unset
        ETB: unset
        ETH: unset
        EUR: unset
        FJD: unset
        FKP: unset
        FOK: unset
        GBP: unset
        GEL: unset
        GGP: unset
        GHS: unset
        GIP: unset
        GMD: unset
        GNF: unset
        GTQ: unset
        GYD: unset
        HKD: unset
        HNL: unset
        HRK: unset
        HTG: unset
        HUF: unset
        IDR: unset
        ILS: unset
        IMP: unset
        INR: unset
        IQD: unset
        IRR: unset
        ISK: unset
        JEP: unset
        JMD: unset
        JOD: unset
        JPY: unset
        KES: unset
        KGS: unset
        KHR: unset
        KID: unset
        KMF: unset
        KPW: unset
        KRW: unset
        KWD: unset
        KYD: unset
        KZT: unset
        LAK: unset
        LBP: unset
        LKR: unset
        LRD: unset
        LSL: unset
        LYD: unset
        MAD: unset
        MDL: unset
        MGA: unset
        MKD: unset
        MMK: unset
        MNT: unset
        MOP: unset
        MRU: unset
        MUR: unset
        MVR: unset
        MWK: unset
        MXN: unset
        MYR: unset
        MZN: unset
        NAD: unset
        NGN: unset
        NIO: unset
        NOK: unset
        NPR: unset
        NZD: unset
        OMR: unset
        PAB: unset
        PEN: unset
        PGK: unset
        PHP: unset
        PKR: unset
        PLN: unset
        PND: unset
        PRB: unset
        PYG: unset
        QAR: unset
        RON: unset
        RSD: unset
        RUB: unset
        RWF: unset
        SAR: unset
        SBD: unset
        SCR: unset
        SDG: unset
        SEK: unset
        SGD: unset
        SHP: unset
        SLL: unset
        SLS: unset
        SOS: unset
        SRD: unset
        SSP: unset
        STN: unset
        SYP: unset
        SZL: unset
        THB: unset
        TJS: unset
        TMT: unset
        TND: unset
        TTD: unset
        TVD: unset
        TWD: unset
        TZS: unset
        UAH: unset
        UGX: unset
        USD: unset
        UYU: unset
        UZS: unset
        VES: unset
        VND: unset
        VUV: unset
        WST: unset
        CFA: unset
        XAF: unset
        XCD: unset
        XOF: unset
        CFP: unset
        XPF: unset
        YER: unset
        ZAR: unset
        ZMW: unset
        protected: unset
        owner: unset
        action: unset
        set-slot-quiet: routine [
            {Set a value in series without triggering eventual owner's events}
            series [any-type!]
            value [any-type!]
        ][
            type: TYPE_OF (series)
            unless ANY_BLOCK_STRICT? (type) [ERR_EXPECT_ARGUMENT (TYPE_BLOCK 0)]
            blk: as red-block! series
            unless block/rs-tail? blk [copy-cell value block/rs-head blk]
        ]
        pretty-print?: unset
        full-support?: unset
        invalid-type: unset
        image: unset
        png: unset
        img: unset
        Android: unset
        FreeBSD: unset
        Syllabe: unset
        OS: unset
        cell!: unset
        IMAGE_PNG: unset
        jpeg: unset
        IMAGE_JPEG: unset
        bmp: unset
        IMAGE_BMP: unset
        gif: unset
        IMAGE_GIF: unset
        redbin: unset
        payload: unset
        TYPE_URL: unset
        TYPE_FILE: unset
        actions: unset
        read*: unset
        TYPE_BINARY: unset
        invalid-data: unset
        bin: unset
        red-binary!: unset
        assert: unset
        >=: make op! [[
            {Returns TRUE if the first value is greater than or equal to the second}
            value1 [any-type!]
            value2 [any-type!]
        ]]
        rs-length?: unset
        push-only*: unset
        codec?: unset
        reactivity: unset
        debug?: unset
        tab: #"^-"
        check: unset
        self: unset
        types!: unset
        owned: unset
        reactor!: make object! [
        ]
        deep-reactor!: make object! [
        ]
        reaction: unset
        targets: unset
        new-rel: unset
        slice: unset
        events?: unset
        reactor: func [spec [block!]][make reactor! spec]
        mark: unset
        repend: func [
            {Appends a reduced value to a series and returns the series head}
            series [series!]
            value
            /only "Appends a block value as a block"
        ][
            head either any [only not any-block? series] [
                insert/only tail series reduce :value
            ] [
                reduce/into :value tail series
            ]
        ]
        set-word?: func ["Returns true if the value is this type" value [any-type!]][set-word! = type? :value]
        q: func [
            "Stops evaluation and exits the program"
            /return status [integer!] "Return an exit status"
        ][
            if system/console [do [_save-cfg]]
            quit-return any [status 0]
        ]
        q': unset
        pane: unset
        stop-reactor: func [
            face [object!]
            /deep
            /local list pos f
        ][
            if system/reactivity/debug? [
                print ["-- reactivity: stopping, face:" face/type "/deep:" deep]
            ]
            list: relations
            while [not tail? list] [
                either any [
                    same? list/1 face
                    all [
                        block? list/4
                        pos: find/same list/4 face
                        empty? head remove pos
                    ]
                ] [
                    remove/part list 4
                ] [
                    list: skip list 4
                ]
            ]
            if all [deep block? face/pane] [foreach f face/pane [stop-reactor/deep f]]
        ]
        words-of: func [{Returns the list of words of a value that supports reflection} value][reflect :value 'words]
        replace: func [
            "Replaces values in a series, in place"
            series [any-block! any-string! binary! vector!] "The series to be modified"
            pattern "Specific value or parse rule pattern to match"
            value "New value, replaces pattern in the series"
            /all "Replace all occurrences, not just the first"
            /deep "Replace pattern in all sub-lists as well"
            /case "Case-sensitive replacement"
            /local parse? form? quote? deep? rule many? size seek active?
        ][
            parse?: any [
                system/words/all [deep any-list? series]
                system/words/all [
                    any [binary? series any-string? series]
                    any [block? :pattern bitset? :pattern]
                ]
            ]
            form?: system/words/all [
                any-string? series
                any [not any-string? :pattern tag? :pattern]
                not block? :pattern
                not bitset? :pattern
            ]
            quote?: system/words/all [
                not form?
                parse?
                not block? :pattern
                not bitset? :pattern
            ]
            pattern: system/words/case [
                form? [form :pattern]
                quote? [reduce ['quote :pattern]]
                'else [:pattern]
            ]
            also series either parse? [
                deep?: system/words/all [
                    deep
                    not binary? series
                ]
                rule: [
                    any [
                        end
                        | change pattern (value) [if (all) | break]
                        | if (deep?) ahead any-list! into rule
                        | skip
                    ]
                ]
                parse series [case case rule]
            ] [
                many?: any [
                    system/words/all [
                        any [binary? series any-string? series]
                        series? :pattern
                    ]
                    system/words/all [
                        any-list? series
                        any-list? :pattern
                    ]
                ]
                size: either many? [length? :pattern] [1]
                seek: reduce [pick [find/case find] case 'series quote :pattern]
                active?: any-function? :value
                until [
                    not system/words/all [
                        series: do seek
                        series: change/part series either active? [do [value]] [value] size
                        all
                    ]
                ]
            ]
        ]
        item: unset
        react: func [
            {Defines a new reactive relation between two or more objects}
            reaction [block! function!] "Reactive relation"
            /link "Link objects together using a reactive relation"
            objects [block!] "Objects to link together"
            /unlink "Removes an existing reactive relation"
            src [word! object! block!] "'all word, or a reactor or a list of reactors"
            /later "Run the reaction on next change instead of now"
            /with "Specifies an optional face object (internal use)"
            ctx [object! set-word! none!] "Optional context for VID faces or target set-word"
            return: [block! function! none!] {The reactive relation or NONE if no relation was processed}
            /local objs found? rule item pos obj
        ][
            case [
                link [
                    unless function? :reaction [cause-error 'script 'react-bad-func []]
                    objs: parse spec-of :reaction [
                        collect some [keep word! | [refinement! | set-word!] break | skip]
                    ]
                    if 2 > length? objs [cause-error 'script 'react-not-enough []]
                    objects: reduce objects
                    if (length? objects) <> length? objs [cause-error 'script 'react-no-match []]
                    unless parse objects [some object!] [cause-error 'script 'react-bad-obj []]
                    insert objects :reaction
                    found?: no
                    parse body-of :reaction rule: [
                        any [
                            item: [path! | lit-path! | get-path!] (
                                item: item/1
                                if all [pos: find objs item/1 word? item/2] [
                                    obj: pick objects 1 + index? pos
                                    if reflect obj 'events? [
                                        add-relation obj item/2 :reaction objects
                                        found?: yes
                                    ]
                                ]
                            )
                            | set-path! | any-string!
                            | into rule
                            | skip
                        ]
                    ]
                    if all [not later found?] [eval objects]
                ]
                unlink [
                    if block? src [src: reduce src]
                    pos: relations
                    found?: no
                    while [pos: find/same/only pos :reaction] [
                        obj: pos/-2
                        either any [src = 'all same? src obj all [block? src find/same src obj]] [
                            pos: remove/part skip pos -2 4
                            found?: yes
                        ] [
                            pos: next pos
                        ]
                    ]
                ]
                'else [
                    found?: no
                    parse reaction rule: [
                        any [
                            item: [path! | lit-path! | get-path!] (
                                found?: found? or identify-sources item/1 :reaction ctx
                                parse item/1 rule
                            )
                            | set-path! | any-string!
                            | into rule
                            | skip
                        ]
                    ]
                    if all [not later found?] [eval reaction]
                ]
            ]
            either found? [:reaction] [none]
        ]
        later: unset
        deprecated: unset
        link: unset
        objects: unset
        unlink: unset
        objs: unset
        function?: func ["Returns true if the value is this type" value [any-type!]][function! = type? :value]
        react-bad-func: unset
        spec-of: func [{Returns the spec of a value that supports reflection} value][reflect :value 'spec]
        react-not-enough: unset
        react-no-match: unset
        react-bad-obj: unset
        native: unset
        dispatch: unset
        actor: unset
        schemes: unset
        more: unset
        =IP-literal: unset
        throw-error: unset
        scheme: unset
        rejoin: func [
            "Reduces and joins a block of values."
            block [block!] "Values to reduce and join"
        ][
            if empty? block: reduce block [return block]
            append either series? first block [copy first block] [
                form first block
            ] next block
        ]
        url-obj: unset
        config: unset
        rebol: false
        halt: func ["Stops evaluation and returns to the input prompt"][throw/name 'halt-request 'console]
        manual: unset
        res: unset
        t?: unset
        unset?: func ["Returns true if the value is this type" value [any-type!]][
            unset! = type? :value
        ]
        arity: unset
        selectable: unset
        get-word?: func ["Returns true if the value is this type" value [any-type!]][get-word! = type? :value]
        paren?: func ["Returns true if the value is this type" value [any-type!]][paren! = type? :value]
        item2: unset
        fn-spec: unset
        f-arity: unset
        at-op?: unset
        op-mode: unset
        op?: func ["Returns true if the value is this type" value [any-type!]][op! = type? :value]
        after: unset
        macro: unset
        valid?: unset
        named?: unset
        to-paren: func ["Convert to paren! value" value][to paren! :value]
        job: unset
        clean: unset
        then: unset
        keep?: unset
        routine: func [{Defines a function with a given Red spec and Red/System body} spec [block!] body [block!]][
            cause-error 'internal 'routines []
        ]
        interpreted?: unset
        load-source: unset
        hidden: unset
        join: unset
        main-path: unset
        to-rebol-file: unset
        build: unset
        false: false
        debug: func [
            {Runs argument code through an interactive debugger}
            code [any-type!] "Code to debug"
            /later {Enters the interactive debugger later, on reading @stop value}
        ][
            saved: values-of options/debug
            options/debug/active?: not later
            do-handler :code :debugger
            set options/debug saved
            ()
        ]
        show-locals?: unset
        stack-indent?: unset
        watch: unset
        add?: unset
        ask: func [
            "Prompt the user for input"
            question [string!]
            /hide
            /history "specify the history block"
            blk [block!]
            return: [string!]
            /local t? line
        ][
            t?: tracing?
            trace off
            if all [
                gui-console-ctx/console/state
                not gui-console-ctx/win/visible?
            ] [
                gui-console-ctx/win/visible?: yes
            ]
            gui-console-ctx/show-caret
            line: gui-console-ctx/terminal/ask question blk hide
            gui-console-ctx/caret/enabled?: no
            unless gui-console-ctx/console/state [line: "quit"]
            trace t?
            line
        ]
        to-word: func ["Convert to word! value" value][to word! :value]
        parents: unset
        show-parents?: unset
        show-stack?: unset
        locals: unset
        l: unset
        help: func [
            {Displays information about functions, values, objects, and datatypes.}
            'word [any-type!]
        ][
            print help-string :word
        ]
        ?: func [
            {Displays information about functions, values, objects, and datatypes.}
            'word [any-type!]
        ][
            print help-string :word
        ]
        store: unset
        sch: unset
        set-ref: unset
        history: unset
        eval: unset
        space: #" "
        block-name: unset
        default!: make typeset! [datatype! none! logic! block! paren! string! file! url! char! integer! float! word! set-word! lit-word! get-word! refinement! issue! native! action! op! function! path! lit-path! set-path! get-path! routine! bitset! object! typeset! error! vector! hash! pair! percent! tuple! map! binary! time! tag! email! handle! date! port! money! ref! point2D! point3D! image! event!]
        saved-frame: unset
        isop?: unset
        tools: unset
        inspect: unset
        all?: unset
        reset: unset
        inspect-sub-exprs?: unset
        event-filter: unset
        scope-filter: unset
        collector: unset
        report?: unset
        right: unset
        indent2: unset
        level: unset
        pexpr: unset
        orig-expr: unset
        expr-depth: unset
        fetched: unset
        pushed: unset
        stack-period: unset
        fetched': unset
        pushed': unset
        ==: make op! [[
            {Returns TRUE if two values are equal, and also the same datatype}
            value1 [any-type!]
            value2 [any-type!]
        ]]
        anon: unset
        entry: unset
        typeset?: func ["Returns true if the value is this type" value [any-type!]][typeset! = type? :value]
        profile: func [
            {Profile the argument code, counting calls and their cumulative duration, then print a report}
            code [any-type!] "Code to profile"
            /by
            cat [word!] "Sort by: 'name, 'count, 'time"
            /local saved rank name cnt duration
        ][
            saved: values-of options/profile
            options/profile/sort-by: any [cat 'count]
            set/any 'res do-handler :code :profiler
            if value? 'res [print ["==" mold/part :res calc-max 2 lf]]
            by: select [name 1 count 2 time 3] options/profile/sort-by
            either by = 1 [
                sort/skip/compare profiling 3 by
            ] [
                sort/skip/reverse/compare profiling 3 by
            ]
            rank: 1
            foreach [name cnt duration] profiling [
                if unset? name [name: "<anonymous>"]
                print [pad append copy "#" rank 4 pad name 16 #"|" pad cnt 10 #"|" pad duration 10]
                rank: rank + 1
            ]
            set options/profile saved
            ()
        ]
        handler: unset
        do-file: func ["Internal Use Only" file [file! url!] callback [function! none!]
        /local ws saved src found? code header? header new-path list c done?][
            ws: charset " ^-^M^/"
            saved: system/options/path
            parse/case read file [some [src: "Red" opt "/System" any ws #"[" (found?: yes) break | skip]]
            unless found? [cause-error 'syntax 'no-header reduce [file]]
            code: load/all src
            if code/1 = 'Red/System [cause-error 'internal 'red-system []]
            header?: all [code/1 = 'Red block? header: code/2]
            code: expand-directives next code
            system/script/header: construct/with code/1 system/standard/header
            if file? file [
                new-path: first split-path clean-path file
                change-dir new-path
                append system/state/source-files file
            ]
            if all [header? list: select header 'currencies] [
                foreach c list [append system/locale/currencies/list c]
            ]
            if header? [code: next code]
            if :callback [code: compose/only [do/trace (code) :callback]]
            set/any 'code try/all/keep [
                set/any 'code catch/name code 'console
                done?: yes
                either 'halt-request = :code [print "(halted)"] [:code]
            ]
            if file? file [
                change-dir saved
                take/last system/state/source-files
            ]
            if all [error? :code not done?] [do :code]
            :code
        ]
        by: unset
        cat: unset
        rank: unset
        duration: unset
        values-of: func [{Returns the list of values of a value that supports reflection} value][reflect :value 'values]
        sort-by: unset
        raw: unset
        logic?: func ["Returns true if the value is this type" value [any-type!]][logic! = type? :value]
        use: unset
        ~code: unset
        trace?: unset
        dumper: unset
        guided-trace: unset
        inspector: unset
        version: unset
        hex: unset
        as-color: routine [
            "Combine R, G and B values into a tuple"
            r [integer!]
            g [integer!]
            b [integer!]
        ][
            err: case [
                r < 0 [r]
                g < 0 [g]
                b < 0 [b]
                true [0]
            ]
            if err <> 0 [fire [TO_ERROR (script invalid-arg) integer/push err]]
            arr1: (b % 256 << 16) or (g % 256 << 8) or (r % 256)
            stack/set-last as red-value! tuple/push 3 arr1 0 0
        ]
        as-rgba: routine [
            {Combine R, G, B and A color components into a tuple}
            r [integer!]
            g [integer!]
            b [integer!]
            a [integer!]
        ][
            as-ipv4 r g b a
        ]
        point: unset
        A1: unset
        B1: unset
        A2: unset
        B2: unset
        TYPE_EVENT: unset
        class-of: func ["Returns the class ID of an object" value][reflect :value 'class]
        face!: make object! [
            type: 'face
            offset: none
            size: none
            text: none
            image: none
            color: none
            menu: none
            data: none
            enabled?: true
            visible?: true
            selected: none
            flags: none
            options: none
            parent: none
            pane: none
            state: none
            rate: none
            edge: none
            para: none
            font: none
            actors: none
            extra: none
            draw: none
        ]
        parent: unset
        para: unset
        font: unset
        actors: unset
        handle: unset
        screen: unset
        view: func [
            {Displays a window view from a layout block or from a window face}
            spec [block! object!] "Layout block or face object"
            /tight "Zero offset and origin"
            /options
            opts [block!] "Optional features in [name: value] format"
            /flags
            flgs [block! word!] "One or more window flags"
            /no-wait "Return immediately - do not wait"
            /no-sync "Requires `show` calls to refresh faces"
            /local sync? result
        ][
            unless system/view/screens [system/view/platform/init]
            sync?: system/view/auto-sync?
            if no-sync [system/view/auto-sync?: no]
            if block? spec [spec: either tight [layout/tight spec] [layout spec]]
            if spec/type <> 'window [cause-error 'script 'not-window []]
            if options [set/any spec make object! opts]
            if flags [spec/flags: either spec/flags [unique union to-block spec/flags to-block flgs] [flgs]]
            unless spec/text [spec/text: "Red: untitled"]
            unless spec/offset [center-face/with spec get-current-screen]
            unless show spec [exit]
            set/any 'result either no-wait [
                do-events/no-wait
                spec
            ] [
                do-events ()
            ]
            system/view/auto-sync?: sync?
            :result
        ]
        get-current-screen: func [
            {Returns the screen face of the Display where the mouse cursor is currently located}
            return: [object!] "Screen face"
            /local handle screen
        ][
            handle: system/view/platform/get-current-screen
            foreach screen system/view/screens [if screen/state/1 = handle [return screen]]
        ]
        screens: unset
        h: unset
        rich-text: make object! [
            rtd: make object! [
                stack: []
                color-stk: []
                out: none
                text: none
                s-idx: none
                s: none
                pos: none
                v: none
                l: none
                cur: none
                pos1: none
                mark: []
                col: 0
                cols: []
                nested: [ahead block! into rtd]
                color: [
                    s: tuple! (v: s/1)
                    | issue! (v: hex-to-rgb s/1)
                    | word! if (tuple? attempt [v: get s/1])
                ]
                f-args: [
                    ahead block! into [integer! string! | string! integer!]
                    | integer!
                    | string!
                ]
                style!: make typeset! [word! path! tuple! tag!]
                style: [ahead style! [
                    ['b | 'bold | <b>] (push 'b) [nested | rtd [/b | /bold | </b>]] (pop 'b)
                    | ['i | 'italic | <i>] (push 'i) [nested | rtd [/i | /italic | </i>]] (pop 'i)
                    | ['u | 'underline | <u>] (push 'u) [nested | rtd [/u | /underline | </u>]] (pop 'u)
                    | ['s | 'strike | <s>] (push 's) [nested | rtd [/s | /strike | </s>]] (pop 's)
                    | ['f | 'font | <font>]
                    s: f-args (push either block? s/1 [head insert copy s/1 'f] [reduce ['f s/1]])
                    [nested | rtd [/f | /font | </font>]]
                    (pop 'f)
                    | ['bg | <bg>] color (push reduce ['bg v]) [nested | rtd [/bg | </bg>]] (pop 'bg)
                    | color (push-color v) opt [nested (pop-color)]
                    | ahead path!
                    into [
                        (col: 0 insert/only mark tail stack) some [
                            (v: none)
                            s: ['b | 'i | 'u | 's | word! if (tuple? attempt [v: get s/1])]
                            (either v [col: col + 1 push-color v] [push s/1])
                        ] (insert cols col)
                    ]
                    nested (pop-all take mark)
                ]]
                rtd: [some [pos: style | s: [string! | char!] (append text s/1 s-idx: tail-idx?)]]
                tail-idx?: func [][index? tail text]
                push-color: func [c [tuple!]][reduce/into [s-idx '_ c] tail color-stk]
                pop-color: func [/local entry pos][
                    entry: skip tail color-stk -3
                    repend out [as-pair entry/1 tail-idx? - entry/1 entry/3]
                    new-line skip tail out -2 on
                    clear entry
                ]
                close-colors: func [/local pos][
                    pos: tail color-stk
                    while [pos: find/reverse pos '_] [
                        pos/1: tail-idx?
                        insert out as-pair pos/-1 tail-idx? - pos/-1
                        insert next out pos/2
                        new-line out on
                        pos: remove/part skip pos -1 3
                    ]
                ]
                push: func [style [word! block!]][reduce/into [s-idx style] tail stack]
                pop: func [style [word!]
                /local entry type][
                    entry: back back tail stack
                    type: any [all [block? entry/2 entry/2/1] entry/2]
                    either style = type [
                        if entry/1 < tail-idx? [
                            append out as-pair entry/1 tail-idx? - entry/1
                            new-line back tail out on
                            append out switch style [
                                b ['bold]
                                i ['italic]
                                u ['underline]
                                s ['strike]
                                f [next entry/2]
                                bg [reduce ['backdrop entry/2/2]]
                            ]
                        ]
                        clear skip tail stack -2
                    ] [cause-error 'script 'rtd-no-match reduce [style]]
                ]
                pop-all: func [mark [block!]
                /local first? i][
                    first?: yes
                    unless empty? cols [repeat i take cols [pop-color]]
                    while [mark <> tail stack] [
                        pop last stack
                        either first? [first?: no] [remove skip tail out -2]
                    ]
                ]
                optimize: func [
                    /local cur pos range pos1 e s l mov
                ][
                    parse out [
                        any [
                            cur: pos: pair! (range: pos/1) [to pair! pos: pos1: | to end] e:
                            any [
                                to range s: skip [to pair! | to end] e: (
                                    s: remove s
                                    either tuple? s/1 [pos: next cur] [pos: pos1]
                                    e: skip move/part s pos l: offset? s back e l
                                ) :e
                            ] (
                                pos: :cur mov: no
                                while [pos: find/reverse pos pair!] [
                                    case [
                                        any [
                                            pos/1/1 > cur/1/1
                                            all [pos/1/1 = cur/1/1 pos/1/2 < cur/1/2]
                                        ] [
                                            mov: yes
                                            pos1: :pos
                                            if head? pos1 [
                                                move/part cur pos1 offset? cur e
                                                break
                                            ]
                                        ]
                                        mov [
                                            move/part cur pos1 offset? cur e
                                            break
                                        ]
                                        'else [break]
                                    ]
                                ]
                            )
                        ]
                    ]
                ]
            ]
            line-height?: func [
                {Given a text position, returns the corresponding line's height}
                face [object!]
                pos [integer!]
                return: [float!]
            ][
                system/view/platform/text-box-metrics face pos 2
            ]
            line-count?: func [
                "number of lines (> 1 if line wrapped)"
                face [object!]
                return: [integer!]
            ][
                system/view/platform/text-box-metrics face 0 4
            ]
        ]
        handles: unset
        text-box-metrics: unset
        size-text: func [
            "Returns the area size of the text in a face"
            face [object!] "Face containing the text to size"
            /with "Provide a text string instead of face/text"
            text [string!] "Text to measure"
            return: [point2D! none!] "Return the text's size or NONE if failed"
            /local h
        ][
            either face/type = 'rich-text [
                if block? h: face/handles [poke h length? h true]
                system/view/platform/text-box-metrics face 0 3
            ] [
                system/view/platform/size-text face text
            ]
        ]
        lower: unset
        pt: unset
        hex-to-rgb: func [
            {Converts a color in hex format to a tuple value; returns NONE if it fails}
            hex [issue!] "Accepts #rgb, #rrggbb, #rrggbbaa"
            return: [tuple! none!]
            /local str bin
        ][
            switch length? str: form hex [
                3 [
                    uppercase str
                    forall str [str/1: str/1 - pick "70" str/1 >= #"A"]
                    as-color 17 * str/1 17 * str/2 17 * str/3
                ]
                6 [if bin: to binary! hex [as-color bin/1 bin/2 bin/3]]
                8 [if bin: to binary! hex [as-rgba bin/1 bin/2 bin/3 bin/4]]
            ]
        ]
        tuple?: func ["Returns true if the value is this type" value [any-type!]][tuple! = type? :value]
        bold: unset
        italic: unset
        u: unset
        underline: unset
        strike: unset
        bg: unset
        _: unset
        backdrop: unset
        rtd-no-match: unset
        first?: unset
        mov: unset
        offset?: func [
            "Returns the offset between two series positions"
            series1 [series!]
            series2 [series!]
        ][
            subtract index? series2 index? series1
        ]
        rtd-invalid-syntax: unset
        make-face: func [
            {Make a face from a given style name or example face}
            style [word!] "A face type"
            /spec
            blk [block!] "Spec block of face options expressed in VID"
            /offset
            xy [pair!] "Offset of the face"
            /size
            wh [pair!] "Size of the face"
            /local
            svv face styles model opts css
        ][
            svv: system/view/VID
            styles: svv/styles
            unless model: select styles style [
                cause-error 'script 'face-type reduce [style]
            ]
            face: make face! copy/deep model/template
            unless spec [blk: []]
            opts: svv/opts-proto
            css: make block! 2
            reactors: make block! 4
            spec: svv/fetch-options/no-skip face opts model blk css reactors no
            if model/init [do bind model/init face]
            svv/process-reactors reactors
            face/offset: any [xy face/offset 0x0]
            if size [face/size: wh]
            face
        ]
        axis: unset
        metrics: unset
        toggle: unset
        facet: unset
        TYPE_WORD: unset
        EQUAL_WORDS?: unset
        rs-tail: unset
        TYPE_LIT_WORD: unset
        gui-console-ctx: make object! [
            cfg-dir: %/C/Users/qtxie/AppData/Roaming/Red/Red-Console/
            cfg-path: %/C/Users/qtxie/AppData/Roaming/Red/Red-Console/console-cfg.red
            cfg: [
                win-pos: (559.2, 339.2)
                win-size: 839x654
                font-name: "Consolas"
                font-size: 11
                font-color: 222.222.222
                background: 22.22.22 buffer-lines: 10000 history: ["q" {sort/case "ABCabcdefDEF"} {sort "ABCabcdefDEF"} {sort/stable "ABCabcdefDEF"} "? tracing?" "tracing?" "to-char 128917" "to-char 8217" "to-char 33" "to-char 101" "to-char 117" "to-char 115" "to-char 105" "to-char 58" "to-char 32" "to-char 109" "to-char 91" "to-hex 14911" "q" "to-hex 1560281120" "q" "to-hex 1560281120" "q" "? write" "write %all-red-values.txt buffer" "" "]" "    append buffer newline" "    ]" "^-    append buffer mold spec-of :val" {^-    append buffer " "} "^-    append buffer form type? :val" "    ][" "^-    ]" "^-^-    append buffer mold :val" "^-    if word = 'system [" "    either object? :val [" {    append buffer ": "} "    append buffer mold word" "    val: get word" {foreach word sort get-sys-words :any-interesting? [} "buffer: make string! 50000" "]" "^-]" "^-^-]" "^-^-^-]" "^-^-^-^-]" "^-^-^-^-^-keep word" {^-^-^-^-if #"_" <> first mold word [} "^-^-^-if test get/any word [" "^-^-foreach word words-of system/words [" "^-collect [" "get-sys-words: func [test [function!]][" {any-interesting?: func [{Returns true if the value is any type of any-function} value [any-type!]][find types type? :value]} {types: make typeset! [native! action! function! routine! object!]} "object!" " [a: 2]" "make object! [a: 2]" "make object [a: 2]" "make context! [a: 2]" "make context [a: 2]" "make function! [a b][a + b]" "]" {    a + b                        ; The body of the function} "] [" {    b [integer! decimal!]        ; Argument 'b', restricted to number types} {    a [integer! decimal!]        ; Argument 'a', restricted to number types} {    "Adds two numbers together."  ; Optional help string} "add-numbers: make function! [" {    a + b                        ; The body of the function} "] [" {    b [integer! decimal!]        ; Argument 'b', restricted to number types} {    a [integer! decimal!]        ; Argument 'a', restricted to number types} {    "Adds two numbers together."  ; Optional help string} "make function! []add-numbers: make function! [" "make function! []" "make function! [][]" "make function [][]" "make func [][]" {replace/all "a-b-c" "-" "\\-"} {replace "a-b-c" "-" "\\-"} "? replace" "? rep" "replace" "make block! [32]" "make integer! [32]" "make object! [a: 32]" "make object [a: 3]" "make object []" "x/b/c" "        scope_stack: &mut Vec<String>," "x/b/c" "system/words/x/a" "x/b/c" "]" "c: does [x/a]" "b: context [" "x: does [print 32]" "a: 2" "x: context ["] mouse-paste?: true menu-bar?: false dark-mode?: true
            ]
            font: make object! [
                name: "Consolas"
                size: 11
                style: none
                angle: 0
                color: 222.222.222
                anti-alias?: false
                shadow: none
                state: [handle! none none]
                parent: []
            ]
            caret-clr: 222.222.222.1
            caret-rate: 0:00:00.53
            scroller: make object! [
                position: 1
                page-size: 38
                min-size: 1
                max-size: 37
                visible?: true
                vertical?: true
                parent: make object! [
                    type: 'rich-text
                    offset: (0, 0)
                    size: 840x655
                    text: none
                    image: none
                    color: 22.22.22
                    menu: none
                    data: none
                    enabled?: true
                    visible?: true
                    selected: none
                    flags: [scrollable all-over]
                    options: [cursor: I-beam]
                    parent: make object! [
                        type: 'window
                        offset: (559.2, 339.2)
                        size: 839x654
                        text: "Red Console"
                        image: none
                        color: none
                        menu: none
                        data: none
                        enabled?: true
                        visible?: false
                        selected: make object! [...]
                        flags: [resize]
                        options: none
                        parent: make object! [
                            type: 'screen
                            offset: 0x0
                            size: 2048x1152
                            text: none
                            image: none
                            color: none
                            menu: none
                            data: 1.25
                            enabled?: true
                            visible?: true
                            selected: none
                            flags: none
                            options: none
                            parent: none
                            pane: []
                            state: [handle! 0 none [1]]
                            rate: none
                            edge: none
                            para: none
                            font: none
                            actors: none
                            extra: none
                            draw: none
                        ]
                        pane: [make object! [...] make object! [
                            type: 'base
                            offset: (0, 0)
                            size: 1x17
                            text: none
                            image: none
                            color: 222.222.222.1
                            menu: none
                            data: none
                            enabled?: false
                            visible?: true
                            selected: none
                            flags: none
                            options: [caret make object! [...] cursor: I-beam accelerated: yes]
                            parent: make object! [...]
                            pane: none
                            state: [handle! 0 none false]
                            rate: 0:00:00.53
                            edge: none
                            para: none
                            font: none
                            actors: make object! [
                                on-time: func [face [object!] event [event!]][
                                    face/color: either face/color = caret-clr [255.255.255.254] [caret-clr]
                                    'done
                                ]
                            ]
                            extra: none
                            draw: none
                        ] make object! [
                            type: 'panel
                            offset: (0, 0)
                            size: 150x200
                            text: none
                            image: none
                            color: 0.0.128
                            menu: none
                            data: none
                            enabled?: true
                            visible?: false
                            selected: none
                            flags: none
                            options: none
                            parent: make object! [...]
                            pane: none
                            state: [handle! 0 none false]
                            rate: none
                            edge: none
                            para: none
                            font: make object! [
                                name: "Consolas"
                                size: 11
                                style: none
                                angle: 0
                                color: 255.255.255
                                anti-alias?: false
                                shadow: none
                                state: [handle! none none]
                                parent: [make object! [
                                    type: 'rich-text
                                    offset: none
                                    size: 820x655
                                    text: "XXXXXXXXXX"
                                    image: none
                                    color: none
                                    menu: none
                                    data: []
                                    enabled?: true
                                    visible?: true
                                    selected: none
                                    flags: none
                                    options: none
                                    parent: none
                                    pane: none
                                    state: none
                                    rate: none
                                    edge: none
                                    para: none
                                    font: make object! [
                                        name: "Consolas"
                                        size: 11
                                        style: none
                                        angle: 0
                                        color: 222.222.222
                                        anti-alias?: false
                                        shadow: none
                                        state: [handle! none none]
                                        parent: [...]
                                    ]
                                    actors: none
                                    extra: none
                                    draw: none
                                    tabs: 32.4
                                    line-spacing: 17
                                    handles: [handle! handle! "XXXXXXXXXX" true]
                                ]]
                            ]
                            actors: make object! [
                                on-key-down: func [face [object!] event [event!]][
                                    probe event/key
                                ]
                            ]
                            extra: none
                            draw: none
                        ]]
                        state: [handle! 0 none false]
                        rate: none
                        edge: none
                        para: none
                        font: none
                        actors: make object! [
                            on-menu: func [face [object!] event [event!] /local ft f][
                                switch event/picked [
                                    about-msg [display-about]
                                    shortcuts [show-shortcuts]
                                    quit [self/on-close face event]
                                    run-file [if f: request-file [terminal/run-file f]]
                                    choose-font [
                                        if ft: request-font/font/mono font [
                                            font: ft
                                            console/font: font
                                            terminal/zoom font
                                        ]
                                    ]
                                    settings [show-cfg-dialog]
                                ]
                            ]
                            on-close: func [face [object!] event [event!]][
                                system/view/platform/exit-event-loop
                                foreach screen system/view/screens [clear head screen/pane]
                                quit
                            ]
                            on-resizing: func [face [object!] event [event!]
                            /local new-sz][
                                new-sz: to-pair event/offset + 1x1
                                console/size: new-sz
                                terminal/resize new-sz
                                terminal/adjust-console-size new-sz
                                unless system/view/auto-sync? [show face]
                            ]
                            on-resize: func [face [object!] event [event!]
                            /local new-sz][
                                new-sz: to-pair event/offset + 1x1
                                console/size: new-sz
                                terminal/resize new-sz
                                terminal/adjust-console-size new-sz
                                unless system/view/auto-sync? [show face]
                            ]
                            on-focus: func [face [object!] event [event!]][
                                focused?: yes
                                caret/color: caret-clr
                                unless caret/enabled? [caret/enabled?: yes]
                                caret/rate: caret-rate
                                terminal/refresh/force
                            ]
                            on-unfocus: func [face [object!] event [event!]][
                                focused?: no
                                if caret/enabled? [caret/enabled?: no]
                                caret/rate: none
                            ]
                            on-key-down: func [face [object!] event [event!]][
                                if event/key = 'F12 [
                                    cfg/menu-bar?: to-word none? face/menu
                                    toggle-menu-bar
                                ]
                            ]
                        ]
                        extra: none
                        draw: none
                    ]
                    pane: none
                    state: [handle! 0 none false]
                    rate: 10
                    edge: none
                    para: none
                    font: make object! [
                        name: "Consolas"
                        size: 11
                        style: none
                        angle: 0
                        color: 222.222.222
                        anti-alias?: false
                        shadow: none
                        state: [handle! none none]
                        parent: []
                    ]
                    actors: make object! [
                        on-time: func [face [object!] event [event!]][
                            if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                            terminal/on-time
                            'done
                        ]
                        on-drawing: func [face [object!] event [event!]][
                            terminal/paint
                        ]
                        on-scroll: func [face [object!] event [event!]][
                            terminal/scroll event
                        ]
                        on-wheel: func [face [object!] event [event!]][
                            either event/ctrl? [
                                terminal/zoom event
                            ] [
                                terminal/scroll event
                            ]
                        ]
                        on-key: func [face [object!] event [event!]][
                            terminal/press-key event
                        ]
                        on-key-down: func [face [object!] event [event!]][
                            if all [1 = length? event/flags find event/flags 'alt] [
                                switch event/key [
                                    #"A" [terminal/select-all]
                                    #"O" [show-cfg-dialog]
                                ]
                            ]
                        ]
                        on-ime: func [face [object!] event [event!]][
                            terminal/process-ime-input event
                        ]
                        on-down: func [face [object!] event [event!]][
                            terminal/mouse-down event
                        ]
                        on-up: func [face [object!] event [event!]][
                            terminal/mouse-up event
                        ]
                        on-alt-down: func [face [object!] event [event!]][
                            if cfg/mouse-paste? = 'true [
                                either terminal/text-selected? [
                                    terminal/copy-selection
                                    clear terminal/selects
                                    system/view/platform/redraw face
                                ] [
                                    terminal/paste
                                ]
                            ]
                        ]
                        on-over: func [face [object!] event [event!]][
                            terminal/mouse-move to-pair event/offset
                        ]
                        on-menu: func [face [object!] event [event!]][
                            switch event/picked [
                                copy [terminal/copy-selection]
                                paste [terminal/paste]
                                select-all [terminal/select-all]
                            ]
                            'done
                        ]
                    ]
                    extra: none
                    draw: none
                    tabs: none
                    line-spacing: 'default
                    handles: none
                    init: func [/local box][
                        terminal/windows: get in get-current-screen 'pane
                        box: terminal/box
                        box/data: make block! 200
                        scroller: get-scroller self 'horizontal
                        scroller/visible?: no
                        scroller: get-scroller self 'vertical
                        scroller/position: 1
                        scroller/max-size: 2
                    ]
                ]
                page: 1
            ]
            focused?: true
            console-menu: [
                "Copy^-Ctrl+C" copy
                "Paste^-Shift+Ins" paste
                ---
                "Select All" select-all
            ]
            console: make object! [
                type: 'rich-text
                offset: (0, 0)
                size: 840x655
                text: none
                image: none
                color: 22.22.22
                menu: none
                data: none
                enabled?: true
                visible?: true
                selected: none
                flags: [scrollable all-over]
                options: [cursor: I-beam]
                parent: make object! [
                    type: 'window
                    offset: (559.2, 339.2)
                    size: 839x654
                    text: "Red Console"
                    image: none
                    color: none
                    menu: none
                    data: none
                    enabled?: true
                    visible?: false
                    selected: make object! [...]
                    flags: [resize]
                    options: none
                    parent: make object! [
                        type: 'screen
                        offset: 0x0
                        size: 2048x1152
                        text: none
                        image: none
                        color: none
                        menu: none
                        data: 1.25
                        enabled?: true
                        visible?: true
                        selected: none
                        flags: none
                        options: none
                        parent: none
                        pane: []
                        state: [handle! 0 none [1]]
                        rate: none
                        edge: none
                        para: none
                        font: none
                        actors: none
                        extra: none
                        draw: none
                    ]
                    pane: [make object! [...] make object! [
                        type: 'base
                        offset: (0, 0)
                        size: 1x17
                        text: none
                        image: none
                        color: 222.222.222.1
                        menu: none
                        data: none
                        enabled?: false
                        visible?: true
                        selected: none
                        flags: none
                        options: [caret make object! [...] cursor: I-beam accelerated: yes]
                        parent: make object! [...]
                        pane: none
                        state: [handle! 0 none false]
                        rate: 0:00:00.53
                        edge: none
                        para: none
                        font: none
                        actors: make object! [
                            on-time: func [face [object!] event [event!]][
                                face/color: either face/color = caret-clr [255.255.255.254] [caret-clr]
                                'done
                            ]
                        ]
                        extra: none
                        draw: none
                    ] make object! [
                        type: 'panel
                        offset: (0, 0)
                        size: 150x200
                        text: none
                        image: none
                        color: 0.0.128
                        menu: none
                        data: none
                        enabled?: true
                        visible?: false
                        selected: none
                        flags: none
                        options: none
                        parent: make object! [...]
                        pane: none
                        state: [handle! 0 none false]
                        rate: none
                        edge: none
                        para: none
                        font: make object! [
                            name: "Consolas"
                            size: 11
                            style: none
                            angle: 0
                            color: 255.255.255
                            anti-alias?: false
                            shadow: none
                            state: [handle! none none]
                            parent: [make object! [
                                type: 'rich-text
                                offset: none
                                size: 820x655
                                text: "XXXXXXXXXX"
                                image: none
                                color: none
                                menu: none
                                data: []
                                enabled?: true
                                visible?: true
                                selected: none
                                flags: none
                                options: none
                                parent: none
                                pane: none
                                state: none
                                rate: none
                                edge: none
                                para: none
                                font: make object! [
                                    name: "Consolas"
                                    size: 11
                                    style: none
                                    angle: 0
                                    color: 222.222.222
                                    anti-alias?: false
                                    shadow: none
                                    state: [handle! none none]
                                    parent: [...]
                                ]
                                actors: none
                                extra: none
                                draw: none
                                tabs: 32.4
                                line-spacing: 17
                                handles: [handle! handle! "XXXXXXXXXX" true]
                            ]]
                        ]
                        actors: make object! [
                            on-key-down: func [face [object!] event [event!]][
                                probe event/key
                            ]
                        ]
                        extra: none
                        draw: none
                    ]]
                    state: [handle! 0 none false]
                    rate: none
                    edge: none
                    para: none
                    font: none
                    actors: make object! [
                        on-menu: func [face [object!] event [event!] /local ft f][
                            switch event/picked [
                                about-msg [display-about]
                                shortcuts [show-shortcuts]
                                quit [self/on-close face event]
                                run-file [if f: request-file [terminal/run-file f]]
                                choose-font [
                                    if ft: request-font/font/mono font [
                                        font: ft
                                        console/font: font
                                        terminal/zoom font
                                    ]
                                ]
                                settings [show-cfg-dialog]
                            ]
                        ]
                        on-close: func [face [object!] event [event!]][
                            system/view/platform/exit-event-loop
                            foreach screen system/view/screens [clear head screen/pane]
                            quit
                        ]
                        on-resizing: func [face [object!] event [event!]
                        /local new-sz][
                            new-sz: to-pair event/offset + 1x1
                            console/size: new-sz
                            terminal/resize new-sz
                            terminal/adjust-console-size new-sz
                            unless system/view/auto-sync? [show face]
                        ]
                        on-resize: func [face [object!] event [event!]
                        /local new-sz][
                            new-sz: to-pair event/offset + 1x1
                            console/size: new-sz
                            terminal/resize new-sz
                            terminal/adjust-console-size new-sz
                            unless system/view/auto-sync? [show face]
                        ]
                        on-focus: func [face [object!] event [event!]][
                            focused?: yes
                            caret/color: caret-clr
                            unless caret/enabled? [caret/enabled?: yes]
                            caret/rate: caret-rate
                            terminal/refresh/force
                        ]
                        on-unfocus: func [face [object!] event [event!]][
                            focused?: no
                            if caret/enabled? [caret/enabled?: no]
                            caret/rate: none
                        ]
                        on-key-down: func [face [object!] event [event!]][
                            if event/key = 'F12 [
                                cfg/menu-bar?: to-word none? face/menu
                                toggle-menu-bar
                            ]
                        ]
                    ]
                    extra: none
                    draw: none
                ]
                pane: none
                state: [handle! 0 none false]
                rate: 10
                edge: none
                para: none
                font: make object! [
                    name: "Consolas"
                    size: 11
                    style: none
                    angle: 0
                    color: 222.222.222
                    anti-alias?: false
                    shadow: none
                    state: [handle! none none]
                    parent: []
                ]
                actors: make object! [
                    on-time: func [face [object!] event [event!]][
                        if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                        terminal/on-time
                        'done
                    ]
                    on-drawing: func [face [object!] event [event!]][
                        terminal/paint
                    ]
                    on-scroll: func [face [object!] event [event!]][
                        terminal/scroll event
                    ]
                    on-wheel: func [face [object!] event [event!]][
                        either event/ctrl? [
                            terminal/zoom event
                        ] [
                            terminal/scroll event
                        ]
                    ]
                    on-key: func [face [object!] event [event!]][
                        terminal/press-key event
                    ]
                    on-key-down: func [face [object!] event [event!]][
                        if all [1 = length? event/flags find event/flags 'alt] [
                            switch event/key [
                                #"A" [terminal/select-all]
                                #"O" [show-cfg-dialog]
                            ]
                        ]
                    ]
                    on-ime: func [face [object!] event [event!]][
                        terminal/process-ime-input event
                    ]
                    on-down: func [face [object!] event [event!]][
                        terminal/mouse-down event
                    ]
                    on-up: func [face [object!] event [event!]][
                        terminal/mouse-up event
                    ]
                    on-alt-down: func [face [object!] event [event!]][
                        if cfg/mouse-paste? = 'true [
                            either terminal/text-selected? [
                                terminal/copy-selection
                                clear terminal/selects
                                system/view/platform/redraw face
                            ] [
                                terminal/paste
                            ]
                        ]
                    ]
                    on-over: func [face [object!] event [event!]][
                        terminal/mouse-move to-pair event/offset
                    ]
                    on-menu: func [face [object!] event [event!]][
                        switch event/picked [
                            copy [terminal/copy-selection]
                            paste [terminal/paste]
                            select-all [terminal/select-all]
                        ]
                        'done
                    ]
                ]
                extra: none
                draw: none
                tabs: none
                line-spacing: 'default
                handles: none
                init: func [/local box][
                    terminal/windows: get in get-current-screen 'pane
                    box: terminal/box
                    box/data: make block! 200
                    scroller: get-scroller self 'horizontal
                    scroller/visible?: no
                    scroller: get-scroller self 'vertical
                    scroller/position: 1
                    scroller/max-size: 2
                ]
            ]
            caret: make object! [
                type: 'base
                offset: (0, 0)
                size: 1x17
                text: none
                image: none
                color: 222.222.222.1
                menu: none
                data: none
                enabled?: false
                visible?: true
                selected: none
                flags: none
                options: [caret make object! [
                    type: 'rich-text
                    offset: (0, 0)
                    size: 840x655
                    text: none
                    image: none
                    color: 22.22.22
                    menu: none
                    data: none
                    enabled?: true
                    visible?: true
                    selected: none
                    flags: [scrollable all-over]
                    options: [cursor: I-beam]
                    parent: make object! [
                        type: 'window
                        offset: (559.2, 339.2)
                        size: 839x654
                        text: "Red Console"
                        image: none
                        color: none
                        menu: none
                        data: none
                        enabled?: true
                        visible?: false
                        selected: make object! [...]
                        flags: [resize]
                        options: none
                        parent: make object! [
                            type: 'screen
                            offset: 0x0
                            size: 2048x1152
                            text: none
                            image: none
                            color: none
                            menu: none
                            data: 1.25
                            enabled?: true
                            visible?: true
                            selected: none
                            flags: none
                            options: none
                            parent: none
                            pane: []
                            state: [handle! 0 none [1]]
                            rate: none
                            edge: none
                            para: none
                            font: none
                            actors: none
                            extra: none
                            draw: none
                        ]
                        pane: [make object! [...] make object! [...] make object! [
                            type: 'panel
                            offset: (0, 0)
                            size: 150x200
                            text: none
                            image: none
                            color: 0.0.128
                            menu: none
                            data: none
                            enabled?: true
                            visible?: false
                            selected: none
                            flags: none
                            options: none
                            parent: make object! [...]
                            pane: none
                            state: [handle! 0 none false]
                            rate: none
                            edge: none
                            para: none
                            font: make object! [
                                name: "Consolas"
                                size: 11
                                style: none
                                angle: 0
                                color: 255.255.255
                                anti-alias?: false
                                shadow: none
                                state: [handle! none none]
                                parent: [make object! [
                                    type: 'rich-text
                                    offset: none
                                    size: 820x655
                                    text: "XXXXXXXXXX"
                                    image: none
                                    color: none
                                    menu: none
                                    data: []
                                    enabled?: true
                                    visible?: true
                                    selected: none
                                    flags: none
                                    options: none
                                    parent: none
                                    pane: none
                                    state: none
                                    rate: none
                                    edge: none
                                    para: none
                                    font: make object! [
                                        name: "Consolas"
                                        size: 11
                                        style: none
                                        angle: 0
                                        color: 222.222.222
                                        anti-alias?: false
                                        shadow: none
                                        state: [handle! none none]
                                        parent: [...]
                                    ]
                                    actors: none
                                    extra: none
                                    draw: none
                                    tabs: 32.4
                                    line-spacing: 17
                                    handles: [handle! handle! "XXXXXXXXXX" true]
                                ]]
                            ]
                            actors: make object! [
                                on-key-down: func [face [object!] event [event!]][
                                    probe event/key
                                ]
                            ]
                            extra: none
                            draw: none
                        ]]
                        state: [handle! 0 none false]
                        rate: none
                        edge: none
                        para: none
                        font: none
                        actors: make object! [
                            on-menu: func [face [object!] event [event!] /local ft f][
                                switch event/picked [
                                    about-msg [display-about]
                                    shortcuts [show-shortcuts]
                                    quit [self/on-close face event]
                                    run-file [if f: request-file [terminal/run-file f]]
                                    choose-font [
                                        if ft: request-font/font/mono font [
                                            font: ft
                                            console/font: font
                                            terminal/zoom font
                                        ]
                                    ]
                                    settings [show-cfg-dialog]
                                ]
                            ]
                            on-close: func [face [object!] event [event!]][
                                system/view/platform/exit-event-loop
                                foreach screen system/view/screens [clear head screen/pane]
                                quit
                            ]
                            on-resizing: func [face [object!] event [event!]
                            /local new-sz][
                                new-sz: to-pair event/offset + 1x1
                                console/size: new-sz
                                terminal/resize new-sz
                                terminal/adjust-console-size new-sz
                                unless system/view/auto-sync? [show face]
                            ]
                            on-resize: func [face [object!] event [event!]
                            /local new-sz][
                                new-sz: to-pair event/offset + 1x1
                                console/size: new-sz
                                terminal/resize new-sz
                                terminal/adjust-console-size new-sz
                                unless system/view/auto-sync? [show face]
                            ]
                            on-focus: func [face [object!] event [event!]][
                                focused?: yes
                                caret/color: caret-clr
                                unless caret/enabled? [caret/enabled?: yes]
                                caret/rate: caret-rate
                                terminal/refresh/force
                            ]
                            on-unfocus: func [face [object!] event [event!]][
                                focused?: no
                                if caret/enabled? [caret/enabled?: no]
                                caret/rate: none
                            ]
                            on-key-down: func [face [object!] event [event!]][
                                if event/key = 'F12 [
                                    cfg/menu-bar?: to-word none? face/menu
                                    toggle-menu-bar
                                ]
                            ]
                        ]
                        extra: none
                        draw: none
                    ]
                    pane: none
                    state: [handle! 0 none false]
                    rate: 10
                    edge: none
                    para: none
                    font: make object! [
                        name: "Consolas"
                        size: 11
                        style: none
                        angle: 0
                        color: 222.222.222
                        anti-alias?: false
                        shadow: none
                        state: [handle! none none]
                        parent: []
                    ]
                    actors: make object! [
                        on-time: func [face [object!] event [event!]][
                            if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                            terminal/on-time
                            'done
                        ]
                        on-drawing: func [face [object!] event [event!]][
                            terminal/paint
                        ]
                        on-scroll: func [face [object!] event [event!]][
                            terminal/scroll event
                        ]
                        on-wheel: func [face [object!] event [event!]][
                            either event/ctrl? [
                                terminal/zoom event
                            ] [
                                terminal/scroll event
                            ]
                        ]
                        on-key: func [face [object!] event [event!]][
                            terminal/press-key event
                        ]
                        on-key-down: func [face [object!] event [event!]][
                            if all [1 = length? event/flags find event/flags 'alt] [
                                switch event/key [
                                    #"A" [terminal/select-all]
                                    #"O" [show-cfg-dialog]
                                ]
                            ]
                        ]
                        on-ime: func [face [object!] event [event!]][
                            terminal/process-ime-input event
                        ]
                        on-down: func [face [object!] event [event!]][
                            terminal/mouse-down event
                        ]
                        on-up: func [face [object!] event [event!]][
                            terminal/mouse-up event
                        ]
                        on-alt-down: func [face [object!] event [event!]][
                            if cfg/mouse-paste? = 'true [
                                either terminal/text-selected? [
                                    terminal/copy-selection
                                    clear terminal/selects
                                    system/view/platform/redraw face
                                ] [
                                    terminal/paste
                                ]
                            ]
                        ]
                        on-over: func [face [object!] event [event!]][
                            terminal/mouse-move to-pair event/offset
                        ]
                        on-menu: func [face [object!] event [event!]][
                            switch event/picked [
                                copy [terminal/copy-selection]
                                paste [terminal/paste]
                                select-all [terminal/select-all]
                            ]
                            'done
                        ]
                    ]
                    extra: none
                    draw: none
                    tabs: none
                    line-spacing: 'default
                    handles: none
                    init: func [/local box][
                        terminal/windows: get in get-current-screen 'pane
                        box: terminal/box
                        box/data: make block! 200
                        scroller: get-scroller self 'horizontal
                        scroller/visible?: no
                        scroller: get-scroller self 'vertical
                        scroller/position: 1
                        scroller/max-size: 2
                    ]
                ] cursor: I-beam accelerated: yes]
                parent: make object! [
                    type: 'window
                    offset: (559.2, 339.2)
                    size: 839x654
                    text: "Red Console"
                    image: none
                    color: none
                    menu: none
                    data: none
                    enabled?: true
                    visible?: false
                    selected: make object! [
                        type: 'rich-text
                        offset: (0, 0)
                        size: 840x655
                        text: none
                        image: none
                        color: 22.22.22
                        menu: none
                        data: none
                        enabled?: true
                        visible?: true
                        selected: none
                        flags: [scrollable all-over]
                        options: [cursor: I-beam]
                        parent: make object! [...]
                        pane: none
                        state: [handle! 0 none false]
                        rate: 10
                        edge: none
                        para: none
                        font: make object! [
                            name: "Consolas"
                            size: 11
                            style: none
                            angle: 0
                            color: 222.222.222
                            anti-alias?: false
                            shadow: none
                            state: [handle! none none]
                            parent: []
                        ]
                        actors: make object! [
                            on-time: func [face [object!] event [event!]][
                                if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                                terminal/on-time
                                'done
                            ]
                            on-drawing: func [face [object!] event [event!]][
                                terminal/paint
                            ]
                            on-scroll: func [face [object!] event [event!]][
                                terminal/scroll event
                            ]
                            on-wheel: func [face [object!] event [event!]][
                                either event/ctrl? [
                                    terminal/zoom event
                                ] [
                                    terminal/scroll event
                                ]
                            ]
                            on-key: func [face [object!] event [event!]][
                                terminal/press-key event
                            ]
                            on-key-down: func [face [object!] event [event!]][
                                if all [1 = length? event/flags find event/flags 'alt] [
                                    switch event/key [
                                        #"A" [terminal/select-all]
                                        #"O" [show-cfg-dialog]
                                    ]
                                ]
                            ]
                            on-ime: func [face [object!] event [event!]][
                                terminal/process-ime-input event
                            ]
                            on-down: func [face [object!] event [event!]][
                                terminal/mouse-down event
                            ]
                            on-up: func [face [object!] event [event!]][
                                terminal/mouse-up event
                            ]
                            on-alt-down: func [face [object!] event [event!]][
                                if cfg/mouse-paste? = 'true [
                                    either terminal/text-selected? [
                                        terminal/copy-selection
                                        clear terminal/selects
                                        system/view/platform/redraw face
                                    ] [
                                        terminal/paste
                                    ]
                                ]
                            ]
                            on-over: func [face [object!] event [event!]][
                                terminal/mouse-move to-pair event/offset
                            ]
                            on-menu: func [face [object!] event [event!]][
                                switch event/picked [
                                    copy [terminal/copy-selection]
                                    paste [terminal/paste]
                                    select-all [terminal/select-all]
                                ]
                                'done
                            ]
                        ]
                        extra: none
                        draw: none
                        tabs: none
                        line-spacing: 'default
                        handles: none
                        init: func [/local box][
                            terminal/windows: get in get-current-screen 'pane
                            box: terminal/box
                            box/data: make block! 200
                            scroller: get-scroller self 'horizontal
                            scroller/visible?: no
                            scroller: get-scroller self 'vertical
                            scroller/position: 1
                            scroller/max-size: 2
                        ]
                    ]
                    flags: [resize]
                    options: none
                    parent: make object! [
                        type: 'screen
                        offset: 0x0
                        size: 2048x1152
                        text: none
                        image: none
                        color: none
                        menu: none
                        data: 1.25
                        enabled?: true
                        visible?: true
                        selected: none
                        flags: none
                        options: none
                        parent: none
                        pane: []
                        state: [handle! 0 none [1]]
                        rate: none
                        edge: none
                        para: none
                        font: none
                        actors: none
                        extra: none
                        draw: none
                    ]
                    pane: [make object! [
                        type: 'rich-text
                        offset: (0, 0)
                        size: 840x655
                        text: none
                        image: none
                        color: 22.22.22
                        menu: none
                        data: none
                        enabled?: true
                        visible?: true
                        selected: none
                        flags: [scrollable all-over]
                        options: [cursor: I-beam]
                        parent: make object! [...]
                        pane: none
                        state: [handle! 0 none false]
                        rate: 10
                        edge: none
                        para: none
                        font: make object! [
                            name: "Consolas"
                            size: 11
                            style: none
                            angle: 0
                            color: 222.222.222
                            anti-alias?: false
                            shadow: none
                            state: [handle! none none]
                            parent: []
                        ]
                        actors: make object! [
                            on-time: func [face [object!] event [event!]][
                                if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                                terminal/on-time
                                'done
                            ]
                            on-drawing: func [face [object!] event [event!]][
                                terminal/paint
                            ]
                            on-scroll: func [face [object!] event [event!]][
                                terminal/scroll event
                            ]
                            on-wheel: func [face [object!] event [event!]][
                                either event/ctrl? [
                                    terminal/zoom event
                                ] [
                                    terminal/scroll event
                                ]
                            ]
                            on-key: func [face [object!] event [event!]][
                                terminal/press-key event
                            ]
                            on-key-down: func [face [object!] event [event!]][
                                if all [1 = length? event/flags find event/flags 'alt] [
                                    switch event/key [
                                        #"A" [terminal/select-all]
                                        #"O" [show-cfg-dialog]
                                    ]
                                ]
                            ]
                            on-ime: func [face [object!] event [event!]][
                                terminal/process-ime-input event
                            ]
                            on-down: func [face [object!] event [event!]][
                                terminal/mouse-down event
                            ]
                            on-up: func [face [object!] event [event!]][
                                terminal/mouse-up event
                            ]
                            on-alt-down: func [face [object!] event [event!]][
                                if cfg/mouse-paste? = 'true [
                                    either terminal/text-selected? [
                                        terminal/copy-selection
                                        clear terminal/selects
                                        system/view/platform/redraw face
                                    ] [
                                        terminal/paste
                                    ]
                                ]
                            ]
                            on-over: func [face [object!] event [event!]][
                                terminal/mouse-move to-pair event/offset
                            ]
                            on-menu: func [face [object!] event [event!]][
                                switch event/picked [
                                    copy [terminal/copy-selection]
                                    paste [terminal/paste]
                                    select-all [terminal/select-all]
                                ]
                                'done
                            ]
                        ]
                        extra: none
                        draw: none
                        tabs: none
                        line-spacing: 'default
                        handles: none
                        init: func [/local box][
                            terminal/windows: get in get-current-screen 'pane
                            box: terminal/box
                            box/data: make block! 200
                            scroller: get-scroller self 'horizontal
                            scroller/visible?: no
                            scroller: get-scroller self 'vertical
                            scroller/position: 1
                            scroller/max-size: 2
                        ]
                    ] make object! [...] make object! [
                        type: 'panel
                        offset: (0, 0)
                        size: 150x200
                        text: none
                        image: none
                        color: 0.0.128
                        menu: none
                        data: none
                        enabled?: true
                        visible?: false
                        selected: none
                        flags: none
                        options: none
                        parent: make object! [...]
                        pane: none
                        state: [handle! 0 none false]
                        rate: none
                        edge: none
                        para: none
                        font: make object! [
                            name: "Consolas"
                            size: 11
                            style: none
                            angle: 0
                            color: 255.255.255
                            anti-alias?: false
                            shadow: none
                            state: [handle! none none]
                            parent: [make object! [
                                type: 'rich-text
                                offset: none
                                size: 820x655
                                text: "XXXXXXXXXX"
                                image: none
                                color: none
                                menu: none
                                data: []
                                enabled?: true
                                visible?: true
                                selected: none
                                flags: none
                                options: none
                                parent: none
                                pane: none
                                state: none
                                rate: none
                                edge: none
                                para: none
                                font: make object! [
                                    name: "Consolas"
                                    size: 11
                                    style: none
                                    angle: 0
                                    color: 222.222.222
                                    anti-alias?: false
                                    shadow: none
                                    state: [handle! none none]
                                    parent: [...]
                                ]
                                actors: none
                                extra: none
                                draw: none
                                tabs: 32.4
                                line-spacing: 17
                                handles: [handle! handle! "XXXXXXXXXX" true]
                            ]]
                        ]
                        actors: make object! [
                            on-key-down: func [face [object!] event [event!]][
                                probe event/key
                            ]
                        ]
                        extra: none
                        draw: none
                    ]]
                    state: [handle! 0 none false]
                    rate: none
                    edge: none
                    para: none
                    font: none
                    actors: make object! [
                        on-menu: func [face [object!] event [event!] /local ft f][
                            switch event/picked [
                                about-msg [display-about]
                                shortcuts [show-shortcuts]
                                quit [self/on-close face event]
                                run-file [if f: request-file [terminal/run-file f]]
                                choose-font [
                                    if ft: request-font/font/mono font [
                                        font: ft
                                        console/font: font
                                        terminal/zoom font
                                    ]
                                ]
                                settings [show-cfg-dialog]
                            ]
                        ]
                        on-close: func [face [object!] event [event!]][
                            system/view/platform/exit-event-loop
                            foreach screen system/view/screens [clear head screen/pane]
                            quit
                        ]
                        on-resizing: func [face [object!] event [event!]
                        /local new-sz][
                            new-sz: to-pair event/offset + 1x1
                            console/size: new-sz
                            terminal/resize new-sz
                            terminal/adjust-console-size new-sz
                            unless system/view/auto-sync? [show face]
                        ]
                        on-resize: func [face [object!] event [event!]
                        /local new-sz][
                            new-sz: to-pair event/offset + 1x1
                            console/size: new-sz
                            terminal/resize new-sz
                            terminal/adjust-console-size new-sz
                            unless system/view/auto-sync? [show face]
                        ]
                        on-focus: func [face [object!] event [event!]][
                            focused?: yes
                            caret/color: caret-clr
                            unless caret/enabled? [caret/enabled?: yes]
                            caret/rate: caret-rate
                            terminal/refresh/force
                        ]
                        on-unfocus: func [face [object!] event [event!]][
                            focused?: no
                            if caret/enabled? [caret/enabled?: no]
                            caret/rate: none
                        ]
                        on-key-down: func [face [object!] event [event!]][
                            if event/key = 'F12 [
                                cfg/menu-bar?: to-word none? face/menu
                                toggle-menu-bar
                            ]
                        ]
                    ]
                    extra: none
                    draw: none
                ]
                pane: none
                state: [handle! 0 none false]
                rate: 0:00:00.53
                edge: none
                para: none
                font: none
                actors: make object! [
                    on-time: func [face [object!] event [event!]][
                        face/color: either face/color = caret-clr [255.255.255.254] [caret-clr]
                        'done
                    ]
                ]
                extra: none
                draw: none
            ]
            tips: make object! [
                type: 'panel
                offset: (0, 0)
                size: 150x200
                text: none
                image: none
                color: 0.0.128
                menu: none
                data: none
                enabled?: true
                visible?: false
                selected: none
                flags: none
                options: none
                parent: make object! [
                    type: 'window
                    offset: (559.2, 339.2)
                    size: 839x654
                    text: "Red Console"
                    image: none
                    color: none
                    menu: none
                    data: none
                    enabled?: true
                    visible?: false
                    selected: make object! [
                        type: 'rich-text
                        offset: (0, 0)
                        size: 840x655
                        text: none
                        image: none
                        color: 22.22.22
                        menu: none
                        data: none
                        enabled?: true
                        visible?: true
                        selected: none
                        flags: [scrollable all-over]
                        options: [cursor: I-beam]
                        parent: make object! [...]
                        pane: none
                        state: [handle! 0 none false]
                        rate: 10
                        edge: none
                        para: none
                        font: make object! [
                            name: "Consolas"
                            size: 11
                            style: none
                            angle: 0
                            color: 222.222.222
                            anti-alias?: false
                            shadow: none
                            state: [handle! none none]
                            parent: []
                        ]
                        actors: make object! [
                            on-time: func [face [object!] event [event!]][
                                if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                                terminal/on-time
                                'done
                            ]
                            on-drawing: func [face [object!] event [event!]][
                                terminal/paint
                            ]
                            on-scroll: func [face [object!] event [event!]][
                                terminal/scroll event
                            ]
                            on-wheel: func [face [object!] event [event!]][
                                either event/ctrl? [
                                    terminal/zoom event
                                ] [
                                    terminal/scroll event
                                ]
                            ]
                            on-key: func [face [object!] event [event!]][
                                terminal/press-key event
                            ]
                            on-key-down: func [face [object!] event [event!]][
                                if all [1 = length? event/flags find event/flags 'alt] [
                                    switch event/key [
                                        #"A" [terminal/select-all]
                                        #"O" [show-cfg-dialog]
                                    ]
                                ]
                            ]
                            on-ime: func [face [object!] event [event!]][
                                terminal/process-ime-input event
                            ]
                            on-down: func [face [object!] event [event!]][
                                terminal/mouse-down event
                            ]
                            on-up: func [face [object!] event [event!]][
                                terminal/mouse-up event
                            ]
                            on-alt-down: func [face [object!] event [event!]][
                                if cfg/mouse-paste? = 'true [
                                    either terminal/text-selected? [
                                        terminal/copy-selection
                                        clear terminal/selects
                                        system/view/platform/redraw face
                                    ] [
                                        terminal/paste
                                    ]
                                ]
                            ]
                            on-over: func [face [object!] event [event!]][
                                terminal/mouse-move to-pair event/offset
                            ]
                            on-menu: func [face [object!] event [event!]][
                                switch event/picked [
                                    copy [terminal/copy-selection]
                                    paste [terminal/paste]
                                    select-all [terminal/select-all]
                                ]
                                'done
                            ]
                        ]
                        extra: none
                        draw: none
                        tabs: none
                        line-spacing: 'default
                        handles: none
                        init: func [/local box][
                            terminal/windows: get in get-current-screen 'pane
                            box: terminal/box
                            box/data: make block! 200
                            scroller: get-scroller self 'horizontal
                            scroller/visible?: no
                            scroller: get-scroller self 'vertical
                            scroller/position: 1
                            scroller/max-size: 2
                        ]
                    ]
                    flags: [resize]
                    options: none
                    parent: make object! [
                        type: 'screen
                        offset: 0x0
                        size: 2048x1152
                        text: none
                        image: none
                        color: none
                        menu: none
                        data: 1.25
                        enabled?: true
                        visible?: true
                        selected: none
                        flags: none
                        options: none
                        parent: none
                        pane: []
                        state: [handle! 0 none [1]]
                        rate: none
                        edge: none
                        para: none
                        font: none
                        actors: none
                        extra: none
                        draw: none
                    ]
                    pane: [make object! [
                        type: 'rich-text
                        offset: (0, 0)
                        size: 840x655
                        text: none
                        image: none
                        color: 22.22.22
                        menu: none
                        data: none
                        enabled?: true
                        visible?: true
                        selected: none
                        flags: [scrollable all-over]
                        options: [cursor: I-beam]
                        parent: make object! [...]
                        pane: none
                        state: [handle! 0 none false]
                        rate: 10
                        edge: none
                        para: none
                        font: make object! [
                            name: "Consolas"
                            size: 11
                            style: none
                            angle: 0
                            color: 222.222.222
                            anti-alias?: false
                            shadow: none
                            state: [handle! none none]
                            parent: []
                        ]
                        actors: make object! [
                            on-time: func [face [object!] event [event!]][
                                if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                                terminal/on-time
                                'done
                            ]
                            on-drawing: func [face [object!] event [event!]][
                                terminal/paint
                            ]
                            on-scroll: func [face [object!] event [event!]][
                                terminal/scroll event
                            ]
                            on-wheel: func [face [object!] event [event!]][
                                either event/ctrl? [
                                    terminal/zoom event
                                ] [
                                    terminal/scroll event
                                ]
                            ]
                            on-key: func [face [object!] event [event!]][
                                terminal/press-key event
                            ]
                            on-key-down: func [face [object!] event [event!]][
                                if all [1 = length? event/flags find event/flags 'alt] [
                                    switch event/key [
                                        #"A" [terminal/select-all]
                                        #"O" [show-cfg-dialog]
                                    ]
                                ]
                            ]
                            on-ime: func [face [object!] event [event!]][
                                terminal/process-ime-input event
                            ]
                            on-down: func [face [object!] event [event!]][
                                terminal/mouse-down event
                            ]
                            on-up: func [face [object!] event [event!]][
                                terminal/mouse-up event
                            ]
                            on-alt-down: func [face [object!] event [event!]][
                                if cfg/mouse-paste? = 'true [
                                    either terminal/text-selected? [
                                        terminal/copy-selection
                                        clear terminal/selects
                                        system/view/platform/redraw face
                                    ] [
                                        terminal/paste
                                    ]
                                ]
                            ]
                            on-over: func [face [object!] event [event!]][
                                terminal/mouse-move to-pair event/offset
                            ]
                            on-menu: func [face [object!] event [event!]][
                                switch event/picked [
                                    copy [terminal/copy-selection]
                                    paste [terminal/paste]
                                    select-all [terminal/select-all]
                                ]
                                'done
                            ]
                        ]
                        extra: none
                        draw: none
                        tabs: none
                        line-spacing: 'default
                        handles: none
                        init: func [/local box][
                            terminal/windows: get in get-current-screen 'pane
                            box: terminal/box
                            box/data: make block! 200
                            scroller: get-scroller self 'horizontal
                            scroller/visible?: no
                            scroller: get-scroller self 'vertical
                            scroller/position: 1
                            scroller/max-size: 2
                        ]
                    ] make object! [
                        type: 'base
                        offset: (0, 0)
                        size: 1x17
                        text: none
                        image: none
                        color: 222.222.222.1
                        menu: none
                        data: none
                        enabled?: false
                        visible?: true
                        selected: none
                        flags: none
                        options: [caret make object! [
                            type: 'rich-text
                            offset: (0, 0)
                            size: 840x655
                            text: none
                            image: none
                            color: 22.22.22
                            menu: none
                            data: none
                            enabled?: true
                            visible?: true
                            selected: none
                            flags: [scrollable all-over]
                            options: [cursor: I-beam]
                            parent: make object! [...]
                            pane: none
                            state: [handle! 0 none false]
                            rate: 10
                            edge: none
                            para: none
                            font: make object! [
                                name: "Consolas"
                                size: 11
                                style: none
                                angle: 0
                                color: 222.222.222
                                anti-alias?: false
                                shadow: none
                                state: [handle! none none]
                                parent: []
                            ]
                            actors: make object! [
                                on-time: func [face [object!] event [event!]][
                                    if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                                    terminal/on-time
                                    'done
                                ]
                                on-drawing: func [face [object!] event [event!]][
                                    terminal/paint
                                ]
                                on-scroll: func [face [object!] event [event!]][
                                    terminal/scroll event
                                ]
                                on-wheel: func [face [object!] event [event!]][
                                    either event/ctrl? [
                                        terminal/zoom event
                                    ] [
                                        terminal/scroll event
                                    ]
                                ]
                                on-key: func [face [object!] event [event!]][
                                    terminal/press-key event
                                ]
                                on-key-down: func [face [object!] event [event!]][
                                    if all [1 = length? event/flags find event/flags 'alt] [
                                        switch event/key [
                                            #"A" [terminal/select-all]
                                            #"O" [show-cfg-dialog]
                                        ]
                                    ]
                                ]
                                on-ime: func [face [object!] event [event!]][
                                    terminal/process-ime-input event
                                ]
                                on-down: func [face [object!] event [event!]][
                                    terminal/mouse-down event
                                ]
                                on-up: func [face [object!] event [event!]][
                                    terminal/mouse-up event
                                ]
                                on-alt-down: func [face [object!] event [event!]][
                                    if cfg/mouse-paste? = 'true [
                                        either terminal/text-selected? [
                                            terminal/copy-selection
                                            clear terminal/selects
                                            system/view/platform/redraw face
                                        ] [
                                            terminal/paste
                                        ]
                                    ]
                                ]
                                on-over: func [face [object!] event [event!]][
                                    terminal/mouse-move to-pair event/offset
                                ]
                                on-menu: func [face [object!] event [event!]][
                                    switch event/picked [
                                        copy [terminal/copy-selection]
                                        paste [terminal/paste]
                                        select-all [terminal/select-all]
                                    ]
                                    'done
                                ]
                            ]
                            extra: none
                            draw: none
                            tabs: none
                            line-spacing: 'default
                            handles: none
                            init: func [/local box][
                                terminal/windows: get in get-current-screen 'pane
                                box: terminal/box
                                box/data: make block! 200
                                scroller: get-scroller self 'horizontal
                                scroller/visible?: no
                                scroller: get-scroller self 'vertical
                                scroller/position: 1
                                scroller/max-size: 2
                            ]
                        ] cursor: I-beam accelerated: yes]
                        parent: make object! [...]
                        pane: none
                        state: [handle! 0 none false]
                        rate: 0:00:00.53
                        edge: none
                        para: none
                        font: none
                        actors: make object! [
                            on-time: func [face [object!] event [event!]][
                                face/color: either face/color = caret-clr [255.255.255.254] [caret-clr]
                                'done
                            ]
                        ]
                        extra: none
                        draw: none
                    ] make object! [...]]
                    state: [handle! 0 none false]
                    rate: none
                    edge: none
                    para: none
                    font: none
                    actors: make object! [
                        on-menu: func [face [object!] event [event!] /local ft f][
                            switch event/picked [
                                about-msg [display-about]
                                shortcuts [show-shortcuts]
                                quit [self/on-close face event]
                                run-file [if f: request-file [terminal/run-file f]]
                                choose-font [
                                    if ft: request-font/font/mono font [
                                        font: ft
                                        console/font: font
                                        terminal/zoom font
                                    ]
                                ]
                                settings [show-cfg-dialog]
                            ]
                        ]
                        on-close: func [face [object!] event [event!]][
                            system/view/platform/exit-event-loop
                            foreach screen system/view/screens [clear head screen/pane]
                            quit
                        ]
                        on-resizing: func [face [object!] event [event!]
                        /local new-sz][
                            new-sz: to-pair event/offset + 1x1
                            console/size: new-sz
                            terminal/resize new-sz
                            terminal/adjust-console-size new-sz
                            unless system/view/auto-sync? [show face]
                        ]
                        on-resize: func [face [object!] event [event!]
                        /local new-sz][
                            new-sz: to-pair event/offset + 1x1
                            console/size: new-sz
                            terminal/resize new-sz
                            terminal/adjust-console-size new-sz
                            unless system/view/auto-sync? [show face]
                        ]
                        on-focus: func [face [object!] event [event!]][
                            focused?: yes
                            caret/color: caret-clr
                            unless caret/enabled? [caret/enabled?: yes]
                            caret/rate: caret-rate
                            terminal/refresh/force
                        ]
                        on-unfocus: func [face [object!] event [event!]][
                            focused?: no
                            if caret/enabled? [caret/enabled?: no]
                            caret/rate: none
                        ]
                        on-key-down: func [face [object!] event [event!]][
                            if event/key = 'F12 [
                                cfg/menu-bar?: to-word none? face/menu
                                toggle-menu-bar
                            ]
                        ]
                    ]
                    extra: none
                    draw: none
                ]
                pane: none
                state: [handle! 0 none false]
                rate: none
                edge: none
                para: none
                font: make object! [
                    name: "Consolas"
                    size: 11
                    style: none
                    angle: 0
                    color: 255.255.255
                    anti-alias?: false
                    shadow: none
                    state: [handle! none none]
                    parent: [make object! [
                        type: 'rich-text
                        offset: none
                        size: 820x655
                        text: "XXXXXXXXXX"
                        image: none
                        color: none
                        menu: none
                        data: []
                        enabled?: true
                        visible?: true
                        selected: none
                        flags: none
                        options: none
                        parent: none
                        pane: none
                        state: none
                        rate: none
                        edge: none
                        para: none
                        font: make object! [
                            name: "Consolas"
                            size: 11
                            style: none
                            angle: 0
                            color: 222.222.222
                            anti-alias?: false
                            shadow: none
                            state: [handle! none none]
                            parent: [...]
                        ]
                        actors: none
                        extra: none
                        draw: none
                        tabs: 32.4
                        line-spacing: 17
                        handles: [handle! handle! "XXXXXXXXXX" true]
                    ]]
                ]
                actors: make object! [
                    on-key-down: func [face [object!] event [event!]][
                        probe event/key
                    ]
                ]
                extra: none
                draw: none
            ]
            terminal: make object! [
                lines: []
                nlines: make vector! [integer! 32 []]
                heights: make vector! [integer! 32 []]
                flags: make vector! [integer! 32 []]
                selects: []
                max-lines: 10000
                full?: false
                ask?: false
                prin?: false
                newline?: true
                mouse-up?: true
                ime-open?: false
                ime-pos: 0
                redraw-cnt: 0
                top: 1
                line: ""
                line-pos: 0
                pos: 0
                scroll-y: 0
                line-y: 0
                line-h: 17
                char-width: 8.1
                page-cnt: 38
                line-cnt: 0
                screen-cnt: 0
                screen-cnt-saved: 0
                history: ["q" {sort/case "ABCabcdefDEF"} {sort "ABCabcdefDEF"} {sort/stable "ABCabcdefDEF"} "? tracing?" "tracing?" "to-char 128917" "to-char 8217" "to-char 33" "to-char 101" "to-char 117" "to-char 115" "to-char 105" "to-char 58" "to-char 32" "to-char 109" "to-char 91" "to-hex 14911" "q" "to-hex 1560281120" "q" "to-hex 1560281120" "q" "? write" "write %all-red-values.txt buffer" "" "]" "    append buffer newline" "    ]" "^-    append buffer mold spec-of :val" {^-    append buffer " "} "^-    append buffer form type? :val" "    ][" "^-    ]" "^-^-    append buffer mold :val" "^-    if word = 'system [" "    either object? :val [" {    append buffer ": "} "    append buffer mold word" "    val: get word" {foreach word sort get-sys-words :any-interesting? [} "buffer: make string! 50000" "]" "^-]" "^-^-]" "^-^-^-]" "^-^-^-^-]" "^-^-^-^-^-keep word" {^-^-^-^-if #"_" <> first mold word [} "^-^-^-if test get/any word [" "^-^-foreach word words-of system/words [" "^-collect [" "get-sys-words: func [test [function!]][" {any-interesting?: func [{Returns true if the value is any type of any-function} value [any-type!]][find types type? :value]} {types: make typeset! [native! action! function! routine! object!]} "object!" " [a: 2]" "make object! [a: 2]" "make object [a: 2]" "make context! [a: 2]" "make context [a: 2]" "make function! [a b][a + b]" "]" {    a + b                        ; The body of the function} "] [" {    b [integer! decimal!]        ; Argument 'b', restricted to number types} {    a [integer! decimal!]        ; Argument 'a', restricted to number types} {    "Adds two numbers together."  ; Optional help string} "add-numbers: make function! [" {    a + b                        ; The body of the function} "] [" {    b [integer! decimal!]        ; Argument 'b', restricted to number types} {    a [integer! decimal!]        ; Argument 'a', restricted to number types} {    "Adds two numbers together."  ; Optional help string} "make function! []add-numbers: make function! [" "make function! []" "make function! [][]" "make function [][]" "make func [][]" {replace/all "a-b-c" "-" "\\-"} {replace "a-b-c" "-" "\\-"} "? replace" "? rep" "replace" "make block! [32]" "make integer! [32]" "make object! [a: 32]" "make object [a: 3]" "make object []" "x/b/c" "        scope_stack: &mut Vec<String>," "x/b/c" "system/words/x/a" "x/b/c" "]" "c: does [x/a]" "b: context [" "x: does [print 32]" "a: 2" "x: context ["]
                hist-idx: 0
                hist-line: none
                hist-pos: 0
                clipboard: none
                clip-buf: ""
                paste-cnt: 0
                box: make object! [
                    type: 'rich-text
                    offset: none
                    size: 820x655
                    text: "XXXXXXXXXX"
                    image: none
                    color: none
                    menu: none
                    data: []
                    enabled?: true
                    visible?: true
                    selected: none
                    flags: none
                    options: none
                    parent: none
                    pane: none
                    state: none
                    rate: none
                    edge: none
                    para: none
                    font: make object! [
                        name: "Consolas"
                        size: 11
                        style: none
                        angle: 0
                        color: 222.222.222
                        anti-alias?: false
                        shadow: none
                        state: [handle! none none]
                        parent: []
                    ]
                    actors: none
                    extra: none
                    draw: none
                    tabs: 32.4
                    line-spacing: 17
                    handles: [handle! handle! "XXXXXXXXXX" true]
                ]
                undo-stack: []
                redo-stack: []
                windows: [make object! [
                    type: 'window
                    offset: (559.2, 339.2)
                    size: 839x654
                    text: "Red Console"
                    image: none
                    color: none
                    menu: none
                    data: none
                    enabled?: true
                    visible?: false
                    selected: make object! [
                        type: 'rich-text
                        offset: (0, 0)
                        size: 840x655
                        text: none
                        image: none
                        color: 22.22.22
                        menu: none
                        data: none
                        enabled?: true
                        visible?: true
                        selected: none
                        flags: [scrollable all-over]
                        options: [cursor: I-beam]
                        parent: make object! [...]
                        pane: none
                        state: [handle! 0 none false]
                        rate: 10
                        edge: none
                        para: none
                        font: make object! [
                            name: "Consolas"
                            size: 11
                            style: none
                            angle: 0
                            color: 222.222.222
                            anti-alias?: false
                            shadow: none
                            state: [handle! none none]
                            parent: []
                        ]
                        actors: make object! [
                            on-time: func [face [object!] event [event!]][
                                if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                                terminal/on-time
                                'done
                            ]
                            on-drawing: func [face [object!] event [event!]][
                                terminal/paint
                            ]
                            on-scroll: func [face [object!] event [event!]][
                                terminal/scroll event
                            ]
                            on-wheel: func [face [object!] event [event!]][
                                either event/ctrl? [
                                    terminal/zoom event
                                ] [
                                    terminal/scroll event
                                ]
                            ]
                            on-key: func [face [object!] event [event!]][
                                terminal/press-key event
                            ]
                            on-key-down: func [face [object!] event [event!]][
                                if all [1 = length? event/flags find event/flags 'alt] [
                                    switch event/key [
                                        #"A" [terminal/select-all]
                                        #"O" [show-cfg-dialog]
                                    ]
                                ]
                            ]
                            on-ime: func [face [object!] event [event!]][
                                terminal/process-ime-input event
                            ]
                            on-down: func [face [object!] event [event!]][
                                terminal/mouse-down event
                            ]
                            on-up: func [face [object!] event [event!]][
                                terminal/mouse-up event
                            ]
                            on-alt-down: func [face [object!] event [event!]][
                                if cfg/mouse-paste? = 'true [
                                    either terminal/text-selected? [
                                        terminal/copy-selection
                                        clear terminal/selects
                                        system/view/platform/redraw face
                                    ] [
                                        terminal/paste
                                    ]
                                ]
                            ]
                            on-over: func [face [object!] event [event!]][
                                terminal/mouse-move to-pair event/offset
                            ]
                            on-menu: func [face [object!] event [event!]][
                                switch event/picked [
                                    copy [terminal/copy-selection]
                                    paste [terminal/paste]
                                    select-all [terminal/select-all]
                                ]
                                'done
                            ]
                        ]
                        extra: none
                        draw: none
                        tabs: none
                        line-spacing: 'default
                        handles: none
                        init: func [/local box][
                            terminal/windows: get in get-current-screen 'pane
                            box: terminal/box
                            box/data: make block! 200
                            scroller: get-scroller self 'horizontal
                            scroller/visible?: no
                            scroller: get-scroller self 'vertical
                            scroller/position: 1
                            scroller/max-size: 2
                        ]
                    ]
                    flags: [resize]
                    options: none
                    parent: make object! [
                        type: 'screen
                        offset: 0x0
                        size: 2048x1152
                        text: none
                        image: none
                        color: none
                        menu: none
                        data: 1.25
                        enabled?: true
                        visible?: true
                        selected: none
                        flags: none
                        options: none
                        parent: none
                        pane: [...]
                        state: [handle! 0 none [1]]
                        rate: none
                        edge: none
                        para: none
                        font: none
                        actors: none
                        extra: none
                        draw: none
                    ]
                    pane: [make object! [
                        type: 'rich-text
                        offset: (0, 0)
                        size: 840x655
                        text: none
                        image: none
                        color: 22.22.22
                        menu: none
                        data: none
                        enabled?: true
                        visible?: true
                        selected: none
                        flags: [scrollable all-over]
                        options: [cursor: I-beam]
                        parent: make object! [...]
                        pane: none
                        state: [handle! 0 none false]
                        rate: 10
                        edge: none
                        para: none
                        font: make object! [
                            name: "Consolas"
                            size: 11
                            style: none
                            angle: 0
                            color: 222.222.222
                            anti-alias?: false
                            shadow: none
                            state: [handle! none none]
                            parent: []
                        ]
                        actors: make object! [
                            on-time: func [face [object!] event [event!]][
                                if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                                terminal/on-time
                                'done
                            ]
                            on-drawing: func [face [object!] event [event!]][
                                terminal/paint
                            ]
                            on-scroll: func [face [object!] event [event!]][
                                terminal/scroll event
                            ]
                            on-wheel: func [face [object!] event [event!]][
                                either event/ctrl? [
                                    terminal/zoom event
                                ] [
                                    terminal/scroll event
                                ]
                            ]
                            on-key: func [face [object!] event [event!]][
                                terminal/press-key event
                            ]
                            on-key-down: func [face [object!] event [event!]][
                                if all [1 = length? event/flags find event/flags 'alt] [
                                    switch event/key [
                                        #"A" [terminal/select-all]
                                        #"O" [show-cfg-dialog]
                                    ]
                                ]
                            ]
                            on-ime: func [face [object!] event [event!]][
                                terminal/process-ime-input event
                            ]
                            on-down: func [face [object!] event [event!]][
                                terminal/mouse-down event
                            ]
                            on-up: func [face [object!] event [event!]][
                                terminal/mouse-up event
                            ]
                            on-alt-down: func [face [object!] event [event!]][
                                if cfg/mouse-paste? = 'true [
                                    either terminal/text-selected? [
                                        terminal/copy-selection
                                        clear terminal/selects
                                        system/view/platform/redraw face
                                    ] [
                                        terminal/paste
                                    ]
                                ]
                            ]
                            on-over: func [face [object!] event [event!]][
                                terminal/mouse-move to-pair event/offset
                            ]
                            on-menu: func [face [object!] event [event!]][
                                switch event/picked [
                                    copy [terminal/copy-selection]
                                    paste [terminal/paste]
                                    select-all [terminal/select-all]
                                ]
                                'done
                            ]
                        ]
                        extra: none
                        draw: none
                        tabs: none
                        line-spacing: 'default
                        handles: none
                        init: func [/local box][
                            terminal/windows: get in get-current-screen 'pane
                            box: terminal/box
                            box/data: make block! 200
                            scroller: get-scroller self 'horizontal
                            scroller/visible?: no
                            scroller: get-scroller self 'vertical
                            scroller/position: 1
                            scroller/max-size: 2
                        ]
                    ] make object! [
                        type: 'base
                        offset: (0, 0)
                        size: 1x17
                        text: none
                        image: none
                        color: 222.222.222.1
                        menu: none
                        data: none
                        enabled?: false
                        visible?: true
                        selected: none
                        flags: none
                        options: [caret make object! [
                            type: 'rich-text
                            offset: (0, 0)
                            size: 840x655
                            text: none
                            image: none
                            color: 22.22.22
                            menu: none
                            data: none
                            enabled?: true
                            visible?: true
                            selected: none
                            flags: [scrollable all-over]
                            options: [cursor: I-beam]
                            parent: make object! [...]
                            pane: none
                            state: [handle! 0 none false]
                            rate: 10
                            edge: none
                            para: none
                            font: make object! [
                                name: "Consolas"
                                size: 11
                                style: none
                                angle: 0
                                color: 222.222.222
                                anti-alias?: false
                                shadow: none
                                state: [handle! none none]
                                parent: []
                            ]
                            actors: make object! [
                                on-time: func [face [object!] event [event!]][
                                    if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                                    terminal/on-time
                                    'done
                                ]
                                on-drawing: func [face [object!] event [event!]][
                                    terminal/paint
                                ]
                                on-scroll: func [face [object!] event [event!]][
                                    terminal/scroll event
                                ]
                                on-wheel: func [face [object!] event [event!]][
                                    either event/ctrl? [
                                        terminal/zoom event
                                    ] [
                                        terminal/scroll event
                                    ]
                                ]
                                on-key: func [face [object!] event [event!]][
                                    terminal/press-key event
                                ]
                                on-key-down: func [face [object!] event [event!]][
                                    if all [1 = length? event/flags find event/flags 'alt] [
                                        switch event/key [
                                            #"A" [terminal/select-all]
                                            #"O" [show-cfg-dialog]
                                        ]
                                    ]
                                ]
                                on-ime: func [face [object!] event [event!]][
                                    terminal/process-ime-input event
                                ]
                                on-down: func [face [object!] event [event!]][
                                    terminal/mouse-down event
                                ]
                                on-up: func [face [object!] event [event!]][
                                    terminal/mouse-up event
                                ]
                                on-alt-down: func [face [object!] event [event!]][
                                    if cfg/mouse-paste? = 'true [
                                        either terminal/text-selected? [
                                            terminal/copy-selection
                                            clear terminal/selects
                                            system/view/platform/redraw face
                                        ] [
                                            terminal/paste
                                        ]
                                    ]
                                ]
                                on-over: func [face [object!] event [event!]][
                                    terminal/mouse-move to-pair event/offset
                                ]
                                on-menu: func [face [object!] event [event!]][
                                    switch event/picked [
                                        copy [terminal/copy-selection]
                                        paste [terminal/paste]
                                        select-all [terminal/select-all]
                                    ]
                                    'done
                                ]
                            ]
                            extra: none
                            draw: none
                            tabs: none
                            line-spacing: 'default
                            handles: none
                            init: func [/local box][
                                terminal/windows: get in get-current-screen 'pane
                                box: terminal/box
                                box/data: make block! 200
                                scroller: get-scroller self 'horizontal
                                scroller/visible?: no
                                scroller: get-scroller self 'vertical
                                scroller/position: 1
                                scroller/max-size: 2
                            ]
                        ] cursor: I-beam accelerated: yes]
                        parent: make object! [...]
                        pane: none
                        state: [handle! 0 none false]
                        rate: 0:00:00.53
                        edge: none
                        para: none
                        font: none
                        actors: make object! [
                            on-time: func [face [object!] event [event!]][
                                face/color: either face/color = caret-clr [255.255.255.254] [caret-clr]
                                'done
                            ]
                        ]
                        extra: none
                        draw: none
                    ] make object! [
                        type: 'panel
                        offset: (0, 0)
                        size: 150x200
                        text: none
                        image: none
                        color: 0.0.128
                        menu: none
                        data: none
                        enabled?: true
                        visible?: false
                        selected: none
                        flags: none
                        options: none
                        parent: make object! [...]
                        pane: none
                        state: [handle! 0 none false]
                        rate: none
                        edge: none
                        para: none
                        font: make object! [
                            name: "Consolas"
                            size: 11
                            style: none
                            angle: 0
                            color: 255.255.255
                            anti-alias?: false
                            shadow: none
                            state: [handle! none none]
                            parent: [make object! [
                                type: 'rich-text
                                offset: none
                                size: 820x655
                                text: "XXXXXXXXXX"
                                image: none
                                color: none
                                menu: none
                                data: []
                                enabled?: true
                                visible?: true
                                selected: none
                                flags: none
                                options: none
                                parent: none
                                pane: none
                                state: none
                                rate: none
                                edge: none
                                para: none
                                font: make object! [
                                    name: "Consolas"
                                    size: 11
                                    style: none
                                    angle: 0
                                    color: 222.222.222
                                    anti-alias?: false
                                    shadow: none
                                    state: [handle! none none]
                                    parent: [...]
                                ]
                                actors: none
                                extra: none
                                draw: none
                                tabs: 32.4
                                line-spacing: 17
                                handles: [handle! handle! "XXXXXXXXXX" true]
                            ]]
                        ]
                        actors: make object! [
                            on-key-down: func [face [object!] event [event!]][
                                probe event/key
                            ]
                        ]
                        extra: none
                        draw: none
                    ]]
                    state: [handle! 0 none false]
                    rate: none
                    edge: none
                    para: none
                    font: none
                    actors: make object! [
                        on-menu: func [face [object!] event [event!] /local ft f][
                            switch event/picked [
                                about-msg [display-about]
                                shortcuts [show-shortcuts]
                                quit [self/on-close face event]
                                run-file [if f: request-file [terminal/run-file f]]
                                choose-font [
                                    if ft: request-font/font/mono font [
                                        font: ft
                                        console/font: font
                                        terminal/zoom font
                                    ]
                                ]
                                settings [show-cfg-dialog]
                            ]
                        ]
                        on-close: func [face [object!] event [event!]][
                            system/view/platform/exit-event-loop
                            foreach screen system/view/screens [clear head screen/pane]
                            quit
                        ]
                        on-resizing: func [face [object!] event [event!]
                        /local new-sz][
                            new-sz: to-pair event/offset + 1x1
                            console/size: new-sz
                            terminal/resize new-sz
                            terminal/adjust-console-size new-sz
                            unless system/view/auto-sync? [show face]
                        ]
                        on-resize: func [face [object!] event [event!]
                        /local new-sz][
                            new-sz: to-pair event/offset + 1x1
                            console/size: new-sz
                            terminal/resize new-sz
                            terminal/adjust-console-size new-sz
                            unless system/view/auto-sync? [show face]
                        ]
                        on-focus: func [face [object!] event [event!]][
                            focused?: yes
                            caret/color: caret-clr
                            unless caret/enabled? [caret/enabled?: yes]
                            caret/rate: caret-rate
                            terminal/refresh/force
                        ]
                        on-unfocus: func [face [object!] event [event!]][
                            focused?: no
                            if caret/enabled? [caret/enabled?: no]
                            caret/rate: none
                        ]
                        on-key-down: func [face [object!] event [event!]][
                            if event/key = 'F12 [
                                cfg/menu-bar?: to-word none? face/menu
                                toggle-menu-bar
                            ]
                        ]
                    ]
                    extra: none
                    draw: none
                ]]
                tab-size: 4
                foreground: 222.222.222
                background: 22.22.22
                select-bg: [backdrop 128.128.128.128]
                pad-left: 3
                scrolling: 0
                scroll-pos: 0
                color?: false
                theme: #[
                    foreground: [222.222.222]
                    background: [22.22.22]
                    selected: [128.128.128.128]
                    string!: [120.120.61]
                    integer!: [255.0.0]
                    float!: [255.0.0]
                    pair!: [255.0.0]
                    percent!: [255.128.128]
                    datatype!: [0.222.0]
                    lit-word!: [0.0.255 bold]
                    set-word!: [0.0.255]
                    tuple!: [0.0.0]
                    url!: [0.0.255 underline]
                    comment!: [128.128.128]
                ]
                ask: func [question [string!] hist [block! none!] hide?][
                    history: either hist [hist] [system/console/history]
                    either prin? [
                        line: append last lines question
                        line: tail line
                    ] [
                        line: make string! 8
                        line: insert line question
                        add-line head line
                    ]
                    pos: 0
                    line-pos: length? lines
                    ask?: yes
                    redraw-cnt: 0
                    clear-stack
                    set-flag hide?
                    either paste/resume [
                        do-ask-loop/no-wait
                    ] [
                        paint/dry
                        system/view/auto-sync?: yes
                        reset-top
                        system/view/platform/redraw gui-console-ctx/console
                        do-events
                    ]
                    ask?: no
                    line
                ]
                do-ask-loop: func [/no-wait][
                    system/view/platform/do-event-loop no-wait
                ]
                exit-ask-loop: func [/escape][
                    clear selects
                    caret/enabled?: no
                    caret/rate: none
                    either escape [append line #"^["] [
                        if all [
                            not empty? line
                            not strict-equal? line first history
                            zero? last flags
                        ] [insert history line]
                        hist-idx: 0
                    ]
                    prin?: no
                    newline?: yes
                    system/view/platform/exit-event-loop
                ]
                refresh: func [/force][
                    either force [
                        system/view/platform/redraw console
                        redraw-cnt: 0
                    ] [
                        redraw-cnt: redraw-cnt + 1
                    ]
                ]
                vprin: func [str [string!]][
                    either empty? lines [
                        append lines str
                        append flags 0
                        calc-top
                    ] [
                        append last lines str
                    ]
                ]
                vprint: func [str [string!] lf? [logic!] /local s cnt first-prin?][
                    if 100000 < length? str [
                        s: skip tail str -10000
                        str: append copy/part str 90000 "^/...^/"
                        append str s
                    ]
                    unless console/state [exit]
                    unless gui-console-ctx/win/visible? [
                        gui-console-ctx/win/visible?: yes
                        show gui-console-ctx/win
                    ]
                    if all [not lf? newline?] [newline?: no first-prin?: yes]
                    if lf? [newline?: yes]
                    s: find str lf
                    either s [
                        cnt: 0
                        if all [
                            prin?
                            not same? head line last lines
                        ] [
                            vprin copy/part str s
                            str: skip s 1
                            s: find str lf
                        ]
                        while [s] [
                            add-lines copy/part str s no
                            str: skip s 1
                            cnt: cnt + 1
                            if cnt = 100 [
                                refresh/force
                                cnt: 0
                            ]
                            s: find str lf
                        ]
                        add-lines str yes
                    ] [
                        either all [lf? not prin?] [add-lines str yes] [
                            if first-prin? [add-line make string! 8]
                            vprin str
                        ]
                    ]
                    prin?: not lf?
                    either any [
                        all [lf? redraw-cnt > 20]
                        redraw-cnt > 1000
                    ] [
                        refresh/force
                    ] [
                        refresh
                    ]
                    ()
                ]
                reset-buffer: func [blk [block! vector!] /advance /local src][
                    src: blk
                    blk: head blk
                    move/part src blk max-lines
                    clear src
                    blk
                ]
                set-flag: func [val [integer! none! logic!]][
                    val: case [
                        none? val [0]
                        logic? val [either val [1] [0]]
                        true [val]
                    ]
                    unless zero? val [val: length? head line]
                    poke flags length? lines val
                ]
                add-line: func [str [string!]][
                    either full? [
                        line-cnt: line-cnt - first nlines
                        if top <> 1 [top: top - 1]
                        either max-lines + 1 = index? lines [
                            lines: reset-buffer lines
                            nlines: reset-buffer nlines
                            heights: reset-buffer heights
                            flags: reset-buffer flags
                        ] [
                            lines: next lines
                            nlines: next nlines
                            heights: next heights
                            flags: next flags
                        ]
                        append lines str
                        append flags 0
                        calc-top/new
                    ] [
                        append lines str
                        append flags 0
                        full?: max-lines = length? lines
                        calc-top
                    ]
                ]
                add-lines: func [str [string!] copy? [logic!]
                /local cols][
                    cols: system/console/size/x
                    either 30 * cols > length? str [
                        if copy? [str: copy str]
                        add-line str
                    ] [
                        until [
                            add-line copy/part str cols
                            str: skip str cols
                            empty? str
                        ]
                    ]
                ]
                calc-last-line: func [new? [logic!] /local n cnt h total][
                    n: length? lines
                    box/text: head last lines
                    total: line-cnt
                    cnt: rich-text/line-count? box
                    h: cnt * line-h
                    either any [new? n > length? nlines] [
                        append heights h
                        append nlines cnt
                        line-cnt: line-cnt + cnt
                    ] [
                        poke heights n h
                        line-cnt: line-cnt + cnt - pick nlines n
                        poke nlines n cnt
                    ]
                    screen-cnt: line-cnt
                    screen-cnt-saved: screen-cnt
                    if screen-cnt > page-cnt [screen-cnt: page-cnt]
                    n: line-cnt - total
                    n
                ]
                calc-top: func [/new /local delta n][
                    n: calc-last-line new
                    if all [
                        n < 0
                        screen-cnt-saved <= page-cnt
                        not full?
                    ] [
                        delta: scroller/position + n
                        scroller/position: either delta < 1 [1] [delta]
                    ]
                    if n <> 0 [scroller/max-size: line-cnt - 1 + page-cnt]
                    delta: screen-cnt + n - page-cnt
                    if screen-cnt < page-cnt [
                        screen-cnt: screen-cnt + n
                        if screen-cnt > page-cnt [screen-cnt: page-cnt]
                    ]
                    if delta >= 0 [reset-top]
                ]
                reset-top: func [][
                    if any [
                        screen-cnt-saved > page-cnt
                        full?
                    ] [
                        top: length? lines
                        scroll-y: line-h - last heights
                        scroll-lines/position page-cnt - 1 scroller/max-size - page-cnt + 1
                    ]
                ]
                update-theme: func [][
                    foreground: first select theme 'foreground
                    background: first select theme 'background
                    select-bg: reduce ['backdrop first select theme 'selected]
                    console/color: background
                ]
                update-cfg: func [font [object!] cfg [block! none!] /local sz][
                    box/font: font
                    box/text: "XXXXXXXXXX"
                    sz: to-pair size-text box
                    char-width: sz/x + 1 * 0.1
                    box/tabs: tab-size * char-width
                    line-h: to-integer rich-text/line-height? box 1
                    box/line-spacing: line-h
                    caret/size/y: line-h
                    if cfg [
                        max-lines: cfg/buffer-lines
                        if cfg/background [change theme/background cfg/background]
                    ]
                    if font/color [change theme/foreground font/color]
                    adjust-console-size gui-console-ctx/console/size
                    update-theme
                ]
                adjust-console-size: func [size [pair!]
                /local cols rows][
                    cols: to integer! size/x - 20 - pad-left / char-width
                    rows: to-integer size/y / line-h
                    system/console/size: as-pair cols rows
                ]
                resize: func [new-size [pair!] /local y][
                    y: new-size/y
                    new-size/x: new-size/x - 20
                    new-size/y: y
                    box/size: new-size
                    if scroller [
                        page-cnt: to-integer y / line-h
                        scroller/page-size: page-cnt
                        scroller/max-size: line-cnt - 1 + page-cnt
                        scroller/position: scroller/position
                    ]
                ]
                scroll: func [event /local key n delta][
                    if empty? lines [exit]
                    key: event/key
                    n: switch/default key [
                        up [1]
                        down [-1]
                        page-up [scroller/page-size]
                        page-down [0 - scroller/page-size]
                        track [scroller/position - event/picked]
                        wheel [
                            delta: event/picked
                            case [
                                all [delta > -1.0 delta < 0.0] [-1]
                                all [delta > 0.0 delta < 1.0] [1]
                                true [
                                    to-integer delta * 3
                                ]
                            ]
                        ]
                    ] [0]
                    if n <> 0 [
                        scroll-lines n
                        system/view/platform/redraw console
                    ]
                ]
                zoom: func [event /local ft sz][
                    box/line-spacing: none
                    either object? event [ft: event] [
                        ft: box/font
                        sz: ft/size
                        either event/picked > 0 [sz: sz + 1] [sz: sz - 1]
                        if sz = 5 [exit]
                        ft/size: sz
                    ]
                    update-cfg ft none
                ]
                update-caret: func [/local len n s h lh offset][
                    unless all [line mouse-up? focused?] [exit]
                    n: top
                    h: 0
                    len: length? skip lines top
                    loop len [
                        h: h + pick heights n
                        n: n + 1
                    ]
                    offset: caret-to-offset box pos + index? line
                    offset/x: offset/x + pad-left
                    offset/y: offset/y + h + scroll-y
                    if ask? [
                        either offset/y < console/size/y [
                            caret/offset: offset
                            unless caret/enabled? [caret/enabled?: yes]
                        ] [
                            if caret/enabled? [caret/enabled?: no]
                        ]
                    ]
                ]
                offset-to-line: func [offset [pair!] /local h y start end n max-n][
                    y: to integer! offset/y - scroll-y
                    end: to integer! line-y - scroll-y
                    h: 0
                    n: top
                    max-n: length? lines
                    until [
                        h: h + pick heights n
                        if y < h [break]
                        n: n + 1
                        any [n > max-n h > end]
                    ]
                    if n > max-n [n: max-n]
                    box/text: head pick lines n
                    start: pick heights n
                    offset/x: offset/x - pad-left
                    offset/y: y + start - h
                    append selects n
                    append selects offset-to-caret box offset
                ]
                mouse-to-caret: func [offset][
                    if any [offset/y < line-y offset/y > (line-y + last heights)] [exit]
                    offset/x: offset/x - pad-left
                    offset/y: offset/y - line-y
                    box/text: head line
                    pos: (offset-to-caret box offset) - (index? line)
                    if pos < 0 [pos: 0]
                    update-caret
                ]
                mouse-down: func [event [event!]][
                    if empty? lines [exit]
                    mouse-up?: no
                    clear selects
                    offset-to-line to-pair event/offset
                    mouse-to-caret to-pair event/offset
                    caret/rate: none
                    caret/enabled?: no
                ]
                mouse-up: func [event [event!]][
                    if empty? lines [exit]
                    mouse-up?: yes
                    if 2 = length? selects [clear selects]
                    caret/enabled?: yes
                    mouse-to-caret to-pair event/offset
                    system/view/platform/redraw console
                    caret/rate: caret-rate
                ]
                mouse-move: func [offset /local y][
                    if any [empty? lines mouse-up? empty? selects] [exit]
                    scrolling: 0
                    case [
                        offset/y < -10 [
                            scroll-lines 1
                            offset/y: 0
                            scrolling: 1
                            scroll-pos: offset
                        ]
                        offset/y - box/size/y > 10 [
                            scroll-lines -1
                            offset/y: box/size/y
                            scrolling: -1
                            scroll-pos: offset
                        ]
                        scrolling <> 0 [scrolling: 0]
                    ]
                    select-to-offset offset
                ]
                select-to-offset: func [offset][
                    clear skip selects 2
                    offset-to-line offset
                    system/view/platform/redraw console
                ]
                on-time: func [][
                    either zero? scrolling [
                        if redraw-cnt <> 0 [refresh/force]
                    ] [
                        if any [empty? lines mouse-up? empty? selects] [exit]
                        scroll-lines scrolling
                        select-to-offset scroll-pos
                    ]
                ]
                jump-word: func [left? [logic!] return: [integer!] /local n dlm wc here p][
                    dlm: charset {/\^^[](){}"@:; ^-}
                    wc: negate dlm
                    here: skip line pos
                    either left? [
                        rev: reverse copy/part head line here
                        parse rev [any dlm any wc p:]
                        n: offset? p rev
                    ] [
                        parse here [any dlm any wc p:]
                        n: offset? here p
                    ]
                    n
                ]
                select-all: func [][
                    if empty? lines [exit]
                    reduce/into [1 1 length? nlines 1 + length? head line] clear selects
                    system/view/platform/redraw console
                ]
                select-text: func [n [integer!] /local start end start-idx end-idx c][
                    if zero? n [exit]
                    c: length? lines
                    set [start start-idx end end-idx] selects
                    if all [start <> c end = c] [start: c start-idx: end-idx]
                    if start <> c [start: c start-idx: pos + index? line end: c]
                    end-idx: pos + n + index? line
                    reduce/into [start start-idx end end-idx] clear selects
                ]
                move-caret: func [n [integer!] /event e [event!] /local left? idx][
                    idx: pos + n
                    if any [negative? idx idx > length? line] [
                        if all [event not e/shift?] [clear selects]
                        exit
                    ]
                    if event [
                        left?: n = -1
                        if e/ctrl? [n: jump-word left?]
                        either e/shift? [select-text n] [clear selects]
                    ]
                    pos: pos + n
                    if negative? pos [pos: 0]
                    if pos > length? line [pos: pos - n]
                ]
                scroll-lines: func [delta /position pos /local n len cnt end offset][
                    end: scroller/max-size - page-cnt + 1
                    offset: either position [pos] [scroller/position]
                    if any [
                        all [offset = 1 delta > 0]
                        all [zero? scroll-y offset = end delta < 0]
                    ] [exit]
                    offset: offset - delta
                    scroller/position: either offset < 1 [1] [
                        either offset > end [end] [offset]
                    ]
                    if zero? delta [exit]
                    n: top
                    either delta > 0 [
                        delta: delta + (to-integer scroll-y / line-h + pick nlines n)
                        scroll-y: 0
                        until [
                            cnt: pick nlines n
                            delta: delta - cnt
                            n: n - 1
                            any [delta < 1 n < 1]
                        ]
                        if delta <= 0 [
                            n: n + 1
                            if delta < 0 [
                                scroll-y: delta * line-h
                            ]
                        ]
                        if zero? n [n: 1 scroll-y: 0]
                    ] [
                        len: length? lines
                        delta: to-integer scroll-y / line-h + delta
                        scroll-y: 0
                        until [
                            cnt: pick nlines n
                            delta: delta + cnt
                            n: n + 1
                            any [delta >= 0 n > len]
                        ]
                        if delta > 0 [
                            n: n - 1
                            scroll-y: delta - cnt * line-h
                        ]
                        if n > len [n: len scroll-y: 0]
                    ]
                    top: n
                ]
                update-scroller: func [delta /local n end][
                    end: scroller/max-size - page-cnt + 1
                    if delta <> 0 [scroller/max-size: line-cnt - 1 + page-cnt]
                    if delta < 0 [
                        n: scroller/position
                        if n <> end [scroller/position: n - delta]
                    ]
                ]
                process-ime-input: func [event [event!] /local text][
                    text: event/picked
                    either ime-open? [
                        change/part skip line ime-pos text pos - ime-pos
                    ] [
                        ime-pos: pos
                        insert skip line pos text
                        ime-open?: yes
                    ]
                    pos: ime-pos + length? text
                    calc-top
                    system/view/platform/redraw console
                ]
                text-selected?: func [return: [logic!]][
                    3 <= length? selects
                ]
                copy-selection: func [
                    return: [logic!]
                    /local start-n end-n start-idx end-idx len n str swap?
                ][
                    unless text-selected? [
                        write-clipboard line
                        return no
                    ]
                    swap?: selects/1 > selects/3
                    if swap? [move/part skip selects 2 selects 2]
                    set [start-n start-idx end-n end-idx] selects
                    if all [start-n = end-n start-idx = end-idx] [
                        if swap? [move/part skip selects 2 selects 2]
                        exit
                    ]
                    clear clip-buf
                    either start-n = end-n [
                        len: end-idx - start-idx
                        if len < 0 [start-idx: end-idx len: 0 - len]
                        insert/part clip-buf at head pick lines start-n start-idx len
                    ] [
                        n: start-n
                        until [
                            str: head pick lines n
                            case [
                                n = start-n [
                                    append clip-buf at str start-idx
                                    append clip-buf #"^/"
                                ]
                                n = end-n [append/part clip-buf str end-idx - 1]
                                true [
                                    append clip-buf str
                                    append clip-buf #"^/"
                                ]
                            ]
                            n: n + 1
                            n > end-n
                        ]
                    ]
                    if swap? [move/part skip selects 2 selects 2]
                    write-clipboard clip-buf
                    yes
                ]
                paste: func [/resume /local nl? start end idx][
                    delete-selected
                    unless resume [
                        clipboard: read-clipboard
                        if image? clipboard [clipboard: none]
                        if block? clipboard [clipboard: mold clipboard]
                    ]
                    if all [clipboard not empty? clipboard] [
                        start: clipboard
                        end: find clipboard #"^/"
                        either end [
                            nl?: yes
                            if end/-1 = #"^M" [end: back end]
                        ] [
                            nl?: no
                            end: tail clipboard
                        ]
                        insert/part skip line pos start end
                        idx: pos
                        pos: pos + offset? start end
                        clipboard: skip end either end/1 = #"^M" [2] [1]
                        if nl? [
                            caret/enabled?: no
                            insert history line
                            unless resume [system/view/platform/exit-event-loop]
                        ]
                        calc-top
                        if empty? clipboard [
                            clear selects
                            clear redo-stack
                            reduce/into [idx pos - idx] undo-stack
                            system/view/platform/redraw console
                        ]
                        paste-cnt: paste-cnt + 1
                        if paste-cnt = 100 [
                            system/view/platform/redraw console
                            paste-cnt: 0
                        ]
                    ]
                    all [clipboard not empty? clipboard]
                ]
                cut: func [][
                    either copy-selection [
                        delete-selected
                    ] [
                        clear line pos: 0
                    ]
                ]
                undo: func [s1 [block!] s2 [block!] /local idx data s][
                    if empty? s1 [exit]
                    set [idx data] s1
                    remove/part s1 2
                    either integer? data [
                        s: take/part skip line idx data
                        reduce/into [idx s] s2
                        pos: idx
                    ] [
                        insert skip line idx data
                        data: either string? data [length? data] [1]
                        reduce/into [idx data] s2
                        pos: idx + data
                    ]
                    clear selects
                ]
                do-completion: func [
                    str [string!]
                    char [char!]
                    /local
                    p-idx candidates str2
                ][
                    p-idx: index? str
                    candidates: red-complete-ctx/complete-input skip str pos yes
                    case [
                        empty? candidates [0]
                        1 = length? candidates [
                            clear head str
                            pos: (index? candidates/1) - p-idx
                            append str head candidates/1
                            clear redo-stack
                        ]
                        true [
                            str2: head insert form next candidates system/console/prompt
                            poke lines length? lines str2
                            calc-top
                            clear head str
                            pos: (index? candidates/1) - p-idx
                            append str head candidates/1
                            add-line head line
                            line-pos: length? lines
                        ]
                    ]
                    clear selects
                ]
                fetch-history: func [direction [word!] /local max str p][
                    if zero? hist-idx [
                        hist-line: at copy head line index? line
                        hist-pos: pos
                    ]
                    max: length? history
                    case [
                        direction = 'prev [hist-idx: hist-idx + 1]
                        direction = 'next [hist-idx: hist-idx - 1]
                    ]
                    if hist-idx < 0 [hist-idx: 0 exit]
                    if hist-idx > max [hist-idx: max]
                    either zero? hist-idx [str: hist-line p: hist-pos] [
                        str: pick history hist-idx
                        p: length? str
                        clear redo-stack
                        clear selects
                    ]
                    clear line
                    append line str
                    pos: p
                    system/view/platform/redraw console
                ]
                delete-selected: func [
                    return: [logic!]
                    /local start-n start-idx end-n end-idx n idx s del?
                ][
                    del?: no
                    if all [
                        not empty? selects
                        2 < length? selects
                    ] [
                        set [start-n start-idx end-n end-idx] selects
                        if all [start-n = length? lines start-n = end-n] [
                            n: absolute end-idx - start-idx
                            idx: min start-idx end-idx
                            idx: idx - index? line
                            if negative? idx [
                                n: n + idx
                                idx: 0
                            ]
                            if n > 0 [
                                if start-idx < end-idx [
                                    pos: pos - n
                                    if pos < 0 [pos: 0]
                                ]
                                s: copy/part skip line idx n
                                reduce/into [idx s] undo-stack
                                remove/part skip line idx n
                                clear selects clear redo-stack
                                del?: yes
                            ]
                        ]
                    ]
                    del?
                ]
                delete-text: func [
                    ctrl? [logic!]
                    /backward
                    /local n idx s del? rev dlm wc p here
                ][
                    if delete-selected [exit]
                    dlm: charset {/\^^[](){}"@:; ^-}
                    wc: negate dlm
                    del?: no
                    here: skip line pos
                    n: 1
                    if all [backward pos <> 0] [
                        if ctrl? [
                            rev: reverse copy/part head line here
                            parse rev [any dlm any wc p:]
                            n: offset? rev p
                        ]
                        pos: pos - n
                        del?: yes
                    ]
                    if all [not backward pos < length? line] [
                        if ctrl? [
                            parse here [any dlm any wc p:]
                            n: offset? here p
                        ]
                        del?: yes
                    ]
                    if del? [
                        s: take/part skip line pos n
                        reduce/into [pos s] undo-stack
                        clear selects clear redo-stack
                    ]
                ]
                clean: func [][
                    full?: no
                    top: 1
                    scroll-y: 0
                    line-y: 0
                    line-cnt: 0
                    screen-cnt: 0
                    line-pos: 1
                    clear lines
                    clear nlines
                    clear heights
                    clear selects
                    scroller/page-size: page-cnt
                    scroller/max-size: page-cnt - 1
                    scroller/position: 0
                    add-line head line
                ]
                run-file: func [f [file!]][
                    append clear line rejoin ["do " mold f]
                    exit-ask-loop
                ]
                press-key: func [event [event!] /local char ctrl? shift?][
                    unless ask? [exit]
                    if line-pos <> length? lines [
                        poke lines line-pos copy head line
                        add-line head line
                        line-pos: length? lines
                    ]
                    if ime-open? [
                        remove/part skip line ime-pos pos - ime-pos
                        pos: ime-pos
                        ime-open?: no
                    ]
                    ctrl?: event/ctrl?
                    shift?: event/shift?
                    char: event/key
                    switch/default char [
                        #"^M" [exit-ask-loop]
                        #"^H" [delete-text/backward ctrl?]
                        #"^~" [delete-text/backward yes]
                        #"^-" [unless empty? line [do-completion line char]]
                        left [move-caret/event -1 event]
                        right [move-caret/event 1 event]
                        up [either ctrl? [scroll-lines 1] [fetch-history 'prev]]
                        down [either ctrl? [scroll-lines -1] [fetch-history 'next]]
                        insert [if event/shift? [paste exit]]
                        delete [either event/shift? [cut] [delete-text ctrl?]]
                        #"^A" home [either shift? [select-text 0 - pos] [clear selects] pos: 0]
                        #"^E" end [
                            either shift? [select-text (length? line) - pos] [clear selects]
                            pos: length? line
                        ]
                        #"^C" [copy-selection exit]
                        #"^V" [paste exit]
                        #"^X" [cut]
                        #"^Z" [undo undo-stack redo-stack]
                        #"^Y" [undo redo-stack undo-stack]
                        #"^[" [exit-ask-loop/escape]
                        #"^L" [clean]
                        #"^K" [clear line pos: 0]
                    ] [
                        unless empty? selects [delete-selected]
                        if all [char? char char > 31] [
                            insert skip line pos char
                            reduce/into [pos 1] undo-stack
                            clear redo-stack
                            pos: pos + 1
                        ]
                        clear selects
                    ]
                    if caret/rate [caret/rate: none caret/color: caret-clr]
                    calc-top
                    system/view/platform/redraw console
                ]
                clear-stack: func [][
                    clear undo-stack
                    clear redo-stack
                ]
                mark-selects: func [
                    styles n
                    /local start-n end-n start-idx end-idx len swap?
                ][
                    if any [empty? selects 3 > length? selects] [exit]
                    swap?: selects/1 > selects/3
                    if swap? [move/part skip selects 2 selects 2]
                    set [start-n start-idx end-n end-idx] selects
                    if any [
                        n < start-n
                        n > end-n
                        all [start-n = end-n start-idx = end-idx]
                    ] [
                        if swap? [move/part skip selects 2 selects 2]
                        exit
                    ]
                    either start-n = end-n [
                        len: end-idx - start-idx
                        if len < 0 [start-idx: end-idx len: 0 - len]
                    ] [
                        len: length? head pick lines n
                        case [
                            n = start-n [len: len - start-idx + 1]
                            n = end-n [start-idx: 1 len: end-idx - 1]
                            true [start-idx: 1]
                        ]
                    ]
                    append styles as-pair start-idx len
                    append styles select-bg
                    if swap? [move/part skip selects 2 selects 2]
                ]
                paint: func [/dry /local txt str cmds y n h cnt delta num end styles][
                    if empty? lines [exit]
                    cmds: [pen color text 0x0 text-box]
                    cmds/2: foreground
                    cmds/4/x: pad-left
                    cmds/5: box
                    end: console/size/y
                    y: scroll-y
                    n: top
                    num: line-cnt
                    styles: box/data
                    foreach str at lines top [
                        txt: either zero? cnt: pick flags n [str] [
                            txt: copy/part str cnt
                            append/dup txt "*" length? skip str cnt
                        ]
                        box/text: txt
                        if color? [highlight/add-styles txt clear styles theme]
                        mark-selects styles n
                        cmds/4/y: y
                        unless dry [system/view/platform/draw-face console cmds]
                        cnt: rich-text/line-count? box
                        h: cnt * line-h
                        poke heights n h
                        line-cnt: line-cnt + cnt - pick nlines n
                        poke nlines n cnt
                        clear styles
                        n: n + 1
                        y: y + h
                        if y > end [break]
                    ]
                    line-y: y - h
                    screen-cnt: to-integer y / line-h
                    screen-cnt-saved: screen-cnt
                    if screen-cnt > page-cnt [screen-cnt: page-cnt]
                    unless dry [
                        update-caret
                        update-scroller line-cnt - num
                    ]
                ]
            ]
            toggle-mouse-mode: func [][
                console/menu: either cfg/mouse-paste? = 'true [none] [console-menu]
            ]
            fstk-logo: make image! [62x63 #{
                393A3C34393B34393B34393B34393B34393B34393B34393B34393B34393B
                34393B34393B34393B34393B34393B34393B34393B34393B34393B34393B
                34393B34393B34393B34393B34393B34393B34393B34393B34393B34393B
                34393B34393B34393B34393B34393B34393B34393B34393B34393B34393B
                34393B34393B34393B34393B34393B34393B34393B34393B34393B34393B
                34393B34393B34393B34393B34393B34393B34393B34393B34393B34393B
                35393B3A3A3C4E42408B53418F55408D54408D54408D54408D54408D5440
                8D54408D54408D54408D54408D54408D54408D54408D54408D54408D5440
                8D54408D54408D5440935640945842945842945842945842945842945842
                945842945842945842945842945842945842945842945842945842945842
                945842945842945842945D44945F45945F45945F45945F45945F45945F45
                945F45945F45945F45945F45945F45945F45945F45945F45945F45945F45
                945F45996044825B483A3C3F604B45DA6744EC6F41EA7142EA7142EA7142
                EA7142EA7142EA7142EA7142EA7142EA7142EA7142EA7142EA7142EA7142
                EA7142EA7142EA7142EA7142EA7142F06E42F67D45F67D45F67D45F67D45
                F67D45F67D45F67D45F67D45F67D45F67D45F67D45F67D45F67D45F67D45
                F67D45F67D45F67D45F67D45F67D45F67F46F98A50F88C52F98A50F98A50
                F98A50F98A50F98A50F98A50F98A50F98A50F98A50F98A50F98A50F98A50
                F98A50F98A50F98A50FB8C52D580533A3E42604C46DA6341E25F3CE36C41
                E46E42E46E42E46E42E46E42E46E42E46E42E46E42E46E42E46E42E46E42
                E46E42E46E42E46E42E46E42E46E42E46E42E46E42ED693EEE6D3FF07843
                F17B45F17A45F17A45F17A45F17A45F17A45F17A45F17A45F17A45F17A45
                F17A45F17A45F17A45F17A45F17A45F17B45F07C45F17A45F27C47F4864E
                F5884FF5884FF5884FF5884FF5884FF5884FF5884FF5884FF5884FF5884F
                F5884FF5884FF5884FF5884FF5884FFC8B50D17D573A3E42604C46DA6341
                E25F3BDF603DE26A41E46E42E46E42E46E42E46E42E46E42E46E42E46E42
                E46E42E46E42E46E42E46E42E46E42E46E42E46E42E46E42E46E42ED693E
                ED693EEE6D3FF07944F17B45F17A45F17A45F17A45F17A45F17A45F17A45
                F17A45F17A45F17A45F17A45F17A45F17A45F17A45F17B45F07C45F17A45
                F17A45F27D47F4864EF5884FF5884FF5884FF5884FF5884FF5884FF5884F
                F5884FF5884FF5884FF5884FF5884FF5884FF5884FFC8B50D17D573A3E42
                604C46DA6341E2603CDE5E3DDE603DE36B41E46E42E46E42E46E42E46E42
                E46E42E46E42E46E42E46E42E46E42E46E42E46E42E46E42E46E42E46E42
                E46E42ED693EED693EED693EEE6E40F07944F17B45F17A45F17A45F17A45
                F17A45F17A45F17A45F17A45F17A45F17A45F17A45F17A45F17A45F17B45
                F07C45F17A45F17A45F17A45F27D47F5884FF5884FF5884FF5884FF5884F
                F5884FF5884FF5884FF5884FF5884FF5884FF5884FF5884FF5884FFC8B50
                D17D573A3E42604C46DA6341E2603CDE603EDE5E3DDE5E3CE36C41E46E42
                E46E42E46E42E46E42E46E42E46E42E46E42E46E42E46E42E46E42E46E42
                E46E42E46E42E46E42ED693EED693EED693EED693EEE6D3FF07843F17B45
                F17A45F17A45F17A45F17A45F17A45F17A45F17A45F17A45F17A45F17A45
                F17A45F17B45F07C45F17A45F17A45F17A45F17A45F27C47F4864EF5884F
                F5884FF5884FF5884FF5884FF5884FF5884FF5884FF5884FF5884FF5884F
                F5884FFC8B50D17D573A3E42604C46DA6341E2603CDE603EDE603EDE5F3D
                DF603DE26A41E46E42E46E42E46E42E46E42E46E42E46E42E46E42E46E42
                E46E42E46E42E46E42E46E42E46E42ED693EED693EED693EED693EED693E
                EE6D3FF07944F17B45F17A45F17A45F17A45F17A45F17A45F17A45F17A45
                F17A45F17A45F17A45F17B45F07C45F17A45F17A45F17A45F17A45F17A45
                F27D47F4864EF5884FF5884FF5884FF5884FF5884FF5884FF5884FF5884F
                F5884FF5884FF5884FFC8B50D17D573A3E42604C46DA6341E2603CDE603E
                DE603EDE603EDE5E3DDE603DE36B41E46E42E46E42E46E42E46E42E46E42
                E46E42E46E42E46E42E46E42E46E42E46E42E46E42ED693EED693EED693E
                ED693EED693EED693EEE6E40F07944F17B45F17A45F17A45F17A45F17A45
                F17A45F17A45F17A45F17A45F17A45F17B45F07C45F17A45F17A45F17A45
                F17A45F17A45F17A45F27D47F5884FF5884FF5884FF5884FF5884FF5884F
                F5884FF5884FF5884FF5884FF5884FFC8B50D17D573A3E42604C46DA6341
                E2603CDE603EDE603EDE603EDE603EDE5E3DDE5E3CE36C41E46E42E46E42
                E46E42E46E42E46E42E46E42E46E42E46E42E46E42E46E42E46E42ED693E
                ED693EED693EED693EED693EED693EED693EEE6D3FF07843F17B45F17A45
                F17A45F17A45F17A45F17A45F17A45F17A45F17A45F17A45F07B45F17A45
                F17A45F17A45F17A45F17A45F17A45F17A45F27B46F4864EF5884FF5884F
                F5884FF5884FF5884FF5884FF5884FF5884FF5884FFC8B50D17D573A3E42
                604C46DA6341E2603CDE603EDE603EDE603EDE603EDE603EDE5F3DDF603D
                E26A41E3683BE36638E36638E36638E36638E36638E36638E36638E36638
                E36638EE6033EE6033EE6033EE6033EE6033EE6033EE6033EE6033EF6434
                F0723AF0723AF0723AF0723AF0723AF0723AF0723AF0723AF0723AF0723A
                F0723AF0723AF0723AF0723AF0723AF0723AF0723AF0723AF06F38F1763D
                F38047F38953F5884FF5884FF5884FF5884FF5884FF5884FF5884FFC8B50
                D17D573A3E42604C46DA6341E2603CDE603EDE603EDE603EDE603EDE603E
                DE603EDE5D3AE26847EEA188F1AB91F1AB91F1AB91F1AB91F1AB91F1AB91
                F1AB91F1AB91F1AB91F4A98FF4A98FF4A98FF4A98FF4A98FF4A98FF4A98F
                F4A98FF4A98FF5AF91F7B393F7B393F7B393F7B393F7B393F7B393F7B393
                F7B393F7B393F7B393F7B393F7B393F7B393F7B393F7B393F7B393F7B393
                F7B393F7B393F4A284F1834EF5884FF5884FF5884FF5884FF5884FF5884F
                F5884FFC8B50D17D573A3E42604C46DA6341E2603CDE603EDE603EDE603E
                DE603EDE603EDE603EDE5A38E87357FCE7E1FFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFBE3DBF0743CF4864EF5884FF5884FF5884F
                F5884FF5884FF5884FFC8B50D17D573A3E42604C46DA6341E2603CDE603E
                DE603EDE603EDE603EDE603EDE603EDE5C39E57456FBE4DFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCDFD1F0713AF27B47F4864D
                F5884FF5884FF5884FF5884FF5884FFC8B50D17D573A3E42604C46DA6341
                E2603CDE603EDE603EDE603EDE603EDE603EDE603EDE5C39E57556FBE5DF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCDFD1F0713A
                F17944F27D47F5874FF5884FF5884FF5884FF5884FFC8B50D17D573A3E42
                604C46DA6341E2603CDE603EDE603EDE603EDE603EDE603EDE603EDE5C39
                E47355FAE4DEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FCDFD1F0723AF17A45F17A45F27C47F4864EF5884FF5884FF5884FFC8B50
                D17D573A3E42604C46DA6341E2603CDE603EDE603EDE603EDE603EDE603E
                DE603EDE5C39E57456FBE4DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFCDFD1F0723AF17A45F17A45F17A45F27D47F4864DF5884F
                F5884FFC8B50D17D573A3E42604C46DA6341E2603CDE603EDE603EDE603E
                DE603EDE603EDE603EDE5C39E57556FBE5DFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFCDFD1F0723AF17A45F17A45F17A45F17A45
                F27D47F5874FF5884FFC8B50D17D573A3E42604C46DA6341E2603CDE603E
                DE603EDE603EDE603EDE603EDE603EDE5C39E47355FAE4DEFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCDFD1F0723AF17A45F17A45
                F17A45F17A45F17A45F27C47F4864EFC8B50D17D573A3E42604C46DA6341
                E2603CDE603EDE603EDE603EDE603EDE603EDE603EDE5C39E57456FBE4DF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCDFD1F0723A
                F17A45F17A45F17A45F17A45F17A45F17A45F27D47FB894ED17D573A3E42
                604C46DA6341E2603CDE603EDE603EDE603EDE603EDE603EDE603EDE5C39
                E6785AFBE6E1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FBE6DEF0723BF17B45F07C45F07C45F07C45F07C45F07C45F07B45F98046
                D17D563A3E42604B45D75A3BE15637DE5739DE5739DE5739DE5739DE5739
                DE5739DE5337E25C46F09F8CF1AA97F1AA97F1AA97F1AA97F1AA97F1AA97
                F1AA97F1AA97F1AA97F6AF98F7B19AF7B19BF6B19CF7B19AF7B19BF6B19B
                F7B29AF6B19CF8B299F6B19CF7B299F6B19CF7B19AF7B19BF6B19BF7B29A
                F6B19CF7B299F5B29DF7B6A2F7B7A3F7B7A3F7B7A3F7B7A3F7B7A3F7B7A3
                F7B7A3F7B9A7F2A895F06D3AF17142F17142F17142F17142F17142F17142
                F17142F17041CF6F473B3F445F4743D34831E14930E04E35DF4C34DF4C34
                DF4C34DF4C34DF4C34DF4C34DF4B34DE452CDE432ADE432ADE432ADE432A
                DE432ADE432ADE432ADE432ADE432AE5462AE85131EA5333E85134EA5332
                EA5333E95233EB5432E85134EB5430E95235EB5430E95235EA5332EA5333
                E95233EB5432E85134EB5430E95232ED5A35EF6139F1653CF2643BF2643B
                F2643BF2643BF2643BF2643BF2643BF26941F26941F26941F26941F26941
                F26941F26941F26941F4673FCC6A453A3E425F4743D24634DC412FDF4D35
                E04E35DF4C34DF4C34DF4C34DF4C34DF4C34DF4C34DF4B33DF4A33DF4A33
                DF4A33DF4A33DF4A33DF4A33DF4A33DF4A33DF4A33E34A31E54E33EB5738
                EB5939EB5738EB5738EB5738EB5738EB5738EB5738EB5738EB5738EB5738
                EB5738EB5738EB5738EB5738EB5738EB5738EB5838ED5B39EE5F3BF26941
                F36940F36940F36940F36940F36940F36940F36940F26941F26941F26941
                F26941F26941F26941F26941F26941F3683FCB6A473A3E425F4743D24634
                DA3F2ED84231DE4C34DF4E35DF4C34DF4C34DF4C34DF4C34DF4C34DF4B33
                DF4A33DF4A33DF4A33DF4A33DF4A33DF4A33DF4A33DF4A33DF4A33E34A31
                E34A31E54C32EA5738EC5839EB5738EB5738EB5738EB5738EB5738EB5738
                EB5738EB5738EB5738EB5738EB5839EB5839EB5839EB5839EB5939ED5C3A
                ED5D3AEE613CF26840F26941F26941F26941F26941F26941F26941F26941
                F26941F26941F26941F26941F26941F26941F26941F3683FCF6A453A3E42
                5F4743D24634DA3F2ED64030D84331DF4C34E04E35DF4C34DF4C34DF4C34
                DF4C34DE452CDE432ADE432ADE432ADE432ADE432ADE432ADE432ADE432A
                DE432AE14328E14328E14328E3482AE94F30E95235E95235E95235E95235
                E95235E95235E95235E95235E95235E95235EC593AEB5839EB5839EB5839
                EB5939ED5C3AED5D3AED5D3AEE603DF26941F26941F26941F26941F26941
                F26941F26941F26941F26941F26941F26941F26941F26941F26941F3683F
                CC6A453A3E425F4743D24634DA3F2ED64030D64030D74231DF4D35E04E35
                DF4C34DF4931E25840F09F8CF1AA97F1AA97F1AA97F1AA97F1AA97F1AA97
                F1AA97F1AA97F1AA97F1AA97F1AA97F1AA97F1AA96F2AB98F5B09CF6B19C
                F6B19CF6B19CF6B19CF6B19CF6B19CF6B19CF6B29FF1A391E95739EB5837
                EB5839EB5839EB5939ED5C3AED5D3AED5D3AED5D3AEF613DF26941F26941
                F26941F26941F26941F26941F26941F26941F26941F26941F26941F26941
                F26941F3683FCB6A473A3E425F4743D24634DA3F2ED64030D64030D64030
                D84231DE4C34DF4E35DF462EE6664DFBE5DFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBEDE8
                E55339EA5537EB5839EB5839EB5939ED5C3AED5D3AED5D3AED5D3AED5D3A
                EE613CF26840F26941F26941F26941F26941F26941F26941F26941F26941
                F26941F26941F26941F3683FCF6A453A3E425F4743D24634DA3F2ED64030
                D64030D64030D64030D84331DF4C34DF482EE4634BFAE3DEFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFAE4DEE55338EA5637EB5839EB5839EB5939ED5C3AED5D3AED5D3A
                ED5D3AED5D3AED5D3AEE603DF26941F26941F26941F26941F26941F26941
                F26941F26941F26941F26941F26941F3683FCC6A453A3E425F4743D24634
                DA3F2ED64030D64030D64030D64030D64030D74231DE472EE4634BFAE3DE
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFAE4DEE55338EA5637EB5839EB5839EB5939ED5C3A
                ED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AEF613DF26941F26941F26941
                F26941F26941F26941F26941F26941F26941F26941F3683FCB6A473A3E42
                5F4743D24634DA3F2ED64030D64030D64030D64030D64030D64030D63C2B
                E0604BFAE3DDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAE4DEE55338EA5637EB5839EB5839
                EB5939ED5C3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AEE613C
                F26840F26941F26941F26941F26941F26941F26941F26941F26941F3683F
                CF6A453A3E425F4743D24634DA3F2ED64030D64030D64030D64030D64030
                D64030D63A29DF5846F9E1DDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAE4DEE55338EA5637
                EB5839EB5839EB5939ED5C3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3A
                ED5D3AED5D3AEE603DF26941F26941F26941F26941F26941F26941F26941
                F26941F3683FCC6A453A3E425F4743D24634DA3F2ED64030D64030D64030
                D64030D64030D64030D63A29DF5846F9E1DDFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAE4DE
                E55338EA5637EB5839EB5839EB5939ED5C3AED5D3AED5D3AED5D3AED5D3A
                ED5D3AED5D3AED5D3AED5D3AED5D3AEF613DF26941F26941F26941F26941
                F26941F26941F26941F3683FCB6A473A3E425F4743D24634DA3F2ED64030
                D64030D64030D64030D64030D64030D63A29DF5846F9E1DDFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFAE4DEE55338EA5637EB5839EB5839EB5939ED5C3AED5D3AED5D3A
                ED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AEE603CF16840
                F26941F26941F26941F26941F26941F3683FCF6A453A3E425F4743D24634
                DA3F2ED64030D64030D64030D64030D64030D64030D63A29DF5846F9E1DD
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFAE4DEE55338EA5637EB5839EB5839EB5939ED5C3A
                ED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3A
                ED5D3AED613BF26941F26941F26941F26941F26941F3683FCC6A453A3E42
                5F4743D24634DA3F2ED64030D64030D64030D64030D64030D64030D63A29
                E15B47FAE3DDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBEDE8E55339EA5537EB5839EB5839
                EB5939ED5C3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3A
                ED5D3AED5D3AED5D3AED5D3AEF623DF26941F26941F26941F26941F3683F
                CB6A473A3E425F4743D24634DA3F2ED64030D64030D64030D64030D64030
                D64030D63E2CDB4F3AEB9685EDA493EDA493EDA493EDA594EFA896F1AA97
                F1AA97F1AA97F1AA97F1AA97F1AA97F1AA97F1AA97F1AA97F1AA97F1AA97
                F1AA97F1AA97F1AA97F1AA97F1AA97F1AA97F2AB97EF9E8BEA5637EB5937
                EB5839EB5839EB5939ED5C3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3A
                ED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AEF613CF26840F26941
                F26941F3683FCF6A453A3E425F4743D24634DA3F2ED64030D64030D64030
                D64030D64030D64030D64130D6402FD43927D43825D43825D43825D43624
                D63926DC4129E0462ADE432ADE432AE14328E14328E14328E14328E14328
                E14328E14328E14328E14328E14328E14328E14328E14328E14328E14328
                E64F33EB5838EC5A3AEB5839EB5939ED5C3AED5D3AED5D3AED5D3AED5D3A
                ED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3A
                EF613DF26941F26941F3683FCC6A453A3E425F4743D24634DA3F2ED64030
                D64030D64030D64030D64030D64030D64030D64030D53E2FD53E2FD53E2F
                D53E2FD53E2FD53E2FD74030E04C34DF4C34DF4A33E34A31E34A31E34A31
                E34A31E34A31E34A31E34A31E34A31E34A31E34A31E34A31E34A31E34A31
                E34A31E34A31E34C32E65034EB5939EC5A3AEB5939ED5C3AED5D3AED5D3A
                ED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3A
                ED5D3AED5D3AED5D3AEF623DF26941F3683FCB6A473A3E425F4743D24634
                DA3F2ED64030D64030D64030D64030D64030D64030D64030D64030D53E2F
                D53E2FD53E2FD53E2FD53E2FD53E2FD53E2FD74030DD4A33E04C34E34C32
                E34C32E34C32E34C32E34C32E34C32E34C32E34C32E34C32E34C32E34C32
                E34C32E34C32E34C32E34C32E34C32E34C32E54E33EB5839EC5B3AED5D3A
                ED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3A
                ED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED613BF1683FCE6A453A3E42
                5F4743D24634DB402ED74230D74230D74230D74230D74230D74230D74230
                D63F2FD43927D43624D43624D43624D43624D43624D43624D43624D63925
                DF4429E44D33E34C32E34C32E34C32E34C32E34C32E34C32E34C32E34C32
                E34C32E34C32E34C32E34C32E34C32E34C32E34C32E34C32E34C32E65034
                EB5938EE5E39ED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3A
                ED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AED5D3AF5603A
                CD6A463B3F435E4542CD3C31D7392BD43C2CD43C2CD43C2CD43C2CD43C2C
                D43C2CD53129DA4F43EB9A8AEDA493EDA493EDA493EDA493EDA493EDA493
                EDA493EDA493ED9B8AE04831E0422AE2462FE2462FE2462FE2462FE2462F
                E2462FE2462FE2462FE2462FE2462FE2462FE2462FE2462FE2462FE2462F
                E2462FE2452FE34831EA5536EB5637EB5637EB5637EB5637EB5637EB5637
                EB5637EB5637EB5637EB5637EB5637EB5637EB5637EB5637EB5637EB5637
                EB5637F35434C95D413C40445C4242C22E2AD22925D32E2AD22D2AD22D2A
                D22D2AD22D2AD22D2AD02422DE6158FBECE8FFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFEFBF6D5382ADA3020DF3E2DDE3D2CDE3D2C
                DE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2C
                DE3D2CDE3D2CDE3D2CDE3D2CDE3E2CDF4731E64F34E85134E75034E75034
                E75034E75034E75034E75034E75034E75034E75034E75034E75034E75034
                E75034E75034E75034F04F31C6573F3A3E425C4242C22E2ACD2525D22C29
                D32E2AD22D2AD22D2AD22D2AD22D2AD12623DE6158FBECE8FFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCF0EBD4372BD52A23DE3E2C
                E0402DDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2C
                DE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CE0402DDE4530E14A32E75033
                E85134E75034E75034E75034E75034E75034E75034E75034E75034E75034
                E75034E75034E75034E75034E75034F04F31C6573F3A3E425C4242C1302D
                C82427CA2729D22D29D32E2AD22D2AD22D2AD22D2AD12623DE6158FBECE8
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCF0EBD4372B
                D32722D5302BDF3F2DE0402DDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2C
                DE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CE0402DDE4530
                DD4531E24A32E85134E95234E75034E75034E75034E75034E75034E75034
                E75034E75034E75034E75034E75034E75034E75034F04F31C6573F3A3E42
                5C4242C22E2AC82325C52529C92629D12C29D32E2AD22D2AD22D2AD12623
                DE6158FBECE8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FCF0EBD4372BD32722D32E2AD4302ADE3D2DE0402DDE3D2CDE3D2CDE3D2C
                DE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2C
                E0402DDE4530DD4531DD4531E14932E85134E95234E75034E75034E75034
                E75034E75034E75034E75034E75034E75034E75034E75034E75034F04F31
                C6573F3A3E425C4242C22E2AC82325C52529C52529C92628D22C29D32E2A
                D22D2AD12623DE6158FBECE8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFCF0EBD4372BD32722D42F2AD32E2AD5312ADE3E2CE0402D
                DE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2C
                DE3D2CDE3D2CE0402DDE4530DD4531DD4531DD4531E14A32E75033E85134
                E75034E75034E75034E75034E75034E75034E75034E75034E75034E75034
                E75034F04F31C6573F3A3E425C4242C22E2AC82325C52529C52529C52529
                CA2729D22D29D32E2AD12623DE6158FBECE8FFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFCF0EBD4372BD32722D42F2AD42F2AD32E2A
                D4302BDF3F2DE0402DDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2C
                DE3D2CDE3D2CDE3D2CDE3D2CE0402DDE4530DD4531DD4531DD4531DD4531
                E24A32E85134E95234E75034E75034E75034E75034E75034E75034E75034
                E75034E75034E75034F04F31C6573F3A3E425C4242C22E2AC82325C52529
                C52529C52529C52529C92629D12C29D12623DE6158FBECE8FFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCF0EBD4372BD32722D42F2A
                D42F2AD42F2AD32E2AD4302ADE3D2DE0402DDE3D2CDE3D2CDE3D2CDE3D2C
                DE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CE0402DDE4530DD4531DD4531
                DD4531DD4531DD4531E14932E85134E95234E75034E75034E75034E75034
                E75034E75034E75034E75034E75034F04F31C6573F3A3E425C4242C22E2A
                C82325C52529C52529C52529C52529C52529C92628CC2323DE6158FBECE8
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCF0EBD4372B
                D32722D42F2AD42F2AD42F2AD42F2AD32E2AD5312ADE3E2CE0402DDE3D2C
                DE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CE0402DDE4530
                DD4531DD4531DD4531DD4531DD4531DD4531E14A32E75033E85134E75034
                E75034E75034E75034E75034E75034E75034E75034F04F31C6573F3A3E42
                5C4242C22E2AC82325C52529C52529C52529C52529C52529C52529C72022
                DF665FFCEFEBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FEFBFAD5392DD32722D42F2AD42F2AD42F2AD42F2AD42F2AD32E2AD4302B
                DF3F2DE0402DDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CDE3D2C
                E0402DDE4530DD4531DD4531DD4531DD4531DD4531DD4531DD4531E24A32
                E85134E95234E75034E75034E75034E75034E75034E75034E75034F04F31
                C6573F3A3E425C4242C22E2AC82325C52529C52529C52529C52529C52529
                C52529C52426CE3B35E37061E77968E77968E77968E77968E77968E77968
                E77968E77968E27062D3352BD22D29D42F2AD42F2AD42F2AD42F2AD42F2A
                D42F2AD32E2AD4302ADE3D2DE0402DDE3D2CDE3D2CDE3D2CDE3D2CDE3D2C
                DE3D2CDE3D2CE0402DDE4530DD4531DD4531DD4531DD4531DD4531DD4531
                DD4531DD4531E14932E85134E95234E75034E75034E75034E75034E75034
                E75034F04F31C6573F3A3E425C4242C22E2AC82325C52529C52529C52529
                C52529C52529C52529C4272AC52424C91B1BCA1C1BCF1F1CCF1F1CCF1F1C
                CF1F1CCF1F1CCF1F1CCF1F1CCF1F1CD32E2AD42F2AD42F2AD42F2AD42F2A
                D42F2AD42F2AD42F2AD42F2AD32E2AD5312ADE3E2CE0402DDE3D2CDE3D2C
                DE3D2CDE3D2CDE3D2CDE3D2CE0402DDE4530DD4531DD4531DD4531DD4531
                DD4531DD4531DD4531DD4531DD4531E14A32E75033E85134E75034E75034
                E75034E75034E75034F04F31C6573F3A3E425C4242C22E2AC82325C52529
                C52529C52529C52529C52529C52529C52529C52529C52529C82629D22C29
                D32E2AD22D2AD22D2AD22D2AD22D2AD22D2AD22D2AD42F2AD42F2AD42F2A
                D42F2AD42F2AD42F2AD42F2AD42F2AD42F2AD42F2AD32E2AD4302BDF3F2D
                E0402DDE3D2CDE3D2CDE3D2CDE3D2CDE3D2CE0402DDE4530DD4531DD4531
                DD4531DD4531DD4531DD4531DD4531DD4531DD4531DD4531E24A32E85134
                E95234E75034E75034E75034E75034F04F31C6573F3A3E425C4242C22E2A
                C82325C52529C52529C52529C52529C52529C52529C52529C52529C52529
                C52529C92629D12C29D32E2AD22D2AD22D2AD22D2AD22D2AD22D2AD42F2A
                D42F2AD42F2AD42F2AD42F2AD42F2AD42F2AD42F2AD42F2AD42F2AD42F2A
                D32E2AD4302ADE3D2DE0402DDE3D2CDE3D2CDE3D2CDE3D2CE0402DDE4530
                DD4531DD4531DD4531DD4531DD4531DD4531DD4531DD4531DD4531DD4531
                DD4531E04832E85134E95234E75034E75034E75034F04F31C6573F3A3E42
                5C4242C22E2AC82325C52529C52529C52529C52529C52529C52529C52529
                C52529C52529C52529C52529C92628D22C29D32E2AD22D2AD22D2AD22D2A
                D22D2AD42F2AD42F2AD42F2AD42F2AD42F2AD42F2AD42F2AD42F2AD42F2A
                D42F2AD42F2AD42F2AD32E2AD5312ADE3E2CE0402DDE3D2CDE3D2CDE3D2C
                E0402DDE4530DD4531DD4531DD4531DD4531DD4531DD4531DD4531DD4531
                DD4531DD4531DD4531DD4531E14A32E75033E85134E75034E75034F04F31
                C6573F3A3E425C4242C22E2AC82325C52529C52529C52529C52529C52529
                C52529C52529C52529C52529C52529C52529C52529CA2729D22D29D32E2A
                D22D2AD22D2AD22D2AD42F2AD42F2AD42F2AD42F2AD42F2AD42F2AD42F2A
                D42F2AD42F2AD42F2AD42F2AD42F2AD42F2AD32E2AD4302BDF3F2DE0402D
                DE3D2CDE3D2CE0402DDE4530DD4531DD4531DD4531DD4531DD4531DD4531
                DD4531DD4531DD4531DD4531DD4531DD4531DD4531E24A32E85134E95234
                E75034F04F31C6573F3A3E425C4242C22E2AC82325C52529C52529C52529
                C52529C52529C52529C52529C52529C52529C52529C52529C52529C52529
                C92629D12C29D32E2AD22D2AD22D2AD42F2AD42F2AD42F2AD42F2AD42F2A
                D42F2AD42F2AD42F2AD42F2AD42F2AD42F2AD42F2AD42F2AD42F2AD32E2A
                D4302ADE3D2DE0402DDE3D2CE0402DDE4530DD4531DD4531DD4531DD4531
                DD4531DD4531DD4531DD4531DD4531DD4531DD4531DD4531DD4531DD4531
                E04832E85134E95234F05031C6573F3A3E425C4242C22E2AC82325C52529
                C52529C52529C52529C52529C52529C52529C52529C52529C52529C52529
                C52529C52529C52529C92628D22C29D32E2AD22D2AD42F2AD42F2AD42F2A
                D42F2AD42F2AD42F2AD42F2AD42F2AD42F2AD42F2AD42F2AD42F2AD42F2A
                D42F2AD42F2AD32E2AD5312ADE3E2CE0402DE0402DDE4530DD4531DD4531
                DD4531DD4531DD4531DD4531DD4531DD4531DD4531DD4531DD4531DD4531
                DD4531DD4531DD4531E14A32E75033F15031C6573F3A3E425C4242C22E2A
                C82325C52529C52529C52529C52529C52529C52529C52529C52529C52529
                C52529C52529C52529C52529C52529C52529CA2729D22D29D32E2AD42F2A
                D42F2AD42F2AD42F2AD42F2AD42F2AD42F2AD42F2AD42F2AD42F2AD42F2A
                D42F2AD42F2AD42F2AD42F2AD42F2AD32E2AD4302BDF3F2DE1432EDE4530
                DD4531DD4531DD4531DD4531DD4531DD4531DD4531DD4531DD4531DD4531
                DD4531DD4531DD4531DD4531DD4531DD4531E04A32EE4F31C6573F3A3E42
                5C4242C2302CCD2724CB2826CB2826CB2826CB2826CB2826CB2826CB2826
                CB2826CB2826CB2826CB2826CB2826CB2826CB2826CB2826CB2826CB2A27
                D32E29DB3028DB3028DB3028DB3028DB3028DB3028DB3028DB3028DB3028
                DB3028DB3028DB3028DB3028DB3028DB3028DB3028DB3028DB3028DC3228
                E03F2CDF4A31DE462FDE462FDE462FDE462FDE462FDE462FDE462FDE462F
                DE462FDE462FDE462FDE462FDE462FDE462FDE462FDE462FDE462FED462E
                CB583D3B3F444C3F408139388237347F38357F38357F38357F38357F3835
                7F38357F38357F38357F38357F38357F38357F38357F38357F38357F3835
                7F38357F38357F38358A3B34893B34893B34883B35893B34893B34883B35
                893B34893B34883B35893B34893B34883B35893B34893B34883B35893B34
                893B348A3B348A3D358B44378A45378A45378A45378A45378A45378A4537
                8A45378A45378A45378A45378A45378A45378A45378A45378A45378A4537
                8A45378D423780493C3A3C3F38393B33383C34393B34393B34393B34393B
                34393B34393B34393B34393B34393B34393B34393B34393B34393B34393B
                34393B34393B34393B34393B34393B34393B34393B34393B33383C34393B
                34393B33383C34393B34393B33383C34393B34393B33383C34393B34393B
                33383C34393B34393B34393B33383C34393B34393B34393B34393B34393B
                34393B34393B34393B34393B34393B34393B34393B34393B34393B34393B
                34393B34393B34393B34393B35393B39393B
            }]
            set-background: func [color [tuple!]][
                console/color: color
                system/view/platform/redraw console
            ]
            set-font-color: func [color [tuple!] /local clr][
                console/font/color: color
                terminal/foreground: color
                if 3 = length? color [clr: color or 0.0.0.1]
                caret/color: clr
                caret-clr: clr
                system/view/platform/redraw console
            ]
            display-about: func [
                /local red-lang github lay text txt small size color link ver
            ][
                red-lang: to-string debase "aHR0cHM6Ly93d3cucmVkLWxhbmcub3Jn"
                github: to-string debase "aHR0cHM6Ly9naXRodWIuY29tL3JlZC9yZWQ="
                lay: layout/tight [
                    title "About"
                    size 360x330
                    backdrop 58.58.60
                    style text: text 360 center 58.58.60
                    style txt: text font-color white
                    style small: txt font [size: 9 color: white]
                    style link: text cursor 'hand all-over
                    on-down [browse to-url face/text]
                    on-over [face/font/style: either event/away? [none] ['underline]]
                    below
                    pad 0x15
                    txt bold "Red Programming Language" font [size: 15 color: white]
                    ver: txt font [size: 9 color: white]
                    at 153x86 image fstk-logo
                    at 0x160 small 360x20 "Copyright 2011-2024 - Red Foundation"
                    at 0x180 small 360x20 "and contributors."
                    at 0x230 link red-lang font-size 10 font-color white
                    at 0x260 link github font-size 10 font-color white
                    at 154x300 button "Close" [unview win/selected: console]
                    do [ver/text: form reduce [
                        "Build" system/version #"-" any [
                            all [system/build/git system/build/git/date]
                            system/build/date
                        ]
                    ]]
                ]
                center-face/with lay win
                view/flags lay [modal no-title]
            ]
            set-dark-mode: func [/local dark? scroller][
                dark?: cfg/dark-mode? = 'true
                foreach face gui-console-ctx/win/parent/pane [
                    system/view/platform/set-dark-mode face dark?
                ]
                system/view/platform/set-dark-mode win dark?
                system/view/platform/set-dark-mode console dark?
                scroller: get-scroller console 'horizontal
                scroller/visible?: no
            ]
            show-cfg-dialog: func [
                /local lay bbox fbox hex-field name cfg-backcolor cfg-forecolor mouse-mode cfg-buffers
            ][
                lay: layout [
                    title "Settings"
                    style bbox: base 20x20 draw [pen gray box 0x0 19x19] on-down [
                        set-background cfg-backcolor/data: face/color
                    ]
                    style fbox: bbox on-down [
                        set-font-color cfg-forecolor/data: face/color
                    ]
                    style hex-field: field 90 center font [name: font/name]
                    group-box "Background color" [
                        bbox #000000 bbox #002b36 bbox #073642 bbox #293955
                        bbox #eee8d5 bbox #fdf6e3 bbox #ffffff
                        cfg-backcolor: hex-field
                    ]
                    return
                    group-box "Font color" [
                        fbox #b98000 fbox #cb4b16 fbox #dc322f fbox #d33682
                        fbox #6c71c4 fbox #268bd2 fbox #2aa198
                        cfg-forecolor: hex-field
                        return
                        fbox #859900 fbox #82bb82 fbox #000000 fbox #657b83
                        fbox #839496 fbox #93a1a1 fbox #ffffff
                    ]
                    return
                    mouse-mode: check "Mouse Copy&&Paste" on-create [
                        face/data: cfg/mouse-paste? = 'true
                    ]
                    pad -3x0 text "Buffer Lines:" 80 middle
                    pad -17x0 cfg-buffers: hex-field right return
                    check "Dark Mode" [
                        cfg/dark-mode?: to-word face/data
                        set-dark-mode
                    ] on-create [
                        unless system/view/platform/support-dark-mode? [
                            face/enabled?: no
                            exit
                        ]
                        face/data: cfg/dark-mode? = 'true
                    ]
                    return
                    pad 90x20
                    button "OK" [
                        if cfg/buffer-lines <> cfg-buffers/data [
                            cfg/buffer-lines: cfg-buffers/data
                            terminal/max-lines: cfg/buffer-lines
                        ]
                        set-font-color cfg/font-color: cfg-forecolor/data
                        set-background cfg/background: cfg-backcolor/data
                        cfg/mouse-paste?: to-word mouse-mode/data
                        toggle-mouse-mode
                        unview
                    ]
                    button "Cancel" [unview]
                ]
                cfg-buffers/data: cfg/buffer-lines
                cfg-forecolor/data: cfg/font-color
                cfg-backcolor/data: cfg/background
                center-face/with lay win
                view/flags lay [modal]
            ]
            apply-cfg: func [
                /local screen font name size color ft
            ][
                screen: get-current-screen
                win/size: cfg/win-size
                either within? cfg/win-pos screen/offset screen/size [
                    win/offset: cfg/win-pos
                ] [
                    center-face/with win screen
                ]
                font: make font! [
                    name: cfg/font-name
                    size: cfg/font-size
                    color: cfg/font-color
                ]
                gui-console-ctx/font: font
                console/font: font
                ft: copy font
                ft/color: white
                tips/font: ft
                terminal/update-cfg font cfg
                set-font-color cfg/font-color
                system/console/history: cfg/history
                terminal/history: cfg/history
                set-dark-mode
            ]
            save-cfg: func [
                /local offset Purpose
            ][
                unless exists? cfg-dir [make-dir/deep cfg-dir]
                offset: win/offset
                if offset/x < 0 [offset/x: 0]
                if offset/y < 0 [offset/y: 0]
                cfg/win-pos: offset
                cfg/win-size: win/size
                cfg/font-name: console/font/name
                cfg/font-size: console/font/size
                clear skip cfg/history 100
                save/header cfg-path cfg [Purpose: "Red Console Configuration File"]
            ]
            check-cfg: func [gui-default
            /local iter f][
                iter: gui-default
                while [not tail? iter] [
                    either f: find cfg iter/1 [
                        if (type? f/2) <> type? iter/2 [
                            f/2: iter/2
                        ]
                    ] [
                        repend cfg [iter/1 iter/2]
                    ]
                    iter: skip iter 2
                ]
            ]
            load-cfg: func [/local cfg-content gui-default][
                system/view/auto-sync?: no
                cfg-dir: append copy system/options/cache %Red-Console/
                unless exists? cfg-dir [make-dir/deep cfg-dir]
                cfg-path: append copy cfg-dir %console-cfg.red
                gui-default: compose [
                    win-pos: 200x200
                    win-size: 640x480
                    font-name: (font/name)
                    font-size: 11
                    font-color: 0.0.0
                    background: 252.252.252
                    mouse-paste?: false
                    menu-bar?: true
                    dark-mode?: no
                ]
                gui-default/win-pos: (200, 200)
                either all [
                    exists? cfg-path
                    attempt [select cfg-content: load cfg-path 'Red]
                ] [
                    cfg: skip cfg-content 2
                    check-cfg gui-default
                ] [
                    cfg: gui-default
                ]
                unless find cfg 'buffer-lines [
                    append cfg [buffer-lines: 10000]
                ]
                unless find cfg 'history [
                    append cfg [history: []]
                ]
                toggle-mouse-mode
                toggle-menu-bar
            ]
            show-caret: func [][unless caret/enabled? [caret/enabled?: yes]]
            win-menu: [
                "File" [
                    "Run..." run-file
                    ---
                    "Quit" quit
                ]
                "Options" [
                    "Choose Font..." choose-font
                    "Settings..." settings
                ]
                "Help" [
                    "Keyboard Shortcuts" shortcuts
                    ---
                    "About" about-msg
                ]
            ]
            show-shortcuts: func [][
                print {^/^-^-Ctrl + C       Copy selected text^/^-^-Ctrl + V       Paste^/^-^-Ctrl + X       Cut selected text^/^-^-Ctrl + A       Go to beginning of line^/^-^-Ctrl + E       Go to end of line^/^-^-Ctrl + H       Backspace^/^-^-Ctrl + Z       Undo^/^-^-Ctrl + Y       Redo^/^-^-Ctrl + L       Clear screen^/^-^-Ctrl + K       Delete line^/^-^-Alt + A        Select all the text^/^-^-Alt + O        Open settings dialog^/^-^-F12            Toggle menu bar^/^-^-}
                terminal/exit-ask-loop
            ]
            toggle-menu-bar: func [][
                win/menu: either cfg/menu-bar? = 'true [win-menu] [none]
            ]
            setup-faces: func [][
                append win/pane reduce [console caret tips]
                win/menu: win-menu
                win/actors: object [
                    on-menu: func [face [object!] event [event!] /local ft f] [
                        switch event/picked [
                            about-msg [display-about]
                            shortcuts [show-shortcuts]
                            quit [self/on-close face event]
                            run-file [if f: request-file [terminal/run-file f]]
                            choose-font [
                                if ft: request-font/font/mono font [
                                    font: ft
                                    console/font: font
                                    terminal/zoom font
                                ]
                            ]
                            settings [show-cfg-dialog]
                        ]
                    ]
                    on-close: func [face [object!] event [event!]] [
                        system/view/platform/exit-event-loop
                        foreach screen system/view/screens [clear head screen/pane]
                        quit
                    ]
                    on-resizing: function [face [object!] event [event!]] [
                        new-sz: to-pair event/offset + 1x1
                        console/size: new-sz
                        terminal/resize new-sz
                        terminal/adjust-console-size new-sz
                        unless system/view/auto-sync? [show face]
                    ]
                    on-resize: :on-resizing
                    on-focus: func [face [object!] event [event!]] [
                        focused?: yes
                        caret/color: caret-clr
                        unless caret/enabled? [caret/enabled?: yes]
                        caret/rate: caret-rate
                        terminal/refresh/force
                    ]
                    on-unfocus: func [face [object!] event [event!]] [
                        focused?: no
                        if caret/enabled? [caret/enabled?: no]
                        caret/rate: none
                    ]
                    on-key-down: func [face [object!] event [event!]] [
                        if event/key = 'F12 [
                            cfg/menu-bar?: to-word none? face/menu
                            toggle-menu-bar
                        ]
                    ]
                ]
                caret/rate: caret-rate
                tips/parent: win
            ]
            win: make object! [
                type: 'window
                offset: (559.2, 339.2)
                size: 839x654
                text: "Red Console"
                image: none
                color: none
                menu: none
                data: none
                enabled?: true
                visible?: false
                selected: make object! [
                    type: 'rich-text
                    offset: (0, 0)
                    size: 840x655
                    text: none
                    image: none
                    color: 22.22.22
                    menu: none
                    data: none
                    enabled?: true
                    visible?: true
                    selected: none
                    flags: [scrollable all-over]
                    options: [cursor: I-beam]
                    parent: make object! [...]
                    pane: none
                    state: [handle! 0 none false]
                    rate: 10
                    edge: none
                    para: none
                    font: make object! [
                        name: "Consolas"
                        size: 11
                        style: none
                        angle: 0
                        color: 222.222.222
                        anti-alias?: false
                        shadow: none
                        state: [handle! none none]
                        parent: []
                    ]
                    actors: make object! [
                        on-time: func [face [object!] event [event!]][
                            if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                            terminal/on-time
                            'done
                        ]
                        on-drawing: func [face [object!] event [event!]][
                            terminal/paint
                        ]
                        on-scroll: func [face [object!] event [event!]][
                            terminal/scroll event
                        ]
                        on-wheel: func [face [object!] event [event!]][
                            either event/ctrl? [
                                terminal/zoom event
                            ] [
                                terminal/scroll event
                            ]
                        ]
                        on-key: func [face [object!] event [event!]][
                            terminal/press-key event
                        ]
                        on-key-down: func [face [object!] event [event!]][
                            if all [1 = length? event/flags find event/flags 'alt] [
                                switch event/key [
                                    #"A" [terminal/select-all]
                                    #"O" [show-cfg-dialog]
                                ]
                            ]
                        ]
                        on-ime: func [face [object!] event [event!]][
                            terminal/process-ime-input event
                        ]
                        on-down: func [face [object!] event [event!]][
                            terminal/mouse-down event
                        ]
                        on-up: func [face [object!] event [event!]][
                            terminal/mouse-up event
                        ]
                        on-alt-down: func [face [object!] event [event!]][
                            if cfg/mouse-paste? = 'true [
                                either terminal/text-selected? [
                                    terminal/copy-selection
                                    clear terminal/selects
                                    system/view/platform/redraw face
                                ] [
                                    terminal/paste
                                ]
                            ]
                        ]
                        on-over: func [face [object!] event [event!]][
                            terminal/mouse-move to-pair event/offset
                        ]
                        on-menu: func [face [object!] event [event!]][
                            switch event/picked [
                                copy [terminal/copy-selection]
                                paste [terminal/paste]
                                select-all [terminal/select-all]
                            ]
                            'done
                        ]
                    ]
                    extra: none
                    draw: none
                    tabs: none
                    line-spacing: 'default
                    handles: none
                    init: func [/local box][
                        terminal/windows: get in get-current-screen 'pane
                        box: terminal/box
                        box/data: make block! 200
                        scroller: get-scroller self 'horizontal
                        scroller/visible?: no
                        scroller: get-scroller self 'vertical
                        scroller/position: 1
                        scroller/max-size: 2
                    ]
                ]
                flags: [resize]
                options: none
                parent: make object! [
                    type: 'screen
                    offset: 0x0
                    size: 2048x1152
                    text: none
                    image: none
                    color: none
                    menu: none
                    data: 1.25
                    enabled?: true
                    visible?: true
                    selected: none
                    flags: none
                    options: none
                    parent: none
                    pane: []
                    state: [handle! 0 none [1]]
                    rate: none
                    edge: none
                    para: none
                    font: none
                    actors: none
                    extra: none
                    draw: none
                ]
                pane: [make object! [
                    type: 'rich-text
                    offset: (0, 0)
                    size: 840x655
                    text: none
                    image: none
                    color: 22.22.22
                    menu: none
                    data: none
                    enabled?: true
                    visible?: true
                    selected: none
                    flags: [scrollable all-over]
                    options: [cursor: I-beam]
                    parent: make object! [...]
                    pane: none
                    state: [handle! 0 none false]
                    rate: 10
                    edge: none
                    para: none
                    font: make object! [
                        name: "Consolas"
                        size: 11
                        style: none
                        angle: 0
                        color: 222.222.222
                        anti-alias?: false
                        shadow: none
                        state: [handle! none none]
                        parent: []
                    ]
                    actors: make object! [
                        on-time: func [face [object!] event [event!]][
                            if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                            terminal/on-time
                            'done
                        ]
                        on-drawing: func [face [object!] event [event!]][
                            terminal/paint
                        ]
                        on-scroll: func [face [object!] event [event!]][
                            terminal/scroll event
                        ]
                        on-wheel: func [face [object!] event [event!]][
                            either event/ctrl? [
                                terminal/zoom event
                            ] [
                                terminal/scroll event
                            ]
                        ]
                        on-key: func [face [object!] event [event!]][
                            terminal/press-key event
                        ]
                        on-key-down: func [face [object!] event [event!]][
                            if all [1 = length? event/flags find event/flags 'alt] [
                                switch event/key [
                                    #"A" [terminal/select-all]
                                    #"O" [show-cfg-dialog]
                                ]
                            ]
                        ]
                        on-ime: func [face [object!] event [event!]][
                            terminal/process-ime-input event
                        ]
                        on-down: func [face [object!] event [event!]][
                            terminal/mouse-down event
                        ]
                        on-up: func [face [object!] event [event!]][
                            terminal/mouse-up event
                        ]
                        on-alt-down: func [face [object!] event [event!]][
                            if cfg/mouse-paste? = 'true [
                                either terminal/text-selected? [
                                    terminal/copy-selection
                                    clear terminal/selects
                                    system/view/platform/redraw face
                                ] [
                                    terminal/paste
                                ]
                            ]
                        ]
                        on-over: func [face [object!] event [event!]][
                            terminal/mouse-move to-pair event/offset
                        ]
                        on-menu: func [face [object!] event [event!]][
                            switch event/picked [
                                copy [terminal/copy-selection]
                                paste [terminal/paste]
                                select-all [terminal/select-all]
                            ]
                            'done
                        ]
                    ]
                    extra: none
                    draw: none
                    tabs: none
                    line-spacing: 'default
                    handles: none
                    init: func [/local box][
                        terminal/windows: get in get-current-screen 'pane
                        box: terminal/box
                        box/data: make block! 200
                        scroller: get-scroller self 'horizontal
                        scroller/visible?: no
                        scroller: get-scroller self 'vertical
                        scroller/position: 1
                        scroller/max-size: 2
                    ]
                ] make object! [
                    type: 'base
                    offset: (0, 0)
                    size: 1x17
                    text: none
                    image: none
                    color: 222.222.222.1
                    menu: none
                    data: none
                    enabled?: false
                    visible?: true
                    selected: none
                    flags: none
                    options: [caret make object! [
                        type: 'rich-text
                        offset: (0, 0)
                        size: 840x655
                        text: none
                        image: none
                        color: 22.22.22
                        menu: none
                        data: none
                        enabled?: true
                        visible?: true
                        selected: none
                        flags: [scrollable all-over]
                        options: [cursor: I-beam]
                        parent: make object! [...]
                        pane: none
                        state: [handle! 0 none false]
                        rate: 10
                        edge: none
                        para: none
                        font: make object! [
                            name: "Consolas"
                            size: 11
                            style: none
                            angle: 0
                            color: 222.222.222
                            anti-alias?: false
                            shadow: none
                            state: [handle! none none]
                            parent: []
                        ]
                        actors: make object! [
                            on-time: func [face [object!] event [event!]][
                                if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                                terminal/on-time
                                'done
                            ]
                            on-drawing: func [face [object!] event [event!]][
                                terminal/paint
                            ]
                            on-scroll: func [face [object!] event [event!]][
                                terminal/scroll event
                            ]
                            on-wheel: func [face [object!] event [event!]][
                                either event/ctrl? [
                                    terminal/zoom event
                                ] [
                                    terminal/scroll event
                                ]
                            ]
                            on-key: func [face [object!] event [event!]][
                                terminal/press-key event
                            ]
                            on-key-down: func [face [object!] event [event!]][
                                if all [1 = length? event/flags find event/flags 'alt] [
                                    switch event/key [
                                        #"A" [terminal/select-all]
                                        #"O" [show-cfg-dialog]
                                    ]
                                ]
                            ]
                            on-ime: func [face [object!] event [event!]][
                                terminal/process-ime-input event
                            ]
                            on-down: func [face [object!] event [event!]][
                                terminal/mouse-down event
                            ]
                            on-up: func [face [object!] event [event!]][
                                terminal/mouse-up event
                            ]
                            on-alt-down: func [face [object!] event [event!]][
                                if cfg/mouse-paste? = 'true [
                                    either terminal/text-selected? [
                                        terminal/copy-selection
                                        clear terminal/selects
                                        system/view/platform/redraw face
                                    ] [
                                        terminal/paste
                                    ]
                                ]
                            ]
                            on-over: func [face [object!] event [event!]][
                                terminal/mouse-move to-pair event/offset
                            ]
                            on-menu: func [face [object!] event [event!]][
                                switch event/picked [
                                    copy [terminal/copy-selection]
                                    paste [terminal/paste]
                                    select-all [terminal/select-all]
                                ]
                                'done
                            ]
                        ]
                        extra: none
                        draw: none
                        tabs: none
                        line-spacing: 'default
                        handles: none
                        init: func [/local box][
                            terminal/windows: get in get-current-screen 'pane
                            box: terminal/box
                            box/data: make block! 200
                            scroller: get-scroller self 'horizontal
                            scroller/visible?: no
                            scroller: get-scroller self 'vertical
                            scroller/position: 1
                            scroller/max-size: 2
                        ]
                    ] cursor: I-beam accelerated: yes]
                    parent: make object! [...]
                    pane: none
                    state: [handle! 0 none false]
                    rate: 0:00:00.53
                    edge: none
                    para: none
                    font: none
                    actors: make object! [
                        on-time: func [face [object!] event [event!]][
                            face/color: either face/color = caret-clr [255.255.255.254] [caret-clr]
                            'done
                        ]
                    ]
                    extra: none
                    draw: none
                ] make object! [
                    type: 'panel
                    offset: (0, 0)
                    size: 150x200
                    text: none
                    image: none
                    color: 0.0.128
                    menu: none
                    data: none
                    enabled?: true
                    visible?: false
                    selected: none
                    flags: none
                    options: none
                    parent: make object! [...]
                    pane: none
                    state: [handle! 0 none false]
                    rate: none
                    edge: none
                    para: none
                    font: make object! [
                        name: "Consolas"
                        size: 11
                        style: none
                        angle: 0
                        color: 255.255.255
                        anti-alias?: false
                        shadow: none
                        state: [handle! none none]
                        parent: [make object! [
                            type: 'rich-text
                            offset: none
                            size: 820x655
                            text: "XXXXXXXXXX"
                            image: none
                            color: none
                            menu: none
                            data: []
                            enabled?: true
                            visible?: true
                            selected: none
                            flags: none
                            options: none
                            parent: none
                            pane: none
                            state: none
                            rate: none
                            edge: none
                            para: none
                            font: make object! [
                                name: "Consolas"
                                size: 11
                                style: none
                                angle: 0
                                color: 222.222.222
                                anti-alias?: false
                                shadow: none
                                state: [handle! none none]
                                parent: [...]
                            ]
                            actors: none
                            extra: none
                            draw: none
                            tabs: 32.4
                            line-spacing: 17
                            handles: [handle! handle! "XXXXXXXXXX" true]
                        ]]
                    ]
                    actors: make object! [
                        on-key-down: func [face [object!] event [event!]][
                            probe event/key
                        ]
                    ]
                    extra: none
                    draw: none
                ]]
                state: [handle! 0 none false]
                rate: none
                edge: none
                para: none
                font: none
                actors: make object! [
                    on-menu: func [face [object!] event [event!] /local ft f][
                        switch event/picked [
                            about-msg [display-about]
                            shortcuts [show-shortcuts]
                            quit [self/on-close face event]
                            run-file [if f: request-file [terminal/run-file f]]
                            choose-font [
                                if ft: request-font/font/mono font [
                                    font: ft
                                    console/font: font
                                    terminal/zoom font
                                ]
                            ]
                            settings [show-cfg-dialog]
                        ]
                    ]
                    on-close: func [face [object!] event [event!]][
                        system/view/platform/exit-event-loop
                        foreach screen system/view/screens [clear head screen/pane]
                        quit
                    ]
                    on-resizing: func [face [object!] event [event!]
                    /local new-sz][
                        new-sz: to-pair event/offset + 1x1
                        console/size: new-sz
                        terminal/resize new-sz
                        terminal/adjust-console-size new-sz
                        unless system/view/auto-sync? [show face]
                    ]
                    on-resize: func [face [object!] event [event!]
                    /local new-sz][
                        new-sz: to-pair event/offset + 1x1
                        console/size: new-sz
                        terminal/resize new-sz
                        terminal/adjust-console-size new-sz
                        unless system/view/auto-sync? [show face]
                    ]
                    on-focus: func [face [object!] event [event!]][
                        focused?: yes
                        caret/color: caret-clr
                        unless caret/enabled? [caret/enabled?: yes]
                        caret/rate: caret-rate
                        terminal/refresh/force
                    ]
                    on-unfocus: func [face [object!] event [event!]][
                        focused?: no
                        if caret/enabled? [caret/enabled?: no]
                        caret/rate: none
                    ]
                    on-key-down: func [face [object!] event [event!]][
                        if event/key = 'F12 [
                            cfg/menu-bar?: to-word none? face/menu
                            toggle-menu-bar
                        ]
                    ]
                ]
                extra: none
                draw: none
            ]
            owned-faces: [make object! [
                type: 'rich-text
                offset: (0, 0)
                size: 840x655
                text: none
                image: none
                color: 22.22.22
                menu: none
                data: none
                enabled?: true
                visible?: true
                selected: none
                flags: [scrollable all-over]
                options: [cursor: I-beam]
                parent: make object! [
                    type: 'window
                    offset: (559.2, 339.2)
                    size: 839x654
                    text: "Red Console"
                    image: none
                    color: none
                    menu: none
                    data: none
                    enabled?: true
                    visible?: false
                    selected: make object! [...]
                    flags: [resize]
                    options: none
                    parent: make object! [
                        type: 'screen
                        offset: 0x0
                        size: 2048x1152
                        text: none
                        image: none
                        color: none
                        menu: none
                        data: 1.25
                        enabled?: true
                        visible?: true
                        selected: none
                        flags: none
                        options: none
                        parent: none
                        pane: []
                        state: [handle! 0 none [1]]
                        rate: none
                        edge: none
                        para: none
                        font: none
                        actors: none
                        extra: none
                        draw: none
                    ]
                    pane: [make object! [...] make object! [
                        type: 'base
                        offset: (0, 0)
                        size: 1x17
                        text: none
                        image: none
                        color: 222.222.222.1
                        menu: none
                        data: none
                        enabled?: false
                        visible?: true
                        selected: none
                        flags: none
                        options: [caret make object! [...] cursor: I-beam accelerated: yes]
                        parent: make object! [...]
                        pane: none
                        state: [handle! 0 none false]
                        rate: 0:00:00.53
                        edge: none
                        para: none
                        font: none
                        actors: make object! [
                            on-time: func [face [object!] event [event!]][
                                face/color: either face/color = caret-clr [255.255.255.254] [caret-clr]
                                'done
                            ]
                        ]
                        extra: none
                        draw: none
                    ] make object! [
                        type: 'panel
                        offset: (0, 0)
                        size: 150x200
                        text: none
                        image: none
                        color: 0.0.128
                        menu: none
                        data: none
                        enabled?: true
                        visible?: false
                        selected: none
                        flags: none
                        options: none
                        parent: make object! [...]
                        pane: none
                        state: [handle! 0 none false]
                        rate: none
                        edge: none
                        para: none
                        font: make object! [
                            name: "Consolas"
                            size: 11
                            style: none
                            angle: 0
                            color: 255.255.255
                            anti-alias?: false
                            shadow: none
                            state: [handle! none none]
                            parent: [make object! [
                                type: 'rich-text
                                offset: none
                                size: 820x655
                                text: "XXXXXXXXXX"
                                image: none
                                color: none
                                menu: none
                                data: []
                                enabled?: true
                                visible?: true
                                selected: none
                                flags: none
                                options: none
                                parent: none
                                pane: none
                                state: none
                                rate: none
                                edge: none
                                para: none
                                font: make object! [
                                    name: "Consolas"
                                    size: 11
                                    style: none
                                    angle: 0
                                    color: 222.222.222
                                    anti-alias?: false
                                    shadow: none
                                    state: [handle! none none]
                                    parent: [...]
                                ]
                                actors: none
                                extra: none
                                draw: none
                                tabs: 32.4
                                line-spacing: 17
                                handles: [handle! handle! "XXXXXXXXXX" true]
                            ]]
                        ]
                        actors: make object! [
                            on-key-down: func [face [object!] event [event!]][
                                probe event/key
                            ]
                        ]
                        extra: none
                        draw: none
                    ]]
                    state: [handle! 0 none false]
                    rate: none
                    edge: none
                    para: none
                    font: none
                    actors: make object! [
                        on-menu: func [face [object!] event [event!] /local ft f][
                            switch event/picked [
                                about-msg [display-about]
                                shortcuts [show-shortcuts]
                                quit [self/on-close face event]
                                run-file [if f: request-file [terminal/run-file f]]
                                choose-font [
                                    if ft: request-font/font/mono font [
                                        font: ft
                                        console/font: font
                                        terminal/zoom font
                                    ]
                                ]
                                settings [show-cfg-dialog]
                            ]
                        ]
                        on-close: func [face [object!] event [event!]][
                            system/view/platform/exit-event-loop
                            foreach screen system/view/screens [clear head screen/pane]
                            quit
                        ]
                        on-resizing: func [face [object!] event [event!]
                        /local new-sz][
                            new-sz: to-pair event/offset + 1x1
                            console/size: new-sz
                            terminal/resize new-sz
                            terminal/adjust-console-size new-sz
                            unless system/view/auto-sync? [show face]
                        ]
                        on-resize: func [face [object!] event [event!]
                        /local new-sz][
                            new-sz: to-pair event/offset + 1x1
                            console/size: new-sz
                            terminal/resize new-sz
                            terminal/adjust-console-size new-sz
                            unless system/view/auto-sync? [show face]
                        ]
                        on-focus: func [face [object!] event [event!]][
                            focused?: yes
                            caret/color: caret-clr
                            unless caret/enabled? [caret/enabled?: yes]
                            caret/rate: caret-rate
                            terminal/refresh/force
                        ]
                        on-unfocus: func [face [object!] event [event!]][
                            focused?: no
                            if caret/enabled? [caret/enabled?: no]
                            caret/rate: none
                        ]
                        on-key-down: func [face [object!] event [event!]][
                            if event/key = 'F12 [
                                cfg/menu-bar?: to-word none? face/menu
                                toggle-menu-bar
                            ]
                        ]
                    ]
                    extra: none
                    draw: none
                ]
                pane: none
                state: [handle! 0 none false]
                rate: 10
                edge: none
                para: none
                font: make object! [
                    name: "Consolas"
                    size: 11
                    style: none
                    angle: 0
                    color: 222.222.222
                    anti-alias?: false
                    shadow: none
                    state: [handle! none none]
                    parent: []
                ]
                actors: make object! [
                    on-time: func [face [object!] event [event!]][
                        if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                        terminal/on-time
                        'done
                    ]
                    on-drawing: func [face [object!] event [event!]][
                        terminal/paint
                    ]
                    on-scroll: func [face [object!] event [event!]][
                        terminal/scroll event
                    ]
                    on-wheel: func [face [object!] event [event!]][
                        either event/ctrl? [
                            terminal/zoom event
                        ] [
                            terminal/scroll event
                        ]
                    ]
                    on-key: func [face [object!] event [event!]][
                        terminal/press-key event
                    ]
                    on-key-down: func [face [object!] event [event!]][
                        if all [1 = length? event/flags find event/flags 'alt] [
                            switch event/key [
                                #"A" [terminal/select-all]
                                #"O" [show-cfg-dialog]
                            ]
                        ]
                    ]
                    on-ime: func [face [object!] event [event!]][
                        terminal/process-ime-input event
                    ]
                    on-down: func [face [object!] event [event!]][
                        terminal/mouse-down event
                    ]
                    on-up: func [face [object!] event [event!]][
                        terminal/mouse-up event
                    ]
                    on-alt-down: func [face [object!] event [event!]][
                        if cfg/mouse-paste? = 'true [
                            either terminal/text-selected? [
                                terminal/copy-selection
                                clear terminal/selects
                                system/view/platform/redraw face
                            ] [
                                terminal/paste
                            ]
                        ]
                    ]
                    on-over: func [face [object!] event [event!]][
                        terminal/mouse-move to-pair event/offset
                    ]
                    on-menu: func [face [object!] event [event!]][
                        switch event/picked [
                            copy [terminal/copy-selection]
                            paste [terminal/paste]
                            select-all [terminal/select-all]
                        ]
                        'done
                    ]
                ]
                extra: none
                draw: none
                tabs: none
                line-spacing: 'default
                handles: none
                init: func [/local box][
                    terminal/windows: get in get-current-screen 'pane
                    box: terminal/box
                    box/data: make block! 200
                    scroller: get-scroller self 'horizontal
                    scroller/visible?: no
                    scroller: get-scroller self 'vertical
                    scroller/position: 1
                    scroller/max-size: 2
                ]
            ] make object! [
                type: 'window
                offset: (559.2, 339.2)
                size: 839x654
                text: "Red Console"
                image: none
                color: none
                menu: none
                data: none
                enabled?: true
                visible?: false
                selected: make object! [
                    type: 'rich-text
                    offset: (0, 0)
                    size: 840x655
                    text: none
                    image: none
                    color: 22.22.22
                    menu: none
                    data: none
                    enabled?: true
                    visible?: true
                    selected: none
                    flags: [scrollable all-over]
                    options: [cursor: I-beam]
                    parent: make object! [...]
                    pane: none
                    state: [handle! 0 none false]
                    rate: 10
                    edge: none
                    para: none
                    font: make object! [
                        name: "Consolas"
                        size: 11
                        style: none
                        angle: 0
                        color: 222.222.222
                        anti-alias?: false
                        shadow: none
                        state: [handle! none none]
                        parent: []
                    ]
                    actors: make object! [
                        on-time: func [face [object!] event [event!]][
                            if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                            terminal/on-time
                            'done
                        ]
                        on-drawing: func [face [object!] event [event!]][
                            terminal/paint
                        ]
                        on-scroll: func [face [object!] event [event!]][
                            terminal/scroll event
                        ]
                        on-wheel: func [face [object!] event [event!]][
                            either event/ctrl? [
                                terminal/zoom event
                            ] [
                                terminal/scroll event
                            ]
                        ]
                        on-key: func [face [object!] event [event!]][
                            terminal/press-key event
                        ]
                        on-key-down: func [face [object!] event [event!]][
                            if all [1 = length? event/flags find event/flags 'alt] [
                                switch event/key [
                                    #"A" [terminal/select-all]
                                    #"O" [show-cfg-dialog]
                                ]
                            ]
                        ]
                        on-ime: func [face [object!] event [event!]][
                            terminal/process-ime-input event
                        ]
                        on-down: func [face [object!] event [event!]][
                            terminal/mouse-down event
                        ]
                        on-up: func [face [object!] event [event!]][
                            terminal/mouse-up event
                        ]
                        on-alt-down: func [face [object!] event [event!]][
                            if cfg/mouse-paste? = 'true [
                                either terminal/text-selected? [
                                    terminal/copy-selection
                                    clear terminal/selects
                                    system/view/platform/redraw face
                                ] [
                                    terminal/paste
                                ]
                            ]
                        ]
                        on-over: func [face [object!] event [event!]][
                            terminal/mouse-move to-pair event/offset
                        ]
                        on-menu: func [face [object!] event [event!]][
                            switch event/picked [
                                copy [terminal/copy-selection]
                                paste [terminal/paste]
                                select-all [terminal/select-all]
                            ]
                            'done
                        ]
                    ]
                    extra: none
                    draw: none
                    tabs: none
                    line-spacing: 'default
                    handles: none
                    init: func [/local box][
                        terminal/windows: get in get-current-screen 'pane
                        box: terminal/box
                        box/data: make block! 200
                        scroller: get-scroller self 'horizontal
                        scroller/visible?: no
                        scroller: get-scroller self 'vertical
                        scroller/position: 1
                        scroller/max-size: 2
                    ]
                ]
                flags: [resize]
                options: none
                parent: make object! [
                    type: 'screen
                    offset: 0x0
                    size: 2048x1152
                    text: none
                    image: none
                    color: none
                    menu: none
                    data: 1.25
                    enabled?: true
                    visible?: true
                    selected: none
                    flags: none
                    options: none
                    parent: none
                    pane: []
                    state: [handle! 0 none [1]]
                    rate: none
                    edge: none
                    para: none
                    font: none
                    actors: none
                    extra: none
                    draw: none
                ]
                pane: [make object! [
                    type: 'rich-text
                    offset: (0, 0)
                    size: 840x655
                    text: none
                    image: none
                    color: 22.22.22
                    menu: none
                    data: none
                    enabled?: true
                    visible?: true
                    selected: none
                    flags: [scrollable all-over]
                    options: [cursor: I-beam]
                    parent: make object! [...]
                    pane: none
                    state: [handle! 0 none false]
                    rate: 10
                    edge: none
                    para: none
                    font: make object! [
                        name: "Consolas"
                        size: 11
                        style: none
                        angle: 0
                        color: 222.222.222
                        anti-alias?: false
                        shadow: none
                        state: [handle! none none]
                        parent: []
                    ]
                    actors: make object! [
                        on-time: func [face [object!] event [event!]][
                            if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                            terminal/on-time
                            'done
                        ]
                        on-drawing: func [face [object!] event [event!]][
                            terminal/paint
                        ]
                        on-scroll: func [face [object!] event [event!]][
                            terminal/scroll event
                        ]
                        on-wheel: func [face [object!] event [event!]][
                            either event/ctrl? [
                                terminal/zoom event
                            ] [
                                terminal/scroll event
                            ]
                        ]
                        on-key: func [face [object!] event [event!]][
                            terminal/press-key event
                        ]
                        on-key-down: func [face [object!] event [event!]][
                            if all [1 = length? event/flags find event/flags 'alt] [
                                switch event/key [
                                    #"A" [terminal/select-all]
                                    #"O" [show-cfg-dialog]
                                ]
                            ]
                        ]
                        on-ime: func [face [object!] event [event!]][
                            terminal/process-ime-input event
                        ]
                        on-down: func [face [object!] event [event!]][
                            terminal/mouse-down event
                        ]
                        on-up: func [face [object!] event [event!]][
                            terminal/mouse-up event
                        ]
                        on-alt-down: func [face [object!] event [event!]][
                            if cfg/mouse-paste? = 'true [
                                either terminal/text-selected? [
                                    terminal/copy-selection
                                    clear terminal/selects
                                    system/view/platform/redraw face
                                ] [
                                    terminal/paste
                                ]
                            ]
                        ]
                        on-over: func [face [object!] event [event!]][
                            terminal/mouse-move to-pair event/offset
                        ]
                        on-menu: func [face [object!] event [event!]][
                            switch event/picked [
                                copy [terminal/copy-selection]
                                paste [terminal/paste]
                                select-all [terminal/select-all]
                            ]
                            'done
                        ]
                    ]
                    extra: none
                    draw: none
                    tabs: none
                    line-spacing: 'default
                    handles: none
                    init: func [/local box][
                        terminal/windows: get in get-current-screen 'pane
                        box: terminal/box
                        box/data: make block! 200
                        scroller: get-scroller self 'horizontal
                        scroller/visible?: no
                        scroller: get-scroller self 'vertical
                        scroller/position: 1
                        scroller/max-size: 2
                    ]
                ] make object! [
                    type: 'base
                    offset: (0, 0)
                    size: 1x17
                    text: none
                    image: none
                    color: 222.222.222.1
                    menu: none
                    data: none
                    enabled?: false
                    visible?: true
                    selected: none
                    flags: none
                    options: [caret make object! [
                        type: 'rich-text
                        offset: (0, 0)
                        size: 840x655
                        text: none
                        image: none
                        color: 22.22.22
                        menu: none
                        data: none
                        enabled?: true
                        visible?: true
                        selected: none
                        flags: [scrollable all-over]
                        options: [cursor: I-beam]
                        parent: make object! [...]
                        pane: none
                        state: [handle! 0 none false]
                        rate: 10
                        edge: none
                        para: none
                        font: make object! [
                            name: "Consolas"
                            size: 11
                            style: none
                            angle: 0
                            color: 222.222.222
                            anti-alias?: false
                            shadow: none
                            state: [handle! none none]
                            parent: []
                        ]
                        actors: make object! [
                            on-time: func [face [object!] event [event!]][
                                if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                                terminal/on-time
                                'done
                            ]
                            on-drawing: func [face [object!] event [event!]][
                                terminal/paint
                            ]
                            on-scroll: func [face [object!] event [event!]][
                                terminal/scroll event
                            ]
                            on-wheel: func [face [object!] event [event!]][
                                either event/ctrl? [
                                    terminal/zoom event
                                ] [
                                    terminal/scroll event
                                ]
                            ]
                            on-key: func [face [object!] event [event!]][
                                terminal/press-key event
                            ]
                            on-key-down: func [face [object!] event [event!]][
                                if all [1 = length? event/flags find event/flags 'alt] [
                                    switch event/key [
                                        #"A" [terminal/select-all]
                                        #"O" [show-cfg-dialog]
                                    ]
                                ]
                            ]
                            on-ime: func [face [object!] event [event!]][
                                terminal/process-ime-input event
                            ]
                            on-down: func [face [object!] event [event!]][
                                terminal/mouse-down event
                            ]
                            on-up: func [face [object!] event [event!]][
                                terminal/mouse-up event
                            ]
                            on-alt-down: func [face [object!] event [event!]][
                                if cfg/mouse-paste? = 'true [
                                    either terminal/text-selected? [
                                        terminal/copy-selection
                                        clear terminal/selects
                                        system/view/platform/redraw face
                                    ] [
                                        terminal/paste
                                    ]
                                ]
                            ]
                            on-over: func [face [object!] event [event!]][
                                terminal/mouse-move to-pair event/offset
                            ]
                            on-menu: func [face [object!] event [event!]][
                                switch event/picked [
                                    copy [terminal/copy-selection]
                                    paste [terminal/paste]
                                    select-all [terminal/select-all]
                                ]
                                'done
                            ]
                        ]
                        extra: none
                        draw: none
                        tabs: none
                        line-spacing: 'default
                        handles: none
                        init: func [/local box][
                            terminal/windows: get in get-current-screen 'pane
                            box: terminal/box
                            box/data: make block! 200
                            scroller: get-scroller self 'horizontal
                            scroller/visible?: no
                            scroller: get-scroller self 'vertical
                            scroller/position: 1
                            scroller/max-size: 2
                        ]
                    ] cursor: I-beam accelerated: yes]
                    parent: make object! [...]
                    pane: none
                    state: [handle! 0 none false]
                    rate: 0:00:00.53
                    edge: none
                    para: none
                    font: none
                    actors: make object! [
                        on-time: func [face [object!] event [event!]][
                            face/color: either face/color = caret-clr [255.255.255.254] [caret-clr]
                            'done
                        ]
                    ]
                    extra: none
                    draw: none
                ] make object! [
                    type: 'panel
                    offset: (0, 0)
                    size: 150x200
                    text: none
                    image: none
                    color: 0.0.128
                    menu: none
                    data: none
                    enabled?: true
                    visible?: false
                    selected: none
                    flags: none
                    options: none
                    parent: make object! [...]
                    pane: none
                    state: [handle! 0 none false]
                    rate: none
                    edge: none
                    para: none
                    font: make object! [
                        name: "Consolas"
                        size: 11
                        style: none
                        angle: 0
                        color: 255.255.255
                        anti-alias?: false
                        shadow: none
                        state: [handle! none none]
                        parent: [make object! [
                            type: 'rich-text
                            offset: none
                            size: 820x655
                            text: "XXXXXXXXXX"
                            image: none
                            color: none
                            menu: none
                            data: []
                            enabled?: true
                            visible?: true
                            selected: none
                            flags: none
                            options: none
                            parent: none
                            pane: none
                            state: none
                            rate: none
                            edge: none
                            para: none
                            font: make object! [
                                name: "Consolas"
                                size: 11
                                style: none
                                angle: 0
                                color: 222.222.222
                                anti-alias?: false
                                shadow: none
                                state: [handle! none none]
                                parent: [...]
                            ]
                            actors: none
                            extra: none
                            draw: none
                            tabs: 32.4
                            line-spacing: 17
                            handles: [handle! handle! "XXXXXXXXXX" true]
                        ]]
                    ]
                    actors: make object! [
                        on-key-down: func [face [object!] event [event!]][
                            probe event/key
                        ]
                    ]
                    extra: none
                    draw: none
                ]]
                state: [handle! 0 none false]
                rate: none
                edge: none
                para: none
                font: none
                actors: make object! [
                    on-menu: func [face [object!] event [event!] /local ft f][
                        switch event/picked [
                            about-msg [display-about]
                            shortcuts [show-shortcuts]
                            quit [self/on-close face event]
                            run-file [if f: request-file [terminal/run-file f]]
                            choose-font [
                                if ft: request-font/font/mono font [
                                    font: ft
                                    console/font: font
                                    terminal/zoom font
                                ]
                            ]
                            settings [show-cfg-dialog]
                        ]
                    ]
                    on-close: func [face [object!] event [event!]][
                        system/view/platform/exit-event-loop
                        foreach screen system/view/screens [clear head screen/pane]
                        quit
                    ]
                    on-resizing: func [face [object!] event [event!]
                    /local new-sz][
                        new-sz: to-pair event/offset + 1x1
                        console/size: new-sz
                        terminal/resize new-sz
                        terminal/adjust-console-size new-sz
                        unless system/view/auto-sync? [show face]
                    ]
                    on-resize: func [face [object!] event [event!]
                    /local new-sz][
                        new-sz: to-pair event/offset + 1x1
                        console/size: new-sz
                        terminal/resize new-sz
                        terminal/adjust-console-size new-sz
                        unless system/view/auto-sync? [show face]
                    ]
                    on-focus: func [face [object!] event [event!]][
                        focused?: yes
                        caret/color: caret-clr
                        unless caret/enabled? [caret/enabled?: yes]
                        caret/rate: caret-rate
                        terminal/refresh/force
                    ]
                    on-unfocus: func [face [object!] event [event!]][
                        focused?: no
                        if caret/enabled? [caret/enabled?: no]
                        caret/rate: none
                    ]
                    on-key-down: func [face [object!] event [event!]][
                        if event/key = 'F12 [
                            cfg/menu-bar?: to-word none? face/menu
                            toggle-menu-bar
                        ]
                    ]
                ]
                extra: none
                draw: none
            ] make object! [
                type: 'base
                offset: (0, 0)
                size: 1x17
                text: none
                image: none
                color: 222.222.222.1
                menu: none
                data: none
                enabled?: false
                visible?: true
                selected: none
                flags: none
                options: [caret make object! [
                    type: 'rich-text
                    offset: (0, 0)
                    size: 840x655
                    text: none
                    image: none
                    color: 22.22.22
                    menu: none
                    data: none
                    enabled?: true
                    visible?: true
                    selected: none
                    flags: [scrollable all-over]
                    options: [cursor: I-beam]
                    parent: make object! [
                        type: 'window
                        offset: (559.2, 339.2)
                        size: 839x654
                        text: "Red Console"
                        image: none
                        color: none
                        menu: none
                        data: none
                        enabled?: true
                        visible?: false
                        selected: make object! [...]
                        flags: [resize]
                        options: none
                        parent: make object! [
                            type: 'screen
                            offset: 0x0
                            size: 2048x1152
                            text: none
                            image: none
                            color: none
                            menu: none
                            data: 1.25
                            enabled?: true
                            visible?: true
                            selected: none
                            flags: none
                            options: none
                            parent: none
                            pane: []
                            state: [handle! 0 none [1]]
                            rate: none
                            edge: none
                            para: none
                            font: none
                            actors: none
                            extra: none
                            draw: none
                        ]
                        pane: [make object! [...] make object! [...] make object! [
                            type: 'panel
                            offset: (0, 0)
                            size: 150x200
                            text: none
                            image: none
                            color: 0.0.128
                            menu: none
                            data: none
                            enabled?: true
                            visible?: false
                            selected: none
                            flags: none
                            options: none
                            parent: make object! [...]
                            pane: none
                            state: [handle! 0 none false]
                            rate: none
                            edge: none
                            para: none
                            font: make object! [
                                name: "Consolas"
                                size: 11
                                style: none
                                angle: 0
                                color: 255.255.255
                                anti-alias?: false
                                shadow: none
                                state: [handle! none none]
                                parent: [make object! [
                                    type: 'rich-text
                                    offset: none
                                    size: 820x655
                                    text: "XXXXXXXXXX"
                                    image: none
                                    color: none
                                    menu: none
                                    data: []
                                    enabled?: true
                                    visible?: true
                                    selected: none
                                    flags: none
                                    options: none
                                    parent: none
                                    pane: none
                                    state: none
                                    rate: none
                                    edge: none
                                    para: none
                                    font: make object! [
                                        name: "Consolas"
                                        size: 11
                                        style: none
                                        angle: 0
                                        color: 222.222.222
                                        anti-alias?: false
                                        shadow: none
                                        state: [handle! none none]
                                        parent: [...]
                                    ]
                                    actors: none
                                    extra: none
                                    draw: none
                                    tabs: 32.4
                                    line-spacing: 17
                                    handles: [handle! handle! "XXXXXXXXXX" true]
                                ]]
                            ]
                            actors: make object! [
                                on-key-down: func [face [object!] event [event!]][
                                    probe event/key
                                ]
                            ]
                            extra: none
                            draw: none
                        ]]
                        state: [handle! 0 none false]
                        rate: none
                        edge: none
                        para: none
                        font: none
                        actors: make object! [
                            on-menu: func [face [object!] event [event!] /local ft f][
                                switch event/picked [
                                    about-msg [display-about]
                                    shortcuts [show-shortcuts]
                                    quit [self/on-close face event]
                                    run-file [if f: request-file [terminal/run-file f]]
                                    choose-font [
                                        if ft: request-font/font/mono font [
                                            font: ft
                                            console/font: font
                                            terminal/zoom font
                                        ]
                                    ]
                                    settings [show-cfg-dialog]
                                ]
                            ]
                            on-close: func [face [object!] event [event!]][
                                system/view/platform/exit-event-loop
                                foreach screen system/view/screens [clear head screen/pane]
                                quit
                            ]
                            on-resizing: func [face [object!] event [event!]
                            /local new-sz][
                                new-sz: to-pair event/offset + 1x1
                                console/size: new-sz
                                terminal/resize new-sz
                                terminal/adjust-console-size new-sz
                                unless system/view/auto-sync? [show face]
                            ]
                            on-resize: func [face [object!] event [event!]
                            /local new-sz][
                                new-sz: to-pair event/offset + 1x1
                                console/size: new-sz
                                terminal/resize new-sz
                                terminal/adjust-console-size new-sz
                                unless system/view/auto-sync? [show face]
                            ]
                            on-focus: func [face [object!] event [event!]][
                                focused?: yes
                                caret/color: caret-clr
                                unless caret/enabled? [caret/enabled?: yes]
                                caret/rate: caret-rate
                                terminal/refresh/force
                            ]
                            on-unfocus: func [face [object!] event [event!]][
                                focused?: no
                                if caret/enabled? [caret/enabled?: no]
                                caret/rate: none
                            ]
                            on-key-down: func [face [object!] event [event!]][
                                if event/key = 'F12 [
                                    cfg/menu-bar?: to-word none? face/menu
                                    toggle-menu-bar
                                ]
                            ]
                        ]
                        extra: none
                        draw: none
                    ]
                    pane: none
                    state: [handle! 0 none false]
                    rate: 10
                    edge: none
                    para: none
                    font: make object! [
                        name: "Consolas"
                        size: 11
                        style: none
                        angle: 0
                        color: 222.222.222
                        anti-alias?: false
                        shadow: none
                        state: [handle! none none]
                        parent: []
                    ]
                    actors: make object! [
                        on-time: func [face [object!] event [event!]][
                            if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                            terminal/on-time
                            'done
                        ]
                        on-drawing: func [face [object!] event [event!]][
                            terminal/paint
                        ]
                        on-scroll: func [face [object!] event [event!]][
                            terminal/scroll event
                        ]
                        on-wheel: func [face [object!] event [event!]][
                            either event/ctrl? [
                                terminal/zoom event
                            ] [
                                terminal/scroll event
                            ]
                        ]
                        on-key: func [face [object!] event [event!]][
                            terminal/press-key event
                        ]
                        on-key-down: func [face [object!] event [event!]][
                            if all [1 = length? event/flags find event/flags 'alt] [
                                switch event/key [
                                    #"A" [terminal/select-all]
                                    #"O" [show-cfg-dialog]
                                ]
                            ]
                        ]
                        on-ime: func [face [object!] event [event!]][
                            terminal/process-ime-input event
                        ]
                        on-down: func [face [object!] event [event!]][
                            terminal/mouse-down event
                        ]
                        on-up: func [face [object!] event [event!]][
                            terminal/mouse-up event
                        ]
                        on-alt-down: func [face [object!] event [event!]][
                            if cfg/mouse-paste? = 'true [
                                either terminal/text-selected? [
                                    terminal/copy-selection
                                    clear terminal/selects
                                    system/view/platform/redraw face
                                ] [
                                    terminal/paste
                                ]
                            ]
                        ]
                        on-over: func [face [object!] event [event!]][
                            terminal/mouse-move to-pair event/offset
                        ]
                        on-menu: func [face [object!] event [event!]][
                            switch event/picked [
                                copy [terminal/copy-selection]
                                paste [terminal/paste]
                                select-all [terminal/select-all]
                            ]
                            'done
                        ]
                    ]
                    extra: none
                    draw: none
                    tabs: none
                    line-spacing: 'default
                    handles: none
                    init: func [/local box][
                        terminal/windows: get in get-current-screen 'pane
                        box: terminal/box
                        box/data: make block! 200
                        scroller: get-scroller self 'horizontal
                        scroller/visible?: no
                        scroller: get-scroller self 'vertical
                        scroller/position: 1
                        scroller/max-size: 2
                    ]
                ] cursor: I-beam accelerated: yes]
                parent: make object! [
                    type: 'window
                    offset: (559.2, 339.2)
                    size: 839x654
                    text: "Red Console"
                    image: none
                    color: none
                    menu: none
                    data: none
                    enabled?: true
                    visible?: false
                    selected: make object! [
                        type: 'rich-text
                        offset: (0, 0)
                        size: 840x655
                        text: none
                        image: none
                        color: 22.22.22
                        menu: none
                        data: none
                        enabled?: true
                        visible?: true
                        selected: none
                        flags: [scrollable all-over]
                        options: [cursor: I-beam]
                        parent: make object! [...]
                        pane: none
                        state: [handle! 0 none false]
                        rate: 10
                        edge: none
                        para: none
                        font: make object! [
                            name: "Consolas"
                            size: 11
                            style: none
                            angle: 0
                            color: 222.222.222
                            anti-alias?: false
                            shadow: none
                            state: [handle! none none]
                            parent: []
                        ]
                        actors: make object! [
                            on-time: func [face [object!] event [event!]][
                                if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                                terminal/on-time
                                'done
                            ]
                            on-drawing: func [face [object!] event [event!]][
                                terminal/paint
                            ]
                            on-scroll: func [face [object!] event [event!]][
                                terminal/scroll event
                            ]
                            on-wheel: func [face [object!] event [event!]][
                                either event/ctrl? [
                                    terminal/zoom event
                                ] [
                                    terminal/scroll event
                                ]
                            ]
                            on-key: func [face [object!] event [event!]][
                                terminal/press-key event
                            ]
                            on-key-down: func [face [object!] event [event!]][
                                if all [1 = length? event/flags find event/flags 'alt] [
                                    switch event/key [
                                        #"A" [terminal/select-all]
                                        #"O" [show-cfg-dialog]
                                    ]
                                ]
                            ]
                            on-ime: func [face [object!] event [event!]][
                                terminal/process-ime-input event
                            ]
                            on-down: func [face [object!] event [event!]][
                                terminal/mouse-down event
                            ]
                            on-up: func [face [object!] event [event!]][
                                terminal/mouse-up event
                            ]
                            on-alt-down: func [face [object!] event [event!]][
                                if cfg/mouse-paste? = 'true [
                                    either terminal/text-selected? [
                                        terminal/copy-selection
                                        clear terminal/selects
                                        system/view/platform/redraw face
                                    ] [
                                        terminal/paste
                                    ]
                                ]
                            ]
                            on-over: func [face [object!] event [event!]][
                                terminal/mouse-move to-pair event/offset
                            ]
                            on-menu: func [face [object!] event [event!]][
                                switch event/picked [
                                    copy [terminal/copy-selection]
                                    paste [terminal/paste]
                                    select-all [terminal/select-all]
                                ]
                                'done
                            ]
                        ]
                        extra: none
                        draw: none
                        tabs: none
                        line-spacing: 'default
                        handles: none
                        init: func [/local box][
                            terminal/windows: get in get-current-screen 'pane
                            box: terminal/box
                            box/data: make block! 200
                            scroller: get-scroller self 'horizontal
                            scroller/visible?: no
                            scroller: get-scroller self 'vertical
                            scroller/position: 1
                            scroller/max-size: 2
                        ]
                    ]
                    flags: [resize]
                    options: none
                    parent: make object! [
                        type: 'screen
                        offset: 0x0
                        size: 2048x1152
                        text: none
                        image: none
                        color: none
                        menu: none
                        data: 1.25
                        enabled?: true
                        visible?: true
                        selected: none
                        flags: none
                        options: none
                        parent: none
                        pane: []
                        state: [handle! 0 none [1]]
                        rate: none
                        edge: none
                        para: none
                        font: none
                        actors: none
                        extra: none
                        draw: none
                    ]
                    pane: [make object! [
                        type: 'rich-text
                        offset: (0, 0)
                        size: 840x655
                        text: none
                        image: none
                        color: 22.22.22
                        menu: none
                        data: none
                        enabled?: true
                        visible?: true
                        selected: none
                        flags: [scrollable all-over]
                        options: [cursor: I-beam]
                        parent: make object! [...]
                        pane: none
                        state: [handle! 0 none false]
                        rate: 10
                        edge: none
                        para: none
                        font: make object! [
                            name: "Consolas"
                            size: 11
                            style: none
                            angle: 0
                            color: 222.222.222
                            anti-alias?: false
                            shadow: none
                            state: [handle! none none]
                            parent: []
                        ]
                        actors: make object! [
                            on-time: func [face [object!] event [event!]][
                                if all [caret/enabled? none? caret/rate] [caret/rate: caret-rate]
                                terminal/on-time
                                'done
                            ]
                            on-drawing: func [face [object!] event [event!]][
                                terminal/paint
                            ]
                            on-scroll: func [face [object!] event [event!]][
                                terminal/scroll event
                            ]
                            on-wheel: func [face [object!] event [event!]][
                                either event/ctrl? [
                                    terminal/zoom event
                                ] [
                                    terminal/scroll event
                                ]
                            ]
                            on-key: func [face [object!] event [event!]][
                                terminal/press-key event
                            ]
                            on-key-down: func [face [object!] event [event!]][
                                if all [1 = length? event/flags find event/flags 'alt] [
                                    switch event/key [
                                        #"A" [terminal/select-all]
                                        #"O" [show-cfg-dialog]
                                    ]
                                ]
                            ]
                            on-ime: func [face [object!] event [event!]][
                                terminal/process-ime-input event
                            ]
                            on-down: func [face [object!] event [event!]][
                                terminal/mouse-down event
                            ]
                            on-up: func [face [object!] event [event!]][
                                terminal/mouse-up event
                            ]
                            on-alt-down: func [face [object!] event [event!]][
                                if cfg/mouse-paste? = 'true [
                                    either terminal/text-selected? [
                                        terminal/copy-selection
                                        clear terminal/selects
                                        system/view/platform/redraw face
                                    ] [
                                        terminal/paste
                                    ]
                                ]
                            ]
                            on-over: func [face [object!] event [event!]][
                                terminal/mouse-move to-pair event/offset
                            ]
                            on-menu: func [face [object!] event [event!]][
                                switch event/picked [
                                    copy [terminal/copy-selection]
                                    paste [terminal/paste]
                                    select-all [terminal/select-all]
                                ]
                                'done
                            ]
                        ]
                        extra: none
                        draw: none
                        tabs: none
                        line-spacing: 'default
                        handles: none
                        init: func [/local box][
                            terminal/windows: get in get-current-screen 'pane
                            box: terminal/box
                            box/data: make block! 200
                            scroller: get-scroller self 'horizontal
                            scroller/visible?: no
                            scroller: get-scroller self 'vertical
                            scroller/position: 1
                            scroller/max-size: 2
                        ]
                    ] make object! [...] make object! [
                        type: 'panel
                        offset: (0, 0)
                        size: 150x200
                        text: none
                        image: none
                        color: 0.0.128
                        menu: none
                        data: none
                        enabled?: true
                        visible?: false
                        selected: none
                        flags: none
                        options: none
                        parent: make object! [...]
                        pane: none
                        state: [handle! 0 none false]
                        rate: none
                        edge: none
                        para: none
                        font: make object! [
                            name: "Consolas"
                            size: 11
                            style: none
                            angle: 0
                            color: 255.255.255
                            anti-alias?: false
                            shadow: none
                            state: [handle! none none]
                            parent: [make object! [
                                type: 'rich-text
                                offset: none
                                size: 820x655
                                text: "XXXXXXXXXX"
                                image: none
                                color: none
                                menu: none
                                data: []
                                enabled?: true
                                visible?: true
                                selected: none
                                flags: none
                                options: none
                                parent: none
                                pane: none
                                state: none
                                rate: none
                                edge: none
                                para: none
                                font: make object! [
                                    name: "Consolas"
                                    size: 11
                                    style: none
                                    angle: 0
                                    color: 222.222.222
                                    anti-alias?: false
                                    shadow: none
                                    state: [handle! none none]
                                    parent: [...]
                                ]
                                actors: none
                                extra: none
                                draw: none
                                tabs: 32.4
                                line-spacing: 17
                                handles: [handle! handle! "XXXXXXXXXX" true]
                            ]]
                        ]
                        actors: make object! [
                            on-key-down: func [face [object!] event [event!]][
                                probe event/key
                            ]
                        ]
                        extra: none
                        draw: none
                    ]]
                    state: [handle! 0 none false]
                    rate: none
                    edge: none
                    para: none
                    font: none
                    actors: make object! [
                        on-menu: func [face [object!] event [event!] /local ft f][
                            switch event/picked [
                                about-msg [display-about]
                                shortcuts [show-shortcuts]
                                quit [self/on-close face event]
                                run-file [if f: request-file [terminal/run-file f]]
                                choose-font [
                                    if ft: request-font/font/mono font [
                                        font: ft
                                        console/font: font
                                        terminal/zoom font
                                    ]
                                ]
                                settings [show-cfg-dialog]
                            ]
                        ]
                        on-close: func [face [object!] event [event!]][
                            system/view/platform/exit-event-loop
                            foreach screen system/view/screens [clear head screen/pane]
                            quit
                        ]
                        on-resizing: func [face [object!] event [event!]
                        /local new-sz][
                            new-sz: to-pair event/offset + 1x1
                            console/size: new-sz
                            terminal/resize new-sz
                            terminal/adjust-console-size new-sz
                            unless system/view/auto-sync? [show face]
                        ]
                        on-resize: func [face [object!] event [event!]
                        /local new-sz][
                            new-sz: to-pair event/offset + 1x1
                            console/size: new-sz
                            terminal/resize new-sz
                            terminal/adjust-console-size new-sz
                            unless system/view/auto-sync? [show face]
                        ]
                        on-focus: func [face [object!] event [event!]][
                            focused?: yes
                            caret/color: caret-clr
                            unless caret/enabled? [caret/enabled?: yes]
                            caret/rate: caret-rate
                            terminal/refresh/force
                        ]
                        on-unfocus: func [face [object!] event [event!]][
                            focused?: no
                            if caret/enabled? [caret/enabled?: no]
                            caret/rate: none
                        ]
                        on-key-down: func [face [object!] event [event!]][
                            if event/key = 'F12 [
                                cfg/menu-bar?: to-word none? face/menu
                                toggle-menu-bar
                            ]
                        ]
                    ]
                    extra: none
                    draw: none
                ]
                pane: none
                state: [handle! 0 none false]
                rate: 0:00:00.53
                edge: none
                para: none
                font: none
                actors: make object! [
                    on-time: func [face [object!] event [event!]][
                        face/color: either face/color = caret-clr [255.255.255.254] [caret-clr]
                        'done
                    ]
                ]
                extra: none
                draw: none
            ]]
            add-gui-print: routine [][
                gui-console-buffer: ALLOC_TAIL (root)
                gui-console-buffer/header: TYPE_UNSET
                dyn-print/add as int-ptr! :red-print-gui #either debug? = yes [null] [
                    as int-ptr! :rs-print-gui
                ]
            ]
            launch: func [/local svs rate][
                rate: get-caret-blink-time
                caret-rate: case [
                    rate > 0 [to-time rate / 1000.0]
                    rate < 0 [none]
                    rate = 0 [2]
                ]
                setup-faces
                win/visible?: no
                load-cfg
                view/flags/no-wait win [resize]
                console/init
                apply-cfg
                system/view/auto-sync?: yes
                win/selected: console
                if empty? system/script/args [win/visible?: yes]
                svs: get-current-screen
                svs/pane: next svs/pane
                add-gui-print
                console/rate: 10
                system/console/launch
            ]
        ]
        terminal: unset
        win: unset
        caret: unset
        forced?: unset
        diff?: unset
        faces: unset
        modal?: unset
        debug-info?: func ["Internal use only" face [object!] return: [logic!]][
            all [
                system/view/debug?
                not all [
                    value? 'gui-console-ctx
                    any [
                        same? face gui-console-ctx/terminal/box
                        same? face gui-console-ctx/console
                        same? face gui-console-ctx/win
                        same? face gui-console-ctx/caret
                    ]
                ]
            ]
        ]
        auto-sync?: unset
        extra: unset
        on-change-facet: unset
        find-flag?: routine [
            "Checks a flag in a face object"
            facet [any-type!]
            flag [word!]
        ][
            switch TYPE_OF (facet) [
                TYPE_WORD [
                    word: as red-word! facet
                    found?: EQUAL_WORDS? (flag word)
                ]
                TYPE_BLOCK [
                    found?: no
                    value: block/rs-head as red-block! facet
                    tail: block/rs-tail as red-block! facet
                    while [all [not found? value < tail]] [
                        type: TYPE_OF (value)
                        if any [type = TYPE_WORD type = TYPE_LIT_WORD] [
                            word: as red-word! value
                            found?: EQUAL_WORDS? (flag word)
                        ]
                        value: value + 1
                    ]
                ]
                default [found?: no]
            ]
            bool: as red-logic! stack/arguments
            bool/header: TYPE_LOGIC
            bool/value: found?
        ]
        modal: unset
        destroy-view: unset
        enabled?: unset
        tab-panel: unset
        panel: unset
        face-type: unset
        visible?: unset
        bad-window: unset
        text-list: unset
        drop-list: unset
        drop-down: unset
        draw: func [
            "Draws scalable vector graphics to an image"
            image [image! pair!] "Image or size for an image"
            cmd [block!] "Draw commands"
            /transparent "Make a transparent image, if pair! spec is used"
            return: [image!]
        ][
            if pair? image [
                image: make image! either transparent [
                    reduce [image system/words/transparent]
                ] [
                    image
                ]
            ]
            system/view/platform/draw-image image cmd
            image
        ]
        selected: unset
        same-pane?: unset
        new-type: unset
        handle?: func ["Returns true if the value is this type" value [any-type!]][
            handle! = type? :value
        ]
        link-tabs-to-parent: func [
            "Internal Use Only"
            face [object!]
            /init "Force /show of first tab"
            /local faces visible?
        ][
            if faces: face/pane [
                visible?: face/visible?
                forall faces [
                    faces/1/visible?: make logic! all [visible? face/selected = index? faces]
                    faces/1/parent: face
                    if init [show/with faces/1 face]
                ]
            ]
        ]
        link-sub-to-parent: func ["Internal Use Only" face [object!] type [word!] old new
        /local parent][
            if object? new [
                unless all [parent: in new 'parent block? get parent] [
                    new/parent: make block! 4
                ]
                new/parent: insert tail new/parent face
                all [
                    object? old
                    parent: in old 'parent
                    block? parent: get parent
                    remove find/same head parent face
                ]
            ]
        ]
        sync: unset
        area: unset
        image?: func ["Returns true if the value is this type" value [any-type!]][image! = type? :value]
        detach-image: unset
        update-view: unset
        on-face-deep-change*: func ["Internal use only" owner word target action new index part state forced?
        /local w diff? faces face modal? screen pane][
            if debug-info? owner [
                print [
                    "-- on-deep-change event --" lf
                    tab "owner      :" owner/type lf
                    tab "action     :" action lf
                    tab "word       :" word lf
                    tab "target type:" mold type? target lf
                    tab "new value  :" mold type? new lf
                    tab "index      :" index lf
                    tab "part       :" part lf
                    tab "auto-sync? :" system/view/auto-sync? lf
                    tab "forced?    :" forced?
                ]
            ]
            if all [state word <> 'state word <> 'extra] [
                either any [
                    forced?
                    system/view/auto-sync?
                    owner/type = 'screen
                ] [
                    unless w: in owner word [exit]
                    state/2: state/2 or (1 << ((index? w) - 1))
                    either word = 'pane [
                        case [
                            action = 'moved [
                                diff?: yes
                                faces: skip head target index
                                loop part [
                                    either same? faces/1/parent owner [diff?: no] [faces/1/parent: owner]
                                    faces: next faces
                                ]
                                if diff? [system/view/platform/on-change-facet owner word target action new index part]
                            ]
                            find [remove clear take change] action [
                                either owner/type = 'screen [
                                    loop part [
                                        face: target/1
                                        if face/type = 'window [
                                            stop-reactor/deep face
                                            modal?: find-flag? face/flags 'modal
                                            system/view/platform/destroy-view face face/state/4
                                            if modal? [
                                                either 1 = length? head target [
                                                    foreach screen system/view/screens [
                                                        unless empty? head screen/pane [
                                                            face: last head screen/pane
                                                            face/enabled?: yes
                                                            unless system/view/auto-sync? [show face]
                                                            break
                                                        ]
                                                    ]
                                                ] [
                                                    pane: target
                                                    until [
                                                        pane: back pane
                                                        pane/1/enabled?: yes
                                                        unless system/view/auto-sync? [show pane/1]
                                                        any [head? pane find-flag? pane/1/flags 'modal]
                                                    ]
                                                ]
                                            ]
                                        ]
                                        target: next target
                                    ]
                                ] [
                                    loop part [
                                        face: target/1
                                        face/parent: none
                                        stop-reactor/deep face
                                        system/view/platform/destroy-view face no
                                        target: next target
                                    ]
                                ]
                            ]
                            'else [
                                if owner/type <> 'screen [
                                    if all [
                                        find [tab-panel window panel] owner/type
                                        find [inserted appended poked changed moved] action
                                    ] [
                                        faces: skip head target index
                                        loop part [
                                            face: faces/1
                                            unless all [
                                                object? face
                                                in face 'type
                                                word? face/type
                                            ] [
                                                cause-error 'script 'face-type reduce [face]
                                            ]
                                            if owner/type = 'tab-panel [
                                                face/visible?: no
                                                face/parent: owner
                                            ]
                                            if all [owner/type = 'window face/type = 'window] [
                                                cause-error 'script 'bad-window []
                                            ]
                                            show/with face owner
                                            faces: next faces
                                        ]
                                    ]
                                    system/view/platform/on-change-facet owner word target action new index part
                                ]
                            ]
                        ]
                    ] [
                        if owner/type <> 'screen [
                            if all [find [field text] owner/type word = 'text] [
                                set-quiet in owner 'data any [
                                    all [not empty? owner/text attempt/safer [load owner/text]]
                                    all [owner/options owner/options/default]
                                ]
                            ]
                            either all [word = 'data find [text-list drop-list drop-down] owner/type] [
                                if string? target [
                                    target: head target
                                    index: (index? find/same owner/data target) - 1
                                    part: 1
                                ]
                                if any [
                                    string? target
                                    all [
                                        block? target
                                        same? (head owner/data) (head target)
                                        not find [insert append cleared removed taken] action
                                    ]
                                ] [
                                    system/view/platform/on-change-facet owner word target action new index part
                                ]
                            ] [
                                system/view/platform/on-change-facet owner word target action new index part
                            ]
                        ]
                    ]
                    system/reactivity/check/only owner word
                ] [
                    if any [
                        none? state/3
                        find [data options pane flags] word
                        not find/skip next state/3 word 8
                    ] [
                        unless find [cleared removed taken] action [
                            if all [
                                find [clear remove take] action
                                word <> 'draw
                            ] [
                                index: 0
                                target: copy/part target part
                            ]
                            reduce/into
                            [owner word target action new index part state]
                            tail any [state/3 state/3: make block! 28]
                        ]
                    ]
                ]
            ]
        ]
        update-font: unset
        update-font-faces: func ["Internal Use Only" parent [block! none!]
        /local f][
            if block? parent [
                foreach f head parent [
                    if f/state [
                        system/reactivity/check/only f 'font
                        f/state/2: f/state/2 or 524288
                        if block? f/draw [
                            f/state/2: f/state/2 or 4194304
                        ]
                        show f
                    ]
                ]
            ]
        ]
        update-para: unset
        update-scroller: unset
        detect: unset
        on-detect: unset
        on-time: unset
        drawing: unset
        on-drawing: unset
        scroll: unset
        on-scroll: unset
        on-down: unset
        up: unset
        on-up: unset
        mid-down: unset
        on-mid-down: unset
        mid-up: unset
        on-mid-up: unset
        alt-down: unset
        on-alt-down: unset
        alt-up: unset
        on-alt-up: unset
        aux-down: unset
        on-aux-down: unset
        aux-up: unset
        on-aux-up: unset
        wheel: unset
        on-wheel: unset
        drag-start: unset
        on-drag-start: unset
        drag: unset
        on-drag: unset
        drop: unset
        on-drop: unset
        click: unset
        on-click: unset
        dbl-click: unset
        on-dbl-click: unset
        over: unset
        on-over: unset
        on-key: unset
        key-down: unset
        on-key-down: unset
        key-up: unset
        on-key-up: unset
        ime: unset
        on-ime: unset
        focus: unset
        on-focus: unset
        unfocus: unset
        on-unfocus: unset
        on-select: unset
        on-change: unset
        on-enter: unset
        menu: unset
        on-menu: unset
        on-close: unset
        on-move: unset
        resize: unset
        on-resize: unset
        moving: unset
        on-moving: unset
        resizing: unset
        on-resizing: unset
        zoom: unset
        on-zoom: unset
        pan: unset
        on-pan: unset
        rotate: unset
        on-rotate: unset
        two-tap: unset
        on-two-tap: unset
        press-tap: unset
        on-press-tap: unset
        on-create: unset
        on-created: unset
        stop: unset
        done: unset
        do-actor: func ["Internal Use Only" face [object!] event [event! none!] type [word!] /local result
        act name][
            if all [
                object? face/actors
                act: in face/actors name: select system/view/evt-names type
                act: get act
            ] [
                if debug-info? face [print ["calling actor:" name]]
                set/any 'result do-safe [act face event]
            ]
            :result
        ]
        result2: unset
        do-safe: func ["Internal Use Only" code [block!] /local result error][
            unset 'result
            if error? error: try/all [
                if 'halt-request = catch/name [
                    set/any 'result do code
                    none
                ] 'console [stop-events]
                none
            ] [print :error]
            :result
        ]
        event?: routine ["Returns true if the value is this type" value [any-type!] return: [logic!]][TYPE_OF (value) = TYPE_EVENT]
        wins: unset
        toggle-GPU: unset
        set-dark-mode: unset
        CLASS_NULL: unset
        GUI-engine: unset
        gui: unset
        OS-fetch-all-screens: unset
        OS-get-current-screen: unset
        closed?: unset
        svs: unset
        to-pair: func ["Convert to pair! value" value][to pair! :value]
        pair: unset
        get-values: unset
        TYPE_STRING: unset
        red-string!: unset
        TYPE_NONE: unset
        FACE_OBJ_TEXT: unset
        datatype: unset
        point2D: unset
        F32_0: unset
        get-text-size: unset
        OS-update-facet: unset
        get-text-alt: unset
        OS-destroy-view: unset
        ownership: unset
        unbind: unset
        OS-update-view: unset
        OS-refresh-window: unset
        face-handle?: unset
        OS-redraw: unset
        OS-show-window: unset
        OS-make-view: unset
        CLASS_WINDOW: unset
        cmds: unset
        IMAGE_WIDTH: unset
        IMAGE_HEIGHT: unset
        OS-do-draw: unset
        _poke: unset
        get-flags: unset
        FACE_OBJ_FLAGS: unset
        OS-draw-face: unset
        no-wait?: unset
        do-events: func [
            {Launch the event loop, blocks until all windows are closed}
            /no-wait "Process an event in the queue and returns at once"
            return: [logic! word!] "Returned value from last event"
            /local result screen win
        ][
            foreach screen system/view/screens [
                if all [win: last head screen/pane win/state] [
                    unless win/state/4 [win/state/4: not no-wait]
                    set/any 'result system/view/platform/do-event-loop no-wait
                    break
                ]
            ]
            :result
        ]
        PostQuitMessage: unset
        post-quit-msg: unset
        test: unset
        GTK: unset
        mono?: unset
        OS-request-font: unset
        red-object!: unset
        title: unset
        filter: unset
        save?: unset
        multi?: unset
        OS-request-file: unset
        OS-request-dir: unset
        arg0: unset
        layout?: unset
        FACE_OBJ_TYPE: unset
        sym: unset
        symbol: unset
        resolve: unset
        txt: unset
        OS-text-box-metrics: unset
        FACE_OBJ_EXT3: unset
        OS-text-box-layout: unset
        scroller: unset
        dark?: unset
        get-face-handle: unset
        DX-create-dev: unset
        colors: unset
        fonts: unset
        margins: unset
        button: unset
        group-box: unset
        calendar: unset
        paddings: unset
        radio: unset
        fixed-heights: unset
        def-heights: unset
        slider: unset
        white: 255.255.255
        fixed: unset
        sans-serif: unset
        serif: unset
        xp: unset
        older: unset
        font-fixed: "Consolas"
        font-sans-serif: "Segoe UI"
        font-serif: "Times New Roman"
        Author: unset
        Tabs: unset
        Rights: unset
        License: unset
        transparent: 0.0.0.255
        pair?: func ["Returns true if the value is this type" value [any-type!]][pair! = type? :value]
        draw-image: unset
        default-actor: unset
        template: unset
        color: unset
        focusable: unset
        line-spacing: unset
        progress: unset
        steps: unset
        camera: unset
        ratio: unset
        h1: unset
        font!: make object! [
            name: none
            size: none
            style: none
            angle: 0
            color: none
            anti-alias?: false
            shadow: none
            state: none
            parent: none
        ]
        h2: unset
        h3: unset
        h4: unset
        h5: unset
        root: unset
        foreach-face: func [
            {Evaluates body for each face in a face tree matching the condition}
            face [object!] "Root face of the face tree"
            body [block! function!] {Body block (`face` object) or function `func [face [object!]]`}
            /with "Filter faces according to a condition"
            spec [block! none!] "Condition applied to face object"
            /post {Evaluates body for current face after processing its children}
            /sub post? "Do not rebind body and spec, internal use only"
            /local exec
        ][
            unless block? face/pane [exit]
            unless sub [
                all [spec bind spec 'face]
                if block? :body [bind body 'face]
            ]
            if post [post?: yes]
            exec: [either block? :body [do body] [body face]]
            foreach face face/pane [
                unless post? [either spec [all [do spec try exec]] [try exec]]
                if block? face/pane [foreach-face/with/sub face :body spec post?]
                if post? [either spec [all [do spec try exec]] [try exec]]
            ]
        ]
        gp: unset
        pos-x: unset
        last-but: unset
        pos-y: unset
        color-backgrounds: unset
        color-tabpanel-children: unset
        OK-Cancel: unset
        adjust-buttons: unset
        capitalize: unset
        Cancel-OK: unset
        silent?: unset
        silent: unset
        silenced: unset
        vid-invalid-syntax: unset
        reactors: unset
        later?: unset
        float?: func ["Returns true if the value is this type" value [any-type!]][float! = type? :value]
        min-sz: unset
        misc: unset
        CR: #"^M"
        align: unset
        max-sz: unset
        edge?: unset
        top-left?: unset
        svmm: unset
        mar: unset
        across: unset
        middle: unset
        below: unset
        center: unset
        at-offset: unset
        to-point2D: func ["Convert to point2D! value" value][to point2D! :value]
        tp-size: unset
        tmpl: unset
        issue?: func ["Returns true if the value is this type" value [any-type!]][issue! = type? :value]
        opts: unset
        para!: make object! [
            origin: none
            padding: none
            scroll: none
            align: none
            v-align: none
            wrap?: false
            parent: none
        ]
        style: unset
        alter: func [
            {If a value is not found in a series, append it; otherwise, remove it. Returns true if added}
            series [series!]
            value
        ][
            not none? unless remove find series :value [append series :value]
        ]
        proto: unset
        bounds: unset
        expected: unset
        datatype?: func ["Returns true if the value is this type" value [any-type!]][datatype! = type? :value]
        css: unset
        styling?: unset
        no-skip: unset
        tight: unset
        opt?: unset
        divides: unset
        calc-y?: unset
        do-with: unset
        scaling: unset
        obj-spec!: unset
        sel-spec!: unset
        rate!: unset
        color!: unset
        cursor!: unset
        drag-on: unset
        hint: unset
        cursor: unset
        tight?: unset
        user-size?: unset
        oi: unset
        face-font: unset
        v-align: unset
        wrap: unset
        wrap?: unset
        no-wrap: unset
        font-name: unset
        font-size: unset
        font-color: unset
        loose: unset
        all-over: unset
        set-flag: func [
            {Sets (or clears) a flag in a face object; Returns the /flags facet value}
            face [object!] "Face where flag to set/clear"
            flag [any-type!] "Flag to set/clear"
            /clear "Clears the flag instead of setting it"
            /toggle "Set it if unset, clears it otherwise"
            /local flags pos
        ][
            flags: face/flags
            case [
                clear [
                    either block? flags [if pos: find flags flag [remove pos]] [face/flags: none]
                ]
                toggle [
                    either block? flags [
                        either pos: find flags flag [remove pos] [append flags flag]
                    ] [
                        face/flags: either all [flags flags = flag] [none] [
                            either flags [reduce [flags flag]] [reduce [flag]]
                        ]
                    ]
                ]
                flags [
                    if word? flags [face/flags: flags: reduce [flags]]
                    either block? flags [append flags flag] [face/flags: flag]
                ]
                'else [face/flags: flag]
            ]
            flags
        ]
        password: unset
        tri-state: unset
        scrollable: unset
        disabled: unset
        rate: unset
        now?: unset
        no-border: unset
        VID: unset
        evt-names: unset
        size-x: unset
        layout: func [
            [no-trace]
            {Return a face with a pane built from a VID description}
            spec [block!] "Dialect block of styles, attributes, and layouts"
            /tight "Zero offset and origin"
            /options
            user-opts [block!] "Optional features in [name: value] format"
            /flags
            flgs [block! word!] "One or more window flags"
            /only "Returns only the pane block"
            /parent
            panel [object!]
            divides [integer! none!]
            /styles "Use an existing styles list"
            css [block!] "Styles list"
            /local axis anti
            background! list reactors local-styles pane-size direction align begin size max-sz current global? below? origin spacing top-left bound cursor opts opt-words re-align sz words reset focal-face svmp pad value anti2 at-offset later? name styling? style styled? st actors face h pos styled w blk vid-align prev mar divide? index dir pad2 image
        ][
            background!: make typeset! [image! file! url! tuple! word! issue!]
            list: make block! 4
            reactors: make block! 10
            local-styles: any [css make block! 2]
            pane-size: 0x0
            direction: 'across
            align: 'top
            begin: tail list
            size: none
            max-sz: 0
            current: 0
            global?: yes
            below?: no
            either tight [origin: spacing: 0x0] [
                origin: any [select self/styles @origin self/origin]
                spacing: any [select self/styles @spacing self/spacing]
            ]
            top-left: bound: cursor: origin
            opts: copy opts-proto
            if empty? opt-words: [] [append opt-words words-of opts]
            re-align: [
                if all [debug? begin not empty? begin] [
                    sz: max-sz * pick [1x0 0x1] direction = 'below
                    repend panel/draw [
                        'line any [begin/1/offset 1x1] cursor
                        'line (any [begin/1/offset 1x1]) + sz cursor + sz
                    ]
                ]
                align-faces begin direction align max-sz
                begin: tail list
                words: pick [[left center right] [top middle bottom]] below?
                align: any [
                    all [find words spec/2 first spec: next spec]
                    all [value = 'return align]
                    all [below? 'left]
                    'top
                ]
            ]
            reset: [
                bound: max bound cursor
                if zero? max-sz [
                    max-sz: spacing/:anti
                    cursor/:anti: cursor/:anti + max-sz
                ]
                do re-align
                cursor: as-pair origin/:axis spacing/:anti + max bound/:anti cursor/:anti + max-sz
                if direction = 'below [cursor: reverse cursor]
                max-sz: 0
            ]
            unless panel [
                focal-face: none
                panel: make face! copy system/view/VID/styles/window/template
            ]
            unless only [either block? panel/pane [list: panel/pane] [panel/pane: list]]
            any [
                all [
                    svmp: select system/view/metrics/paddings panel/type
                    bound: cursor: origin: origin + pad: as-pair svmp/1/x svmp/2/x
                ]
                pad: 0x0
            ]
            if debug? [append panel/draw: make block! 30 [pen red]]
            catch/name [
                while [all [global? not tail? spec]] [
                    switch/default spec/1 [
                        title [panel/text: fetch-argument string! spec]
                        size [panel/size: size: fetch-argument pos-size! spec]
                        backdrop [
                            value: pre-load fetch-argument background! spec
                            switch type?/word value [
                                tuple! [panel/color: value]
                                image! [panel/image: value]
                            ]
                        ]
                    ] [
                        either all [word? spec/1 find/skip next system/view/evt-names spec/1 2] [
                            make-actor panel spec/1 spec/2 spec spec: next spec
                        ] [
                            global?: no
                        ]
                    ]
                    if global? [spec: next spec]
                ]
                while [not tail? spec] [
                    value: spec/1
                    set [axis anti] pick [[x y] [y x]] direction = 'across
                    switch/default value [
                        below
                        across [
                            below?: value = 'below
                            do re-align
                            all [
                                direction <> value
                                anti2: pick [y x] value = 'across
                                cursor/:anti2 <> origin/:anti2
                                cursor/:anti2: cursor/:anti2 + spacing/:anti2
                            ]
                            direction: value
                            bound: max bound cursor
                            max-sz: 0
                        ]
                        space [spacing: fetch-argument pos-size! spec]
                        origin [do reset origin: bound: current: cursor: pad + top-left: fetch-argument pos-size! spec max-sz: 0]
                        at [at-offset: fetch-expr 'spec spec: back spec]
                        pad [cursor: cursor + fetch-argument pos-size! spec]
                        do [do-safe bind fetch-argument block! spec panel]
                        return [either divides [throw-error spec] [do reset]]
                        react [
                            if later?: spec/2 = 'later [spec: next spec]
                            repend reactors [none fetch-argument block! spec later?]
                        ]
                        style [
                            unless set-word? name: first spec: next spec [throw-error spec]
                            styling?: yes
                        ]
                    ] [
                        unless styling? [
                            name: none
                            if set-word? value [
                                name: value
                                value: first spec: next spec
                            ]
                        ]
                        unless style: any [
                            styled?: select local-styles value
                            select system/view/VID/styles value
                        ] [
                            throw-error spec
                        ]
                        st: style/template
                        if st/type = 'window [throw-error spec]
                        if actors: st/actors [st/actors: none]
                        face: make face! copy/deep st
                        if actors [face/actors: copy/deep st/actors: actors]
                        if all [name not styling?] [set name face]
                        if all [
                            h: select system/view/metrics/def-heights face/type
                            h > face/size/y
                        ] [face/size/y: h]
                        unless styling? [face/parent: panel]
                        spec: fetch-options/:tight face opts style spec local-styles reactors to-logic styling?
                        if all [style/init not styling?] [do bind style/init face]
                        either styling? [
                            if same? css local-styles [local-styles: copy css]
                            name: to word! form name
                            value: copy style
                            clean-style value/template: body-of face face/type
                            if opts/init [
                                either value/init [append value/init opts/init] [
                                    reduce/into [to-set-word 'init opts/init] tail value
                                ]
                            ]
                            either pos: find local-styles name [pos/2: value] [
                                reduce/into [name value] tail local-styles
                            ]
                            styled: make block! 4
                            foreach w opt-words [if get in opts w [append styled w]]
                            repend value [to-set-word 'styled styled]
                            styling?: off
                        ] [
                            blk: [style: _ vid-align: _ at-offset: none next: none prev: none]
                            blk/2: value
                            blk/4: align
                            add-option face new-line/all blk no
                            either at-offset [
                                face/options/at-offset: face/offset: at-offset
                                at-offset: none
                                all [
                                    mar: select system/view/metrics/margins face/type
                                    face/offset: face/offset - as-pair mar/1/x mar/2/x
                                ]
                            ] [
                                either all [
                                    divide?: all [divides divides <= length? list]
                                    zero? index: (length? list) // divides
                                ] [
                                    do reset
                                ] [
                                    if all [max-sz > 0 cursor/:axis <> origin/:axis] [
                                        cursor/:axis: cursor/:axis + spacing/:axis
                                    ]
                                ]
                                max-sz: max max-sz face/size/:anti
                                face/offset: cursor
                                if point2D? face/size [cursor: to-point2D cursor]
                                cursor/:axis: cursor/:axis + face/size/:axis
                                if all [divide? index > 0] [
                                    index: index + 1
                                    if point2D? list/:index/offset [face/offset: to-point2D face/offset]
                                    face/offset/:axis: list/:index/offset/:axis
                                ]
                            ]
                            unless any [face/color panel/type = 'tab-panel face/type = 'text] [
                                face/color: system/view/metrics/colors/(face/type)
                            ]
                            append list face
                            pane-size: max pane-size face/offset + face/size
                            if opts/now? [do-actor face none 'time]
                        ]
                        if h: select system/view/metrics/fixed-heights face/type [
                            dir: 'y
                            if all [
                                face/type = 'progress
                                face/size/y > face/size/x
                            ] [dir: 'x]
                            face/offset/:dir: face/offset/:dir + (face/size/:dir - h / 2)
                            face/size/:dir: h
                        ]
                    ]
                    spec: next spec
                ]
                do re-align
                process-reactors reactors
            ] 'silenced
            either only [list] [
                either size [panel/size: size] [
                    if pane-size <> 0x0 [
                        if svmp [
                            pad2: as-pair svmp/1/y svmp/2/y
                            origin: either top-left + pad = origin [top-left + pad2] [max top-left pad2]
                        ]
                        panel/size: pane-size + origin
                    ]
                ]
                if all [not size image: panel/image] [panel/size: max panel/size image/size]
                if options [set/some panel make object! user-opts]
                if flags [panel/flags: either panel/flags [unique union to-block panel/flags to-block flgs] [flgs]]
                if all [block? panel/actors panel/type = 'window] [panel/actors: context panel/actors]
                if panel/type = 'window [system/view/VID/GUI-rules/process panel]
                panel
            ]
        ]
        extract: func [
            {Extracts a value from a series at regular intervals}
            series [series!]
            width [integer!] "Size of each entry (the skip)"
            /index "Extract from an offset position"
            pos [integer!] "The position"
            /into {Provide an output series instead of creating a new one}
            output [series!] "Output series"
        ][
            width: max 1 width
            if pos [series: at series pos]
            unless into [output: make series (length? series) / width]
            while [not tail? series] [
                append/only output series/1
                series: skip series width
            ]
            output
        ]
        styled: unset
        rtd-layout: func [
            "Returns a rich-text face from a RTD source code"
            spec [block!] "RTD source code"
            /only "Returns only [text data] facets"
            /with "Populate an existing face object"
            face [object!] "Face object to populate"
            return: [object! block!]
        ][
            clear stack
            clear color-stk
            out: make block! 50
            text: make string! 100
            s-idx: 1
            unless parse spec rtd [cause-error 'script 'rtd-invalid-syntax reduce [pos]]
            close-colors
            optimize
            case [
                only [reduce [text out]]
                with [face/text: text face/data: out face]
                'else [face: make-face/spec 'rich-text reduce [text] face/data: out face]
            ]
        ]
        user-opts: unset
        flgs: unset
        styles: unset
        anti: unset
        background!: unset
        local-styles: unset
        pane-size: unset
        direction: unset
        begin: unset
        current: unset
        global?: unset
        below?: unset
        top-left: unset
        bound: unset
        opt-words: unset
        re-align: unset
        focal-face: unset
        svmp: unset
        anti2: unset
        styled?: unset
        st: unset
        vid-align: unset
        prev: unset
        divide?: unset
        pad2: unset
        to-logic: func ["Convert to logic! value" value][to logic! :value]
        to-set-word: func ["Convert to set-word! value" value][to set-word! :value]
        point2D?: func ["Returns true if the value is this type" value [any-type!]][point2D! = type? :value]
        to-block: func ["Convert to block! value" value][to block! :value]
        process: unset
        no-wait: unset
        do-event-loop: unset
        exit-event-loop: unset
        stop-events: func [
            "Stop the last opened event loop"
        ][
            system/view/platform/exit-event-loop
        ]
        act: unset
        force: unset
        show?: unset
        pending: unset
        new?: unset
        not-linked: unset
        null-handle: handle!
        make-view: unset
        face?: func [
            "Returns TRUE if the value is a face! object"
            value "Value to test"
            return: [logic!]
        ][
            to logic! all [
                object? :value
                any [
                    (class-of value) = class-of face!
                    all [
                        in value 'type
                        in value 'offset
                        in value 'size
                        in value 'parent
                        in value 'pane
                        in value 'state
                        in value 'para
                        in value 'font
                        in value 'actors
                    ]
                ]
            ]
        ]
        refresh-window: unset
        show-window: unset
        no-sync: unset
        sync?: unset
        not-window: unset
        center-face: func [
            "Center a face inside its parent"
            face [object!] "Face to center"
            /x "Center horizontally only"
            /y "Center vertically only"
            /with {Provide a reference face for centering instead of parent face}
            parent [object!] "Reference face"
            return: [object!] "Returns the centered face"
            /local pos
        ][
            unless parent [parent: face/parent]
            either parent [
                pos: parent/size - face/size / 2
                case [
                    x [face/offset/x: pos/x]
                    y [face/offset/x: pos/y]
                    'else [face/offset: pos]
                ]
                if face/type = 'window [face/offset: face/offset + parent/offset]
            ] [
                print "CENTER-FACE: face has no parent!"
            ]
            face
        ]
        xy: unset
        wh: unset
        svv: unset
        model: unset
        opts-proto: unset
        fetch-options: unset
        process-reactors: unset
        depth: unset
        dump-face: func [
            {Display debugging info about a face and its children}
            face [object!] "Face to analyze"
            /local depth f
        ][
            depth: ""
            print [
                depth "Type:" face/type "Style:" if face/options [face/options/style]
                "Offset:" face/offset "Size:" face/size "Color:" face/color
                "Text:" if face/text [mold/part face/text 20]
            ]
            append depth "    "
            if block? face/pane [foreach f face/pane [dump-face f]]
            remove/part depth 4
            face
        ]
        ok: unset
        scroller!: make object! [
            position: none
            page-size: none
            min-size: 1
            max-size: none
            visible?: true
            vertical?: true
            parent: none
        ]
        page: unset
        min-size: unset
        max-size: unset
        vertical?: unset
        vertical: unset
        checks: unset
        get-face-pane: func [
            "Returns the list of a container children or none"
            face [object!] "Face container"
            return: [block! none!]
        ][
            either face/type = 'tab-panel [select pick face/pane face/selected 'pane] [face/pane]
        ]
        get-focusable: func [
            "Returns the next focusable face from a face tree"
            faces [block!] "Position to start from in a face's pane"
            /back "Search backward"
            /local origin checks flags f pane p
        ][
            origin: faces
            checks: [
                f/visible?
                f/enabled?
                flags: f/flags
                any [
                    flags = 'focusable
                    all [block? flags find flags 'focusable]
                ]
            ]
            either back [
                unless empty? head faces [
                    while [not head? faces] [
                        f: first faces: skip faces -1
                        all [
                            block? pane: get-face-pane f
                            not empty? pane
                            return get-focusable/back tail pane
                        ]
                        if all checks [return f]
                    ]
                ]
            ] [
                while [not tail? faces] [
                    f: faces/1
                    if all checks [return f]
                    all [
                        block? pane: get-face-pane f
                        not empty? pane
                        return get-focusable pane
                    ]
                    faces: next faces
                ]
            ]
            p: select first head faces 'parent
            faces: find/same p/parent/pane p
            p: faces/1
            either p/type = 'window [
                if same? p/pane origin [return origin/1]
                get-focusable/:back either back [tail p/pane] [p/pane]
            ] [
                if p/parent/type = 'tab-panel [
                    p: p/parent
                    if back [return p]
                    faces: find/same p/parent/pane p
                ]
                unless back [faces: next faces]
                get-focusable/:back faces
            ]
        ]
        fun: unset
        svh: unset
        handlers: unset
        ft: unset
        mono: unset
        request-font: func [
            "Requests a font object"
            /font "Sets the selected font"
            ft [object!]
            /mono "Show monospaced font only"
        ][
            system/view/platform/request-font make font! [] ft mono
        ]
        multi: unset
        request-file: func [
            {Asks user to select a file and returns full file path (or block of paths)}
            /title "Window title"
            text [string!]
            /file "Default file name or directory"
            name [string! file!]
            /filter "Block of filters (filter-name filter)"
            list [block!]
            /save "File save mode"
            /multi {Allows multiple file selection, returned as a block}
        ][
            system/view/platform/request-file text name list save multi
        ]
        request-dir: func [
            {Asks user to select a directory and returns full directory path (or block of paths)}
            /title "Window title"
            text [string!]
            /dir "Set starting directory"
            name [string! file!]
            /filter "TBD: Block of filters (filter-name filter)"
            list [block!]
            /keep "Keep previous directory path"
            /multi {TBD: Allows multiple file selection, returned as a block}
        ][
            system/view/platform/request-dir text name list keep multi
        ]
        post: unset
        sub: unset
        post?: unset
        msg: unset
        unview: func [
            "Close last opened window view"
            /all "Close all views"
            /only "Close a given view"
            face [object!] "Window view to close"
            /local all? svs pane
        ][
            if system/view/debug? [print ["unview: all:" :all "only:" only]]
            all?: :all
            svs: either system/words/all [only face/type = 'window] [face/parent] [get-current-screen]
            if empty? pane: svs/pane [exit]
            case [
                only [remove find/same head pane face]
                all? [while [not tail? pane] [remove back tail pane]]
                'else [remove back tail pane]
            ]
        ]
        drag-evt: unset
        drag-info: unset
        planar?: func ["Returns true if the value is any type of planar" value [any-type!]][find planar! type? :value]
        owned-faces: unset
        back?: unset
        control: unset
        set-focus: func [
            "Sets the focus on the argument face"
            face [object!]
            /local p
        ][
            p: face/parent
            while [p/type <> 'window] [p: p/parent]
            p/selected: face
        ]
        =?: make op! [[
            "Returns TRUE if two values have the same identity"
            value1 [any-type!]
            value2 [any-type!]
        ]]
        decode-4: unset
        c2: unset
        get-char: unset
        GET_UNIT: unset
        log-b: unset
        c1: unset
        special?: unset
        hi: unset
        lo: unset
        s2: unset
        overwrite-char: unset
        val: make object! [...]
        ind: unset
        ascii?: unset
        sep: unset
        map: unset
        any-word?: func ["Returns true if the value is any type of any-word" value [any-type!]][find any-word! type? :value]
        special-char: unset
        mark1: unset
        mark2: unset
        escape: #"^["
        int: unset
        keys: unset
        pretty: unset
        ascii: unset
        application: unset
        to-json: func [
            "Convert Red data to a JSON string"
            data
            /pretty indent [string!] "Pretty format the output, using given indentation"
            /ascii "Force ASCII output (instead of UTF-8)"
            /local result
        ][
            result: make string! 4000
            init-state indent ascii
            red-to-json-value result data
        ]
        load-json: func [
            "Convert a JSON string to Red data"
            input [string!] "The JSON string"
        ][
            _out: _res: copy []
            mark: last-lf: input
            line-ct: 1
            either parse/case input json-value [pick _out 1] [
                make error! form reduce [
                    "Invalid JSON string."
                    "Line:" line-ct
                    "Index:" index? mark
                    "Column:" offset? last-lf mark
                    "Near:" either tail? mark ["<end of input>"] [mold copy/part mark 40]
                ]
            ]
        ]
        to-csv: func [
            "Make CSV data from input value"
            data [block! map! object!] {May be block of fixed size records, block of block records, or map columns}
            /with "Delimiter to use (default is comma)"
            delimiter [char! string!]
            /skip "Treat block as table of records with fixed length"
            size [integer!]
            /quote
            qt-char [char!] {Use different character for quotes than double quote (")}
            /local longest keyval? types value
        ][
            longest: 0
            delimiter: any [delimiter comma]
            quote-char: any [qt-char #"^""]
            double-quote: rejoin [quote-char quote-char]
            quotable-chars: charset rejoin [space newline quote-char delimiter]
            if any [map? data object? data] [return encode-map data delimiter]
            if skip [return encode-flat data delimiter size]
            keyval?: any [map? first data object? first data]
            unless any [
                block? first data
                keyval?
            ] [data: reduce [data]]
            types: unique collect [foreach value data [keep type? value]]
            either all [
                1 = length? types
                keyval?
            ] [
                encode-maps data delimiter
            ] [
                encode-blocks data delimiter
            ]
        ]
        load-csv: func [
            {Converts CSV text to a block of rows, where each row is a block of fields.}
            data [string!] "Text CSV data to load"
            /with
            delimiter [char! string!] "Delimiter to use (default is comma)"
            /header {Treat first line as header; implies /as-columns if /as-records is not used}
            /as-columns {Returns named columns; default names if /header is not used}
            /as-records {Returns records instead of rows; default names if /header is not used}
            /flat {Returns a flat block; you need to know the number of fields}
            /trim "Ignore spaces between quotes and delimiter"
            /quote
            qt-char [char!] {Use different character for quotes than double quote (")}
            /local disallowed refs output out-map longest line value record newline quotchars valchars quoted-value char normal-value s e single-value values add-value add-line length index line-rule init parsed? mark key-index key
        ][
            disallowed: [
                [as-columns as-records] [flat as-columns] [flat as-records] [flat header]
            ]
            foreach refs disallowed [
                if all refs [
                    return make error! rejoin [
                        "Cannot use /" refs/1 " and /" refs/2 " refinements together"
                    ]
                ]
            ]
            if all [header not as-records] [as-columns: true]
            delimiter: any [delimiter comma]
            quote-char: any [qt-char #"^""]
            output: make block! (length? data) / 80
            out-map: make map! []
            longest: 0
            line: make block! 20
            value: make string! 200
            record: none
            newline: [crlf | lf | cr]
            quotchars: charset reduce ['not quote-char]
            valchars: charset reduce ['not append copy "^/^M" delimiter]
            quoted-value: [
                (clear value) [
                    quote-char
                    any [
                        [
                            set char quotchars
                            | quote-char quote-char (char: quote-char)
                        ]
                        (append value char)
                    ]
                    quote-char
                ]
            ]
            normal-value: [s: any valchars e: (value: copy/part s e)]
            single-value: [quoted-value | normal-value]
            values: [any [single-value delimiter add-value] single-value add-value]
            add-value: [(
                if trim [
                    value: system/words/trim value
                    all [
                        quote-char = first value
                        quote-char = last value
                        take value
                        take/last value
                    ]
                ]
                append line copy value
            )]
            add-line: [
                (
                    all [
                        ignore-empty?
                        empty? last line
                        take/last line
                    ]
                    length: length? line
                    if zero? longest [longest: length]
                    if all [strict? longest <> length] [
                        return make error! non-aligned
                    ]
                    if longest < length [longest: length]
                    either as-records [
                        if longest > length? header [
                            loop longest - (length? header) [
                                append header next-column-name last header
                            ]
                        ]
                        record: make map! length
                        repeat index length [
                            record/(header/:index): line/:index
                        ]
                        append output record
                    ] [
                        either flat [
                            append output copy line
                        ] [
                            append/only output copy line
                        ]
                    ]
                )
                init
            ]
            line-rule: [end | values [newline | end] add-line]
            init: [(clear line)]
            parsed?: parse data [
                opt [
                    if (header)
                    values newline
                    (header: copy line)
                    init
                ]
                mark: (
                    if all [
                        header
                        any [
                            equal? mark head mark
                            empty? mark
                        ]
                    ] [do make error! "CSV data are too small to use /HEADER refinement"]
                )
                (unless header [header: make-header 1])
                [
                    init some line-rule
                    | init values add-line
                ]
                any newline
            ]
            if as-columns [
                key-index: 0
                if longest > length? header [
                    header: make-header longest
                ]
                foreach key header [
                    key-index: key-index + 1
                    out-map/:key: make block! length? output
                    foreach line output [append out-map/:key line/:key-index]
                ]
                output: out-map
            ]
            output
        ]
        delimiter: unset
        quot?: unset
        previous: unset
        columns: unset
        keys-of: func [{Returns the list of words of a value that supports reflection} value][reflect :value 'words]
        column: unset
        csv-line: unset
        as-columns: unset
        as-records: unset
        qt-char: unset
        disallowed: unset
        refs: unset
        out-map: unset
        longest: unset
        record: unset
        quotchars: unset
        valchars: unset
        quoted-value: unset
        char: unset
        normal-value: unset
        single-value: unset
        add-value: unset
        add-line: unset
        line-rule: unset
        key-index: unset
        comma: #","
        crlf: "^M^/"
        keyval?: unset
        map?: func ["Returns true if the value is this type" value [any-type!]][map! = type? :value]
        fit: unset
        line-start: unset
        ellipsize-at: func [
            {Truncate and add ellipsis if str is longer than len}
            str [string!] "(modified)"
            len [integer!] "Max length"
        ][
            if (length? str) > len [
                append clear skip str (len - 3) "..."
            ]
            str
        ]
        char?: func ["Returns true if the value is this type" value [any-type!]][char! = type? :value]
        pre: unset
        tmp: unset
        dot: #"."
        molded: unset
        vector?: func ["Returns true if the value is this type" value [any-type!]][vector! = type? :value]
        any-object?: func [{Returns true if the value is any type of any-object} value [any-type!]][find any-object! type? :value]
        a-an: func [
            {Returns the appropriate variant of a or an (simple, vs 100% grammatically correct)}
            str [string!]
            /pre "Prepend to str"
            /local tmp
        ][
            tmp: either find "aeiou" str/1 ["an"] ["a"]
            either pre [rejoin [tmp #" " str]] [tmp]
        ]
        t: unset
        fn: unset
        cur-frame: unset
        =val: unset
        func-desc=: unset
        attr-val=: unset
        func-attr=: unset
        param-name=: unset
        param-type=: unset
        param-desc=: unset
        param-attr=: unset
        param=: unset
        ref-name=: unset
        ref-desc=: unset
        ref-param=: unset
        refinement=: unset
        locals=: unset
        returns=: unset
        spec=: unset
        desc: unset
        attr: unset
        params: unset
        refinements: unset
        returns: unset
        found-at-least-one?: unset
        col-1: unset
        catalog: unset
        accessors: unset
        param: unset
        no-name: unset
        fn-as-obj: unset
        rec: unset
        parse-func-spec: unset
        word-col-wd: unset
        map-word: unset
        obj-word: unset
        help-string: func [
            {Returns information about functions, values, objects, and datatypes.}
            'word [any-type!] "Omit the word arg for HELP usage."
            /local ref-given? value
        ][
            clear output-buffer
            case [
                unset? :word [_print HELP-USAGE]
                string? :word [what/with/spec/buffer word]
                all [word? :word unset? get/any :word] [what/with/buffer word]
                'else [
                    ref-given?: any [word? :word path? :word]
                    value: either ref-given? [get/any :word] [:word]
                    case [
                        all [ref-given? any-function? :value] [show-function-help :word]
                        any-function? :value [_print mold :value]
                        datatype? :value [show-datatype-help :value]
                        object? :value [show-object-help word]
                        map? :value [show-map-help word]
                        all [ref-given? any [any-block? :value vector? :value]] [_print/fit [word-is-value-str/only :word DEF_SEP form-value :value]]
                        image? :value [
                            either all [in system 'view :system/view] [view [image value]] [
                                _print/fit form-value value
                            ]
                        ]
                        all [path? :word object? :value] [show-object-help word]
                        ref-given? [_print word-is-value-str word]
                        'else [_print value-is-type-str :word]
                    ]
                ]
            ]
            output-buffer
        ]
        ref-given?: unset
        what: func [
            "Lists all functions, or search for values"
            /with "Search all values that contain text in their name"
            text [word! string!]
            /spec "Search for text in value specs as well"
            /buffer {Buffer and return output, rather than printing results}
            /local found-at-least-one? word val
        ][
            clear output-buffer
            found-at-least-one?: no
            foreach word sort get-sys-words either with [:set?] [:any-function?] [
                val: get word
                if any [
                    not with
                    find form word text
                    all [spec any-function? :val find mold spec-of :val text]
                ] [
                    found-at-least-one?: yes
                    _print/fit [DENT_1 as-col-1 word as-type-col :val DEF_SEP form-value :val]
                ]
            ]
            if not found-at-least-one? [
                _print {No matching values were found in the global context.}
            ]
            either buffer [output-buffer] [print output-buffer]
        ]
        routine?: func ["Returns true if the value is this type" value [any-type!]][routine! = type? :value]
        cc: unset
        git: unset
        plt: unset
        os-info: routine [{Returns detailed operating system version information}][
            __get-OS-info
        ]
        branch: unset
        tag: unset
        to-UTC-date: func [
            "Returns the date with UTC zone"
            date [date!]
            return: [date!]
        ][
            date/timezone: 0
            date
        ]
        commit: unset
        arch: unset
        for: unset
        built: unset
        write-clipboard: routine [
            "Write content to the system clipboard"
            data [any-type!] "string!, block! of files!, an image! or none!"
            return: [logic!] "indicates success"
        ][
            clipboard/write as red-value! data
        ]
        --catch: unset
        =quote=: unset
        =quoted-switch=: unset
        =normal-switch=: unset
        ret: unset
        SetConsoleTitle: unset
        c-string!: unset
        print-line: unset
        gui-console?: unset
        pasting?: unset
        init-globals: unset
        red-pair!: unset
        get-in: unset
        ctx||623: unset
        step: unset
        back2: unset
        prefix: unset
        other: unset
        no-banner: unset
        col: unset
        expect-arg: unset
        list-dir: func [
            {Displays a list of files and directories from given folder or current one}
            dir [any-type!] "Folder to list"
            /col "Forces the display in a given number of columns"
            n [integer!] "Number of columns"
            /local list limit max-sz name
        ][
            unless value? 'dir [dir: %.]
            unless find [file! word! path!] type?/word :dir [
                cause-error 'script 'expect-arg ['list-dir type? :dir 'dir]
            ]
            list: read normalize-dir dir
            limit: system/console/size/x - 13
            max-sz: to-integer either n [
                limit / n - n
            ] [
                n: max 1 limit / 22
                22 - n
            ]
            while [not tail? list] [
                loop n [
                    if max-sz <= length? name: list/1 [
                        name: append copy/part name max-sz - 4 "..."
                    ]
                    prin tab
                    prin pad form name max-sz
                    prin " "
                    if tail? list: next list [break]
                ]
                prin lf
            ]
            ()
        ]
        to-integer: func ["Convert to integer! value" value][to
        integer! :value]
        probe: func [
            "Returns a value after printing its molded form"
            value [any-type!]
        ][
            print mold :value
            :value
        ]
        console?: unset
        w1: unset
        ptr: unset
        sys-word: unset
        action?: func ["Returns true if the value is this type" value [any-type!]][action! = type? :value]
        native?: func ["Returns true if the value is this type" value [any-type!]][native! = type? :value]
        refinement?: func ["Returns true if the value is this type" value [any-type!]][refinement! = type? :value]
        files: unset
        replace?: unset
        change?: unset
        delim?: unset
        insert?: unset
        delimiters: unset
        theme: unset
        paste: unset
        ---: unset
        select-all: unset
        I-beam: unset
        paint: unset
        press-key: unset
        alt: unset
        process-ime-input: unset
        mouse-down: unset
        mouse-up: unset
        mouse-paste?: unset
        text-selected?: unset
        copy-selection: unset
        selects: unset
        redraw: unset
        mouse-move: unset
        get-scroller: func [
            "return a scroller object from a face"
            face [object!]
            orientation [word!]
            return: [object!]
        ][
            make scroller! [
                position: 1
                page: 1
                min-size: 1
                max-size: 1
                parent: face
                vertical?: orientation = 'vertical
            ]
        ]
        horizontal: unset
        accelerated: unset
        comment!: unset
        question: unset
        hist: unset
        hide?: unset
        resume: unset
        dry: unset
        lf?: unset
        first-prin?: unset
        advance: unset
        copy?: unset
        cols: unset
        line-count?: unset
        delta: unset
        line-height?: unset
        buffer-lines: unset
        rows: unset
        new-size: unset
        page-size: unset
        page-up: unset
        page-down: unset
        track: unset
        lh: unset
        caret-to-offset: func [
            {Given a text position, returns the corresponding coordinate relative to the top-left of the layout box}
            face [object!]
            pos [integer!]
            /lower "lower end offset of the caret"
            return: [point2D!]
            /local opt
        ][
            opt: either lower [6] [0]
            system/view/platform/text-box-metrics face pos opt
        ]
        max-n: unset
        offset-to-caret: func [
            {Given a coordinate, returns the corresponding caret position}
            face [object!]
            pt [planar!]
            return: [integer!]
        ][
            system/view/platform/text-box-metrics face pt 1
        ]
        left?: unset
        wc: unset
        here: unset
        rev: unset
        start-idx: unset
        end-idx: unset
        start-n: unset
        end-n: unset
        swap?: unset
        nl?: unset
        read-clipboard: routine [
            "Return the contents of the system clipboard"
            return: [any-type!] {false on failure, none if empty, otherwise: string!, block! of files!, or an image!}
        ][
            stack/set-last clipboard/read
        ]
        s1: unset
        p-idx: unset
        candidates: unset
        str2: unset
        red-complete-ctx: make object! [
            has-common-part?: false
            common-substr: func [
                "Internal Use Only"
                blk [block!]
                /local a b
            ][
                has-common-part?: either 1 < length? blk [
                    sort blk
                    a: first blk
                    b: last blk
                    while [
                        all [
                            not tail? a
                            not tail? b
                            find/match a first b
                        ]
                    ] [
                        a: next a
                        b: next b
                    ]
                    insert blk copy/part head a a
                    yes
                ] [no]
            ]
            red-complete-path: func [
                "Internal Use Only"
                str [string!]
                console? [logic!]
                /local s result word w1 ptr words first? sys-word w
            ][
                result: make block! 4
                first?: yes
                s: ptr: str
                while [ptr: find str #"/"] [
                    word: attempt [to word! copy/part str ptr]
                    if none? word [return result]
                    either first? [
                        set/any 'w1 get/any word
                        first?: no
                    ] [
                        if w1: in :w1 word [set/any 'w1 get/any w1]
                    ]
                    str: either object? :w1 [next ptr] [""]
                ]
                case [
                    any [function? :w1 action? :w1 native? :w1 routine? :w1] [
                        word: find/last/tail s #"/"
                        words: make block! 4
                        foreach w spec-of w1 [
                            if all [refinement? w w <> /local] [append words w]
                        ]
                    ]
                    object? :w1 [
                        word: str
                        words: words-of w1
                    ]
                    words: select system/catalog/accessors type?/word :w1 [
                        word: find/last/tail s #"/"
                    ]
                ]
                if words [
                    foreach w words [
                        sys-word: form w
                        if any [empty? word find/match sys-word word] [
                            append result sys-word
                        ]
                    ]
                ]
                if console? [common-substr result]
                if any [1 = length? result has-common-part?] [
                    poke result 1 append copy/part s word result/1
                ]
                result
            ]
            red-complete-file: func [
                "Internal Use Only"
                str [string!]
                console? [logic!]
                /local file result path word f files replace? change?
            ][
                result: make block! 4
                file: to file! next str
                replace?: no
                either word: find/last/tail str #"/" [
                    path: to file! copy/part next str word
                    unless exists? path [return result]
                    replace?: yes
                ] [
                    path: %./
                    word: file
                ]
                files: read path
                foreach f files [
                    if any [empty? word find/match f word] [
                        append result f
                    ]
                ]
                if console? [common-substr result]
                if any [1 = length? result has-common-part?] [
                    poke result 1 append copy/part str either replace? [word] [1] result/1
                ]
                result
            ]
            complete-input: func [
                str [string!]
                console? [logic!]
                /local
                word ptr result sys-word delim? len insert?
                start end delimiters d w change?
            ][
                has-common-part?: no
                result: make block! 4
                delimiters: [#"^-" #" " #"[" #"(" #":" #"'" #"{"]
                delim?: no
                insert?: not tail? str
                len: (index? str) - 1
                end: str
                ptr: str: head str
                foreach d delimiters [
                    word: find/last/tail/part str d len
                    if all [word (index? ptr) < (index? word)] [ptr: word]
                ]
                either head? ptr [start: str] [start: ptr delim?: yes]
                word: copy/part start end
                unless empty? word [
                    case [
                        all [
                            #"%" = word/1
                            1 < length? word
                        ] [
                            append result 'file
                            append result red-complete-file word console?
                        ]
                        all [
                            #"/" <> word/1
                            ptr: find word #"/"
                            #" " <> pick ptr -1
                        ] [
                            append result 'path
                            append result red-complete-path word console?
                        ]
                        true [
                            append result 'word
                            foreach w words-of system/words [
                                if value? w [
                                    sys-word: mold w
                                    if find/match sys-word word [
                                        append result sys-word
                                    ]
                                ]
                            ]
                            if ptr: find result word [swap next result ptr]
                            if console? [common-substr next result]
                        ]
                    ]
                ]
                if console? [result: next result]
                if all [console? any [has-common-part? 1 = length? result]] [
                    if word = result/1 [
                        unless has-common-part? [clear result]
                    ]
                    unless empty? result [
                        either any [insert? delim?] [
                            str: append copy/part str start result/1
                            poke result 1 tail str
                            if insert? [append str end]
                        ] [
                            poke result 1 tail result/1
                        ]
                    ]
                ]
                result
            ]
        ]
        complete-input: unset
        prompt: unset
        del?: unset
        backward: unset
        home: unset
        text-box: unset
        highlight: make object! [
            _dst: none
            _theme: none
            lex: func [
                event [word!]
                input [string! binary!]
                type [datatype! word! none!]
                line [integer!]
                token
                return: [logic!]
                /local style
            ][
                [scan error]
                switch event [
                    scan [
                        if all [type style: select _theme to-word type] [
                            append _dst as-pair token/x token/y - token/x
                            append _dst style
                        ]
                    ]
                    error [input: next input]
                ]
                false
            ]
            add-styles: func [
                src [string!]
                dst [block! none!]
                theme [map!]
            ][
                _dst: dst
                _theme: theme
                transcode/trace src :lex
            ]
        ]
        add-styles: unset
        draw-face: unset
        clr: unset
        foreground: unset
        red-lang: unset
        github: unset
        lay: unset
        small: unset
        ver: unset
        to-string: func ["Convert to string! value" value][to string! :value]
        hand: unset
        to-url: func ["Convert to url! value" value][to url! :value]
        no-title: unset
        dark-mode?: unset
        bbox: unset
        fbox: unset
        hex-field: unset
        cfg-backcolor: unset
        cfg-forecolor: unset
        mouse-mode: unset
        cfg-buffers: unset
        gray: 128.128.128
        support-dark-mode?: unset
        max-lines: unset
        background: unset
        win-size: unset
        within?: func [
            {Return TRUE if the point is within the rectangle bounds}
            point [planar!] "XY position"
            offset [planar!] "Offset of area"
            size [planar!] "Size of area"
            return: [logic!]
        ][
            to logic! all [
                point/x >= offset/x
                point/y >= offset/y
                point/x < (offset/x + size/x)
                point/y < (offset/y + size/y)
            ]
        ]
        win-pos: unset
        update-cfg: unset
        Purpose: unset
        gui-default: unset
        iter: unset
        cfg-content: unset
        menu-bar?: unset
        run-file: unset
        choose-font: unset
        settings: unset
        shortcuts: unset
        about-msg: unset
        exit-ask-loop: unset
        new-sz: unset
        adjust-console-size: unset
        refresh: unset
        F12: unset
        gui-console-buffer: unset
        ALLOC_TAIL: unset
        TYPE_UNSET: unset
        dyn-print: unset
        int-ptr!: unset
        red-print-gui: unset
        rs-print-gui: unset
        get-caret-blink-time: routine [
            return: [integer!]
        ][
            #either OS = 'Windows [
                GetCaretBlinkTime
            ] [500]
        ]
        to-time: func ["Convert to time! value" value][to time! :value]
        save-cfg: unset
        hide: unset
        show-caret: unset
        GetCaretBlinkTime: unset
        user-info: unset
        fragment: unset
        catch?: unset
        shift-right: routine ["Shift bits to the right" data [integer!] bits [integer!]][natives/shift* no -1 -1]
        shift-left: routine ["Shift bits to the left" data [integer!] bits [integer!]][natives/shift* no 1 -1]
        shift-logical: routine ["Shift bits to the right (unsigned)" data [integer!] bits [integer!]][natives/shift* no -1 1]
        count-chars: routine [
            {Count UTF-8 encoded characters between two positions in a binary series}
            start [binary!]
            pos [binary!]
            return: [integer!]
        ][
            s: GET_BUFFER (start)
            p: (as byte-ptr! s/offset) + start/head
            tail: (as byte-ptr! s/offset) + pos/head
            c: len: 0
            while [p < tail] [
                p: unicode/fast-decode-utf8-char p :len
                c: c + 1
            ]
            c
        ]
        pick-stack: routine [
            idx [integer!]
        ][
            either all [idx > 0 idx < stack-size?] [
                stack/set-last stack/bottom + idx - 1
            ] [
                SET_RETURN (none-value)
            ]
        ]
        frame-index?: routine [return: [integer!]][
            (as-integer stack/arguments - stack/bottom) >> 4
        ]
        write-stdout: routine ["Write data to STDOUT" data [any-type!]][
            simple-io/write null as red-value! data null null no no no
        ]
        sp: #" "
        dbl-quote: #"^""
        pi: 3.141592653589793
        internal!: make typeset! [unset!]
        external!: make typeset! [event!]
        aqua: 40.100.130
        beige: 255.228.196
        black: 0.0.0
        blue: 0.0.255
        brick: 178.34.34
        brown: 139.69.19
        coal: 64.64.64
        coffee: 76.26.0
        crimson: 220.20.60
        cyan: 0.255.255
        forest: 0.48.0
        gold: 255.205.40
        green: 0.255.0
        ivory: 255.255.240
        khaki: 179.179.126
        leaf: 0.128.0
        linen: 250.240.230
        magenta: 255.0.255
        maroon: 128.0.0
        mint: 100.136.116
        navy: 0.0.128
        oldrab: 72.72.16
        olive: 128.128.0
        orange: 255.150.10
        papaya: 255.80.37
        pewter: 170.170.170
        pink: 255.164.200
        purple: 128.0.128
        reblue: 38.58.108
        rebolor: 142.128.110
        sienna: 160.82.45
        silver: 192.192.192
        sky: 164.200.255
        snow: 240.240.240
        tanned: 222.184.135
        teal: 0.128.128
        violet: 72.0.90
        water: 80.108.142
        wheat: 245.222.129
        yello: 255.240.120
        yellow: 255.255.0
        glass: 0.0.0.255
        ??: func [
            "Prints a word and the value it refers to (molded)"
            'value [word! path!]
        ][
            prin mold :value
            prin ": "
            print either any [path? :value value? :value] [mold get/any :value] ["unset!"]
        ]
        fourth: func ["Returns the fourth value in a series" s [series! tuple! date!]][pick s 4]
        fifth: func ["Returns the fifth value in a series" s [series! tuple! date!]][pick s 5]
        email?: func ["Returns true if the value is this type" value [any-type!]][email! = type? :value]
        get-path?: func ["Returns true if the value is this type" value [any-type!]][get-path! = type? :value]
        hash?: func ["Returns true if the value is this type" value [any-type!]][hash! = type? :value]
        lit-path?: func ["Returns true if the value is this type" value [any-type!]][lit-path! = type? :value]
        lit-word?: func ["Returns true if the value is this type" value [any-type!]][lit-word! = type? :value]
        percent?: func ["Returns true if the value is this type" value [any-type!]][
            percent! = type? :value
        ]
        set-path?: func ["Returns true if the value is this type" value [any-type!]][set-path! = type? :value]
        time?: func ["Returns true if the value is this type" value [any-type!]][time! = type? :value]
        date?: func ["Returns true if the value is this type" value [any-type!]][date! = type? :value]
        money?: func ["Returns true if the value is this type" value [any-type!]][money! = type? :value]
        ref?: func ["Returns true if the value is this type" value [any-type!]][ref! = type? :value]
        point3D?: func ["Returns true if the value is this type" value [any-type!]][point3D! = type? :value]
        any-path?: func ["Returns true if the value is any type of any-path" value [any-type!]][find any-path! type? :value]
        number?: func ["Returns true if the value is any type of number" value [any-type!]][find number! type? :value]
        immediate?: func [{Returns true if the value is any type of immediate} value [any-type!]][find immediate! type? :value]
        scalar?: func ["Returns true if the value is any type of scalar" value [any-type!]][find scalar! type? :value]
        all-word?: func ["Returns true if the value is any type of all-word" value [any-type!]][find all-word! type? :value]
        any-point?: func [{Returns true if the value is any type of any-point} value [any-type!]][find any-point! type? :value]
        to-bitset: func ["Convert to bitset! value" value][to
        bitset! :value]
        to-binary: func ["Convert to binary! value" value][to binary! :value]
        to-char: func ["Convert to char! value" value][to char! :value]
        to-email: func ["Convert to email! value" value][to email! :value]
        to-file: func ["Convert to file! value" value][to file! :value]
        to-float: func ["Convert to float! value" value][to float! :value]
        to-get-path: func ["Convert to get-path! value" value][to get-path! :value]
        to-get-word: func ["Convert to get-word! value" value][to get-word! :value]
        to-hash: func ["Convert to hash! value" value][to hash! :value]
        to-issue: func ["Convert to issue! value" value][to issue! :value]
        to-lit-path: func ["Convert to lit-path! value" value][to lit-path! :value]
        to-lit-word: func ["Convert to lit-word! value" value][to lit-word! :value]
        to-map: func ["Convert to map! value" value][to map! :value]
        to-none: func ["Convert to none! value" value][to none! :value]
        to-path: func ["Convert to path! value" value][to path! :value]
        to-percent: func ["Convert to percent! value" value][to
        percent! :value]
        to-refinement: func ["Convert to refinement! value" value][to refinement! :value]
        to-set-path: func ["Convert to set-path! value" value][to set-path! :value]
        to-tag: func ["Convert to tag! value" value][to tag! :value]
        to-typeset: func ["Convert to typeset! value" value][to typeset! :value]
        to-tuple: func ["Convert to tuple! value" value][to tuple! :value]
        to-unset: func ["Convert to unset! value" value][to
        unset! :value]
        to-image: func ["Convert to image! value" value][to image! :value]
        to-date: func ["Convert to date! value" value][to date! :value]
        to-money: func ["Convert to money! value" value][to money! :value]
        to-ref: func ["Convert to ref! value" value][to ref! :value]
        to-point3D: func ["Convert to point3D! value" value][to point3D! :value]
        p-indent: unset
        parse-trace: func [
            {Wrapper for parse/trace using the default event processor}
            input [series!]
            rules [block!]
            /case "Uses case-sensitive comparison"
            /part "Limit to a length or position"
            limit [integer!]
            return: [logic! block!]
        ][
            clear p-indent
            parse/:case/:part/trace input rules limit :on-parse-event
        ]
        modulo: func [
            {Wrapper for MOD that handles errors like REMAINDER. Negligible values (compared to A and B) are rounded to zero}
            a [number! money! char! pair! tuple! vector! time!]
            b [number! money! char! pair! tuple! vector! time!]
            return: [number! money! char! pair! tuple! vector! time!]
            /local r
        ][
            r: mod a absolute b
            either any [a - r = a r + b = b] [0] [r]
        ]
        eval-set-path: func ["Internal Use Only" value1][]
        extract-boot-args: func [
            {Process command-line arguments and store values in system/options (internal usage)}
            /local args at-arg2 ws split-mode arg-end s' e' arg2-update s e
        ][
            unless args: system/script/args [exit]
            at-arg2: none
            ws: charset " ^-"
            split-mode: yes
            system/options/boot: take system/options/args: collect [
                arg-end: has [s' e'] [
                    unless same? s': s e': e [
                        if s/1 = #"^"" [s': next s]
                        if all [e/-1 = #"^"" not same? e s'] [e': back e]
                        keep copy/part s' e'
                    ]
                ]
                arg2-update: [if (at-arg2) | at-arg2:]
                parse s: args [
                    some [e:
                    #"^"" (split-mode: not split-mode)
                    | if (split-mode) some ws (arg-end) arg2-update s:
                    | skip] e: (arg-end) arg2-update
                ]
            ]
            remove/part args at-arg2
            system/options/args
        ]
        flip-exe-flag: func [
            {Flip the sub-system for the red.exe between console and GUI modes (Windows only)}
            path [file!] "Path to the red.exe"
            /local file buffer flag
        ][
            file: either dir? path [append copy path %red.exe] [path]
            buffer: read/binary file
            flag: skip find/tail/case buffer "PE" 90
            flag/1: either flag/1 = 2 [3] [2]
            write/binary file buffer
        ]
        split: func [
            {Break a string series into pieces using the provided delimiters}
            series [any-string!] dlm [string! char! bitset!] /local s
            num
        ][
            num: either string? dlm [length? dlm] [1]
            parse series [collect any [end keep (make string! 0) | copy s [to [dlm | end]] keep (s) num skip]]
        ]
        exists-thru?: func [
            {Returns true if the remote file is present in the local disk cache}
            url [url! file!] "Remote file address"
        ][
            exists? any [all [file? url url] path-thru url]
        ]
        read-thru: func [
            "Reads a remote file through local disk cache"
            url [url!] "Remote file address"
            /update "Force a cache update"
            /binary "Use binary mode"
            /local path data
        ][
            path: path-thru url
            either all [not update exists? path] [
                data: read/:binary path
            ] [
                data: read/:binary url
                attempt [write/binary path data]
            ]
            data
        ]
        do-thru: func [
            {Evaluates a remote Red script through local disk cache}
            url [url!] "Remote file address"
            /update "Force a cache update"
        ][
            do load-thru/:update url
        ]
        cos: func [
            "Returns the trigonometric cosine"
            angle [float!] "Angle in radians"
        ][
            #system [
                stack/arguments: stack/arguments - 1
                natives/cosine* no 1
            ]
        ]
        sin: func [
            "Returns the trigonometric sine"
            angle [float!] "Angle in radians"
        ][
            #system [
                stack/arguments: stack/arguments - 1
                natives/sine* no 1
            ]
        ]
        tan: func [
            "Returns the trigonometric tangent"
            angle [float!] "Angle in radians"
        ][
            #system [
                stack/arguments: stack/arguments - 1
                natives/tangent* no 1
            ]
        ]
        acos: func [
            {Returns the trigonometric arccosine in radians in range [0,pi]}
            cosine [float!] "in range [-1,1]"
        ][
            #system [
                stack/arguments: stack/arguments - 1
                natives/arccosine* no 1
            ]
        ]
        asin: func [
            {Returns the trigonometric arcsine in radians in range [-pi/2,pi/2])}
            sine [float!] "in range [-1,1]"
        ][
            #system [
                stack/arguments: stack/arguments - 1
                natives/arcsine* no 1
            ]
        ]
        atan: func [
            {Returns the trigonometric arctangent in radians in range [-pi/2,+pi/2]}
            tangent [float!] "in range [-inf,+inf]"
        ][
            #system [
                stack/arguments: stack/arguments - 1
                natives/arctangent* no 1
            ]
        ]
        atan2: func [
            {Returns the smallest angle between the vectors (1,0) and (x,y) in range (-pi,pi]}
            y [float! integer!]
            x [float! integer!]
            return: [float!]
        ][
            #system [
                stack/arguments: stack/arguments - 2
                natives/arctangent2* no 1
            ]
        ]
        sqrt: func [
            "Returns the square root of a number"
            number [float! integer! percent!]
            return: [float!]
        ][
            #system [
                stack/arguments: stack/arguments - 1
                natives/square-root* no
            ]
        ]
        to-local-date: func [
            "Returns the date with local zone"
            date [date!]
            return: [date!]
        ][
            date/timezone: now/zone
            date
        ]
        show-memory-stats: func [data [block!]
        /local class used total i c frm unit][
            repeat class 2 [
                print [lf #"[" pad form pick [Nodes Series] class 6 "] -- Free ----- Used ----- Total --"]
                used: total: 0
                either empty? data/:class [
                    repeat i 3 [prin pad/left copy "-" pick [16 11 12] i]
                    prin lf
                ] [
                    c: 0
                    foreach frm data/:class [
                        prin ["  " pad append form c: c + 1 #":" 4]
                        repeat i 3 [prin pad/left form frm/:i pick [11 11 12] i]
                        prin lf
                        used: used + frm/2
                        total: total + frm/3
                    ]
                ]
                unit: pick ["nodes" "bytes"] class
                print ["  --^/  Used     : " used unit]
                print ["  Allocated: " total unit]
            ]
            c: total: 0
            print "^/[ Big    ]"
            unless empty? data/3 [
                foreach frm data/3 [
                    prin ["  " pad append form c: c + 1 #":" 4]
                    print pad/left frm 11
                    total: total + frm
                ]
            ]
            print [
                "  --^/  Allocated: " total "bytes^/"
                "--^/Total allocated from OS (virtual):" pad/left form data/4 9 lf
                "Total allocated on heap (malloc):" pad/left form data/5 9 lf
            ]
        ]
        transcode-trace: func [
            {Shortcut function for transcoding while tracing all lexer events}
            src [binary! string!]
        ][
            transcode/trace src :system/lexer/tracer
        ]
        average: func [
            "Returns the average of all values in a block"
            block [block! vector! paren! hash!]
        ][
            if empty? block [return none]
            divide sum block length? block
        ]
        last?: func [
            "Returns TRUE if the series length is 1"
            series [series!]
        ][
            1 = length? series
        ]
        clock: func [
            {Display execution time of code, returning result of it's evaluation}
            code [block!]
            /times n [integer! float!]
            {Repeat N times (default: once); displayed time is per iteration}
            /local result
            text dt unit
        ][
            n: max 1 any [n 1]
            text: mold/flat/part code 70
            dt: time-it [set/any 'result loop n code]
            dt: 1000.0 / n * to float! dt
            unit: either dt < 1 [dt: dt * 1000.0 "μs^-"] ["ms^-"]
            parse form dt [
                0 3 [opt #"." skip] opt [to #"."] dt: (dt: head clear dt)
            ]
            print [dt unit text]
            :result
        ]
        single?: func [
            "Returns TRUE if the series length is 1"
            series [series!]
        ][
            1 = length? series
        ]
        v0.6.6: unset
        698eac0d83bbba408c82efb29264ec1bfbe62b85: unset
        message: unset
        config-name: unset
        OS-version: unset
        ABI: unset
        link?: unset
        encap?: unset
        build-prefix: unset
        build-basename: unset
        build-suffix: unset
        PE: unset
        exe: unset
        IA-32: unset
        cpu-version: unset
        verbosity: unset
        sub-system: unset
        runtime?: unset
        use-natives?: unset
        debug-safe?: unset
        dev-mode?: unset
        need-main?: unset
        PIC?: unset
        base-address: unset
        dynamic-linker: unset
        syscall: unset
        export-ABI: unset
        stack-align-16?: unset
        literal-pool?: unset
        unicode?: unset
        red-pass?: unset
        red-only?: unset
        red-store-bodies?: unset
        red-strict-check?: unset
        red-tracing?: unset
        red-help?: unset
        redbin-compress?: unset
        legacy: unset
        libRed?: unset
        libRedRT?: unset
        libRedRT-update?: unset
        draw-engine: unset
        modules: unset
        command-line: unset
        show-func-map?: unset
        datatypes: unset
        errors: unset
        while-cond: unset
        no-load: unset
        invalid: unset
        missing: unset
        no-rs-header: unset
        bad-header: unset
        malconstruct: unset
        bad-char: unset
        no-value: unset
        need-value: unset
        not-defined: unset
        not-in-context: unset
        no-arg: unset
        expect-val: unset
        expect-type: unset
        cannot-use: unset
        invalid-type-spec: unset
        invalid-key-type: unset
        invalid-op: unset
        no-op-arg: unset
        bad-op-spec: unset
        invalid-part: unset
        not-same-type: unset
        not-same-class: unset
        not-related: unset
        bad-func-def: unset
        bad-func-arg: unset
        bad-func-extern: unset
        no-refine: unset
        bad-refines: unset
        bad-refine: unset
        dup-refine: unset
        word-first: unset
        empty-path: unset
        unset-path: unset
        invalid-path: unset
        invalid-path-set: unset
        invalid-path-get: unset
        bad-path-type: unset
        bad-path-type2: unset
        bad-path-set: unset
        bad-field-set: unset
        dup-vars: unset
        past-end: unset
        missing-arg: unset
        out-of-range: unset
        invalid-chars: unset
        invalid-compare: unset
        wrong-type: unset
        type-limit: unset
        size-limit: unset
        no-return: unset
        throw-usage: unset
        locked-word: unset
        bad-bad: unset
        bad-make-arg: unset
        bad-to-arg: unset
        invalid-months: unset
        invalid-spec-field: unset
        missing-spec-field: unset
        move-bad: unset
        too-long: unset
        invalid-char: unset
        bad-loop-series: unset
        wrong-denom: unset
        bad-denom: unset
        invalid-obj-evt: unset
        parse-rule: unset
        parse-end: unset
        parse-invalid-ref: unset
        parse-block: unset
        parse-unsupported: unset
        parse-infinite: unset
        parse-stack: unset
        parse-keep: unset
        parse-into-bad: unset
        parse-into-type: unset
        invalid-draw: unset
        invalid-data-facet: unset
        not-event-type: unset
        invalid-facet-type: unset
        react-gctx: unset
        lib-invalid-arg: unset
        rb-invalid-record: unset
        zero-divide: unset
        overflow: unset
        positive: unset
        cannot-close: unset
        invalid-utf8: unset
        not-open: unset
        no-connect: unset
        no-scheme: unset
        unknown-scheme: unset
        invalid-spec: unset
        invalid-port: unset
        invalid-actor: unset
        no-port-action: unset
        no-codec: unset
        bad-media: unset
        invalid-cmd: unset
        reserved1: unset
        reserved2: unset
        bad-path: unset
        not-here: unset
        no-memory: unset
        wrong-mem: unset
        stack-overflow: unset
        limit-hit: unset
        too-deep: unset
        no-cycle: unset
        feature-na: unset
        not-done: unset
        last-error: unset
        stack-trace: unset
        callbacks: unset
        lexer?: unset
        sort?: unset
        port?: unset
        ports: unset
        language: unset
        language*: unset
        locale*: unset
        months: unset
        days: unset
        do-arg: unset
        quiet: unset
        binary-base: unset
        decimal-digits: unset
        money-digits: unset
        module-paths: unset
        file-types: unset
        float: unset
        pretty?: unset
        full?: unset
        Needs: unset
        awake: unset
        near: unset
        file-info: unset
        url-parts: unset
        exit-states: unset
        eof: unset
        rawstring: unset
        >>>: make op! [["Shift bits to the right (unsigned)" data [integer!] bits [integer!]]]
        xor: make op! [[
            {Returns the first value exclusive ORed with the second}
            value1 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
            value2 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
            return: [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
        ]]
        eval-path: unset
        ctx||313~encode: unset
        ctx||313~decode: unset
        ctx||316~encode: unset
        ctx||316~decode: unset
        ctx||319~encode: unset
        ctx||319~decode: unset
        ctx||322~encode: unset
        ctx||322~decode: unset
        ctx||325~encode: unset
        ctx||325~decode: unset
        deep-reactor: func [spec [block!]][make deep-reactor! spec]
        relations: unset
        queue: unset
        eat-events?: unset
        not-safe!: unset
        add-relation: unset
        identify-sources: unset
        eval-reaction: unset
        pending?: unset
        no-react: func [
            {Evaluates a block with all previously defined reactions disabled}
            body [block!] "Code block to evaluate"
            /local result
        ][
            relations: tail relations
            set/any 'result eval/safe body
            relations: head relations
            :result
        ]
        clear-reactions: func ["Removes all reactive relations"][
            if system/reactivity/debug? [print "-- reactivity: clear all"]
            clear relations
        ]
        dump-reactions: func [
            {Outputs all the current reactive relations for debugging purpose}
            /local limit count obj field reaction target list
        ][
            limit: (any [all [system/console system/console/size/x] 72]) - 10
            count: 0
            foreach [obj field reaction target] relations [
                prin count: count + 1
                prin ":---^/"
                prin "  Source: object "
                list: words-of obj
                remove find list 'on-change*
                remove find list 'on-deep-change*
                print mold/part list limit - 5
                prin "   Field: "
                print form field
                prin "  Action: "
                print mold/flat/part :reaction limit
                case [
                    block? target [
                        prin "    Args: "
                        print replace/all (mold/flat/part next target limit) "make object!" "object"
                    ]
                    set-word? target [
                        prin "  Target: "
                        print form target
                    ]
                ]
            ]
            if empty? relations [print "-- no reactions --"]
            ()
        ]
        relate: func [
            {Defines a reactive relation whose result is assigned to a word}
            'field [set-word!] {Set-word which will get set to the result of the reaction}
            reaction [block!] "Reactive relation"
            /local obj rule item
        ][
            obj: context? field
            parse reaction rule: [
                any [
                    item: word! (if in obj item/1 [add-relation obj item/1 reaction field])
                    | [path! | lit-path! | get-path!] (
                        item: item/1
                        if all [in obj item/1 not same? obj system/words] [
                            add-relation obj item/1 reaction field
                        ]
                    ) | set-path! | any-string! | into rule | skip
                ]
            ]
            react/later/with reaction field
            set field either block? :reaction/1 [do :reaction/1] [eval reaction]
        ]
        is: func [][cause-error 'internal 'deprecated ["IS" "RELATE word: [reaction]"]]
        react?: func [
            {Returns a reactive relation if an object's field is a reactive source}
            reactor [object!] "Object to check"
            field [word!] "Field to check"
            /target {Check if it's a target of an `is` reaction instead of a source}
            return: [block! function! word! none!] "Returns reaction, type or NONE"
            /local pos
        ][
            either target [
                pos: skip relations 3
                while [pos: find/skip pos field 4] [
                    if same? reactor context? pos/1 [return pos/-1]
                    pos: skip pos 4
                ]
            ] [
                pos: relations
                while [pos: find/same/skip pos reactor 4] [
                    if pos/2 = field [return pos/3]
                    pos: skip pos 4
                ]
            ]
            none
        ]
        register-scheme: func [
            "Registers a new scheme"
            spec [object!] "Scheme definition"
            /native
            dispatch [handle!]
        ][
            if native [spec/actor: dispatch]
            unless find/skip system/schemes spec/name 2 [
                reduce/into [spec/name spec] system/schemes
            ]
        ]
        url-parser: make object! [
            =scheme: none
            =user-info: none
            =host: none
            =port: none
            =path: none
            =query: none
            =fragment: none
            vars: [=scheme =user-info =host =port =path =query =fragment]
            alpha: make bitset! #{00000000000000007FFFFFE07FFFFFE0}
            digit: make bitset! #{000000000000FFC0}
            alpha-num: make bitset! #{000000000000FFC07FFFFFE07FFFFFE0}
            hex-digit: make bitset! #{000000000000FFC07E0000007E}
            gen-delims: make bitset! #{000000001001002180000014}
            sub-delims: make bitset! #{000000004BF80014}
            reserved: [gen-delims | sub-delims]
            unreserved: [alpha | digit | make bitset! #{00000000000600000000000100000002}]
            pct-encoded: [#"%" 2 hex-digit]
            alpha-num+: func [more [string!]][union alpha-num charset more]
            scheme-char: make bitset! #{000000000016FFC07FFFFFE07FFFFFE0}
            url-rules: [scheme-part hier-part opt query opt fragment]
            scheme-part: [copy =scheme [alpha any scheme-char] #":"]
            hier-part: ["//" authority path-abempty | path-absolute | path-rootless | path-empty]
            authority: [opt user-info host opt [":" port]]
            user-info: [
                copy =user-info [any [unreserved | pct-encoded | sub-delims | #":"] #"@"]
                (take/last =user-info)
            ]
            IP-literal: [copy =IP-literal [[#"[" | "%5B"] thru [#"]" | "%5D"]]]
            host: [
                IP-literal (=host: =IP-literal)
                | copy =host any [unreserved | pct-encoded | sub-delims]
            ]
            port: [copy =port [1 5 digit]]
            path-abempty: [copy =path any-segments | path-empty]
            path-absolute: [copy =path [#"/" opt [segment-nz any-segments]]]
            path-rootless: [copy =path [segment-nz any-segments]]
            path-empty: [none]
            any-segments: [any [#"/" segment]]
            segment: [any pchar]
            segment-nz: [some pchar]
            segment-nz-nc: [some [unreserved | pct-encoded | sub-delims | #"@"]]
            pchar: [unreserved | pct-encoded | sub-delims | #":" | #"@"]
            query: ["?" copy =query any [pchar | slash | #"?"]]
            fragment: ["#" copy =fragment any [pchar | slash | #"?"]]
            parse-url: func [
                {Return object with URL components, or cause an error if not a valid URL}
                url [url! string!]
                /throw-error "Throw an error, instead of returning NONE."
                /local scheme user-info host port path target query fragment ref
            ][
                set vars none
                either parse mold url url-rules [
                    =path: either all [=path not empty? =path] [
                        split-path to file! dehex =path
                    ] [
                        [none none]
                    ]
                    object [
                        scheme: to word! =scheme
                        user-info: if =user-info [dehex =user-info]
                        host: if =host [dehex =host]
                        port: if =port [to integer! =port]
                        path: first =path
                        target: second =path
                        query: if =query [dehex =query]
                        fragment: if =fragment [dehex =fragment]
                        ref: url
                    ]
                ] [
                    if throw-error [
                        make error! rejoin ["URL error: " url]
                    ]
                ]
            ]
        ]
        =scheme: unset
        =user-info: unset
        =host: unset
        =port: unset
        =path: unset
        =query: unset
        =fragment: unset
        digit: unset
        alpha-num: unset
        hex-digit: unset
        gen-delims: unset
        sub-delims: unset
        reserved: unset
        unreserved: unset
        pct-encoded: unset
        alpha-num+: unset
        scheme-char: unset
        url-rules: unset
        scheme-part: unset
        hier-part: unset
        authority: unset
        IP-literal: unset
        path-abempty: unset
        path-absolute: unset
        path-rootless: unset
        path-empty: unset
        any-segments: unset
        segment: unset
        segment-nz: unset
        segment-nz-nc: unset
        pchar: unset
        parse-url: unset
        decode-url: func [
            {Decode a URL into an object containing its constituent parts}
            url [url! string!]
        ][
            parse-url url
        ]
        encode-url: func [url-obj [object!] "What you'd get from decode-url"
        /local result][
            result: make url! 60
            if url-obj/scheme [
                append result url-obj/scheme
                append result #":"
            ]
            if url-obj/host [
                append result "//"
                if url-obj/user-info [
                    append result url-obj/user-info
                    append result #"@"
                ]
                append result url-obj/host
                if url-obj/port [
                    append result #":"
                    append result url-obj/port
                ]
            ]
            if all [url-obj/path url-obj/path <> %./] [
                append result url-obj/path
            ]
            if url-obj/target [
                append result url-obj/target
            ]
            if url-obj/query [
                append result #"?"
                append result url-obj/query
            ]
            if url-obj/fragment [
                append result #"#"
                append result url-obj/fragment
            ]
            result
        ]
        preprocessor: make object! [
            exec: make object! [
                config: make object! [
                    config-name: 'Windows
                    OS: 'Windows
                    OS-version: 0
                    ABI: none
                    link?: true
                    debug?: false
                    encap?: false
                    build-prefix: %""
                    build-basename: %/home/dk/static.red-lang.org/dl/auto/win/red-view-06mar26-698eac0d8.exe
                    build-suffix: none
                    format: 'PE
                    type: 'exe
                    target: 'IA-32
                    cpu-version: 6.0
                    verbosity: 0
                    sub-system: 'GUI
                    runtime?: true
                    use-natives?: false
                    debug-safe?: true
                    dev-mode?: false
                    need-main?: false
                    PIC?: false
                    base-address: none
                    dynamic-linker: none
                    syscall: 'Linux
                    export-ABI: none
                    stack-align-16?: false
                    literal-pool?: false
                    unicode?: false
                    red-pass?: true
                    red-only?: false
                    red-store-bodies?: true
                    red-strict-check?: true
                    red-tracing?: true
                    red-help?: true
                    redbin-compress?: false
                    legacy: none
                    gui-console?: true
                    libRed?: false
                    libRedRT?: false
                    libRedRT-update?: false
                    GUI-engine: 'native
                    draw-engine: none
                    modules: [View JSON CSV]
                    show: none
                    command-line: none
                    show-func-map?: false
                ]
            ]
            protos: []
            macros: [<none>]
            stack: []
            syms: []
            depth: 0
            active?: true
            trace?: false
            s: none
            do-quit: func [][
                case [
                    all [rebol system/options/args] [quit/return 1]
                    all [not rebol system/console] [throw/name 'halt-request 'console]
                    'else [halt]
                ]
            ]
            throw-error: func [error [error!] cmd [issue!] code [block!] /local w][
                prin ["*** Preprocessor Error in" mold cmd lf]
                error/where: new-line/all reduce [cmd] no
                print form :error
                either system/console [throw/name 'halt-request 'console] [halt]
            ]
            syntax-error: func [s [block! paren!] e [block! paren!]][
                print [
                    "*** Preprocessor Error: Syntax error^/"
                    "*** Where:" trim/head mold/only copy/part s next e
                ]
                do-quit
            ]
            do-safe: func [code [block! paren!] /manual /with cmd [issue!] /local res t? src][
                if t?: all [trace? not with] [
                    print [
                        "preproc: matched" mold/flat copy/part get code/2 get code/3 lf
                        "preproc: eval macro" copy/part mold/flat body-of first code 80
                    ]
                ]
                if error? set/any 'res try code [throw-error :res any [cmd #macro] code]
                if all [
                    manual
                    any [
                        (type? src: get code/2) <> type? get/any 'res
                        not same? head src head get/any 'res
                    ]
                ] [
                    print [
                        {*** Macro Error: [manual] macro not returning a position^/}
                        "*** Where:" mold code
                    ]
                    do-quit
                ]
                if t? [print ["preproc: ==" mold get/any 'res]]
                either unset? get/any 'res [[]] [:res]
            ]
            do-code: func [code [block! paren!] cmd [issue!] /local p][
                clear syms
                parse code [any [
                    p: set-word! (unless in exec p/1 [append syms p/1])
                    | skip
                ]]
                unless empty? syms [
                    exec: make exec append syms none
                    rebind-all
                ]
                do-safe/with bind to block! code exec cmd
            ]
            rebind-all: func [/local rule p][
                protos: bind protos exec
                parse macros rule: [
                    any [p: function! (bind body-of first p exec) | p: [block! | paren!] :p into rule | skip]
                ]
            ]
            count-args: func [spec [block!] /block /local total pos][
                total: either block [copy []] [0]
                parse spec [
                    any [
                        pos: [word! | lit-word! | get-word!] (
                            either block [append total type? pos/1] [total: total + 1]
                        )
                        | refinement! (return total)
                        | skip
                    ]
                ]
                total
            ]
            arg-mode?: func [spec [block!] idx [integer!]][
                pick count-args/block spec idx
            ]
            func-arity?: func [spec [block!] /with path [path!] /block /local arity pos][
                arity: either block [count-args/block spec] [count-args spec]
                if path [
                    foreach word next path [
                        unless pos: find/tail spec to refinement! word [
                            print [
                                "*** Macro Error: unknown refinement^/"
                                "*** Where:" mold path
                            ]
                            do-quit
                        ]
                        either block
                        [append arity count-args/block pos]
                        [arity: arity + count-args pos]
                    ]
                ]
                arity
            ]
            value-path?: func [path [path!] /local value i item selectable][
                selectable: make typeset! [
                    block! paren! path! lit-path! set-path! get-path!
                    object! port! error! map!
                ]
                repeat i length? path [
                    set/any 'value either i = 1 [get/any first path] [
                        set/any 'item pick path i
                        case [
                            get-word? :item [set/any 'item get/any to word! item]
                            paren? :item [set/any 'item do item]
                        ]
                        either integer? :item [pick value item] [select value :item]
                    ]
                    unless find selectable type? get/any 'value [
                        path: copy/part path i
                        break
                    ]
                ]
                reduce [path get/any 'value]
            ]
            fetch-next: func [code [block! paren!] /local i left item item2 value fn-spec path f-arity at-op? op-mode][
                left: reduce [yes]
                while [all [not tail? left not tail? code]] [
                    either not left/1 [
                        remove left
                    ] [
                        item: first code
                        f-arity: any [
                            all [
                                word? :item
                                any-function? set/any 'value get/any :item
                                func-arity?/block fn-spec: spec-of get/any :item
                            ]
                            all [
                                path? :item
                                set/any [path value] value-path? :item
                                any-function? get/any 'value
                                func-arity?/block/with
                                fn-spec: spec-of :value
                                at :item length? :path
                            ]
                        ]
                        if at-op?: all [
                            1 < length? code
                            word? item2: second code
                            op? get/any :item2
                        ] [
                            if all [f-arity 1 < length? f-arity] [
                                at-op?: word! = arg-mode? fn-spec 1
                            ]
                        ]
                        case [
                            at-op? [
                                code: next code
                                left/1: word! = arg-mode? spec-of get/any :item2 2
                            ]
                            f-arity [
                                if op? get/any 'value [return skip code 2]
                                remove left
                                repeat i length? f-arity [insert at left i word! = f-arity/:i]
                            ]
                            not find [set-word! set-path!] type?/word item [
                                remove left
                            ]
                        ]
                    ]
                    code: next code
                ]
                code
            ]
            eval: func [code [block! paren!] cmd [issue!] /local after expr][
                after: fetch-next code
                expr: copy/part code after
                if trace? [print ["preproc:" mold cmd mold expr]]
                expr: do-code expr cmd
                if trace? [print ["preproc: ==" mold expr]]
                reduce [expr after]
            ]
            do-macro: func [name pos [block! paren!] arity [integer!] /local cmd saved p v res][
                depth: depth + 1
                saved: s
                parse next pos [arity [s: macros | skip]]
                cmd: make block! 1
                append cmd name
                insert/part tail cmd next pos arity
                if trace? [print ["preproc: eval macro" mold cmd]]
                p: next cmd
                forall p [
                    switch type?/word v: p/1 [
                        word! [change p to lit-word! v]
                        path! [change/only p to lit-path! v]
                    ]
                ]
                if unset? set/any 'res do bind cmd exec [
                    print ["*** Macro Error: no value returned by" name "macro^/"]
                    do-quit
                ]
                if trace? [print ["preproc: ==" mold :res]]
                s: saved
                s/1: :res
                if positive? depth: depth - 1 [
                    saved: s
                    parse s [s: macros]
                    s: saved
                ]
                s/1
            ]
            register-macro: func [spec [block!] /local cnt rule p name macro pos valid? named?][
                named?: set-word? spec/1
                cnt: 0
                rule: make block! 10
                valid?: parse spec/3 [
                    any [
                        opt string!
                        opt block!
                        [word! (cnt: cnt + 1) | /local any word!]
                        opt [
                            p: block! :p into [some word!]
                        ]
                    ]
                ]
                if any [
                    not valid?
                    all [
                        not named?
                        any [cnt <> 2 all [block? spec/1 empty? spec/1]]
                    ]
                ] [
                    print [
                        "*** Macro Error: invalid specification^/"
                        "*** Where:" mold copy/part spec 3
                    ]
                    do-quit
                ]
                either named? [
                    repend rule [
                        name: to lit-word! spec/1
                        to-paren compose [change/part s do-macro (:name) s (cnt) (cnt + 1)]
                        to get-word! 's
                    ]
                    append protos copy/part spec 4
                ] [
                    macro: do bind copy/part next spec 3 exec
                    repend rule [
                        to set-word! 's
                        spec/1
                        to set-word! 'e
                        to-paren compose/deep either all [
                            block? spec/3/1 find spec/3/1 'manual
                        ] [
                            [s: do-safe/manual [(:macro) s e]]
                        ] [
                            [s: change/part s do-safe [(:macro) s e] e]
                        ]
                        to get-word! 's
                    ]
                ]
                pos: tail macros
                either tag? macros/1 [remove macros] [insert macros '|]
                insert macros rule
                new-line pos yes
                exec: make exec protos
                rebind-all
            ]
            reset: func [job [object! none!]][
                exec: do [context [config: job]]
                clear protos
                insert clear macros <none>
            ]
            expand: func [
                code [block! paren!] job [object! none!]
                /clean
                /local rule e pos cond value then else cases body keep? expr src saved file new
            ][
                either clean [reset job] [exec/config: job]
                rule: [
                    any [
                        s: macros
                        | 'routine 2 skip
                        | #system skip
                        | #system-global skip
                        | s: #include (
                            if active? [
                                either all [not Rebol system/state/interpreted?] [
                                    saved: s
                                    attempt [expand load s/2 job]
                                    s: saved
                                    s/1: 'do
                                ] [
                                    attempt [
                                        src: red/load-source/hidden clean-path join red/main-path s/2
                                        expand src job
                                    ]
                                ]
                            ]
                        )
                        | s: #include-binary [file! | string!] (
                            if active? [
                                either all [not Rebol system/state/interpreted?] [
                                    s/1: 'read/binary
                                    if string? s/2 [s/2: to-red-file s/2]
                                ] [
                                    file: either string? s/2 [to-rebol-file s/2] [s/2]
                                    file: clean-path join red/main-path file
                                    change/part s read/binary file 2
                                ]
                            ]
                        )
                        | s: #if (set [cond e] eval next s s/1) :e [set then block! | (syntax-error s e)] e: (
                            if active? [either cond [change/part s then e] [remove/part s e]]
                        ) :s
                        | s: #either (set [cond e] eval next s s/1) :e
                        [set then block! set else block! | (syntax-error s e)] e: (
                            if active? [either cond [change/part s then e] [change/part s else e]]
                        ) :s
                        | s: #switch (set [cond e] eval next s s/1) :e [set cases block! | (syntax-error s e)] e: (
                            if active? [
                                body: any [select cases cond select cases #default]
                                either body [change/part s body e] [remove/part s e]
                            ]
                        ) :s
                        | s: #case [set cases block! | e: (syntax-error s e)] e: (
                            if active? [
                                until [
                                    set [cond cases] eval cases s/1
                                    any [cond tail? cases: next cases]
                                ]
                                either cond [change/part s cases/1 e] [remove/part s e]
                            ]
                        ) :s
                        | s: #do (keep?: no) opt ['keep (keep?: yes)] [block! | (syntax-error s next s)] e: (
                            if active? [
                                pos: pick [3 2] keep?
                                if trace? [print ["preproc: eval" mold s/:pos]]
                                saved: s
                                expr: do-code s/:pos s/1
                                s: saved
                                if all [keep? trace?] [print ["preproc: ==" mold expr]]
                                either keep? [s: change/part s :expr e] [remove/part s e]
                            ]
                        ) :s
                        | s: #local [block! | (syntax-error s next s)] e: (
                            repend stack [negate length? macros tail protos]
                            saved: s
                            new: expand s/2 job
                            s: saved
                            change/part s new e
                            clear take/last stack
                            remove/part macros skip tail macros take/last stack
                            if tail? next macros [macros/1: <none>]
                        ) :s
                        | s: #reset (reset job remove s) :s
                        | s: #trace [[
                            ['on (trace?: on) | 'off (trace?: off)] (remove/part s 2) :s
                        ] | (syntax-error s next s)]
                        | s: #process [[
                            'on (active?: yes remove/part s 2) :s
                            | 'off (active?: no remove/part s 2) :s [to #process | to end (active?: yes)]
                        ] | (syntax-error s next s)]
                        | s: #macro [
                            [set-word! | word! | lit-word! | block!] ['func | 'function] block! block!
                            | (syntax-error s skip s 4)
                        ] e: (
                            register-macro next s
                            remove/part s e
                        ) :s
                        | pos: [block! | paren!] :pos into rule
                        | skip
                    ]
                ]
                unless Rebol [rule/1: 'while]
                parse code rule
                code
            ]
        ]
        protos: unset
        macros: unset
        syms: unset
        do-quit: unset
        syntax-error: unset
        do-code: unset
        rebind-all: unset
        count-args: unset
        arg-mode?: unset
        func-arity?: unset
        value-path?: unset
        fetch-next: unset
        do-macro: unset
        register-macro: unset
        fun-stk: unset
        expr-stk: unset
        watching: unset
        profiling: unset
        indent: unset
        hist-length: unset
        dbg-usage: unset
        indent?: unset
        calc-max: unset
        show-context: unset
        show-parents: unset
        show-stack: unset
        show-watching: unset
        do-command: unset
        debugger: unset
        tracers: unset
        emit: unset
        opening-marker: unset
        closing-markers: unset
        mold-part: unset
        top-of: unset
        mold-size: unset
        free: unset
        func-depth: unset
        subexprs: unset
        save-level: unset
        unroll-level: unset
        fixed-width: unset
        last-path: unset
        constants: unset
        type-names: unset
        ignored-words: unset
        fetched-index: unset
        fetched'-index: unset
        profiler: unset
        do-handler: unset
        overlap?: func [
            {Return TRUE if the two faces bounding boxes are overlapping}
            A [object!] "First face"
            B [object!] "Second face"
            return: [logic!] "TRUE if overlapping"
            /local A1 B1 A2 B2
        ][
            A1: A/offset
            B1: B/offset
            A2: A1 + A/size
            B2: B1 + B/size
            to logic! all [A1/x < B2/x B1/x < A2/x A1/y < B2/y B1/y < A2/y]
        ]
        distance?: func [
            {Returns the distance between 2 points or face centers}
            A [object! planar!] "First face or point"
            B [object! planar!] "Second face or point"
            return: [float!] "Distance between them"
            /local d
        ][
            A: either object? A [A/offset * 2 + A/size] [A * 2]
            B: either object? B [B/offset * 2 + B/size] [B * 2]
            d: B - A
            d/x ** 2 + (d/y ** 2) ** 0.5 / 2
        ]
        offset-to-char: func [
            {Given a coordinate, returns the corresponding character position}
            face [object!]
            pt [planar!]
            return: [integer!]
        ][
            system/view/platform/text-box-metrics face pt 5
        ]
        rtd: unset
        color-stk: unset
        s-idx: unset
        cur: unset
        pos1: unset
        nested: unset
        f-args: unset
        style!: unset
        tail-idx?: unset
        push-color: unset
        pop-color: unset
        close-colors: unset
        pop-all: unset
        optimize: unset
        metrics?: func [
            {Returns a pair! value in the type metrics for the argument face}
            face [object!] "Face object to query"
            type [word!] "Metrics type: 'paddings or 'margins"
            /total "Return the addition of metrics along an axis"
            axis [word!] "Axis to use for addition: 'x or 'y"
            /local res
        ][
            res: select system/view/metrics/:type face/type
            all [
                face/options
                type: face/options/class
                res: find res type
                res: next res
            ]
            either total [
                axis: any [select [x 1 y 2] axis 1]
                res/:axis/x + res/:axis/y
            ] [res]
        ]
        edge: unset
        anti-alias?: unset
        shadow: unset
        padding: unset
        event-port: unset
        screen-size: unset
        dpi: unset
        capture-events: unset
        capturing?: unset
        GPU?: unset
        mouse-event?: unset
        make-null-handle: unset
        ctx||479~make-null-handle: unset
        fetch-all-screens: unset
        ctx||479~fetch-all-screens: unset
        ctx||479~get-current-screen: unset
        all-windows-closed?: unset
        refresh-screens: unset
        get-screen-size: unset
        ctx||479~get-screen-size: unset
        ctx||479~size-text: unset
        ctx||479~on-change-facet: unset
        update-text: unset
        ctx||479~update-text: unset
        ctx||479~update-font: unset
        ctx||479~update-para: unset
        ctx||479~destroy-view: unset
        ctx||479~detach-image: unset
        ctx||479~update-view: unset
        ctx||479~refresh-window: unset
        ctx||479~redraw: unset
        ctx||479~show-window: unset
        ctx||479~make-view: unset
        ctx||479~draw-image: unset
        ctx||479~draw-face: unset
        ctx||479~do-event-loop: unset
        ctx||479~exit-event-loop: unset
        ctx||479~request-font: unset
        ctx||479~request-file: unset
        ctx||479~request-dir: unset
        ctx||479~text-box-metrics: unset
        ctx||479~update-scroller: unset
        ctx||479~set-dark-mode: unset
        ctx||479~support-dark-mode?: unset
        ctx||479~toggle-GPU: unset
        product: unset
        extras: unset
        GUI-rules: unset
        processors: unset
        cancel-captions: unset
        general: unset
        spacing: unset
        pos-size!: unset
        containers: unset
        default-font: unset
        opt-as-integer: unset
        calc-size: unset
        align-faces: unset
        resize-child-panels: unset
        clean-style: unset
        process-draw: unset
        preset-focus: unset
        add-option: unset
        add-flag: unset
        add-bounds: unset
        fetch-value: unset
        fetch-argument: unset
        fetch-expr: unset
        make-actor: unset
        do-no-sync: func [
            "Evaluate CODE with view/auto-sync?: off"
            code [block!]
            /local r e old
        ][
            old: system/view/auto-sync?
            system/view/auto-sync?: no
            e: try/all [set/any 'r do code 'ok]
            system/view/auto-sync?: old
            if error? e [do :e]
            :r
        ]
        insert-event-func: func [
            {Adds a function to monitor global events. Returns the function}
            name [word!]
            fun [block! function!] "A function or a function body block"
            /local svh
        ][
            if block? :fun [fun: apply :function [copy [face event] fun]]
            if any [
                find svh: system/view/handlers name
                find/same svh :fun
            ] [
                return none
            ]
            insert svh reduce [name :fun]
            :fun
        ]
        remove-event-func: func [
            "Removes an event function previously added"
            id [word! function!] "Handler name or function reference"
            /local svh pos
        ][
            svh: system/view/handlers
            pos: either word? :id [find svh id] [back find svh :id]
            remove/part pos 2
        ]
        alert: func [
            {Displays an alert message in a pop-up modal window}
            msg [string! block!] "Message to display"
        ][
            view/flags compose [
                title "Message"
                below center
                text 200 (form reduce msg) center
                button focus "OK" [unview] on-key [
                    switch event/key [
                        #"^M" #"^[" #" " #"^O" [unview]
                    ]
                ]
            ] 'modal
        ]
        dragging: unset
        ~anon538~: unset
        field-sync: unset
        ~anon540~: unset
        non-line-ws: unset
        ws*: unset
        ws+: unset
        non-zero-digit: unset
        hex-char: unset
        chars: unset
        not-word-char: unset
        word-1st: unset
        word-char: unset
        sign: unset
        frac: unset
        numeric-literal: unset
        string-literal: unset
        json-esc-ch: unset
        unescape: unset
        ctx||542~unescape: unset
        json-object: unset
        property-list: unset
        property: unset
        json-name: unset
        array-list: unset
        json-array: unset
        json-value: unset
        _out: unset
        _res: unset
        _tmp: unset
        _str: unset
        _s: unset
        _e: unset
        line-ct: unset
        last-lf: unset
        indent-level: unset
        normal-chars: unset
        escapes: unset
        init-state: unset
        emit-indent: unset
        emit-key-value: unset
        red-to-json-value: unset
        ignore-empty?: unset
        strict?: unset
        quote-char: unset
        double-quote: unset
        quotable-chars: unset
        parsed?: unset
        non-aligned: unset
        to-csv-line: unset
        escape-value: unset
        next-column-name: unset
        make-header: unset
        get-columns: unset
        encode-map: unset
        encode-maps: unset
        encode-flat: unset
        encode-blocks: unset
        help-ctx: make object! [
            DOC_SEP: "=>"
            DEF_SEP: ""
            NO_DOC: ""
            HELP_ARG_COL_SIZE: 12
            HELP_TYPE_COL_SIZE: 12
            HELP_COL_1_SIZE: 15
            RT_MARGIN: 1
            DENT_1: "    "
            DENT_2: "        "
            NON_CONSOLE_SIZE: 120
            output-buffer: ""
            _print: func [value /fit
            /local line-start width][
                _prin :value
                if fit [
                    line-start: any [find/reverse/tail tail output-buffer newline output-buffer]
                    width: any [all [system/console max 1 system/console/size/x] NON_CONSOLE_SIZE]
                    ellipsize-at line-start width - RT_MARGIN
                ]
                append output-buffer newline
            ]
            _prin: func [value][
                append output-buffer case [
                    string? :value [value]
                    block? :value [form reduce value]
                    char? :value [form value]
                    'else [mold :value]
                ]
            ]
            as-arg-col: func ["Format value as argument column output" value][
                pad form :value HELP_ARG_COL_SIZE
            ]
            as-col-1: func ["Format value as first column output" value][
                pad form :value HELP_COL_1_SIZE
            ]
            as-type-col: func ["Format value as type column output" value [any-type!]][
                pad mold type? :value HELP_TYPE_COL_SIZE
            ]
            dot-str: func ["Add an ending dot if there isn't one" str [string!]][
                append copy str either dot = last str [""] [dot]
            ]
            VAL_FORM_LIMIT: func [][
                either system/console [
                    max 0 system/console/size/x - HELP_COL_1_SIZE - RT_MARGIN
                ] [
                    NON_CONSOLE_SIZE
                ]
            ]
            fmt: func [v /molded][
                if any [molded not string? :v] [v: mold/flat/part :v VAL_FORM_LIMIT + 1]
                :v
            ]
            form-value: func [value [any-type!]][
                case [
                    unset? :value [""]
                    any-function? :value [fmt any [doc-string :value spec-of :value]]
                    any [any-block? value vector? value] [
                        fmt form reduce [
                            "length:" length? value
                            either (index? value) > 1 [form reduce ["index:" index? value]] [""]
                            fmt value
                        ]
                    ]
                    any-object? value [fmt words-of value]
                    map? value [fmt keys-of value]
                    image? value [fmt form reduce ["size:" value/size]]
                    typeset? value [fmt mold to block! value]
                    string? value [fmt/molded value]
                    'else [fmt :value]
                ]
            ]
            get-sys-words: func [test [function!]][
                collect [
                    foreach word words-of system/words [
                        if test get/any word [keep word]
                    ]
                ]
            ]
            longest-word: func [words [block! object! map!]][
                if all [any [object? words map? words] empty? words: words-of words] [return ""]
                forall words [words/1: form words/1]
                sort/compare words func [a b] [(length? a) < (length? b)]
                last words
            ]
            set?: func [value [any-type!]][not unset? :value]
            value-is-type-str: func [value][
                rejoin [mold :value " is " a-an/pre mold type? :value " value."]
            ]
            word-is-value-str: func [
                word [word! path!]
                /only "Don't include value itself"
                /local value
            ][
                value: get/any word
                rejoin [
                    uppercase mold :word " is " a-an/pre mold type? :value " value"
                    either only [dot] [append copy ": " form-value :value]
                ]
            ]
            arg-info: func [
                {Returns name, type, and doc-string for the given word in the spec.}
                spec [block!]
                word [word!]
                /local t d pos
            ][
                t: d: 0
                if pos: find spec word [
                    set [t d] either block? pos/2 [
                        either string? pos/3 [[2 3]] [[2 0]]
                    ] [
                        either string? pos/2 [[0 2]] [[0 0]]
                    ]
                    reduce [word pos/:t dot-str pos/:d]
                ]
            ]
            doc-string: func [
                "Returns the doc string for a function."
                fn [any-function!]
                /local spec
            ][
                spec: spec-of :fn
                all [string? spec/1 dot-str spec/1]
            ]
            ext-word!: make typeset! [word! set-word! lit-word! get-word! refinement! issue!]
            ext-word?: func [value [any-type!]][find ext-word! type? :value]
            func-spec-words: func [
                "Returns all words from a function spec."
                fn [any-function!]
                /opt "Include refinements and their arguments"
                /all {Include return:, /local and what follows; implies /opt}
                /local val blk
            ][
                remove-each val blk: copy spec-of :fn [not ext-word? val]
                if system/words/all [not opt not all] [
                    clear find blk refinement!
                ]
                if not all [
                    remove find blk to set-word! 'return
                    clear find blk /local
                ]
                blk
            ]
            func-spec-ctx: make object! [
                func-spec: make object! [
                    desc: none
                    attr: none
                    params: []
                    refinements: []
                    locals: []
                    returns: []
                ]
                param-frame-proto: [name none type none desc none]
                refinement-frame-proto: [name none desc none params []]
                stack: []
                push: func [val][append/only stack val]
                pop: func [][also take back tail stack cur-frame: last stack]
                push-param-frame: func [][
                    push cur-frame: copy param-frame-proto
                ]
                push-refinement-frame: func [][
                    push cur-frame: copy/deep refinement-frame-proto
                ]
                emit: func [key val
                /local pos][
                    pos: find/only/skip cur-frame key 2
                    head change/only next pos val
                ]
                parse-func-spec: func [
                    {Parses a function spec and returns an object model of it.}
                    spec [block! any-function!]
                    /local =val
                    func-desc= attr-val= func-attr= param-name= param-type= param-desc= param-attr= param= ref-name= ref-desc= ref-param= tmp refinement= locals= returns= return spec= res
                ][
                    clear stack
                    func-desc=: [set =val string! (res/desc: =val)]
                    attr-val=: ['catch | 'throw | 'trace | 'no-trace]
                    func-attr=: [into [copy =val some attr-val= (res/attr: =val)]]
                    param-name=: [
                        set =val [word! | get-word! | lit-word!]
                        (push-param-frame emit 'name =val)
                    ]
                    param-type=: [
                        set =val block! (emit 'type =val) (
                            if not any [
                                parse reduce =val [some [datatype! | typeset!]]
                                parse =val ['function! block!]
                            ] [
                                _print ["Looks like we have a bad type spec:" mold =val]
                            ]
                        )
                    ]
                    param-desc=: [set =val string! (emit 'desc =val)]
                    param-attr=: [opt param-type= opt param-desc=]
                    param=: [param-name= param-attr= (append/only res/params new-line/all pop off)]
                    ref-name=: [set =val refinement! (push-refinement-frame emit 'name =val)]
                    ref-desc=: :param-desc=
                    ref-param=: [param-name= param-attr= (tmp: pop append/only cur-frame/params tmp)]
                    refinement=: [ref-name= opt ref-desc= any ref-param= (append/only res/refinements pop)]
                    locals=: [/local copy =val any word! (res/locals: =val)]
                    returns=: [
                        quote return: (push-param-frame emit 'name 'return)
                        param-type= opt param-desc=
                        (res/returns: pop)
                    ]
                    spec=: [
                        opt func-attr=
                        opt func-desc=
                        any param=
                        any [locals= to end | refinement= | returns=]
                    ]
                    if any-function? :spec [spec: spec-of :spec]
                    res: make func-spec []
                    either parse spec spec= [res] [none]
                ]
            ]
            HELP-USAGE: {^/^-Use HELP or ? to view built-in docs for functions, values ^/^-for contexts, or all values of a given datatype:^/^/^-^-help append^/^-^-? system^/^-^-? function!^/^/^-To search for values by name, use a word:^/^/^-^-? pri^/^-^-? to-^/^/^-To also search in function specs, use a string:^/^/^-^-? "pri"^/^-^-? "issue!"^/^/^-To buffer and return output, rather than printing results, ^/^-use help-string:^/^/^-^-help-string append^/^/^-Other useful functions:^/^/^-^-??     - Display a word and the value it references^/^-^-probe  - Print a molded value^/^-^-source - Show a function's source code^/^-^-what   - Show a list of known functions or words^/^-^-about  - Display version number and build date^/^-^-quit   - Leave the Red console^/^-}
            show-datatype-help: func [
                type [datatype!]
                /local val
                found-at-least-one? word col-1
            ][
                found-at-least-one?: no
                foreach word words-of system/words [
                    col-1: rejoin [DENT_1 as-col-1 word]
                    set/any 'val get/any word
                    if all [not unset? :val type = type? :val (found-at-least-one?: yes)] [
                        _print/fit case [
                            datatype? :val [
                                either system/catalog/accessors/:word [
                                    [col-1 DOC_SEP replace/all mold system/catalog/accessors/:word newline "^/^-"]
                                ] [
                                    [col-1]
                                ]
                            ]
                            any-function? :val [[col-1 DOC_SEP any [doc-string :val ""]]]
                            'else [[col-1 DEF_SEP form-value :val]]
                        ]
                    ]
                ]
                if not found-at-least-one? [
                    _print ["No" type "values were found in the global context."]
                ]
            ]
            form-param: func [param [block!] /no-name
            /local type][
                form reduce [
                    either no-name [""] [as-arg-col mold param/name]
                    either type: select/skip param 'type 2 [mold/flat type] [NO_DOC]
                    either param/desc [mold dot-str param/desc] [NO_DOC]
                ]
            ]
            print-param: func [param [block!] /no-name][
                _print either no-name [form-param/no-name param] [form-param param]
            ]
            show-function-help: func [
                "Displays help information about a function."
                word [word! path!]
                /local fn fn-as-obj param rec
            ][
                fn: either any-function? :word [:word] [get :word]
                if not any-function? :fn [
                    _print {show-function-help only works on words that refer to functions.}
                    exit
                ]
                fn-as-obj: func-spec-ctx/parse-func-spec :fn
                if not object? fn-as-obj [
                    _print "Func spec couldn't be parsed, may be malformed."
                    _print mold :fn
                    exit
                ]
                _print "USAGE:"
                _print either op? :fn [
                    [DENT_1 fn-as-obj/params/1/name word fn-as-obj/params/2/name]
                ] [
                    [DENT_1 uppercase form word mold/only/flat func-spec-words :fn]
                ]
                if fn-as-obj/attr [
                    _print [newline "ATTRIBUTES:^/" DENT_1 mold fn-as-obj/attr]
                ]
                _print [
                    newline "DESCRIPTION:" newline
                    reduce either fn-as-obj/desc [[DENT_1 dot-str trim/lines copy fn-as-obj/desc newline]] [""]
                    DENT_1 word-is-value-str/only word
                ]
                if not empty? fn-as-obj/params [
                    _print [newline "ARGUMENTS:"]
                    foreach param fn-as-obj/params [_print [DENT_1 form-param param]]
                ]
                if not empty? fn-as-obj/refinements [
                    _print [newline "REFINEMENTS:"]
                    foreach rec fn-as-obj/refinements [
                        _print [DENT_1 as-arg-col mold/only rec/name DOC_SEP either rec/desc [dot-str rec/desc] [NO_DOC]]
                        foreach param rec/params [_prin DENT_2 print-param param]
                    ]
                ]
                if not empty? fn-as-obj/returns [
                    _print [newline "RETURNS:"]
                    if fn-as-obj/returns/desc [_print [DENT_1 dot-str fn-as-obj/returns/desc]]
                    _print [DENT_1 mold/flat fn-as-obj/returns/type]
                ]
                exit
            ]
            show-map-help: func [
                "Displays help information about a map."
                word [word! path! map!]
                /local value
                map word-col-wd map-word
            ][
                if map? get word [
                    _print [uppercase form word "is a map! with the following words and values:"]
                ]
                map: either map? word [word] [get word]
                if not map? map [
                    _print {show-map-help only works on words that refer to maps.}
                    exit
                ]
                word-col-wd: length? longest-word map
                foreach map-word words-of map [
                    set/any 'value map/:map-word
                    _print/fit [
                        DENT_1 pad form map-word word-col-wd DEF_SEP as-type-col :value DEF_SEP
                        either same? :value output-buffer [""] [form-value :value]
                    ]
                ]
            ]
            show-object-help: func [
                "Displays help information about an object."
                word [word! path! object!]
                /local value
                obj word-col-wd obj-word
            ][
                if object? get word [
                    _print [uppercase form word {is an object! with the following words and values:}]
                ]
                obj: either object? word [word] [get word]
                if not object? obj [
                    _print {show-object-help only works on words that refer to objects.}
                    exit
                ]
                word-col-wd: length? longest-word obj
                foreach obj-word words-of obj [
                    set/any 'value get/any obj-word
                    _print/fit [
                        DENT_1 pad form obj-word word-col-wd DEF_SEP as-type-col :value DEF_SEP
                        either same? :value output-buffer [""] [form-value :value]
                    ]
                ]
            ]
        ]
        DOC_SEP: unset
        DEF_SEP: unset
        NO_DOC: unset
        HELP_ARG_COL_SIZE: unset
        HELP_TYPE_COL_SIZE: unset
        HELP_COL_1_SIZE: unset
        RT_MARGIN: unset
        DENT_1: unset
        DENT_2: unset
        NON_CONSOLE_SIZE: unset
        output-buffer: unset
        _print: unset
        _prin: unset
        as-arg-col: unset
        as-col-1: unset
        as-type-col: unset
        dot-str: unset
        VAL_FORM_LIMIT: unset
        fmt: unset
        form-value: unset
        get-sys-words: func [test [function!]][
            collect [
                foreach word words-of system/words [
                    if test get/any word [
                        if #"_" <> first mold word [
                            keep word
                        ]
                    ]
                ]
            ]
        ]
        longest-word: unset
        set?: unset
        value-is-type-str: unset
        word-is-value-str: unset
        arg-info: unset
        doc-string: unset
        ext-word!: unset
        ext-word?: unset
        func-spec-words: unset
        func-spec-ctx: unset
        func-spec: unset
        param-frame-proto: unset
        refinement-frame-proto: unset
        push-param-frame: unset
        push-refinement-frame: unset
        HELP-USAGE: unset
        show-datatype-help: unset
        form-param: unset
        print-param: unset
        show-function-help: unset
        show-map-help: unset
        show-object-help: unset
        fetch-help: func [
            {Returns information about functions, values, objects, and datatypes.}
            'word [any-type!] "Omit the word arg for HELP usage."
            /local ref-given? value
        ][
            clear output-buffer
            case [
                unset? :word [_print HELP-USAGE]
                string? :word [what/with/spec/buffer word]
                all [word? :word unset? get/any :word] [what/with/buffer word]
                'else [
                    ref-given?: any [word? :word path? :word]
                    value: either ref-given? [get/any :word] [:word]
                    case [
                        all [ref-given? any-function? :value] [show-function-help :word]
                        any-function? :value [_print mold :value]
                        datatype? :value [show-datatype-help :value]
                        object? :value [show-object-help word]
                        map? :value [show-map-help word]
                        all [ref-given? any [any-block? :value vector? :value]] [_print/fit [word-is-value-str/only :word DEF_SEP form-value :value]]
                        image? :value [
                            either all [in system 'view :system/view] [view [image value]] [
                                _print/fit form-value value
                            ]
                        ]
                        all [path? :word object? :value] [show-object-help word]
                        ref-given? [_print word-is-value-str word]
                        'else [_print value-is-type-str :word]
                    ]
                ]
            ]
            output-buffer
        ]
        about: func [
            "Print Red version information"
            /debug {Print full Red and OS version information suitable for submitting issues}
            /cc "Also copy to clipboard"
            /local git plt txt
        ][
            git: system/build/git
            plt: os-info
            either debug [
                txt: either git [
                    form reduce [
                        "-----------RED & PLATFORM VERSION-----------" lf
                        "RED: [ branch:" mold git/branch "tag:" mold git/tag "ahead:" git/ahead
                        "date:" to-UTC-date git/date "commit:" mold git/commit "]^/"
                        "PLATFORM: [ name:" mold plt/name "OS:" mold to lit-word! system/platform
                        "arch:" mold to lit-word! plt/arch "version:" mold plt/version
                        "build:" mold plt/build "]^/"
                        "--------------------------------------------"
                    ]
                ] [
                    {Looks like this Red binary has been built from source.^/Please download latest build from our website:^/https://www.red-lang.org/p/download.html^/and try your code on it before submitting an issue.}
                ]
            ] [
                txt: reduce [
                    'Red system/version
                    'for system/platform
                    'built any [all [git git/date] system/build/date]
                ]
                if git [
                    repend txt [" commit" copy/part mold system/build/git/commit 8]
                ]
                txt: form txt
            ]
            if cc [write-clipboard txt]
            print txt
        ]
        def-prompt: unset
        def-result: unset
        gui?: unset
        read-argument: unset
        ctx||623~init: unset
        delimiter-map: unset
        delimiter-lex: unset
        check-delimiters: unset
        try-do: unset
        cue: unset
        mode: unset
        eval-command: unset
        run: unset
        launch: unset
        ls: func [{Display a directory listing, for the current dir if none is given} 'dir [any-type!]][list-dir :dir]
        ll: func [{Display a single column directory listing, for the current dir if none is given} 'dir [any-type!]][list-dir/col :dir 1]
        pwd: func [{Displays the active directory path (Print Working Dir)}][print mold system/options/path]
        cd: func [
            "Changes the active directory path"
            :dir [file! word! path!] {New active directory of relative path to the new one}
        ][
            change-dir :dir
        ]
        has-common-part?: unset
        common-substr: unset
        red-complete-path: unset
        red-complete-file: unset
        red-complete-input: func [
            str [string!]
            console? [logic!]
            /local
            word ptr result sys-word delim? len insert?
            start end delimiters d w change?
        ][
            has-common-part?: no
            result: make block! 4
            delimiters: [#"^-" #" " #"[" #"(" #":" #"'" #"{"]
            delim?: no
            insert?: not tail? str
            len: (index? str) - 1
            end: str
            ptr: str: head str
            foreach d delimiters [
                word: find/last/tail/part str d len
                if all [word (index? ptr) < (index? word)] [ptr: word]
            ]
            either head? ptr [start: str] [start: ptr delim?: yes]
            word: copy/part start end
            unless empty? word [
                case [
                    all [
                        #"%" = word/1
                        1 < length? word
                    ] [
                        append result 'file
                        append result red-complete-file word console?
                    ]
                    all [
                        #"/" <> word/1
                        ptr: find word #"/"
                        #" " <> pick ptr -1
                    ] [
                        append result 'path
                        append result red-complete-path word console?
                    ]
                    true [
                        append result 'word
                        foreach w words-of system/words [
                            if value? w [
                                sys-word: mold w
                                if find/match sys-word word [
                                    append result sys-word
                                ]
                            ]
                        ]
                        if ptr: find result word [swap next result ptr]
                        if console? [common-substr next result]
                    ]
                ]
            ]
            if console? [result: next result]
            if all [console? any [has-common-part? 1 = length? result]] [
                if word = result/1 [
                    unless has-common-part? [clear result]
                ]
                unless empty? result [
                    either any [insert? delim?] [
                        str: append copy/part str start result/1
                        poke result 1 tail str
                        if insert? [append str end]
                    ] [
                        poke result 1 tail result/1
                    ]
                ]
            ]
            result
        ]
        _dst: unset
        _theme: unset
        lex: unset
        tips!: make object! [
            type: 'panel
            offset: 0x0
            size: 150x200
            text: none
            image: none
            color: 0.0.128
            menu: none
            data: none
            enabled?: true
            visible?: true
            selected: none
            flags: none
            options: none
            parent: none
            pane: none
            state: none
            rate: none
            edge: none
            para: none
            font: none
            actors: make object! [
                on-key-down: func [face [object!] event [event!]][
                    probe event/key
                ]
            ]
            extra: none
            draw: none
        ]
        ctx||653~on-change*: unset
        ctx||653~on-deep-change*: unset
        cfg-dir: unset
        cfg-path: unset
        cfg: unset
        ctx||660~on-change*: unset
        ctx||660~on-deep-change*: unset
        caret-clr: unset
        caret-rate: unset
        ctx||662~on-change*: unset
        focused?: unset
        console-menu: unset
        ctx||664~on-change*: unset
        ctx||664~on-deep-change*: unset
        ctx||682~on-change*: unset
        ctx||682~on-deep-change*: unset
        tips: unset
        ctx||687~on-change*: unset
        ctx||687~on-deep-change*: unset
        nlines: unset
        heights: unset
        ask?: unset
        prin?: unset
        newline?: unset
        mouse-up?: unset
        ime-open?: unset
        ime-pos: unset
        redraw-cnt: unset
        line-pos: unset
        scroll-y: unset
        line-y: unset
        line-h: unset
        char-width: unset
        page-cnt: unset
        line-cnt: unset
        screen-cnt: unset
        screen-cnt-saved: unset
        hist-idx: unset
        hist-line: unset
        hist-pos: unset
        clip-buf: unset
        paste-cnt: unset
        ctx||691~on-change*: unset
        ctx||691~on-deep-change*: unset
        undo-stack: unset
        redo-stack: unset
        tab-size: unset
        select-bg: unset
        pad-left: unset
        scrolling: unset
        scroll-pos: unset
        color?: unset
        do-ask-loop: unset
        vprin: unset
        vprint: unset
        reset-buffer: unset
        add-lines: unset
        calc-last-line: unset
        calc-top: unset
        reset-top: unset
        update-theme: unset
        update-caret: unset
        offset-to-line: unset
        mouse-to-caret: unset
        select-to-offset: unset
        jump-word: unset
        select-text: unset
        move-caret: unset
        scroll-lines: unset
        cut: unset
        undo: unset
        do-completion: unset
        fetch-history: unset
        delete-selected: unset
        delete-text: unset
        clear-stack: unset
        mark-selects: unset
        toggle-mouse-mode: unset
        fstk-logo: unset
        set-background: unset
        set-font-color: unset
        display-about: unset
        show-cfg-dialog: unset
        apply-cfg: unset
        check-cfg: unset
        load-cfg: unset
        win-menu: unset
        show-shortcuts: unset
        toggle-menu-bar: unset
        setup-faces: unset
        add-gui-print: unset
        ctx||658~add-gui-print: unset
        select-key*: unset
        ~anon830~: unset
        ctx||841~on-change*: unset
        ctx||841~on-deep-change*: unset
        command: unset
        away: unset
        page-left: unset
        page-right: unset
        F1: unset
        F2: unset
        F3: unset
        F4: unset
        F5: unset
        F6: unset
        F7: unset
        F8: unset
        F9: unset
        F10: unset
        F11: unset
        left-shift: unset
        right-shift: unset
        left-control: unset
        right-control: unset
        left-alt: unset
        right-alt: unset
        left-menu: unset
        right-menu: unset
        left-command: unset
        right-command: unset
        caps-lock: unset
        num-lock: unset
        scroll-lock: unset
        pause: unset
        any-interesting?: func [{Returns true if the value is any type of any-function} value [any-type!]][find types type? :value]
    ]
    platform: 'Windows
    catalog: make object! [
        datatypes: none
        actions: none
        natives: none
        accessors: [
            date! [
                date year month day zone time hour minute second weekday yearday
                timezone week isoweek julian
            ]
            email! [user host]
            event! [
                type face window offset key picked flags orientation away? down? mid-down?
                alt-down? aux-down? ctrl? shift?
            ]
            image! [size argb rgb alpha]
            pair! [x y]
            point2D! [x y]
            point3D! [x y z]
            time! [hour minute second]
            money! [code amount]
        ]
        errors: make object! [
            throw: make object! [
                code: 0
                type: "Throw Error"
                break: "no loop to break"
                return: "return or exit not in function"
                throw: ["no catch for throw:" :arg1]
                continue: "no loop to continue"
                while-cond: {BREAK/CONTINUE cannot be used in WHILE condition block}
            ]
            note: make object! [
                code: 100
                type: "note"
                no-load: ["cannot load: " :arg1]
            ]
            syntax: make object! [
                code: 200
                type: "Syntax Error"
                invalid: [:arg1 "invalid" :arg2 "at" :arg3]
                missing: [:arg1 "missing" :arg2 "at" :arg3]
                no-header: ["script is missing a Red header:" :arg1]
                no-rs-header: ["script is missing a Red/System header:" :arg1]
                bad-header: ["script header is not valid:" :arg1]
                malconstruct: [:arg1 "invalid construction spec at" :arg2]
                bad-char: [:arg1 "invalid character at" :arg2]
            ]
            script: make object! [
                code: 300
                type: "Script Error"
                no-value: [:arg1 "has no value"]
                need-value: [:arg1 "needs a value"]
                not-defined: [:arg1 "word is not bound to a context"]
                not-in-context: ["context for" :arg1 "is not available"]
                no-arg: [:arg1 "is missing its" :arg2 "argument"]
                expect-arg: [:arg1 "does not allow" :arg2 "for its" :arg3 "argument"]
                expect-val: ["expected" :arg1 "not" :arg2]
                expect-type: [:arg1 :arg2 "field must be of type" :arg3]
                cannot-use: ["cannot use" :arg1 "on" :arg2 "value"]
                invalid-arg: ["invalid argument:" :arg1]
                invalid-type: [:arg1 "type is not allowed here"]
                invalid-type-spec: ["invalid type specifier:" :arg1]
                invalid-key-type: ["invalid key type:" :arg1]
                invalid-op: ["invalid operator:" :arg1]
                no-op-arg: [:arg1 "operator is missing an argument"]
                bad-op-spec: {making an op! requires a function with only 2 arguments and no lit/get-word on left argument}
                invalid-data: ["data not in correct format:" :arg1]
                invalid-part: ["invalid /part count:" :arg1]
                not-same-type: "values must be of the same type"
                not-same-class: ["cannot coerce" :arg1 "to" :arg2]
                not-related: ["incompatible argument for" :arg1 "of" :arg2]
                bad-func-def: ["invalid function definition:" :arg1]
                bad-func-arg: ["function argument" :arg1 "is not valid"]
                bad-func-extern: ["invalid /extern value:" :arg1]
                no-refine: [:arg1 "has no refinement called" :arg2]
                bad-refines: "incompatible or invalid refinements"
                bad-refine: ["invalid refinement value:" :arg1]
                dup-refine: ["duplicate refinement usage in:" :arg1]
                word-first: ["path must start with a word:" :arg1]
                empty-path: "cannot evaluate an empty path value"
                unset-path: [:arg2 "is unset in path" :arg1]
                invalid-path: ["cannot access" :arg2 "in path" :arg1]
                invalid-path-set: ["unsupported type in" :arg1 "set-path"]
                invalid-path-get: ["unsupported type in" :arg1 "get-path"]
                bad-path-type: [:arg3 "returned a" :arg2 "value, so" :arg1 "could not be accessed"]
                bad-path-type2: ["path element >" :arg1 "< does not apply to" :arg2 "type"]
                bad-path-set: ["cannot set" :arg2 "in path" :arg1]
                bad-field-set: ["cannot set" :arg1 "field to" :arg2 "datatype"]
                dup-vars: ["duplicate variable specified:" :arg1]
                past-end: "out of range or past end"
                missing-arg: "missing a required argument or refinement"
                out-of-range: ["value out of range:" :arg1]
                invalid-chars: "contains invalid characters"
                invalid-compare: ["cannot compare" :arg1 "with" :arg2]
                wrong-type: ["datatype assertion failed for:" :arg1]
                invalid-refine-arg: ["invalid" :arg1 "argument:" :arg2]
                type-limit: [:arg1 "overflow/underflow"]
                size-limit: ["maximum limit reached:" :arg1]
                no-return: "block did not return a value"
                throw-usage: "invalid use of a thrown error value"
                locked-word: ["protected word - cannot modify:" :arg1]
                protected: "protected value or series - cannot modify"
                bad-bad: [:arg1 "error:" :arg2]
                bad-make-arg: ["cannot MAKE" :arg1 "from:" :arg2]
                bad-to-arg: ["cannot MAKE/TO" :arg1 "from:" :arg2]
                invalid-months: "invalid system/locale/month list"
                invalid-spec-field: ["invalid" :arg1 "field in spec block"]
                missing-spec-field: [:arg1 "not found in spec block"]
                move-bad: ["Cannot MOVE elements from" :arg1 "to" :arg2]
                too-long: "Content too long"
                invalid-char: ["Invalid char! value:" :arg1]
                bad-loop-series: ["Loop series changed to invalid value:" :arg1]
                wrong-denom: [:arg1 "not same denomination as" :arg2]
                bad-denom: ["invalid denomination:" :arg1]
                invalid-obj-evt: ["invalid object event handler:" :arg1]
                parse-rule: ["PARSE - invalid rule or usage of rule:" :arg1]
                parse-end: ["PARSE - unexpected end of rule after:" :arg1]
                parse-invalid-ref: ["PARSE - get-word refers to a different series!" :arg1]
                parse-block: ["PARSE - input must be of any-block! type:" :arg1]
                parse-unsupported: {PARSE - matching by datatype not supported for any-string! input}
                parse-infinite: ["PARSE - infinite recursion at rule: [" :arg1 "]"]
                parse-stack: "PARSE - stack limit reached"
                parse-keep: "PARSE - KEEP is used without a wrapping COLLECT"
                parse-into-bad: {PARSE - COLLECT INTO/AFTER invalid series! argument}
                parse-into-type: {PARSE - COLLECT INTO/AFTER expects a series! of compatible datatype}
                invalid-draw: ["invalid Draw dialect input at:" :arg1]
                invalid-data-facet: ["invalid DATA facet content" :arg1]
                face-type: ["VIEW - invalid face type:" :arg1]
                not-window: "VIEW - expected a window root face"
                bad-window: {VIEW - a window face cannot be nested in another window}
                not-linked: "VIEW - face not linked to a window"
                not-event-type: ["VIEW - not a valid event type" :arg1]
                invalid-facet-type: ["VIEW - invalid rate value:" :arg1]
                vid-invalid-syntax: ["VID - invalid syntax at:" :arg1]
                rtd-invalid-syntax: ["RTD - invalid syntax at:" :arg1]
                rtd-no-match: ["RTD - opening/closing tag not matching for:" :arg1]
                react-bad-func: {REACT - /LINK option requires a function! as argument}
                react-not-enough: {REACT - reactive functions must accept at least 2 arguments}
                react-no-match: {REACT - objects block length must match reaction function arg count}
                react-bad-obj: "REACT - target can only contain object values"
                react-gctx: ["REACT - word" :arg1 "is not a reactor's field"]
                lib-invalid-arg: ["LIBRED - invalid argument for" :arg1]
                rb-invalid-record: ["REDBIN - invalid record at index" :arg1]
            ]
            math: make object! [
                code: 400
                type: "Math Error"
                zero-divide: "attempt to divide by zero"
                overflow: "math or number overflow"
                positive: "positive number required"
            ]
            access: make object! [
                code: 500
                type: "Access Error"
                cannot-open: ["cannot open:" :arg1]
                cannot-close: ["cannot close:" :arg1]
                invalid-utf8: ["invalid UTF-8 encoding:" :arg1]
                not-open: ["port is not open:" :arg1]
                no-connect: ["cannot connect:" :arg1 "reason: timeout"]
                no-scheme: ["missing port scheme:" :arg1]
                unknown-scheme: ["scheme is unknown:" :arg1]
                invalid-spec: ["invalid spec or options:" :arg1]
                invalid-port: ["invalid port object (invalid field values)"]
                invalid-actor: ["invalid port actor (must be handle or object)"]
                no-port-action: "port action not supported"
                no-create: ["cannot create:" :arg1]
                no-codec: ["cannot decode or encode (no codec):" :arg1]
                bad-media: ["bad media data (corrupt image, sound, video)"]
                invalid-cmd: ["invalid port command:" :arg1]
            ]
            reserved1: make object! [
                code: 600
                type: "Reserved1 Error"
            ]
            reserved2: make object! [
                code: 700
                type: "Reserved2 Error"
            ]
            user: make object! [
                code: 800
                type: "User Error"
                message: 'arg1
            ]
            internal: make object! [
                code: 900
                type: "Internal Error"
                bad-path: ["bad path:" arg1]
                not-here: [arg1 "not supported on your system"]
                no-memory: "not enough memory"
                wrong-mem: "failed to release memory"
                stack-overflow: "stack overflow"
                limit-hit: ["internal limit reached:" :arg1]
                too-deep: "block or paren series is too deep to process"
                no-cycle: "circular reference not allowed"
                feature-na: "feature not available"
                not-done: "reserved for future use (or not yet implemented)"
                invalid-error: ["invalid error object field value:" :arg1]
                routines: {routines require compilation, from OS shell: `red -r <script.red>`}
                red-system: {contains Red/System code which requires compilation}
                deprecated: [arg1 "is DEPRECATED, please use" arg2 "instead"]
            ]
        ]
    ]
    state: make object! [
        interpreted?: func ["Return TRUE if called from the interpreter"][
            #system [logic/box stack/eval? null no]
        ]
        last-error: none
        stack-trace: 1
        source-files: []
        callbacks: make object! [
            lexer?: false
            parse?: false
            sort?: false
            change?: false
            deep?: false
            port?: false
            bits: 0
        ]
    ]
    modules: []
    codecs: #[
        png: make object! [
            title: ""
            name: 'PNG
            mime-type: [image/png]
            suffixes: [%.png]
            encode: routine [img [image!] where [any-type!]][
                #if not find [Android FreeBSD NetBSD Syllabe] OS [
                    stack/set-last as cell! image/encode img where IMAGE_PNG
                ]
            ]
            decode: routine [data [any-type!]][
                #if not find [Android FreeBSD NetBSD Syllabe] OS [
                    stack/set-last as cell! image/decode data
                ]
            ]
        ]
        jpeg: make object! [
            title: ""
            name: 'JPEG
            mime-type: [image/jpeg]
            suffixes: [%.jpg %.jpeg %.jpe %.jfif]
            encode: routine [img [image!] where [any-type!]][
                #if not find [Android FreeBSD NetBSD Syllabe] OS [
                    stack/set-last as cell! image/encode img where IMAGE_JPEG
                ]
            ]
            decode: routine [data [any-type!]][
                #if not find [Android FreeBSD NetBSD Syllabe] OS [
                    stack/set-last as cell! image/decode data
                ]
            ]
        ]
        bmp: make object! [
            title: ""
            name: 'BMP
            mime-type: [image/bmp]
            suffixes: [%.bmp]
            encode: routine [img [image!] where [any-type!]][
                #if not find [Android FreeBSD NetBSD Syllabe] OS [
                    stack/set-last as cell! image/encode img where IMAGE_BMP
                ]
            ]
            decode: routine [data [any-type!]][
                #if not find [Android FreeBSD NetBSD Syllabe] OS [
                    stack/set-last as cell! image/decode data
                ]
            ]
        ]
        gif: make object! [
            title: ""
            name: 'GIF
            mime-type: [image/gif]
            suffixes: [%.gif]
            encode: routine [img [image!] where [any-type!]][
                #if not find [Android Linux FreeBSD NetBSD Syllabe] OS [
                    stack/set-last as cell! image/encode img where IMAGE_GIF
                ]
            ]
            decode: routine [data [any-type!]][
                #if not find [Android FreeBSD NetBSD Syllabe] OS [
                    stack/set-last as cell! image/decode data
                ]
            ]
        ]
        redbin: make object! [
            title: "Redbin codec"
            name: 'Redbin
            mime-type: []
            suffixes: [%.redbin]
            encode: routine [data [any-type!] where [any-type!]][
                stack/set-last as red-value! redbin/encode data
            ]
            decode: routine [
                payload [any-type!]
            ][
                switch TYPE_OF (payload) [
                    TYPE_URL
                    TYPE_FILE [
                        payload: actions/read* -1 -1 1 -1 -1 -1
                    ]
                    TYPE_BINARY [0]
                    default [fire [TO_ERROR (script invalid-data) payload]]
                ]
                bin: as red-binary! payload
                assert TYPE_OF (bin) = TYPE_BINARY
                if 16 >= binary/rs-length? bin [fire [TO_ERROR (script invalid-data) payload]]
                blk: block/push-only* 0
                redbin/codec?: yes
                redbin/decode binary/rs-head bin blk yes
                if 1 = block/rs-length? blk [blk: as red-block! block/rs-head blk]
                SET_RETURN (blk)
            ]
        ]
        json: make object! [
            Title: "JSON codec"
            Name: 'JSON
            Mime-Type: [application/json]
            Suffixes: [%.json]
            encode: func [data [any-type!] where [file! url! none!]][
                to-json data
            ]
            decode: func [text [string! binary! file!]][
                if file? text [text: read text]
                if binary? text [text: to string! text]
                load-json text
            ]
        ]
        csv: make object! [
            Title: "CSV codec"
            Name: 'CSV
            Mime-Type: [text/csv]
            Suffixes: [%.csv]
            encode: func [data [any-type!] where [file! url! none!]][
                to-csv data
            ]
            decode: func [text [string! binary! file!]][
                if file? text [text: read text]
                if binary? text [text: to string! text]
                load-csv text
            ]
        ]
    ]
    schemes: []
    ports: make object! [    ]
    locale: make object! [
        language: none
        language*: none
        locale: none
        locale*: none
        months: [
            "January" "February" "March" "April" "May" "June"
            "July" "August" "September" "October" "November" "December"
        ]
        days: [
            "Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday" "Sunday"
        ]
        currencies: make object! [
            list: [
                AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BTC BGN BHD BIF BMD BND BOB BRL BSD
                BTN BWP BYN BZD CAD CDF CHF CKD CLP CNY COP CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN
                ETB ETH EUR FJD FKP FOK GBP GEL GGP GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS
                IMP INR IQD IRR ISK JEP JMD JOD JPY KES KGS KHR KID KMF KPW KRW KWD KYD KZT LAK LBP LKR
                LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRU MUR MVR MWK MXN MYR MZN NAD NGN NIO NOK NPR
                NZD OMR PAB PEN PGK PHP PKR PLN PND PRB PYG QAR RED RON RSD RUB RWF SAR SBD SCR SDG SEK
                SGD SHP SLL SLS SOS SRD SSP STN SYP SZL THB TJS TMT TND TOP TRY TTD TVD TWD TZS UAH UGX
                USD UYU UZS VES VND VUV WST CFA XAF XCD XOF CFP XPF YER ZAR ZMW
            ]
        ]
    ]
    options: make object! [
        boot: "D:\EE\QW\red-view-06mar26-698eac0d8.exe"
        home: none
        path: %/D/EE/QW/red/
        script: %red/all-red-builtins.red
        cache: %/C/Users/qtxie/AppData/Roaming/Red/
        thru-cache: none
        args: []
        do-arg: none
        debug: none
        secure: none
        quiet: false
        binary-base: 16
        decimal-digits: 15
        money-digits: 2
        module-paths: []
        file-types: none
        float: make object! [
            pretty?: true
            full?: false
        ]
    ]
    script: make object! [
        title: none
        header: none
        parent: none
        path: none
        args: ""
    ]
    standard: make object! [
        header: make object! [
            Title: none
            Name: none
            Type: none
            Version: none
            Date: none
            File: none
            Home: none
            Author: none
            Tabs: none
            Needs: none
            License: none
            Note: none
            History: none
        ]
        port: make object! [
            spec: none
            scheme: none
            actor: none
            awake: none
            state: none
            data: none
            extra: none
        ]
        error: make object! [
            code: none
            type: none
            id: none
            arg1: none
            arg2: none
            arg3: none
            near: none
            where: none
            stack: none
            files: none
        ]
        file-info: make object! [
            name: none
            size: none
            date: none
            type: none
        ]
        url-parts: make object! [
            scheme: none
            user-info: none
            host: none
            port: none
            path: none
            target: none
            query: none
            fragment: none
            ref: none
        ]
        scheme: make object! [
            name: none
            title: none
            info: none
            actor: none
            awake: none
        ]
    ]
    lexer: make object! [
        pre-load: none
        exit-states: [eof error! block! block! paren! paren! string! string! map! path! datatype! comment string! word! issue! integer! refinement! char! file! binary! percent! float! float! tuple! date! pair! time! money! tag! url! email! hex rawstring ref!]
        tracer: func [
            event [word!]
            input [string! binary!]
            type [datatype! word! none!]
            line [integer!]
            token
            return: [logic!]
        ][
            print [
                uppercase pad event 8
                pad mold type 12
                pad mold/part token 12 12
                pad line 4
                mold/part input 16
            ]
            either event = 'error [input: next input no] [yes]
        ]
    ]
    console: make object! [
        def-prompt: ">> "
        def-result: "=="
        prompt: ">> "
        result: "=="
        history: ["q" {sort/case "ABCabcdefDEF"} {sort "ABCabcdefDEF"} {sort/stable "ABCabcdefDEF"} "? tracing?" "tracing?" "to-char 128917" "to-char 8217" "to-char 33" "to-char 101" "to-char 117" "to-char 115" "to-char 105" "to-char 58" "to-char 32" "to-char 109" "to-char 91" "to-hex 14911" "q" "to-hex 1560281120" "q" "to-hex 1560281120" "q" "? write" "write %all-red-values.txt buffer" "" "]" "    append buffer newline" "    ]" "^-    append buffer mold spec-of :val" {^-    append buffer " "} "^-    append buffer form type? :val" "    ][" "^-    ]" "^-^-    append buffer mold :val" "^-    if word = 'system [" "    either object? :val [" {    append buffer ": "} "    append buffer mold word" "    val: get word" {foreach word sort get-sys-words :any-interesting? [} "buffer: make string! 50000" "]" "^-]" "^-^-]" "^-^-^-]" "^-^-^-^-]" "^-^-^-^-^-keep word" {^-^-^-^-if #"_" <> first mold word [} "^-^-^-if test get/any word [" "^-^-foreach word words-of system/words [" "^-collect [" "get-sys-words: func [test [function!]][" {any-interesting?: func [{Returns true if the value is any type of any-function} value [any-type!]][find types type? :value]} {types: make typeset! [native! action! function! routine! object!]} "object!" " [a: 2]" "make object! [a: 2]" "make object [a: 2]" "make context! [a: 2]" "make context [a: 2]" "make function! [a b][a + b]" "]" {    a + b                        ; The body of the function} "] [" {    b [integer! decimal!]        ; Argument 'b', restricted to number types} {    a [integer! decimal!]        ; Argument 'a', restricted to number types} {    "Adds two numbers together."  ; Optional help string} "add-numbers: make function! [" {    a + b                        ; The body of the function} "] [" {    b [integer! decimal!]        ; Argument 'b', restricted to number types} {    a [integer! decimal!]        ; Argument 'a', restricted to number types} {    "Adds two numbers together."  ; Optional help string} "make function! []add-numbers: make function! [" "make function! []" "make function! [][]" "make function [][]" "make func [][]" {replace/all "a-b-c" "-" "\\-"} {replace "a-b-c" "-" "\\-"} "? replace" "? rep" "replace" "make block! [32]" "make integer! [32]" "make object! [a: 32]" "make object [a: 3]" "make object []" "x/b/c" "        scope_stack: &mut Vec<String>," "x/b/c" "system/words/x/a" "x/b/c" "]" "c: does [x/a]" "b: context [" "x: does [print 32]" "a: 2" "x: context ["]
        size: 100x38
        catch?: false
        delimiters: []
        ws: make bitset! #{0064000080}
        gui?: true
        read-argument: func [/local value
        args --catch file src =quote= =quoted-switch= s e =normal-switch= path][
            if args: system/script/args [
                args: system/options/args
                --catch: "--catch"
                while [
                    all [
                        not tail? args
                        find/match args/1 "--"
                        args/-1 <> "--"
                    ]
                ] [
                    either --catch <> args/1 [
                        args: next args
                    ] [
                        remove args
                        system/console/catch?: yes
                    ]
                ]
                unless tail? args [
                    file: to-red-file args/1
                    either error? set/any 'src try/keep [read file] [
                        print src
                        src: none
                    ] [
                        system/options/script: file
                        remove/part system/options/args next args =quote=: {"}
                        =quoted-switch=: [=quote= "--" s: thru [e: =quote= any ws | end]]
                        =normal-switch=: ["--" s: thru [e: some ws | end]]
                        parse system/script/args [
                            any ws args: any [
                                [=quoted-switch= | =normal-switch=]
                                args: not if (same? s e)
                            ]
                        ]
                        parse args [any [=quote= thru [=quote= | end] | not ws skip] any ws args:]
                        remove/part head args args
                    ]
                    path: first split-path file
                    if path <> %./ [change-dir path]
                ]
                src
            ]
        ]
        init: routine [
            str [string!]
        ][
            #either OS = 'Windows [
                ret: SetConsoleTitle as c-string! string/rs-head str
                if zero? ret [print-line "SetConsoleTitle failed!" halt]
            ] [
                #if gui-console? = no [terminal/pasting?: no]
            ]
            #if gui-console? = no [
                terminal/init
                terminal/init-globals
                size: as red-pair! red/word/get-in exec/ctx||623 5
                if any [zero? size/x zero? size/y] [
                    size/x: 80
                    size/y: 50
                ]
            ]
        ]
        delimiter-map: [block! #"[" paren! #"(" string! #"{" map! #"(" point2D! #"(" path! #"/" lit-path! #"/" get-path! #"/" set-path! #"/"]
        count: func [s [string!] c [char!] /reverse return: [integer!]
        /local cnt step][
            cnt: 0
            step: pick [-1 1] reverse
            loop length? head s [either s/1 = c [cnt: cnt + 1 s: skip s step] [return cnt]]
            cnt
        ]
        delimiter-lex: func [
            event [word!]
            input [string! binary!]
            type [datatype! word! none!]
            line [integer!]
            token
            return: [logic!]
            /local back2 begin end
        ][
            [open close error]
            switch event [
                open [
                    append delimiters delimiter-map/:type
                    true
                ]
                close [
                    if delimiter-map/:type <> last delimiters [throw 'stop]
                    take/last delimiters
                    true
                ]
                error [
                    if type = error! [throw 'stop]
                    if all [
                        find [block! paren! map! point2D!] to-word type
                        delimiter-map/:type = last delimiters
                        not find input #")"
                        not find input #"]"
                    ] [
                        throw 'break
                    ]
                    back2: back back tail delimiters
                    if all [type = paren! #"/" = back2/1] [
                        remove back2
                        throw 'break
                    ]
                    if type = tag! [
                        append delimiters #"<"
                        throw 'break
                    ]
                    if all [
                        type = binary!
                        #"}" <> pick tail input -2
                    ] [
                        append delimiters #"{"
                        throw 'break
                    ]
                    if type = string! [
                        either input/(token/x - token/y) = #"%" [
                            begin: count head input #"%"
                            end: count/reverse back back tail input #"%"
                            if begin > end [
                                append delimiters #"{"
                                throw 'break
                            ]
                        ] [
                            if delimiter-map/:type = last delimiters [
                                throw 'break
                            ]
                        ]
                    ]
                    throw 'stop
                ]
            ]
        ]
        check-delimiters: func [
            buffer [string!]
            return: [logic!]
        ][
            clear delimiters
            'stop <> catch [transcode/trace buffer :delimiter-lex]
        ]
        try-do: func [code return: [any-type!] /local result][
            set/any 'result try/all/keep [
                either 'halt-request = set/any 'result catch/name code 'console [
                    print "(halted)"
                ] [
                    :result
                ]
            ]
            :result
        ]
        line: ""
        buffer: ""
        cue: none
        mode: 'mono
        do-command: func [/local result err p
        code limit prefix][
            if error? code: try/keep [load/all buffer] [print code]
            unless any [error? code tail? code] [
                set/any 'result try-do code
                case [
                    error? :result [
                        print [result lf]
                    ]
                    not unset? :result [
                        if error? set/any 'err try/keep [
                            limit: size/x - 3
                            result: either float? :result [
                                form/part :result limit + 5
                            ] [
                                mold/part :result limit + 5
                            ]
                            if limit < length? result [
                                clear change at result limit - length? prompt "..."
                            ]
                            prefix: any [
                                all [string? set/any 'p try/all [do [system/console/result]] :p]
                                all [error? :p p/where: "system/console/result" print form :p def-result]
                            ]
                            print [prefix result]
                        ] [
                            print :err
                        ]
                    ]
                ]
            ]
            clear buffer
        ]
        eval-command: func [line [string!]][
            if mode = 'mono [clear delimiters]
            if any [not tail? line mode <> 'mono] [
                either all [not empty? line escape = last line] [
                    cue: none
                    clear buffer
                    mode: 'mono
                    print "(escape)"
                ] [
                    cue: none
                    append buffer line
                    append buffer lf
                    either check-delimiters buffer [
                        either empty? delimiters [
                            do-command
                            mode: 'mono
                        ] [
                            mode: 'other
                            cue: rejoin [last delimiters "    "]
                        ]
                    ] [
                        do-command
                        mode: 'mono
                    ]
                ]
            ]
        ]
        run: func [/no-banner /local p][
            unless no-banner [
                print [
                    "--== Red" system/version "==--" lf
                    "Type HELP for starting information." lf
                ]
            ]
            forever [
                eval-command ask any [
                    cue
                    all [string? set/any 'p try/all [do [prompt]] :p]
                    all [error? :p p/where: "system/console/prompt" print :p prompt: def-prompt]
                    form :p
                ]
            ]
        ]
        launch: func [/local result found?
        script src pos][
            either script: src: read-argument [
                parse/case script [some [pos: "Red" opt "/System" any ws #"[" (found?: yes) break | skip]]
                either all [found? script: pos] [
                    either error? script: try-do [load script] [
                        print :script
                    ] [
                        either not all [
                            block? script
                            script: find/case script 'Red
                            block? script/2
                        ] [
                            print [
                                "*** Error:"
                                either find src "Red/System" [
                                    {contains Red/System code which requires compilation!}
                                ] [
                                    "not a Red program!"
                                ]
                            ]
                        ] [
                            expand-directives script
                            set/any 'result try-do skip script 2
                            if error? :result [print result]
                        ]
                    ]
                ] [
                    print "*** Error: Red header not found!"
                ]
                if any [catch? all [gui? gui-console-ctx/win/visible?]] [
                    if all [catch? gui?] [gui-console-ctx/win/visible?: yes]
                    run/no-banner
                ]
            ] [
                run
            ]
        ]
    ]
    view: make object! [
        screens: [make object! [
            type: 'screen
            offset: 0x0
            size: 2048x1152
            text: none
            image: none
            color: none
            menu: none
            data: 1.25
            enabled?: true
            visible?: true
            selected: none
            flags: none
            options: none
            parent: none
            pane: []
            state: [handle! 0 none [1]]
            rate: none
            edge: none
            para: none
            font: none
            actors: none
            extra: none
            draw: none
        ]]
        event-port: none
        metrics: make object! [
            screen-size: none
            dpi: 120
            paddings: #[
                check: [16x0 0x0]
                radio: [16x0 0x0]
                field: [0x8 0x0]
                group-box: [3x3 10x3]
                tab-panel: [1x3 25x0]
                button: [8x8 0x0]
                toggle: [8x8 0x0]
                drop-down: [0x7 0x0]
                drop-list: [0x7 0x0]
                calendar: [21x0 1x0]
            ]
            margins: #[
                button: [1x1 1x1]
                toggle: [1x1 1x1]
                tab-panel: [0x2 0x1]
                group-box: [0x0 0x1]
                calendar: [1x0 0x0]
            ]
            def-heights: #[]
            fixed-heights: #[]
            misc: #[
                scroller: 21x21
            ]
            colors: #[
                text: 0.0.0
                window: 255.255.255
                panel: 240.240.240
                tab-panel: 255.255.255
            ]
        ]
        fonts: make object! [
            system: "Microsoft YaHei UI"
            fixed: "Consolas"
            sans-serif: "Segoe UI"
            serif: "Times New Roman"
            size: 9
        ]
        platform: make object! [
            mouse-event?: true
            make-null-handle: routine [][handle/box 0 handle/CLASS_NULL]
            fetch-all-screens: routine [][
                #either GUI-engine = 'terminal [
                    SET_RETURN (none-value)
                ] [
                    SET_RETURN (gui/OS-fetch-all-screens)
                ]
            ]
            get-current-screen: routine [][
                SET_RETURN (gui/OS-get-current-screen)
            ]
            all-windows-closed?: func [return: [logic!] /local closed? [logic!]][
                foreach screen system/view/screens [
                    if not empty? screen/pane [return no]
                ]
                yes
            ]
            refresh-screens: func [/local svs spec screen][
                svs: system/view/screens
                foreach spec fetch-all-screens [
                    either svs/1 [
                        screen: svs/1
                        screen/offset: spec/1
                        screen/size: to-pair spec/2 / spec/3
                        screen/data: spec/3
                        screen/state/1: spec/4
                    ] [
                        append svs make face! [
                            type: 'screen
                            offset: spec/1
                            size: to-pair spec/2 / spec/3
                            data: spec/3
                            pane: make block! 4
                            state: reduce [spec/4 0 none copy [1]]
                        ]
                    ]
                    svs: next svs
                ]
                unless empty? svs [
                    foreach screen svs [clear screen/pane]
                    clear svs
                ]
            ]
            get-screen-size: routine [
                id [integer!]
            ][
                pair: gui/get-screen-size id
                SET_RETURN (pair)
            ]
            size-text: routine [
                face [object!]
                value [any-type!]
            ][
                values: object/get-values face
                switch TYPE_OF (value) [
                    TYPE_STRING [text: as red-string! value]
                    TYPE_NONE [text: as red-string! values + gui/FACE_OBJ_TEXT]
                    default [fire [TO_ERROR (script invalid-type) datatype/push TYPE_OF (value)]]
                ]
                if TYPE_OF (text) <> TYPE_STRING [
                    SET_RETURN (none-value)
                    exit
                ]
                pt: point2D/push F32_0 F32_0
                gui/get-text-size face text pt
                stack/set-last as red-value! pt
            ]
            on-change-facet: routine [
                owner [object!]
                word [any-word!]
                value [any-type!]
                action [word!]
                new [any-type!]
                index [integer!]
                part [integer!]
            ][
                if TYPE_OF (new) = TYPE_NONE [new: null]
                gui/OS-update-facet owner word value action new index part
            ]
            update-text: routine [face [object!]][
                #if OS = 'Windows [gui/get-text-alt face -1]
                SET_RETURN (none-value)
            ]
            update-font: routine [font [object!] flags [integer!]][
                gui/update-font font flags
                SET_RETURN (none-value)
            ]
            update-para: routine [face [object!] flags [integer!]][
                gui/update-para face flags
                SET_RETURN (none-value)
            ]
            destroy-view: routine [face [object!] empty? [logic!]][
                gui/OS-destroy-view face empty?
                SET_RETURN (none-value)
            ]
            detach-image: routine [img [image!]][
                ownership/unbind as red-value! img
                SET_RETURN (none-value)
            ]
            update-view: routine [face [object!]][
                gui/OS-update-view face
                SET_RETURN (none-value)
            ]
            refresh-window: routine [h [handle!]][
                gui/OS-refresh-window h/value
            ]
            redraw: routine [face [object!]][
                h: as-integer gui/face-handle? face
                if h <> 0 [gui/OS-redraw h]
            ]
            show-window: routine [id [handle!]][
                gui/OS-show-window id/value
                SET_RETURN (none-value)
            ]
            make-view: routine [face [object!] parent [handle!]][
                handle/box gui/OS-make-view face parent/value handle/CLASS_WINDOW
            ]
            draw-image: routine [image [image!] cmds [block!]][
                if any [zero? IMAGE_WIDTH (image/size) zero? IMAGE_HEIGHT (image/size)] [exit]
                gui/OS-do-draw image cmds
                ownership/check as red-value! image words/_poke as red-value! image -1 -1
            ]
            draw-face: routine [face [object!] cmds [block!]][
                flags: gui/get-flags as red-block! (object/get-values face) + gui/FACE_OBJ_FLAGS
                h: gui/face-handle? face
                if h <> null [gui/OS-draw-face h cmds flags]
            ]
            do-event-loop: routine [no-wait? [logic!]][
                bool: as red-logic! stack/arguments
                bool/value: gui/do-events no-wait? null
                bool/header: TYPE_LOGIC
            ]
            exit-event-loop: routine [][
                #switch GUI-engine [
                    native [
                        #switch OS [
                            Windows [gui/PostQuitMessage 0]
                            macOS [gui/post-quit-msg]
                            Linux [gui/post-quit-msg]
                            #default [0]
                        ]
                    ]
                    test []
                    GTK []
                    terminal [gui/post-quit-msg]
                ]
            ]
            request-font: routine [font [object!] selected [any-type!] mono? [logic!]][
                gui/OS-request-font font as red-object! selected mono?
            ]
            request-file: routine [
                title [any-type!]
                name [any-type!]
                filter [any-type!]
                save? [logic!]
                multi? [logic!]
            ][
                stack/set-last gui/OS-request-file
                as red-string! title
                as red-file! name
                as red-block! filter
                save?
                multi?
            ]
            request-dir: routine [
                title [any-type!]
                dir [any-type!]
                filter [any-type!]
                keep? [logic!]
                multi? [logic!]
            ][
                stack/set-last gui/OS-request-dir
                as red-string! title
                as red-file! dir
                as red-block! filter
                keep?
                multi?
            ]
            text-box-metrics: routine [
                box [object!]
                arg0 [any-type!]
                type [integer!]
            ][
                layout?: yes
                values: object/get-values box
                word: as red-word! values + gui/FACE_OBJ_TYPE
                sym: symbol/resolve word/symbol
                if sym <> gui/rich-text [
                    fire [TO_ERROR (script face-type) word]
                ]
                txt: as red-string! values + gui/FACE_OBJ_TEXT
                if TYPE_OF (txt) <> TYPE_STRING [
                    stack/set-last none-value
                    exit
                ]
                #either GUI-engine = 'terminal [
                    stack/set-last gui/OS-text-box-metrics box arg0 type
                ] [
                    state: as red-block! values + gui/FACE_OBJ_EXT3
                    if TYPE_OF (state) = TYPE_BLOCK [
                        bool: as red-logic! (block/rs-tail state) - 1
                        layout?: bool/value
                    ]
                    if layout? [gui/OS-text-box-layout box null 0 no]
                    stack/set-last gui/OS-text-box-metrics state arg0 type
                ]
            ]
            update-scroller: routine [scroller [object!] flags [integer!]][
                gui/update-scroller scroller flags
                SET_RETURN (none-value)
            ]
            set-dark-mode: routine [face [object!] dark? [logic!]][
                word: as red-word! (object/get-values face) + gui/FACE_OBJ_TYPE
                gui/set-dark-mode gui/get-face-handle face dark? gui/window = symbol/resolve word/symbol
            ]
            support-dark-mode?: routine [return: [logic!]][
                gui/support-dark-mode?
            ]
            toggle-GPU: routine [][
                #if GUI-engine <> 'terminal [
                    #switch OS [
                        Windows [gui/DX-create-dev]
                        #default [0]
                    ]
                ]
            ]
            init: func [/local svs colors fonts][
                system/view/screens: svs: make block! 6
                #system [gui/init]
                extend system/view/metrics/margins [
                    button: [1x1 1x1]
                    toggle: [1x1 1x1]
                    tab-panel: [0x2 0x1]
                    group-box: [0x0 0x1]
                    calendar: [1x0 0x0]
                ]
                extend system/view/metrics/paddings [
                    check: [16x0 0x0]
                    radio: [16x0 0x0]
                    field: [0x8 0x0]
                    group-box: [3x3 10x3]
                    tab-panel: [1x3 25x0]
                    button: [8x8 0x0]
                    toggle: [8x8 0x0]
                    drop-down: [0x7 0x0]
                    drop-list: [0x7 0x0]
                    calendar: [21x0 1x0]
                ]
                extend system/view/metrics/fixed-heights []
                if version/1 <= 6 [
                    extend system/view/metrics/def-heights [
                        button: 23
                        toggle: 23
                        text: 24
                        field: 24
                        check: 24
                        radio: 24
                        slider: 24
                        drop-down: 23
                        drop-list: 23
                    ]
                ]
                colors: system/view/metrics/colors
                colors/tab-panel: white
                refresh-screens
                set fonts:
                bind [fixed sans-serif serif] system/view/fonts
                switch system/platform [
                    Windows [
                        case [
                            version >= 6.0.0 [["Consolas" "Segoe UI" "Times New Roman"]]
                            'xp [["Courier New" "Tahoma" "Times New Roman"]]
                        ]
                    ]
                    macOS [
                        case [
                            version >= 10.11.0 [["SF Mono" "San Francisco" "Times"]]
                            version >= 10.10.0 [["Menlo" "Helvetica Neue" "Times"]]
                            'older [["Menlo" "Lucida Grande" "Times"]]
                        ]
                    ]
                    Linux [["Monospace" "DejaVu Sans" "Times New Roman"]]
                    Android [["Roboto Mono" "Roboto" "Noto Serif"]]
                ]
                set [font-fixed font-sans-serif font-serif] reduce fonts
            ]
            version: 10.0.0
            build: 26100
            product: 1
        ]
        VID: make object! [
            styles: #[
                window: [
                    default-actor: on-down
                    template: [type: 'window size: 100x100]
                ]
                base: [
                    default-actor: on-down
                    template: [type: 'base size: 80x80 color: 128.128.128]
                ]
                button: [
                    default-actor: on-click
                    template: [type: 'button size: 60x23 flags: 'focusable]
                ]
                text: [
                    default-actor: on-down
                    template: [type: 'text size: 80x23]
                ]
                field: [
                    default-actor: on-enter
                    template: [type: 'field size: 80x23 flags: 'focusable]
                ]
                area: [
                    default-actor: on-change
                    template: [type: 'area size: 150x150 flags: 'focusable]
                ]
                rich-text: [
                    default-actor: on-change
                    template: [
                        type: 'rich-text size: 150x150 color: 255.255.255
                        tabs: none line-spacing: 'default handles: none
                    ]
                ]
                toggle: [
                    default-actor: on-change
                    template: [type: 'toggle size: 60x23 flags: 'focusable]
                ]
                check: [
                    default-actor: on-change
                    template: [type: 'check size: 80x23 flags: 'focusable]
                ]
                radio: [
                    default-actor: on-change
                    template: [type: 'radio size: 80x23 flags: 'focusable]
                ]
                progress: [
                    default-actor: on-change
                    template: [type: 'progress size: 150x16]
                ]
                slider: [
                    default-actor: on-change
                    template: [type: 'slider size: 150x23 data: 0% flags: 'focusable]
                ]
                scroller: [
                    default-actor: on-change
                    template: [type: 'scroller size: 150x20 data: 0.0 steps: 0.1]
                ]
                camera: [
                    default-actor: on-down
                    template: [type: 'camera size: 250x250 ratio: 0.0]
                ]
                calendar: [
                    default-actor: on-change
                    template: [type: 'calendar size: 139x148 flags: 'focusable]
                ]
                text-list: [
                    default-actor: on-change
                    template: [type: 'text-list size: 100x140 flags: 'focusable]
                ]
                drop-list: [
                    default-actor: on-change
                    template: [type: 'drop-list size: 100x23 flags: 'focusable]
                ]
                drop-down: [
                    default-actor: on-enter
                    template: [type: 'drop-down size: 100x23 flags: 'focusable]
                ]
                panel: [
                    default-actor: on-down
                    template: [type: 'panel size: 200x200]
                ]
                group-box: [
                    default-actor: on-down
                    template: [type: 'group-box size: 50x50]
                ]
                tab-panel: [
                    default-actor: on-select
                    template: [type: 'tab-panel size: 50x50 flags: 'focusable]
                ]
                h1: [
                    default-actor: on-down
                    template: [type: 'text size: 80x24 font: make font! [size: 32]]
                ]
                h2: [
                    default-actor: on-down
                    template: [type: 'text size: 80x24 font: make font! [size: 26]]
                ]
                h3: [
                    default-actor: on-down
                    template: [type: 'text size: 80x24 font: make font! [size: 22]]
                ]
                h4: [
                    default-actor: on-down
                    template: [type: 'text size: 80x24 font: make font! [size: 17]]
                ]
                h5: [
                    default-actor: on-down
                    template: [type: 'text size: 80x24 font: make font! [size: 13]]
                ]
                box: [
                    default-actor: on-down
                    template: [type: 'base size: 80x80 color: none]
                ]
                image: [
                    default-actor: on-down
                    template: [type: 'base size: 100x100]
                    init: [unless image [image: make image! size]]
                ]
            ]
            extras: []
            GUI-rules: make object! [
                active?: true
                debug?: false
                processors: make object! [
                    cancel-captions: ["cancel" "delete" "remove"]
                    color-backgrounds: func [
                        {Color the background of faces with no color, with parent's background color}
                        root [object!]
                    ][
                        foreach-face/with root [face/color: face/parent/color] [
                            all [
                                none? face/color
                                face/parent
                                find [window panel group-box tab-panel] face/parent/type
                                find [text slider radio check group-box tab-panel panel] face/type
                            ]
                        ]
                    ]
                    color-tabpanel-children: func [
                        {Color the background of faces with no color, with parent's background color}
                        root [object!]
                        /local gp
                    ][
                        foreach-face/with root [
                            face/color: any [
                                gp/color
                                system/view/metrics/colors/tab-panel
                            ]
                        ] [
                            all [
                                none? face/color
                                face/parent
                                face/parent/type = 'panel
                                gp: face/parent/parent
                                gp/type = 'tab-panel
                                find [text slider radio check group-box tab-panel] face/type
                            ]
                        ]
                    ]
                    OK-Cancel: func [
                        "Put Cancel buttons last"
                        root [object!]
                        /local pos-x last-but pos-y f
                    ][
                        foreach-face/with root [
                            pos-x: face/offset/x
                            face/offset/x: f/offset/x
                            f/offset/x: pos-x
                        ] [
                            either all [
                                face/type = 'button
                                face/parent
                                find cancel-captions face/text
                            ] [
                                last-but: none
                                pos-x: face/offset/x
                                pos-y: face/offset/y
                                foreach f face/parent/pane [
                                    all [
                                        f <> face
                                        f/type = 'button
                                        5 > absolute f/offset/y - pos-y
                                        pos-x < f/offset/x
                                        pos-x: f/offset/x
                                        last-but: f
                                    ]
                                ]
                                last-but
                            ] [no]
                        ]
                    ]
                ]
                general: []
                OS: [
                    Windows [
                        color-backgrounds
                        color-tabpanel-children
                        OK-Cancel
                    ]
                    macOS [
                        adjust-buttons
                        capitalize
                        Cancel-OK
                    ]
                    Linux []
                ]
                user: []
                process: func [root [object!]
                /local list name][
                    unless active? [exit]
                    foreach list reduce [general select OS system/platform user] [
                        foreach name list [
                            if debug? [print ["Applying rule:" name]]
                            name: get in processors name
                            do [name root]
                        ]
                    ]
                ]
            ]
            debug?: false
            origin: 10x10
            spacing: 10x10
            pos-size!: make typeset! [pair! point2D!]
            containers: [panel tab-panel group-box]
            default-font: [
                name system/view/fonts/system
                size system/view/fonts/size
            ]
            opts-proto: make object! [
                type: none
                offset: none
                size: none
                size-x: none
                text: none
                color: none
                enabled?: none
                visible?: none
                selected: none
                image: none
                rate: none
                font: none
                flags: none
                options: none
                para: none
                data: none
                extra: none
                actors: none
                draw: none
                now?: none
                init: none
            ]
            throw-error: func [spec [block!]][
                either system/view/silent? [
                    throw/name 'silent 'silenced
                ] [
                    cause-error 'script 'vid-invalid-syntax [copy/part spec 3]
                ]
            ]
            process-reactors: func [reactors [block!] /local res
            f blk later? ctx face][
                set 'res try/all [
                    foreach [f blk later?] reactors [
                        blk: copy/deep blk
                        either f [
                            bind blk ctx: context [face: f]
                            either later? [react/later/with blk ctx] [react/with blk ctx]
                        ] [
                            either later? [react/later blk] [react blk]
                        ]
                    ]
                ]
                if error? :res [do res]
            ]
            opt-as-integer: func [value [integer! float!]
            /local i][
                either all [float? value zero? value - i: to integer! value] [i] [value]
            ]
            calc-size: func [face [object!]
            /local min-sz data txt s len mark e new][
                case [
                    find [text-list drop-list drop-down] face/type [
                        min-sz: 0x0
                        either all [
                            block? data: face/data
                            not empty? data
                        ] [
                            foreach txt data [
                                if any-string? txt [min-sz: max min-sz size-text/with face as string! txt]
                            ]
                        ] [min-sz: size-text/with face "X"]
                        if all [face/text face/type <> 'drop-list] [
                            min-sz: max min-sz size-text face
                        ]
                        s: system/view/metrics/misc/scroller
                        either s [as-pair min-sz/x + s/x min-sz/y] [min-sz]
                    ]
                    all [face/type = 'area string? face/text not empty? face/text] [
                        len: 0
                        parse mark: face/text [
                            any [
                                s: thru [CR | LF | end] e:
                                (if len < new: offset? s e [len: new mark: s])
                                opt LF skip
                            ]
                        ]
                        size-text/with face copy/part mark len
                    ]
                    'else [either face/text [size-text face] [size-text/with face "X"]]
                ]
            ]
            align-faces: func [pane [block!] dir [word!] align [word!] max-sz [integer! float!]
            /local edge? top-left? axis svmm face offset mar type][
                if empty? pane [exit]
                edge?: any [
                    all [dir = 'across align <> 'middle]
                    all [dir = 'below align <> 'center]
                ]
                top-left?: find [top left] align
                axis: pick [y x] dir = 'across
                svmm: system/view/metrics/margins
                foreach face pane [
                    unless face/options/at-offset [
                        offset: either top-left? [0] [max-sz - face/size/:axis]
                        mar: select system/view/metrics/margins face/type
                        if type: face/options/class [mar: select mar type]
                        if mar [
                            offset: offset + either dir = 'across [
                                switch align [
                                    top [negate mar/2/x]
                                    middle [opt-as-integer round/floor mar/2/x + mar/2/y / 2.0]
                                    bottom [mar/2/y]
                                ]
                            ] [
                                switch align [
                                    left [negate mar/1/x]
                                    center [opt-as-integer round/floor mar/1/x + mar/1/y / 2.0]
                                    right [mar/1/y]
                                ]
                            ]
                        ]
                        if offset <> 0 [
                            if find [center middle] align [offset: opt-as-integer round/floor offset / 2.0]
                            if float? offset [face/offset: to-point2D face/offset]
                            face/offset/:axis: face/offset/:axis + offset
                        ]
                    ]
                ]
            ]
            resize-child-panels: func [tab [object!]
            /local tp-size pad pane][
                if block? tab/pane [
                    tp-size: tab/size
                    if pad: system/view/metrics/paddings/tab-panel [
                        tp-size: tp-size - as-pair pad/1/x + pad/1/y pad/2/x + pad/2/y
                    ]
                    foreach pane tab/pane [pane/size: tp-size]
                ]
            ]
            clean-style: func [tmpl [block!] type [word!] /local para font][
                parse tmpl [
                    some [remove [set-word! [none! | function!]] | skip]
                ]
                if all [para: tmpl/para para/parent] [
                    tmpl/para: make para [parent: none]
                ]
                if all [font: tmpl/font font/parent] [
                    tmpl/font: make font [parent: state: none]
                ]
                if find [field text] type [
                    remove/part find tmpl 'data 2
                ]
            ]
            process-draw: func [code [block!]
            /local rule pos color][
                parse code rule: [
                    any [
                        pos: issue! (if color: hex-to-rgb pos/1 [pos/1: color])
                        | set-word! (set pos/1 next pos)
                        | any-string! | any-path!
                        | into rule
                        | skip
                    ]
                ]
                code
            ]
            pre-load: func [value
            /local color][
                if word? value [attempt [value: get value]]
                if all [issue? value not color: hex-to-rgb value] [
                    throw-error reduce [value]
                ]
                if color [value: color]
                if find [file! url!] type?/word value [value: load value]
                value
            ]
            preset-focus: func [face [object!]
            /local p][
                if p: face/parent [
                    while [all [p p/type <> 'window]] [p: p/parent]
                    if p/type = 'window [p/selected: face]
                ]
            ]
            add-option: func [opts [object!] spec [block!]
            /local field value][
                either block? opts/options [
                    foreach [field value] spec [put opts/options field value]
                ] [
                    opts/options: copy spec
                ]
                last spec
            ]
            add-flag: func [obj [object!] facet [word!] field [word!] flag return: [logic!]
            /local blk][
                unless obj/:facet [
                    obj/:facet: make get select [font font! para para!] facet []
                    if field = 'color [obj/font/color: none]
                ]
                obj: obj/:facet
                make logic! either all [blk: obj/:field facet = 'font field = 'style] [
                    unless block? blk [obj/:field: blk: reduce [blk]]
                    alter blk flag
                ] [
                    obj/:field: flag
                ]
            ]
            add-bounds: func [proto [object!] spec [block!]][
                make-actor proto 'on-drag-start [
                    unless face/options/bounds [object [min: 0x0 max: face/parent/size - face/size]]
                ] spec
            ]
            fetch-value: func [blk
            /local value][
                value: blk/1
                any [all [any [word? :value path? :value] get :value] value]
            ]
            fetch-argument: func [expected [datatype! typeset!] 'pos [word!]
            /local spec type value][
                spec: next get pos
                either any [
                    expected = type: type? value: spec/1
                    all [typeset? expected find expected type]
                ] [
                    value
                ] [
                    unless all [
                        any [type = word! type = path!]
                        value: get value
                        any [
                            all [datatype? expected expected = type? value]
                            all [typeset? expected find expected type? value]
                        ]
                    ] [throw-error spec]
                ]
                set pos spec
                value
            ]
            fetch-expr: func [code [word!]][do/next next get code code]
            fetch-options: func [
                face [object!] opts [object!] style [block!] spec [block!] css [block!] reactors [block!] styling? [logic!]
                /no-skip
                /tight
                return: [block!]
                /local opt? divides calc-y? do-with scaling obj-spec! sel-spec! rate! color! cursor! value match? drag-on default hint cursor tight? later? max-sz p words user-size? oi x font face-font field actors name f s b pad sz min-sz new mar
            ][
                opt?: yes
                divides: none
                calc-y?: no
                do-with: none
                scaling: 1x1
                obj-spec!: make typeset! [block! object!]
                sel-spec!: make typeset! [integer! float! percent!]
                rate!: make typeset! [integer! time!]
                color!: make typeset! [tuple! issue!]
                cursor!: make typeset! [word! lit-word! image!]
                set opts none
                until [
                    unless no-skip [spec: next spec]
                    if no-skip [no-skip: false]
                    value: first spec
                    match?: parse spec [[
                        ['left | 'center | 'right] (opt?: add-flag opts 'para 'align value)
                        | ['top | 'middle | 'bottom] (opt?: add-flag opts 'para 'v-align value)
                        | ['bold | 'italic | 'underline | 'strike] (opt?: add-flag opts 'font 'style value)
                        | 'extra (opts/extra: fetch-expr 'spec spec: back spec)
                        | 'data (opts/data: fetch-expr 'spec spec: back spec)
                        | 'draw (opts/draw: process-draw fetch-expr 'spec spec: back spec)
                        | 'font (opts/font: make any [opts/font font!] fetch-argument obj-spec! spec)
                        | 'para (opts/para: make any [opts/para para!] fetch-argument obj-spec! spec)
                        | 'wrap (opt?: add-flag opts 'para 'wrap? yes)
                        | 'no-wrap (add-flag opts 'para 'wrap? no opt?: yes)
                        | 'focus (preset-focus face)
                        | 'font-name (add-flag opts 'font 'name fetch-argument string! spec)
                        | 'font-size (add-flag opts 'font 'size fetch-argument integer! spec)
                        | 'font-color (add-flag opts 'font 'color pre-load fetch-argument color! spec)
                        | 'options (add-option opts fetch-argument block! spec)
                        | 'loose (add-option opts compose [drag-on: 'down] add-bounds opts back spec)
                        | 'all-over (set-flag opts 'all-over)
                        | 'password (set-flag opts 'password)
                        | 'tri-state (set-flag opts 'tri-state)
                        | 'scrollable (set-flag opts 'scrollable)
                        | 'hidden (opts/visible?: no)
                        | 'disabled (opts/enabled?: no)
                        | 'select (opts/selected: fetch-argument sel-spec! spec)
                        | 'rate (opts/rate: fetch-argument rate! spec)
                        opt [rate! 'now (opts/now?: yes spec: next spec)]
                        | 'default (opts/data: add-option opts append copy [default:] fetch-value spec: next spec)
                        | 'no-border (set-flag opts 'no-border)
                        | 'space (opt?: no)
                        | 'hint (add-option opts compose [hint: (fetch-argument string! spec)])
                        | 'cursor (add-option opts compose [cursor: (pre-load fetch-argument cursor! spec)])
                        | 'init (opts/init: fetch-argument block! spec)
                        | 'with (do-with: fetch-argument block! spec)
                        | 'tight (if opts/text [tight?: yes])
                        | 'react (
                            if later?: spec/2 = 'later [spec: next spec]
                            repend reactors [face fetch-argument block! spec later?]
                        )
                        | 'style to end (opt?: no)
                    ] to end]
                    unless match? [
                        case [
                            all [
                                word? value
                                any [
                                    select css value
                                    select system/view/VID/styles value
                                ]
                            ] [
                                opt?: no
                            ]
                            all [word? value find/skip next system/view/evt-names value 2] [
                                make-actor opts value spec/2 spec spec: next spec
                            ]
                            'else [
                                opt?: switch/default type?/word value: pre-load value [
                                    point2D!
                                    pair! [unless opts/size [opts/size: value]]
                                    string! [unless opts/text [opts/text: value]]
                                    logic!
                                    date!
                                    percent! [
                                        either opts/image [scaling: value] [
                                            unless opts/data [opts/data: value]
                                        ]
                                        yes
                                    ]
                                    image! [unless opts/image [opts/image: value]]
                                    tuple! [
                                        either opts/color [
                                            add-flag opts 'font 'color value
                                        ] [
                                            opts/color: value
                                        ]
                                    ]
                                    integer! [
                                        unless opts/size [
                                            either find [panel group-box] face/type [
                                                divides: value
                                            ] [
                                                opts/size: as-pair value face/size/y
                                                opts/size-x: value
                                            ]
                                        ]
                                    ]
                                    block! [
                                        switch/default face/type [
                                            panel [layout/parent/styles/:tight value face divides css]
                                            group-box [layout/parent/styles/:tight value face divides css]
                                            tab-panel [
                                                unless parse value [some [string! block!]] [throw-error spec]
                                                face/pane: make block! (length? value) / 2
                                                opts/data: extract value 2
                                                max-sz: 0x0
                                                foreach p extract next value 2 [
                                                    layout/parent/styles/:tight reduce ['panel copy p] face divides css
                                                    p: last face/pane
                                                    max-sz: max max-sz p/offset + p/size
                                                ]
                                                unless opts/size [opts/size: max-sz]
                                            ]
                                        ] [make-actor opts style/default-actor value spec]
                                        yes
                                    ]
                                    get-word! [make-actor opts style/default-actor value spec]
                                    char! [yes]
                                ] [no]
                            ]
                        ]
                    ]
                    any [not opt? tail? spec]
                ]
                unless opt? [spec: back spec]
                words: select style 'styled
                if all [not opts/size-x find words 'size-x] [
                    opts/size-x: style/template/size/x
                ]
                user-size?: opts/size
                all [
                    face/type = 'base
                    image? opts/data
                    opts/image: opts/data
                    opts/data: none
                ]
                if all [oi: opts/image any [opts/size-x not opts/size]] [
                    opts/size: either opts/size-x [
                        x: either zero? oi/size/x [1] [oi/size/x]
                        as-pair opts/size/x opts/size * (oi/size/y / x)
                    ] [
                        oi/size * scaling
                    ]
                ]
                all [
                    face/type = 'rich-text
                    opts/data
                    not pair? opts/data/1
                    rtd-layout/with opts/data face
                    opts/data: none
                ]
                font: opts/font
                if any [face-font: face/font font] [
                    either face-font [
                        face-font: copy face-font
                        if font [
                            face-font/state: none
                            set/some face-font font
                            opts/font: face-font
                        ]
                    ] [
                        face-font: font
                    ]
                    foreach [field value] default-font [
                        if none? face-font/:field [face-font/:field: get value]
                    ]
                ]
                if all [opts/para face/para] [
                    set/some face/para opts/para
                    opts/para: face/para
                ]
                if all [block? face/actors block? actors: opts/actors] [
                    foreach [name f s b] face/actors [
                        unless find actors name [repend actors [name f s b]]
                    ]
                ]
                if block? style/template/actors [
                    unless block? actors [actors: opts/actors: make block! 4]
                    foreach [name f s b] style/template/actors [
                        unless find actors name [repend actors [name f s b]]
                    ]
                ]
                if opts/flags [opts/flags: set-flag face opts/flags]
                set/some face opts
                if all [not styling? block? face/actors] [face/actors: context face/actors]
                all [
                    pad: select system/view/metrics/paddings face/type
                    pad: as-pair pad/1/x + pad/1/y pad/2/x + pad/2/y
                ]
                if all [
                    any [not user-size? all [user-size? opts/size-x]]
                    any [opts/size-x not find words 'size]
                ] [
                    sz: any [face/size 0x0]
                    min-sz: either find containers face/type [sz] [
                        (any [pad 0x0]) + any [
                            all [
                                any [face/text series? face/data face/font]
                                calc-size face
                            ]
                            sz
                        ]
                    ]
                    new: either opts/size-x [
                        as-pair opts/size-x max sz/y min-sz/y
                    ] [
                        max sz min-sz
                    ]
                    if new <> face/size [face/size: new]
                ]
                if tight? [face/size: calc-size face]
                all [
                    not styling?
                    mar: select system/view/metrics/margins face/type
                    face/size: face/size + as-pair mar/1/x + mar/1/y mar/2/x + mar/2/y
                ]
                if face/type = 'tab-panel [resize-child-panels face]
                if do-with [do bind do-with face]
                spec
            ]
            make-actor: func [obj [object!] name [word!] body spec [block!]][
                unless any [name block? body] [throw-error spec]
                unless obj/actors [obj/actors: make block! 4]
                spec: [[trace] face [object!] event [event! none!]]
                if all [block? body body/1 = 'local block? body/2] [
                    append spec: copy spec /local
                    append spec body/2
                ]
                append obj/actors load append form name #":"
                append obj/actors either get-word? body [body] [
                    reduce [
                        'func spec
                        copy/deep body
                    ]
                ]
            ]
        ]
        handlers: [tab func [face event
        /local flags faces back? pane new opt][
            if all [
                event/type = 'key-down
                event/key = #"^-"
                any [
                    face/type <> 'area
                    all [
                        not find event/flags 'control
                        flags: face/flags
                        any [flags = 'focusable all [block? flags find flags 'focusable]]
                    ]
                ]
                not all [
                    value? 'gui-console-ctx
                    find/same gui-console-ctx/owned-faces face
                ]
            ] [
                faces: either face/type = 'window [face/pane] [find/same face/parent/pane face]
                unless back?: to-logic find event/flags 'SHIFT [
                    faces: either all [pane: get-face-pane face not empty? pane] [pane] [next faces]
                ]
                new: any [
                    all [
                        opt: face/options
                        any [
                            all [back? opt/prev]
                            all [not back? opt/next]
                        ]
                    ]
                    apply :get-focusable [faces /back back?]
                ]
                unless same? new face [set-focus new]
                return 'stop
            ]
            event
        ] field-sync func [face event][
            if all [
                find [change] event/type
                event/face/type = 'field
            ] [
                face: event/face
                set-quiet in face 'data any [
                    all [not empty? face/text attempt/safer [load face/text]]
                    all [face/options face/options/default]
                ]
                system/reactivity/check/only face 'data
            ]
        ] reactors func [face event /local facet][
            if find [change enter unfocus] event/type [
                face: event/face
                facet: switch/default face/type [
                    scroller ['data]
                    slider ['data]
                    check ['data]
                    radio ['data]
                    tab-panel ['data]
                    field ['text]
                    area ['text]
                    drop-down ['text]
                    text-list ['selected]
                    drop-list ['selected]
                ] [none]
                if facet [system/reactivity/check/only face facet]
            ]
            if all [event/window event/type = 'focus] [system/reactivity/check/only event/window 'selected]
            if event/face/type = 'window [
                switch event/type [
                    move moving [system/reactivity/check/only event/face 'offset]
                    resize resizing [system/reactivity/check/only event/face 'size]
                ]
            ]
            if event/type = 'select [
                face: event/face
                if find [field area] face/type [
                    system/reactivity/check/only face 'selected
                ]
            ]
            none
        ] radio func [face event /local f][
            if all [
                event/type = 'click
                event/face/type = 'radio
            ] [
                face: event/face
                foreach f face/parent/pane [
                    if all [f/type = 'radio f/data] [f/data: off show f]
                ]
                face/data: on
                show face
                event/type: 'change
            ]
            event
        ] enter func [face event][
            all [
                event/type = 'key
                find "^M^/" event/key
                switch event/face/type [
                    field
                    drop-down [event/type: 'enter]
                    button [event/type: 'click]
                ]
            ]
            event
        ] debug func [face event][
            if all [
                system/view/debug?
                not all [
                    value? 'gui-console-ctx
                    find/same gui-console-ctx/owned-faces event/face
                ]
            ] [
                print [
                    "face> type:" event/face/type
                    "event> type:" event/type
                    "offset:" event/offset
                    "key:" mold event/key
                    "flags:" mold event/flags
                ]
            ]
            none
        ] dragging func [face event
        /local drag-evt type flags result drag-info new box][
            if all [
                block? event/face/options
                drag-evt: event/face/options/drag-on
            ] [
                face: event/face
                type: event/type
                either type = drag-evt [
                    face/flags: any [
                        all [not block? flags: face/flags :flags reduce [:flags 'all-over]]
                        all [flags append flags 'all-over]
                        'all-over
                    ]
                    set/any 'result do-actor face event 'drag-start
                    unless all [
                        object? :result
                        [min max] = words-of result
                        planar? result/min
                        planar? result/max
                    ] [
                        result: none
                    ]
                    face/state/4: reduce [event/offset any [result face/options/bounds]]
                    unless system/view/auto-sync? [show face]
                ] [
                    if drag-info: face/state/4 [
                        either type = 'over [
                            unless event/away? [
                                new: (any [face/offset 0x0]) + event/offset - drag-info/1
                                if face/offset <> new [
                                    if box: drag-info/2 [new: min box/max max box/min new]
                                    if face/offset <> new [face/offset: new]
                                    set/any 'result do-actor face event 'drag
                                    show face/parent
                                    return :result
                                ]
                            ]
                        ] [
                            if drag-evt = select [
                                up down
                                mid-up mid-down
                                alt-up alt-down
                                aux-up aux-down
                            ] type [
                                do-actor face event 'drop
                                if face/state [face/state/4: none]
                                face/flags: all [
                                    block? flags: face/flags
                                    remove find flags 'all-over
                                    flags
                                ]
                            ]
                        ]
                    ]
                ]
            ]
            none
        ]]
        evt-names: make hash! [
            detect on-detect
            time on-time
            drawing on-drawing
            scroll on-scroll
            down on-down
            up on-up
            mid-down on-mid-down
            mid-up on-mid-up
            alt-down on-alt-down
            alt-up on-alt-up
            aux-down on-aux-down
            aux-up on-aux-up
            wheel on-wheel
            drag-start on-drag-start
            drag on-drag
            drop on-drop
            click on-click
            dbl-click on-dbl-click
            over on-over
            key on-key
            key-down on-key-down
            key-up on-key-up
            ime on-ime
            focus on-focus
            unfocus on-unfocus
            select on-select
            change on-change
            enter on-enter
            menu on-menu
            close on-close
            move on-move
            resize on-resize
            moving on-moving
            resizing on-resizing
            zoom on-zoom
            pan on-pan
            rotate on-rotate
            two-tap on-two-tap
            press-tap on-press-tap
            create on-create
            created on-created
        ]
        capture-events: func [face [object!] event [event!] /local result][
            if face/parent [
                set/any 'result capture-events face/parent event
                if find [stop done] :result [return :result]
            ]
            if capturing? [
                set/any 'result do-actor face event 'detect
                if find [stop done] :result [return :result]
            ]
        ]
        awake: func [event [event!] /with face /local result result2
        name handler screen pos][
            unless face [unless face: event/face [exit]]
            unless with [
                foreach [name handler] handlers [
                    set/any 'result do-safe [handler face event]
                    either event? :result [event: result] [if :result [return :result]]
                ]
                set/any 'result capture-events face event
                if find [stop done] :result [return :result]
            ]
            set/any 'result do-actor face event event/type
            if all [face/parent not find [done continue] :result] [
                set/any 'result2 system/view/awake/with event face/parent
                if :result2 = 'stop [return 'stop]
            ]
            if all [event/type = 'close :result <> 'continue] [
                result: pick [stop done] face/state/4
                foreach screen system/view/screens [
                    if pos: find/same head screen/pane face [remove pos break]
                ]
            ]
            :result
        ]
        capturing?: false
        auto-sync?: true
        debug?: false
        silent?: false
        GPU?: true
    ]
    reactivity: make object! [
        relations: []
        queue: []
        eat-events?: true
        debug?: false
        types!: make typeset! [block! paren! string! file! url! path! lit-path! set-path! get-path! bitset! object! vector! hash! binary! tag! email! ref! image!]
        not-safe!: make typeset! [unset! native! action! op! function! routine! error!]
        add-relation: func [
            obj [object!]
            word
            reaction [block! function!]
            targets [set-word! block! object! none!]
            /local new-rel
        ][
            new-rel: reduce [obj :word :reaction targets]
            unless find/same/skip relations new-rel 4 [append relations new-rel]
        ]
        identify-sources: func [path [any-path!] reaction ctx return: [logic!] /local obj
        p found? slice][
            p: path
            found?: no
            if any [not word? p/1 find not-safe! type? get/any p/1] [return no]
            until [
                if all [not tail? next p not word? p/2] [return no]
                slice: copy/part path next p
                set/any 'obj try [get/any :slice]
                if find not-safe! type? :obj [return no]
                if all [
                    word? p/2
                    object? :obj
                    reflect obj 'events?
                ] [
                    add-relation obj p/2 :reaction ctx
                    found?: yes
                ]
                tail? p: next p
            ]
            found?
        ]
        eval: func [code [block!] /safe
        /local result][
            either safe [
                if error? set/any 'result try/all code [
                    print :result
                    prin "*** Near: "
                    print mold/part/flat code 80
                    result: none
                ]
                get/any 'result
            ] [
                do code
            ]
        ]
        eval-reaction: func [reactor [object!] reaction [block! function!] target /mark][
            if mark [repend queue [reactor :reaction target yes]]
            either set-word? target [
                set/any target eval/safe :reaction
            ] [
                eval/safe any [all [block? :reaction reaction] target]
            ]
        ]
        pending?: func [reactor [object!] reaction [block! function!]
        /local q][
            q: queue
            while [q: find/same/skip q reactor 4] [
                if same? :q/2 :reaction [return yes]
                q: skip q 4
            ]
            no
        ]
        check: func [reactor [object!] /only field [word! set-word!]
        /local pos reaction q q'][
            unless tail? pos: relations [
                while [pos: find/same/skip pos reactor 4] [
                    reaction: :pos/3
                    if all [
                        any [not only pos/2 = field]
                        any [empty? queue not pending? reactor :reaction]
                    ] [
                        either empty? queue [
                            eval-reaction/mark reactor :reaction pos/4
                            q: tail queue
                            until [
                                q: skip q': q -4
                                either q/4 [
                                    clear q
                                ] [
                                    eval-reaction q/1 :q/2 q/3
                                    either tail? q' [
                                        clear q
                                    ] [
                                        q/4: yes
                                        q: tail queue
                                    ]
                                ]
                                head? q
                            ]
                            clear queue
                        ] [
                            unless all [
                                eat-events?
                                pending? reactor :reaction
                            ] [
                                repend queue [reactor :reaction pos/4 no]
                            ]
                        ]
                    ]
                    pos: skip pos 4
                ]
            ]
        ]
    ]
    tools: make object! [
        fun-stk: []
        expr-stk: []
        watching: []
        profiling: []
        indent: 0
        hist-length: none
        dbg-usage: {^-`help` or `?`: print a list of debugger's commands.^/^-`next` or `n` or just ENTER: evaluate next value.^/^-`continue` or `c`: exit debugging console but continue evaluation.^/^-`quit` or `q`: exit debugger and stop evaluation.^/^-`stack` or `s`: display the current calls and expression stack.^/^-`parents` or `p`: display the parents call stack.^/^-`:word`: outputs the value of `word`. If it is a `function!`, outputs the local context.^/^-`:a/b/c`: outputs the value of `a/b/c` path.^/^-`watch <word1> <word2>...`: watch one or more words. `w` can be used as shortcut for `watch`.^/^-`-watch <word1> <word2>...`: stop watching one or more words. `-w` can be used as shortcut for `-watch`.^/^-`+stack`  or `+s`: outputs expression stack on each new event.^/^-`-stack`  or `-s`: do not output expression stack on each new event.^/^-`+locals` or `+l`: output local context for each entry in the callstack.^/^-`-locals` or `-l`: do not output local context for each entry in the callstack.^/^-`+indent` or `+i`: indent the output of the expression stack.^/^-`-indent` or `-i`: do not indent the output of the expression stack.^/^-}
        options: make object! [
            debug: make object! [
                active?: false
                show-stack?: true
                show-parents?: false
                show-locals?: false
                stack-indent?: false
            ]
            trace: make object! [
                indent?: true
            ]
            profile: make object! [
                sort-by: 'count
                types: make typeset! [native! action! op! function!]
            ]
        ]
        calc-max: func [used [integer!] return: [integer!]][
            either system/console [system/console/size/x - used] [72 - used]
        ]
        show-context: func [ctx [function! object!]
        /local w out][
            foreach w words-of :ctx [
                prin out: rejoin ["  > " pad mold :w 10 ": "]
                prin mold/flat/part try [get/any :w] calc-max length? out
                either find [none true false unset] :w [print " (word!)"] [prin lf]
            ]
        ]
        show-parents: func [event [word!]
        /local list w pos][
            collect-calls list: make block! 10
            unless empty? fun-stk [
                remove/part list find list first first skip tail fun-stk pick -2x-1 event = 'call
            ]
            foreach [w pos] reverse/skip list 2 [
                if all [not unset? get/any w function? get/any w] [
                    if :w = 'debug [exit]
                    print ["Call:" w]
                    if options/debug/show-locals? [show-context get :w]
                ]
            ]
        ]
        show-stack: func [
            /local indent frame
        ][
            prin either empty? head expr-stk ["^/-empty stack-"] [lf]
            indent: 0
            foreach frame head expr-stk [
                unless integer? frame [
                    forall frame [
                        prin "Stack: "
                        if options/debug/stack-indent? [loop indent [prin "  "]]
                        print mold/part/flat first frame calc-max 7 + (indent * 2)
                        if head? frame [indent: indent + 1]
                    ]
                ]
            ]
            prin lf
        ]
        show-watching: func [
            /local w out
        ][
            foreach w watching [
                prin out: rejoin ["Watch: " mold w ": "]
                print mold/flat/part get/any w calc-max length? out
            ]
        ]
        do-command: func [event [word!]
        /local watch list w cmd add?][
            if value? 'ask [
                watch: [
                    list: next list
                    either add? [append watching list] [
                        foreach w list [try [remove find watching to-word w]]
                    ]
                ]
                do [
                    until [
                        cmd: trim ask "debug> "
                        case [
                            cmd/1 = #":" [
                                print ["==" mold get/any load next cmd]
                            ]
                            find "+-" cmd/1 [
                                add?: cmd/1 = #"+"
                                switch first list: load/all next cmd [
                                    watch w [do watch]
                                    parents p [options/debug/show-parents?: add?]
                                    stack s [options/debug/show-stack?: add?]
                                    locals l [options/debug/show-locals?: add?]
                                    indent i [options/debug/stack-indent?: add?]
                                ]
                            ]
                            'else [
                                unless empty? list: load/all cmd [
                                    switch/default list/1 [
                                        watch w [add?: yes do watch]
                                        parents p [show-parents event]
                                        stack s [show-stack]
                                        next n [clear cmd]
                                        continue c [options/debug/active?: no clear cmd]
                                        quit q [halt]
                                        help ? [print dbg-usage]
                                    ] [
                                        print "Unknown command!"
                                    ]
                                ]
                            ]
                        ]
                        empty? cmd
                    ]
                ]
            ]
        ]
        debugger: func [
            event [word!]
            code [any-block! none!]
            offset [integer!]
            value [any-type!]
            ref [any-type!]
            frame [pair!]
            /local store idx pos indent sch out set-ref limit
        ][
            store: [
                either empty? expr-stk [
                    append/only expr-stk to-paren reduce [:value]
                ] [
                    append/only last expr-stk :value
                ]
            ]
            switch event [
                fetch [
                    switch :value [@stop [options/debug/active?: yes] @go [options/debug/active?: no]]
                    if paren? expr-stk/1 [remove expr-stk]
                ]
                enter [
                    unless empty? head expr-stk [
                        append expr-stk index? expr-stk
                        expr-stk: tail expr-stk
                    ]
                ]
                exit [
                    either head? expr-stk [clear expr-stk] [
                        if paren? expr-stk/1 [set/any 'value expr-stk/1/1]
                        idx: first pos: find/reverse tail expr-stk integer!
                        clear pos
                        expr-stk: at head expr-stk idx
                        do store
                    ]
                ]
                open [
                    append/only expr-stk reduce [:value]
                ]
                push [
                    either find [set-word! set-path!] type?/word :value [
                        append/only expr-stk reduce [:value]
                    ] [
                        do store
                    ]
                ]
                prolog [append/only fun-stk last expr-stk]
                epilog [unless empty? fun-stk [take/last fun-stk]]
                set
                return [
                    take/last expr-stk
                    do store
                ]
                error [options/debug/active?: yes]
                init end [
                    clear fun-stk
                    clear expr-stk: head expr-stk
                    indent: 0
                    sch: system/console/history
                    if event = 'init [hist-length: length? sch]
                    if event = 'end [
                        options/debug/active?: no
                        remove/part sch (length? sch) - hist-length
                    ]
                ]
            ]
            if all [
                options/debug/active?
                not find [init end enter exit prolog epilog expr] event
            ] [
                if event = 'fetch [event: 'eval]
                prin out: rejoin ["-----> " uppercase mold event space]
                if event = 'set [
                    append out set-ref: rejoin [ref space]
                    prin set-ref
                ]
                limit: calc-max (length? out) + 1
                print either all [any-function? :value not find [set return push] event] [
                    prin mold/part/flat :ref limit
                    rejoin [" (" mold type? :value #")"]
                ] [
                    mold/part/flat :value limit
                ]
                if :code [print ["Input:" mold/only/part/flat skip :code offset calc-max 8]]
                unless empty? watching [show-watching]
                if options/debug/show-parents? [show-parents event]
                if options/debug/show-stack? [show-stack]
                do-command event
                if event = 'error [options/debug/active?: no]
            ]
        ]
        tracers: make object! [
            emit: make native! [[
                "Outputs a value followed by a newline"
                value [any-type!]
            ]]
            opening-marker: make bitset! #{00000000208000080000001000000010}
            closing-markers: {()[]{}<>""}
            mold-part: func [value [any-type!] part [integer!] /only
            /local r open close][
                r: mold/flat/part/:only :value part + 1
                if part < length? r [
                    open: find/part r opening-marker skip tail r -5
                    clear either open [
                        close: select closing-markers open/1
                        change change skip tail r -5 "..." close
                    ] [
                        change skip tail r -4 "..."
                    ]
                    clear skip r part
                ]
                r
            ]
            dumper: func [
                event [word!]
                code [any-block! none!]
                offset [integer!]
                value [any-type!]
                ref [any-type!]
                frame [pair!]
            ][
                do [emit [uppercase form event offset mold-part :ref 30 mold-part :value 30 frame]]
            ]
            push: func [s [series!] i [any-type!] /dup n [integer!]][append/only/dup s :i any [n 1]]
            drop: func [s [series!] n [integer!]][clear skip tail s negate n]
            pop: func [s [series!]][take/last s]
            top-of: func [s [series!]][back tail s]
            step: func [s [series!] /down][change s s/1 + pick [-1 1] down]
            mold-size: 30
            free: make object! [
                list: [[] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] []]
                put: func [block [block!]][if 100 > length? block [push list clear head block]]
                get: func [][any [pop list make block! 10]]
            ]
            data: make object! [
                debug?: false
                inspect: none
                event-filter: none
                scope-filter: none
                inspect-sub-exprs?: none
                func-depth: 0
                expr-depth: 0
                path: []
                fetched: []
                fetched': []
                pushed: []
                pushed': []
                subexprs: []
                stack: []
                saved: [func-depth expr-depth fetched fetched' pushed pushed' subexprs]
                stack-period: 9
                save-level: func ["Save current nesting level on the stack" frame [pair!]
                /local word value][
                    push stack frame
                    push stack length? path
                    foreach word saved [
                        push stack value: get word
                        set word either block? value [free/get] [0]
                    ]
                ]
                unroll-level: func ["Unroll last nesting level from the stack"
                /local i n value word][
                    repeat i n: length? saved [
                        value: get word: pick saved n - i + 1
                        if block? value [free/put value]
                        set word pop stack
                    ]
                    clear skip path pop stack
                    pop stack
                ]
                reset: func ["Reset collector's data"
                /local block-name][
                    clear path
                    clear stack
                    set [func-depth expr-depth] 0
                    foreach block-name skip saved 2 [clear get block-name]
                ]
                collector: func [
                    {Generic tracer that collects high-level tracing info}
                    event [word!]
                    code [default!]
                    offset [integer!]
                    value [any-type!]
                    ref [any-type!]
                    frame [pair!]
                    /local call saved-frame isop? bgn word
                ][
                    call: [
                        all [
                            any [none? event-filter find event-filter event]
                            any [none? scope-filter none? code find/same/only scope-filter code]
                            any [
                                inspect-sub-exprs?
                                find [error throw] event
                                0 = expr-depth
                                all [1 = expr-depth find [call return] event]
                            ]
                            inspect system/tools/tracers/data event code offset :value :ref frame
                        ]
                    ]
                    if find [return catch] event [
                        saved-frame: pick tail stack negate stack-period
                        while [unless tail? stack [saved-frame/1 > frame/1]] [
                            unroll-level
                            saved-frame: pick tail stack negate stack-period
                        ]
                    ]
                    if find [return epilog exit expr error throw] event [do call]
                    switch event [
                        prolog [func-depth: func-depth + 1]
                        epilog [func-depth: func-depth - 1]
                        fetch [
                            if any [inspect-sub-exprs? not path? code] [
                                push fetched :value
                                push fetched' mold-part :value mold-size
                            ]
                        ]
                        push [
                            if any [inspect-sub-exprs? not path? code] [
                                push pushed :value
                                push pushed' mold-part :value mold-size
                            ]
                        ]
                        open [
                            isop?: any [op? :value op? if word? :value [attempt [get/any value]]]
                            push subexprs index? pushed
                            pushed: either isop? [top-of pushed] [tail pushed]
                            pushed': either isop? [top-of pushed'] [tail pushed']
                            push pushed :value
                            push pushed' mold-part :value mold-size
                            expr-depth: expr-depth + 1
                        ]
                        call [
                            push path any [if path? ref [:ref/1] ref <anon>]
                        ]
                        return [
                            pop path
                            expr-depth: expr-depth - 1
                            bgn: any [pop subexprs 1]
                            pushed: at head clear pushed bgn
                            pushed': at head clear pushed' bgn
                            push pushed :value
                            push pushed' mold-part :value mold-size
                        ]
                        enter [
                            unless path? code [save-level frame]
                        ]
                        exit [
                            unless path? code [unroll-level]
                            if paren? code [
                                push pushed :value
                                push pushed' mold-part :value mold-size
                            ]
                        ]
                        expr [
                            foreach word [fetched fetched' pushed pushed'] [
                                clear get word
                            ]
                        ]
                    ]
                    unless find [return epilog exit expr error throw] event [do call]
                    if debug? [
                        do [emit [
                            uppercase pad event 7
                            pad type? code 6
                            pad :ref 12
                            pad frame 6
                            pad mold-part :value 20 22
                            pad form/part fetched' 60 62
                            pad func-depth 3
                            pad expr-depth 3
                            subexprs
                        ]]
                    ]
                ]
            ]
            guided-trace: func [
                {Trace a block of code, providing 'inspect' tracer with collected data}
                inspect [function!] {func [data [object!] event code offset value ref frame]}
                code [any-type!]
                all? [logic!] "Trace all sub-expressions of each expression"
                deep? [logic!] "Enter functions and natives"
                debug? [logic!] "Dump all events encountered"
                /local b rule
            ][
                if tracing? [exit]
                data/reset
                data/debug?: debug?
                data/inspect: :inspect
                data/inspect-sub-exprs?: all?
                data/event-filter: if block? b: first body-of :inspect [b]
                data/scope-filter: if all [not deep? any-list? :code] [
                    to hash! collect [
                        keep/only head code
                        parse code rule: [any [
                            ahead set b any-block! (keep/only head b) into rule | skip
                        ]]
                    ]
                ]
                do-handler :code :data/collector
            ]
            inspector: make object! [
                fixed-width: none
                last-path: []
                constants: [yes no on off true false none]
                type-names: [datatype! unset! none! logic! block! paren! string! file! url! char! integer! float! word! set-word! lit-word! get-word! refinement! issue! native! action! op! function! path! lit-path! set-path! get-path! routine! bitset! object! typeset! error! vector! hash! pair! percent! tuple! map! binary! time! tag! email! handle! date! port! money! ref! point2D! point3D! image!]
                ignored-words: make hash! [yes no on off true false none datatype! unset! none! logic! block! paren! string! file! url! char! integer! float! word! set-word! lit-word! get-word! refinement! issue! native! action! op! function! path! lit-path! set-path! get-path! routine! bitset! object! typeset! error! vector! hash! pair! percent! tuple! map! binary! time! tag! email! handle! date! port! money! ref! point2D! point3D! image!]
                fetched-index: -5
                fetched'-index: -4
                inspect: func [
                    data [object!]
                    event [word!]
                    code [default!]
                    offset [integer!]
                    value [any-type!]
                    ref [any-type!]
                    /local word
                    report? full width left right indent indent2 level expr path p pexpr orig-expr name
                ][
                    [expr error throw push return]
                    report?: all select [
                        expr [
                            not data/inspect-sub-exprs?
                            data/expr-depth = 0
                            not paren? code
                        ]
                        error [true]
                        throw [true]
                        push [
                            data/inspect-sub-exprs?
                            set/any 'word last data/fetched
                            any [word? :word get-word? :word]
                            not find ignored-words word
                            word <> last data/pushed
                        ]
                        return [data/inspect-sub-exprs?]
                    ] event
                    any [report? exit]
                    full: any [fixed-width attempt [system/console/size/1] 80]
                    width: full - 7
                    left: min 60 to integer! width / 2
                    right: width - left
                    indent: append/dup clear "" " " full - 1
                    indent2: append/dup clear skip "  " 2 "`" full - 3
                    level: (length? data/stack) / data/stack-period - 1
                    level: level % 10 + 1 * 2
                    expr: case [
                        not data/inspect-sub-exprs? [data/fetched']
                        event = 'push [top-of data/fetched']
                        'else [data/pushed']
                    ]
                    if paren? expr [expr: as [] expr]
                    if path? code [expr: as path! expr]
                    unless any [data/inspect-sub-exprs? data/path == last-path] [
                        path: uppercase mold-part as path! data/path full - 1 - level
                        p: change skip indent2 level path
                        unless empty? pexpr: pick tail data/stack fetched'-index [
                            orig-expr: pick tail data/stack fetched-index
                            name: either path? :orig-expr/1 [:orig-expr/1/1] [:orig-expr/1]
                            if :name = last data/path [
                                pexpr: next pexpr
                            ]
                            change change p " " form/part pexpr (length? p) - 1
                        ]
                        do [emit indent2]
                        append clear last-path data/path
                    ]
                    change skip indent level form/part expr left - level
                    change change skip indent left " => " mold-part :value right
                    do [emit indent]
                ]
            ]
        ]
        profiler: func [
            event [word!]
            code [any-block! none!]
            offset [integer!]
            value [any-type!]
            ref [any-type!]
            frame [pair!]
            /local anon time opt pos entry
        ][
            [init call return prolog epilog]
            anon: [0]
            switch event [
                prolog [
                    time: now/precise
                    poke skip tail fun-stk -2 1 time
                ]
                epilog [
                    poke back tail fun-stk 1 now/precise
                ]
                call [
                    if all [typeset? opt: options/profile/types find opt type? :value] [
                        if any-function? :ref [ref: append copy <anon> anon/1: anon/1 + 1]
                        either pos: find/only/skip profiling ref 3 [
                            pos/2: pos/2 + 1
                        ] [
                            repend profiling [ref 1 0]
                        ]
                        repend fun-stk [ref now/precise none]
                    ]
                ]
                return [
                    time: now/precise
                    unless empty? fun-stk [
                        entry: skip tail fun-stk -3
                        pos: find/only/skip profiling first entry 3
                        pos/3: pos/3 + difference any [entry/3 time] entry/2
                        clear entry
                    ]
                ]
                init [
                    clear profiling
                    clear fun-stk
                ]
            ]
        ]
        do-handler: func [code [any-type!] handler [function!]][
            either find [file! url!] type?/word :code [
                do-file code :handler
            ] [
                do/trace :code :handler
            ]
        ]
    ]
]
tag?: make function! ["Returns true if the value is this type" value [any-type!]]
tail: make action! [
    {Returns a series at the index after its last value}
    series [series! port!]
    return: [series! port!]
]
tail?: make action! [
    "Returns true if a series is past its last value"
    series [series! port!]
    return: [logic!]
]
take: make action! [
    "Removes and returns one or more elements"
    series [series! port! none!]
    /part "Specifies a length or end position"
    length [number! series!]
    /deep "Copy nested values"
    /last "Take it from the tail end"
]
tan: make function! [
    "Returns the trigonometric tangent"
    angle [float!] "Angle in radians"
]
tangent: make native! [
    "Returns the trigonometric tangent"
    angle [float! integer!]
    /radians "DEPRECATED: use `tan` native instead"
    return: [float!]
]
third: make function! ["Returns the third value in a series" s [series! tuple! date! point3D! time!]]
throw: make native! [
    "Throws control back to a previous catch"
    value [any-type!] "Value returned from catch"
    /name "Throws to a named catch"
    word [word!]
]
time-it: make function! [
    "Returns the time required to evaluate a block"
    body [block!]
    return: [time!]
    /local t0
]
time?: make function! ["Returns true if the value is this type" value [any-type!]]

to: make action! [
    "Converts to a specified datatype"
    type [any-type!] "The datatype or example value"
    spec [any-type!] "The attributes of the new value"
]
to-binary: make function! ["Convert to binary! value" value]
to-bitset: make function! ["Convert to bitset! value" value]
to-block: make function! ["Convert to block! value" value]
to-char: make function! ["Convert to char! value" value]
to-csv: make function! [
    "Make CSV data from input value"
    data [block! map! object!] {May be block of fixed size records, block of block records, or map columns}
    /with "Delimiter to use (default is comma)"
    delimiter [char! string!]
    /skip "Treat block as table of records with fixed length"
    size [integer!]
    /quote
    qt-char [char!] {Use different character for quotes than double quote (")}
    /local longest keyval? types value
]
to-date: make function! ["Convert to date! value" value]
to-email: make function! ["Convert to email! value" value]
to-file: make function! ["Convert to file! value" value]
to-float: make function! ["Convert to float! value" value]
to-get-path: make function! ["Convert to get-path! value" value]
to-get-word: make function! ["Convert to get-word! value" value]
to-hash: make function! ["Convert to hash! value" value]
to-hex: make native! [
    {Converts numeric value to a hex issue! datatype (with leading # and 0's)}
    value [integer!]
    /size "Specify number of hex digits in result"
    length [integer!]
    return: [issue!]
]
to-image: make function! ["Convert to image! value" value]
to-integer: make function! ["Convert to integer! value" value]
to-issue: make function! ["Convert to issue! value" value]
to-json: make function! [
    "Convert Red data to a JSON string"
    data
    /pretty indent [string!] "Pretty format the output, using given indentation"
    /ascii "Force ASCII output (instead of UTF-8)"
    /local result
]
to-lit-path: make function! ["Convert to lit-path! value" value]
to-lit-word: make function! ["Convert to lit-word! value" value]
to-local-date: make function! [
    "Returns the date with local zone"
    date [date!]
    return: [date!]
]
to-local-file: make native! [
    {Converts a Red file path to the local system file path}
    path [file! string!]
    /full {Prepends current dir for full path (for relative paths only)}
    return: [string!]
]
to-logic: make function! ["Convert to logic! value" value]
to-map: make function! ["Convert to map! value" value]
to-money: make function! ["Convert to money! value" value]
to-none: make function! ["Convert to none! value" value]
to-pair: make function! ["Convert to pair! value" value]
to-paren: make function! ["Convert to paren! value" value]
to-path: make function! ["Convert to path! value" value]
to-percent: make function! ["Convert to percent! value" value]
to-point2D: make function! ["Convert to point2D! value" value]
to-point3D: make function! ["Convert to point3D! value" value]
to-red-file: make function! [
    {Converts a local system file path to a Red file path}
    path [file! string!]
    return: [file!]
    /local colon? slash? len i c dst
]
to-ref: make function! ["Convert to ref! value" value]
to-refinement: make function! ["Convert to refinement! value" value]
to-set-path: make function! ["Convert to set-path! value" value]
to-set-word: make function! ["Convert to set-word! value" value]
to-string: make function! ["Convert to string! value" value]
to-tag: make function! ["Convert to tag! value" value]
to-time: make function! ["Convert to time! value" value]
to-tuple: make function! ["Convert to tuple! value" value]
to-typeset: make function! ["Convert to typeset! value" value]
to-unset: make function! ["Convert to unset! value" value]
to-url: make function! ["Convert to url! value" value]
to-UTC-date: make function! [
    "Returns the date with UTC zone"
    date [date!]
    return: [date!]
]
to-word: make function! ["Convert to word! value" value]
trace: make function! [
    {Runs argument code and prints an evaluation trace; also turns on/off tracing}
    code [any-type!] "Code to trace or tracing mode (logic!)"
    /raw {Switch to raw interpreter events tracing (incompatible with other modes)}
    /deep "Trace into functions and natives"
    /all "Trace all sub-expressions of each expression"
    /debug {Used internally to debug the tracer itself (outputs all events)}
    /local bool
]
tracing?: make routine! []
transcode: make native! [
    {Translates UTF-8 binary source to values. Returns one or several values in a block}
    src [binary! string!] {UTF-8 input buffer; string argument will be UTF-8 encoded}
    /next {Translate next complete value (blocks as single value)}
    /one {Translate next complete value, returns the value only}
    /prescan {Prescans only, do not load values. Returns guessed type.}
    /scan {Scans only, do not load values. Returns recognized type.}
    /part "Translates only part of the input buffer"
    length [integer! binary!] "Length in bytes or tail position"
    /into "Optionally provides an output block"
    dst [block!]
    /trace
    callback [
        function! [
            event [word!]
            input [binary! string!]
            type [word! datatype!]
            line [integer!]
            token
            return: [logic!]
        ]
        routine! [
            event [word!]
            input [binary! string!]
            type [word! datatype!]
            line [integer!]
            token
            return: [logic!]
        ]
    ]
    return: [block!]
]
transcode-trace: make function! [
    {Shortcut function for transcoding while tracing all lexer events}
    src [binary! string!]
]
trim: make action! [
    "Removes space from a string or NONE from a block"
    series [series! port!]
    /head "Removes only from the head"
    /tail "Removes only from the tail"
    /auto "Auto indents lines relative to first line"
    /lines "Removes all line breaks and extra spaces"
    /all "Removes all whitespace"
    /with "Same as /all, but removes characters in 'str'"
    str [char! string! binary! integer!]
]
try: make native! [
    {Tries to DO a block and returns its value or an error}
    block [block!]
    /all {Catch also BREAK, CONTINUE, RETURN, EXIT and THROW exceptions}
    /keep {Capture and save the call stack in the error object}
]
tuple?: make function! ["Returns true if the value is this type" value [any-type!]]
type?: make native! [
    "Returns the datatype of a value"
    value [any-type!]
    /word "Return a word value, rather than a datatype value"
]
typeset?: make function! ["Returns true if the value is this type" value [any-type!]]
union: make native! [
    "Returns the union of two data sets"
    set1 [block! hash! string! bitset! typeset!]
    set2 [block! hash! string! bitset! typeset!]
    /case "Use case-sensitive comparison"
    /skip "Treat the series as fixed size records"
    size [integer!]
    return: [block! hash! string! bitset! typeset!]
]
unique: make native! [
    "Returns the data set with duplicates removed"
    set [block! hash! string!]
    /case "Use case-sensitive comparison"
    /skip "Treat the series as fixed size records"
    size [integer!]
    return: [block! hash! string!]
]
unless: make native! [
    {If conditional expression is falsy, evaluate block; else return NONE}
    cond [any-type!]
    then-blk [block!]
]
unset: make native! [
    "Unsets the value of a word in its current context"
    word [word! block!] "Word or block of words"
]
unset?: make function! ["Returns true if the value is this type" value [any-type!]]
until: make native! [
    "Evaluates body until it is truthy"
    body [block!]
]
unview: make function! [
    "Close last opened window view"
    /all "Close all views"
    /only "Close a given view"
    face [object!] "Window view to close"
    /local all? svs pane
]
update: make action! [
    {Updates external and internal states (normally after read/write)}
    port [port!]
]
update-font-faces: make function! ["Internal Use Only" parent [block! none!]
/local f]
uppercase: make native! [
    "Converts string of characters to uppercase"
    string [any-string! char!] "Value to convert (modified when series)"
    /part "Limits to a given length or position"
    limit [number! any-string!]
    return: [any-string! char!]
]

url?: make function! ["Returns true if the value is this type" value [any-type!]]
value?: make native! [
    "Returns TRUE if the word has a value"
    value [word!]
    return: [logic!]
]
values-of: make function! [{Returns the list of values of a value that supports reflection} value]
vector?: make function! ["Returns true if the value is this type" value [any-type!]]
view: make function! [
    {Displays a window view from a layout block or from a window face}
    spec [block! object!] "Layout block or face object"
    /tight "Zero offset and origin"
    /options
    opts [block!] "Optional features in [name: value] format"
    /flags
    flgs [block! word!] "One or more window flags"
    /no-wait "Return immediately - do not wait"
    /no-sync "Requires `show` calls to refresh faces"
    /local sync? result
]
wait: make native! [
    "Waits for a duration in seconds or specified time"
    value [number! time! block! none!]
    /all "Returns all events in a block"
]
what: make function! [
    "Lists all functions, or search for values"
    /with "Search all values that contain text in their name"
    text [word! string!]
    /spec "Search for text in value specs as well"
    /buffer {Buffer and return output, rather than printing results}
    /local found-at-least-one? word val
]
what-dir: make function! [
    "Returns the active directory path"
    /local path
]
while: make native! [
    {Evaluates body as long as condition block evaluates to truthy value}
    cond [block!] "Condition block to evaluate on each iteration"
    body [block!] "Block to evaluate on each iteration"
]
within?: make function! [
    {Return TRUE if the point is within the rectangle bounds}
    point [planar!] "XY position"
    offset [planar!] "Offset of area"
    size [planar!] "Size of area"
    return: [logic!]
]
word?: make function! ["Returns true if the value is this type" value [any-type!]]
words-of: make function! [{Returns the list of words of a value that supports reflection} value]
write: make action! [
    "Writes to a file, URL, or other port"
    destination [file! url! port!]
    data [any-type!]
    /binary "Preserves contents exactly"
    /lines "Write each value in a block as a separate line"
    /info
    /append "Write data at end of file"
    /part "Partial write a given number of units"
    length [number!]
    /seek "Write at a specific position"
    index [number!]
    /allow "Specifies protection attributes"
    access [block!]
    /as {Write with the specified encoding, default is 'UTF-8}
    encoding [word!]
]
write-clipboard: make routine! [
    "Write content to the system clipboard"
    data [any-type!] "string!, block! of files!, an image! or none!"
    return: [logic!] "indicates success"
]
write-stdout: make routine! ["Write data to STDOUT" data [any-type!]]
xor~: make action! [
    {Returns the first value exclusive ORed with the second}
    value1 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
    value2 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
    return: [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]
]
zero?: make native! [
    "Returns TRUE if the value is zero"
    value [number! money! pair! time! char! tuple! any-point!]
    return: [logic!]
]
