
# Introductory examples:

- royal -- toy prolog database
- fun -- functions in prolog
- lists -- equivalent list syntaxes

# Applications of Logic Programming

- money -- money puzzle
- bcnf -- functional dependencies

# Symbolic Interpretation

- expr -- standard DCG example
- calc -- calculator language
- lambda -- lambda calculus interpreter

NB: The last three examples make use of definite clause grammars.
They work with ciao prolog, and probably can be easily ported to any other standard prolog that provides a dcg package.  This version also makes use of ciao prolog's experimental module support.

Oscar Nierstrasz 2002-03-11

---

# Getting started on Un*x-like machines

<http://www.ciaohome.org/docs/branches/1.14/13646/CiaoDE-1.14.2-13646_ciao.html/GetStartUnix.html>

"Typing ciao (or ciaosh) should start the typical Prolog-style top-level shell."

"Once the shell is started, you can compile and execute modules inside the interactive top-level shell in the standard way. E.g., type use_module(file)., use_module(library(file)). for library modules, ensure_loaded(file). for files which are not modules, and use_package(file). for library packages (these are syntactic/semantic packages that extend the Ciao language in many different ways). Note that the use of compile/1 and consult/1 is discouraged in Ciao."

consult/1 seems to work just fine for the examples (which are not modules).

---
