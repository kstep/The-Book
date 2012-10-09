>== Debugging ==
<input type="hidden" value="d41d8cd98f00b204e9800998ecf8427e" name="wpAutoSummary" /><input type="hidden" value="0" name="oldid" /><textarea tabindex="1" accesskey="," id="wpTextbox1" cols="80" rows="25" style="" name="wpTextbox1">== Debugging ==
Programming is a complex process, and since it is done by human beings, it often leads to errors. This makes debugging a fundamental skill of any programmer as debugging is an intrinsic part of programming. 

For historical reasons, programming errors are called bugs (after an actual bug was found in a computer's mechanical relay, causing it to malfunction, as documented by Dr. Grace Hopper) and going through the code, examining it and looking for something wrong in the implementation (bugs) and correcting them is called debugging. The only help available to the programmer are the clues generated by the observable output. Other alternatives are running automated tools to test or verify the code or analyze the code as it runs, this is the task where a [[w:debugger|debugger]] can come to your aid.

Debugging can be quite stressful, especially [[C++ Programming/Threading#Multi-Threading|multi-threaded]] programs that are extremely hard to debug, but it can also be a quite fun intellectual activity, kind of like a logic puzzle. Experience in debugging will not only reduce future errors but generate better hypothesis for what might be going wrong and ways to improve the design.

In debugging code there are already understood sections and situations that are prone to errors, for instance issues regarding pointer arithmetics is a well understood fragility inherited from C and in debugging, as any other methodology, there are already established techniques, procedures and practices that can make the detection of bugs easier (i.e.:[[w:Delta Debugging|Delta Debugging]]).

The field of debugging also covers establishing the security for the code (or the system it will run under). Of course this will all depend on the design limitations and requirements for the specific implementation.  

=== Definition of bug ===
A bug in a program is defined by an unexpected behavior, unintended by the programmer. It happens when the behavior was not expected or intended in that program's code. A bug can also be described as error, flaw, mistake, [[w:failure|failure]], or [[w:fault (technology)|fault]].

Most bugs arise from programming mistakes, and a few are caused by externalities (compiler, hardware or other systems outside of the direct responsibility of the programmer). A program that contains a large number of bugs, and/or bugs that seriously interfere with its functionality, is said to be '''buggy'''.

Reports detailing bugs in a program are commonly known as '''bug reports''', fault reports, problem reports, trouble reports, change requests, and so forth.

There are a few different kinds of bugs that can occur in a program, and it is useful to distinguish between them in order to track them down more quickly.

Categorizations for bugs regarding their origin:
*'''Organizational'''
**Conceptual error. Where the code is syntactically correct, but the programmer or designer intended it to do something else. These can occur due to differences between the documentation and the actual product.
**Unpropagated updates; e.g. programmer changes "myAdd" but forgets to change "mySubtract", which uses the same algorithm. These errors are mitigated by the [[w:Don't repeat yourself|Do not Repeat Yourself]] philosophy.
**Comments out of date or incorrect: many programmers assume the comments accurately describe the code.
*'''External'''
**[[#Compiler Bugs|Compiler bugs]] or unexpected results due to lack of a default behavior on the C++ language specifications.
**Environmental bugs on external dependencies (libraries or other software) or Operating System bugs/undocumented behaviors.
**Hardware bugs or undocumented behaviors.
*'''Arithmetic bugs'''
**[[w:Divide by zero#Division by zero in computer arithmetic|Division by zero]].
**[[w:Arithmetic overflow|Arithmetic overflow]] or [[w:Arithmetic underflow|underflow]].
**Loss of [[w:arithmetic precision|arithmetic precision]] due to [[w:rounding|rounding]] or [[w:numerical stability|numerically unstable]] algorithms.
*'''Logic bugs'''
**[[w:Infinite loop|Infinite loop]]s and infinite [[w:Recursion (computer science)|recursion]].
**[[w:Off by one error|Off by one error]], counting one too many or too few when looping.
*'''Syntax bugs''' ([[#Typos|Typos]])
*'''Resource bugs'''
**[[w:Pointer (computing)#The null pointer|Null pointer]] dereference.
**Using an [[w:uninitialized variable|uninitialized variable]].
**Using an otherwise valid instruction on the wrong [[w:data type|data type]] (see [[w:packed decimal|packed decimal]]/[[w:binary coded decimal|binary coded decimal]]).
**[[w:Access violation|Access violation]]s.
**Resource leaks, where a finite system resource such as [[w:memory leak|memory]] or [[w:handle leak|file handles]] are exhausted by repeated allocation without release.
**[[w:Buffer overflow|Buffer overflow]], in which a program tries to store data past the end of allocated storage. This may or may not lead to an access violation or [[w:storage violation|storage violation]]. These bugs can form a [[w:Software bug#Security_vulnerabilities|security vulnerability]].
**Excessive recursion which though logically valid causes [[w:stack overflow|stack overflow]]
*'''Co-processing bugs'''
**[[w:Deadlock|Deadlock]].
**[[w:Race condition|Race condition]]. 
**Concurrency errors in [[w:Critical section|Critical section]]s, [[w:Mutual exclusion|Mutual exclusion]]s and other features of [[w:Concurrent programming#Coordinating access to resources|concurrent processing]]. [[w:Time-of-check-to-time-of-use|Time-of-check-to-time-of-use]] (TOCTOU) is a form of unprotected critical section.

{{TODO|Categorization by result/severity (security)}}

==== Common errors ====
Common programming errors are bugs mostly occur due to lack of experience, attention or when the programmer delegates too much responsibility to the compiler, IDE or other development tools.

;Usage of uninitialized variables or pointers.  

;Forgetting the <code>break</code> statement in a <code>switch</code> when fall-through was not meant

;Forgetting to check for null before accessing a member on a pointer.  This will cause access violations (segmentation faults) and cause your program to halt unexpectedly.
<source lang=cpp>
// unsafe
p->doStuff(); 

// much better!
if (p) 
{
   p->doStuff(); 
}
</source>

===== Typos =====
Typos are a aggregation of simple to commit syntax errors (in very specific situations where the C++ language is ambivalent). The term comes from [[w:Typographical error|typographical error]] as in an error on the typing  process.

;Forgetting the <code>; </code> at the end of a line. All time classic !

;Use of the wrong operator, such as performing assignment instead of [[w:==#Equality|equality test]]. In simple cases often warned by the compiler.
<source lang=cpp>
// Example of an assignment of a number in an if statement when a comparison was meant.
if ( x = 143 ) // should be: if ( x == 143)
</source>

;Forgetting the brackets in a multi lined loop or if statement.
<source lang=cpp>
if (x==3)
cout << x;
flag++;
</source>

==== Understanding the timing ====
===== Compile-time errors =====
The compiler can only translate a program if the program is syntactically correct; otherwise, the compilation fails and you will not be able to run your program. Syntax refers to the structure of your program and the rules about that structure.

For example, in English, a sentence must begin with a capital letter and end with a period. this sentence contains a syntax error. So does this one

For most human readers, a few syntax errors are not a significant problem, which is why we can read the poetry of [http://en.wikipedia.org/wiki/E._E._Cummings E. E. Cummings] without spewing error messages.

Compilers are not so forgiving. If there is a single syntax error anywhere in your program, the compiler will print an error message and quit, and you will not be able to run your program.

To make matters worse, there are more syntax rules in C++ than there are in English, and the error messages you get from the compiler are often not very helpful. During the first few weeks of your programming career, you will probably spend a lot of time tracking down syntax errors. As you gain experience, though, you will make fewer errors and find them faster.

====== Linker errors ======
Most linker errors are generated when using improper settings on your compiler/IDE, most recent compilers will report some sort of information about the errors and if you keep in mind the linker function you will be able to easily address them. Most other sort of errors are due to improper use of the language or setup of the project files, that can lead to code collisions due to redefinitions or missing information.

===== Run-time errors =====
The run-time error, so-called because the error does not appear until you run the program.

;'''Logic errors and semantics'''
The third type of error is the logical or semantic error. If there is a logical error in your program, it will compile and run successfully, in the sense that the computer will not generate any error messages, but it will not do the right thing. It will do something else. Specifically, it will do what you told it to do.

The problem is that the program you wrote is not the program you wanted to write. The meaning of the program (its semantics) is wrong. Identifying logical errors can be tricky, since it requires you to work backwards by looking at the output of the program and trying to figure out what it is doing.

==== Compiler Bugs ====
As we have seen earlier, bugs are common to every programming task. Creating a compiler is no different, in fact creating a C++ compiler is an extremely complex programming task, more so since the language even if stable is always evolving and not only on the standard.

The liberty C++ permits enables programmers to push the envelop on what it is possible and expected and to an increase on the level of code complexity due to abstractions. This has lead to compilers to attempt to automating several low level actions to ease the burden to the programmer, like code optimization, higher level of interaction and control over the compiler components and the inclusion of very low level configuration possibilities. All these features increase the number of ways a compiler can end up generating incorrect (or sometimes technically correct but unexpected) results. The programmer should always keep in mind that compiler bugs are possible but extremely rare.

One of the most common bugs attributed to the compiler result from a badly configured optimization option (or an inability to understand them). If you suspect a compiler error turn optimizations off fist.

=== Experimental debugging ===
One of the most important skills you should acquire from working with this book is debugging. Although it can be frustrating, debugging is one of the most intellectually rich, challenging, and interesting parts of programming.

In some ways debugging is like detective work. You are confronted with clues and you have to infer the processes and events that lead to the results you see.

Debugging is also like an experimental science. Once you have an idea what is going wrong, you modify your program and try again. If your hypothesis was correct, then you can predict the result of the modification, and you take a step closer to a working program. If your hypothesis was wrong, you have to come up with a new one. As [http://en.wikipedia.org/wiki/Sherlock_Holmes Sherlock Holmes] pointed out, "When you have eliminated the impossible, whatever remains, however improbable, must be the truth." (from [http://en.wikipedia.org/wiki/A._Conan_Doyle A. Conan Doyle's] The Sign of Four).

For some people, programming and debugging are the same thing. That is, programming is the process of gradually debugging a program until it does what you want. The idea is that you should always start with a working program that does something, and make small modifications, debugging them as you go, so that you always have a working program.

For example, [http://en.wikipedia.org/wiki/Linux Linux] is an operating system that contains thousands of lines of code, but it started out as a simple program [http://en.wikipedia.org/wiki/Linus_Benedict_Torvalds Linus Torvalds] used to explore the Intel 80386 chip. According to Larry Greenfield, "One of Linus's earlier projects was a program that would switch between printing AAAA and BBBB. This later evolved to Linux" (from [ftp://sunsite.unc.edu//pub/Linux/docs/LDP/users-guide/!INDEX.html The Linux Users' Guide Beta Version 1], Page 10).

=== Tracing ===
The technique of '''[[w:Tracing|tracing]]''' evolved directly from the hardware to the [[w:software engineering|software engineering]] field. In field of hardware it consists on sampling the signals of an given circuit to verify the consistency of the hardware implemented logic/algorithm, as such earlier programmers adopted the term and function to trace the execution of the software with one particularly distinction, tracing should not be performed or enabled in public release versions.

There are several ways to execute the '''tracing''', by simply include into the code report faculties that would produce the output of its state at run time (similarly to the errors and warnings the compiler and linker generates), one can even use the compiler and linker to report special messages. Another way is to interact directly to a debugger in a specified debug mode the debugger to interact with the running code. One can even integrate full fledged [[w:Data logging|logging]] systems that can record that same information in volume, and in an organized fashion, it all depends on the levels of complexity and detail required for the pertinent functionality one requires.

;Event logging versus tracing
Logging can be an objective of a final product, but rarely covering the direct internal functioning of the main program, providing debug information useful for diagnostics and [[w:auditing|auditing]]. The debug information is typically only of interest to the programmers for debugging purposes, and additionally, depending on the type and detail of information contained in a trace log, by experienced [[w:system administrator|system administrator]]s or [[w:technical support|technical support]] personnel to diagnose common problems with software. Tracing is a [[w:cross-cutting concern|cross-cutting concern]].

=== Debugger ===
Normally, there is no way to see the source code of a program while the program is running. This inability to "see under the covers" while the program is executing is a real handicap when you are debugging a program. The most primitive way of looking under the covers is to insert (depending on your programming language) print or display, or exhibit, or echo statements into your code, to display information about what is happening. But finding the location of a problem this way can be a slow, painful process. This is where a ''debugger'' comes in.

If you want to use a debugger and have never used one before, then you have two tasks ahead of you. Your first task is to learn basic debugger concepts and vocabulary. The second is to learn how to use the particular debugger that is available to you. The documentation for your debugger will help you with the second task, but it may not help with the first. In this section we will help you with the first task by providing an introduction to basic debugger concepts and terminology in regard to the language at hand. Once you become familiar with these basics, then your debugger's documentation/use should make more sense to you. Most software debugging is a slow manual process that does not scale well. 

A ''debugger'' is a piece of software that enables you to run your program in debugging mode rather than in normal mode. Running a program in debugging mode allows you to look under the covers while your program is running. Specifically, a ''debugger'' enables you:
# to see the source code of each statement in your program as that statement executes.
# to suspend or pause execution of the program at places of your choosing.
# while the program is paused, to issue various commands in order to examine and change the internal state of the program.
# to resume (or continue) execution.

It is worth noting that there is a generally accepted set of debugger terms and concepts. Most debuggers are evolutionary descendants of a Unix console debugger for C named dbx, so they share concepts and terminology derived from dbx. Many visual debuggers are simply graphic wrappers around a console debugger, so visual debuggers share the same heritage, and the same set of concepts and terms. Programmers keep running into the same types of bugs that others have encountered (even across different languages by reusing code); one common example is buffer overruns.

Debuggers come in two flavors: '''console-mode''' (or simply console) debuggers and '''visual''' or '''graphical''' debuggers.

'''Console debuggers''' are often a part of the language itself, or included in the language's standard libraries. The user interface to a console debugger is the keyboard and a console-mode window (Microsoft Windows users know this as a "DOS console"). When a program is executing under a console debugger, the lines of source code stream past the console window as they are executed. A typical debugger has many ways to specify the exact places in the program where you want execution to pause. When the debugger pauses, it displays a special debugger prompt that indicates that the debugger is waiting for keyboard input. The user types in commands that tell the debugger what to do next. Typical commands would be to display the value of certain program variables, or to continue execution of the program.

'''Visual debuggers''' are typically available as one component of a multi-featured IDE (integrated development environment). A powerful and easy-to-use visual debugger is an important selling-point for an IDE. The user interface of a visual debugger typically looks like the interface of a graphical text editor. The source code is displayed on the screen, in much the same way that it is displayed when you are editing it. The debugger has its own toolbar or menu with specialized debugger features. And it may have a special debugger margin an area to the left of the source code, used for displaying symbols for breakpoints, the current-line pointer, and so on. As the debugger runs, some kind of visual pointer (perhaps a yellow arrow) will move down this debugger margin, indicating which statement has just finished executing, or which statement is about to be executed. Features of the debugger can be invoked by mouse-clicks on areas of the source code, the debugger margin, or the debugger menus.

==== How do you start the debugger? ====
How you start the debugger (or put your program into debugging mode) depends on your programming language and on the kind of debugger that you are using. If you are using a console debugger, then depending on the facilities offered by your particular debugger you may have a choice of several different ways to start the debugger. One way may be to add an argument (e.g. -d) to the command line that starts the program running. If you do this, then the program will be in debugging mode from the moment it starts running. A second way may be to start the debugger, passing it the name of your program as an argument. For example, if your debugger's name is <tt>pdb</tt> and your program's name is <tt>myProgram</tt>, then you might start executing your program by entering <tt>pdb myProgram</tt> at the command prompt. A third way may be to insert statements into the source code of your program statements that put your program into debugging mode. If you do this, when you start your program running, it will execute normally until it reaches the debugging statements. When those statements execute, they put your program into debugging mode, and from that point on you will be in debugging mode.

If you are working with an IDE that provides a visual debugger, then there is usually a "debug" button or menu item on your toolbar. Clicking it will start your program running in debug mode. As the debugger runs, some kind of visual pointer will move down the debugger margin, indicating what statement is executing.

==== Tracing your program ====
To explore the features offered by debuggers, let us begin by imagining that you have a simple debugger to work with. This debugger is very primitive, with an extremely limited feature set. But as a purely hypothetical debugger, it has one major advantage over all real debuggers: simply wishing for a new feature causes that feature magically to be added to the debugger's feature set!

At the outset, your debugger has very few capabilities. Once you start the debugger, it will show you the code for one statement in your program, execute the statement, and then pause. When the debugger is paused, you can tell it to do only two things:
# the command print <aVariableName> will print the value of a variable, and
# the command step will execute the next statement and then pause again.
If the debugger is a console debugger, you must type these commands at the debugger prompt. If the debugger is a visual debugger, you can just click a Next button, or type a variable name into a special Show Variable window. And that is all the capabilities that the debugger has.

Although such a simple debugger is moderately useful, it is also very clumsy. Using it, you very quickly find yourself wishing for more control over where the debugger pauses, and for a larger set of commands that you can execute when the debugger is paused.

==== Controlling where the debugger pauses ====
What you desire most is for the debugger not to pause after every statement. Most programs do a lot of setup work before they get to the area where the real problems lie, and you are tired of having to step through each of those setup statements one statement at a time to get to the real trouble zone. In short, you wish you could ''set breakpoints''. A ''breakpoint'' is an object that you can attach to a line of code. The debugger runs without pausing until it encounters a line with a breakpoint attached to it. The breakpoint tells the debugger to pause, so the debugger pauses.

With breakpoint functionality added to the debugger (wishing for it has made it appear!), you can now set a breakpoint at the beginning of the section of the code where the problem lies, then start up the debugger. It will run the program until it reaches the breakpoint. Then it will pause, and you can start examining the situation with your print command.

But when you're finished using the print command, you are back to where you were before single-stepping through the remainder of the program with the step command. You begin to wish for an alternative to the step command for a run to next breakpoint command. With such a command, you can set multiple breakpoints in the program. Then, when you are paused at a breakpoint, you have the option of single-stepping through the code with the step command, or running to the next breakpoint with the run to next breakpoint command.

With our hypothetical debugger, wishing makes it so! Now you have on-the-fly control over where the program will pause next. You're starting to get some real control over the debugging process!

The introduction of the run to next breakpoint command starts you thinking. What other useful alternatives to the step command can you think of?

Often you find yourself paused at a place in the code where you know that the next 15 statements contain no problems. Rather than stepping through them one-by-one, you wish you could to tell the debugger something like step 15 and it would execute the next 15 statements before pausing.

When you are working your way through a program, you often come to a statement that makes a call to a subroutine. In such cases, the step command is in effect a step into command. That is, it drops down into the subroutine, and allows you to trace the execution of the statements inside the subroutine, one by one.

However, in many cases you know that there is no problem in the subroutine. In such cases, you want to tell the debugger to step over the subroutine call that is, to run the subroutine without pausing at any of the statements inside the subroutine. The step over command is a sort of step (but do not show me any of the messy details) command. (In some debuggers, the step over command is called next.)

When you use step or step into to drop down into a subroutine, it sometimes happens that you get to a point where there is nothing more in the subroutine that is of interest. You wish to be able to tell the debugger to step out or run until subroutine end, which would cause it to run without pause until it encountered a return statement (or an implicit return of control to its caller) and then to pause.

And you realize that the step over and step into commands might be useful with loops as well as with subroutines. When you encounter a looping construct ( a {{C++ Programming/kw|for}} statement or a do while statement, for instance) it would be handy to be able to choose to step into or to step over the execution of the loop.

Almost always there comes a time when there is nothing more to be learned by stepping through the code. You wish for a command to tell the debugger to continue or simply run to the end of the program.

Even with all of these commands, if you are using a console debugger you find that you are still using the step command quite a bit, and you are getting tired of typing the word step. You wish that if you wanted to repeat a command, you could just hit the ENTER key at the debugger prompt, and the debugger would repeat the last command that you entered at the debugger prompt. Lo, wishing makes it so!

This is such a productivity feature, that you start thinking about other features that a console debugger might provide to improve its ease-of-use. You notice that you often need to print multiple variables, and you often want to print the same set of variables over and over again. You wish that you had some way to create a macro or alias for a set of commands. You might like, for example, to define a macro with an alias of foo the macro would consist of a set of debugger print statements. Once foo is defined, then entering foo at the debugger prompt runs the statements in the macro, just as if you had entered them at the debugger prompt.

==== Persistence ====
Eventually the end of the workday arrives. Your debugging work is not yet finished. You log off of your computer and go home for some well-earned rest. The next morning, you arrive at work bright-eyed and bushy-tailed and ready to continue debugging. You boot your computer, fire up the debugger, and find that all of the aliases, breakpoints, and watchpoints that you defined the previous day are gone! And now you have a really big wish for the debugger. You want it to have some persistence. You want it to be able to remember this stuff, so you do not have to re-create it every time you start a new debugger session.

You can define aliases at the debugger prompt, which is great for aliases that you need to invent for special occasions. But often, there is a set of aliases that you need in every debugging session. That is, you'd like to be able to save alias definitions, and automatically re-create the aliases when you start any debugging session.

Most debuggers allow you to create a file that contains alias definitions. That file is given a special name. When the debugger starts, it looks for the file with that special name, and automatically loads those alias definitions.

==== Examining the call stack ====
When you are stepping through a program, one of the questions that you may have is "How did I get to this point in the code?" The answer to this question lies in the ''call stack'' (also known as the ''execution stack'') of the current statement. The ''call stack'' is a list of the functions that were entered to get you to your current statement. For example, if the main program module is MAIN, and MAIN calls function A, and function A calls function B, and function B calls function C, and function C contains statement S, then the execution stack to statement S is:

 MAIN
     A
      B
       C
        statement S

In many interpreted languages, if your program crashes, the interpreter will print the call stack for you as a ''stack trace''.

==== Conditional Breakpoints ====
Some debuggers allow you to attach a set of ''conditions'' to breakpoints. You may be able to specify that the debugger should pause at the breakpoint only if a certain condition is met (for example ''VariableX > 100'') or if the value of a certain variable has changed since the last time the breakpoint was encountered. You may be able, for example, to set the breakpoint to break when a certain counter reaches a value of (say) 100. This would allow a loop to run 100 times before breaking.

A breakpoint that has conditions attached to it is called a ''conditional breakpoint''. A breakpoint that has no conditions attached to it is called an ''unconditional'' or ''simple breakpoint''. In some debuggers, ''all'' breakpoints have conditions attached to them, and "'''unconditional'''" breakpoints are simply breakpoints with a condition of ''true''.

==== Watchpoints ====
Some debuggers support a kind of breakpoint called a ''watch'' or a ''watchpoint''. A '''watchpoint''' is a ''conditional breakpoint'' that is not associated with any particular line, but with a variable. A watchpoint is useful when you would like to pause whenever a certain variable's value changes. Searching through your code, looking for every line that changes the variable's value, and setting breakpoints on those lines, would be both laborious and error-prone. Watchpoints allow you to avoid all of that by associating a breakpoint with a variable rather than a point in the source code. Once a watchpoint has been defined, then it "watches" its variable. Whenever the value of the variable changes, the code pauses and you will probably get a message telling you why execution has paused. Then you can look at where you are in the code and what the value of the variable is.

==== Setting Breakpoints in a Visual Debugger ====
How you create (or "set" or "insert") a breakpoint will depend on your particular debugger, and especially on whether it is a visual debugger or a console-mode debugger. In this section we discuss how you typically set breakpoints in a visual debugger, and in the next section we will discuss how it is done in a console-mode debugger.

Visual debuggers typically let you scroll through the code until you find a point where you want to set a breakpoint. You place the cursor on the line of where you want to insert the breakpoint and then press a special hotkey or click a menu item or icon on the debugger toolbar. If an icon is available, it may be something that suggests the act of watching for instance it may look like a pair of glasses or binoculars. At that point, a special dialog may pop up allowing you to specify whether the breakpoint is conditional or unconditional, and (if it is conditional) allowing you to specify the conditions associated with the breakpoint.

Once the breakpoint has been placed, many visual debuggers place a red dot or a red octagon (similar to a American/European traffic [http://en.wikipedia.org/wiki/Stop_sign "STOP" sign]) in the margin to indicate there is a breakpoint at that point in the code.

=== Other runtime analyzers ===
{{TODO|Add missing info|C++ Programming}}
{{BookCat}}
<noinclude>{{displaytitle|title=C++ Programming}}</noinclude>