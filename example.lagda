\documentclass{article}

\usepackage{comment,lagda}

\title{An example Literate Agda paper}
\author{Alan Jeffrey\\ Mozilla Research}

\begin{comment}
\begin{code}
-- Some definitions used in this example
record /unit : Set where

record _/times_ (A B : Set) : Set where
  field fst : A
  field snd : B

data /Nat : Set where
  /zero : /Nat
  1+ : /Nat -> /Nat
{-# BUILTIN NATURAL /Nat #-}

_+_ : /Nat -> /Nat -> /Nat
/zero + y = y
1+ x + y = 1+ (x + y)
infixr 5 _+_

data _/eq_ {a} {A : Set a} (x : A) : A -> Set where
  /refl : x /eq x
infixr 2 _/eq_

/cong : forall {a b} {A : Set a} {B : Set b} (f : A -> B) {x y : A} -> (x /eq y) -> (f x /eq f y)
/cong f /refl = /refl
\end{code}
\end{comment}

% The LaTeX rendering for those definitions

\newcommand{\eq}{=}
\newcommand{\foo}{\mathsf{foo}}
\newcommand{\raised}{^}
\newcommand{\unit}{()}
\newcommand{\infer}[2]{\frac{\displaystyle #1}{\displaystyle #2}}

\begin{document}

\maketitle

\section{Introduction}

The idea of the \verb|lagda| package is to support writing code in
Literate Agda, which is typeset in \LaTeX, and looks as much
like human-readable mathematics as possible. For example, this equation is verified by Agda:
\begin{code}
--\[
%oneAndOneIsTwo : 
  1 + 1 /eq 2
%oneAndOneIsTwo = /refl
--\]
\end{code}

\section{The code environment}

The macros define one envionment \verb|code|, which contains code that is typechecked
by Agda. For example, we can define $\foo$ as:

\begin{verbatim}
\begin{code}
--\[
/foo = 37
--\]
\end{code}
\end{verbatim}
which is rendered as:
\begin{code*}
--\[
/foo = 37
--\]
\end{code*}
The \verb|code| environment does three things:
\begin{enumerate}

\item It allows forward slash as well as backward slash to act as the command
  escape character, so you can write \verb|/foo| as well as \verb|\foo| inside
  a \verb|code| block. This is needed, because Agda treats \verb|\| as a synonym
  for $\lambda$.

\item It allows parenthesis as well as braces to act as grouping characters,
  so you can write \verb|/bar(x)| as well as \verb|\bar{x}| inside a code block.
  This is needed because Agda treats \verb|{...}| as a hole.

\item It makes \verb|--| expand to nothing rather than ligature to an em-dash,
  which means that you can write Agda comments but still have them rendered by
  LaTeX (such as the use of \verb|--\[| in the example above). This is useful
  for injecting raw LaTeX into Agda.

\end{enumerate}
There's also a \verb|code*| environment, which is exactly the same, but isn't
typechecked by Agda.

That's it for the macros!

\section{Using the code environment}

The \verb|comment| package makes commenting out some Agda technicalities
such as type declarations simple.

If you define a macro such as:
\begin{verbatim}
\newcommand{\raised}{^}
\end{verbatim}
then you can use it in some Agda, for example, its definition is:
\begin{verbatim}
\begin{comment}
\begin{code}
_/raised_ : Set -> /Nat -> Set
\end{code}
\end{comment}
\begin{code}
--\[
A /raised 0 = /unit --\qquad
A /raised (1+ n) = A /times (A /raised n)
--\]
\end{code}
\end{verbatim}
which renders as:
\begin{code*}
--\[
A /raised 0 = /unit --\qquad
A /raised (1+ n) = A /times (A /raised n)
--\]
\end{code*}
This uses \verb|--| to comment out some formatting commands,
such as \verb|--\qquad|.

The \verb|%| character is a comment as far as \LaTeX\ is concerned, but is
a regular character to Agda. This can be used to hide details which should
be elided from readers. For example, we can state that $0$ is the unit of addition:
\begin{verbatim}
\begin{code}
--\[
%plus-left-unit : forall x ->
  (0 + x) /eq x
%plus-left-unit x = /refl
-- /qquad
%plus-right-unit : forall x ->
  (x + 0) /eq x
%plus-right-unit /zero = /refl
%plus-right-unit (1+ x) = /cong 1+ (%plus-right-unit x)
--\]
\end{code}
\end{verbatim}
which renders as:
\begin{code*}
--\[
%plus-left-unit : forall x ->
  (0 + x) /eq x
%plus-left-unit x = /refl
-- /qquad
%plus-right-unit : forall x ->
  (x + 0) /eq x
%plus-right-unit /zero = /refl
%plus-right-unit (1+ x) = /cong 1+ (%plus-right-unit x)
--\]
\end{code*}
Mixing \LaTeX\ and Agda allows things like rendering inductive
definitions in the usual style of deduction rules, for example
if we define:
\begin{verbatim}
\begin{comment}
\begin{code}
_%->_ : Set -> Set -> Set
(A %-> B) = (A -> B)
\end{code}
\end{comment}
\end{verbatim}
then we can define the order on the naturals as:
\begin{verbatim}
\begin{comment}
\begin{code}
data _/leq_ : /Nat -> /Nat -> Set where
\end{code}
\end{comment}
\begin{code}
--\[
  %leq-zero : forall n ->
--\infer(
--)(
    0 /leq n
--)
--\qquad
  %leq-succ : forall m n ->
--\infer(
    (m /leq n) %->
--)(
    (1+ m /leq 1+ n)
--)
--\]
\end{code}
\end{verbatim}
rendered as:
\begin{code*}
--\[
  %leq-zero : forall n ->
--\infer(
--)(
    0 /leq n
--)
--\qquad
  %leq-succ : forall m n ->
--\infer(
    (m /leq n) %->
--)(
    (1+ m /leq 1+ n)
--)
--\]
\end{code*}

\section{Use with latexmk}

The command \verb|latexmk| can be used to run \LaTeX\ whenever a source file changes.
This is particularly nice for Literate Agda files, since typechecking a file in
Emacs (\verb|C-C C-L|) has the side-effect of saving the file, which causes \verb|latexmk|
to typeset the document.

\end{document}
