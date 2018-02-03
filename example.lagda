\documentclass{article}

\usepackage{comment,lagda}

\title{An example Literate Agda paper}
\author{Alan Jeffrey\\ Mozilla Research}

\begin{comment}
\begin{code}
-- Some definitions used in this example
data /Nat : Set where
  /zero : /Nat
  /succ : /Nat → /Nat
{-# BUILTIN NATURAL /Nat #-}

_+_ : /Nat → /Nat → /Nat
/zero + y = y
/succ x + y = /succ (x + y)
infixr 5 _+_

data _/eq_ {a} {A : Set a} (x : A) : A → Set where
  /refl : x /eq x
infixr 2 _/eq_
\end{code}
\end{comment}

% The LaTeX rendering for those definitions

\newcommand{\eq}{=}

\begin{document}

\maketitle

\section{Introduction}

The idea of these macros is that you can write code in Literate Agda
and then typeset the mathematics in \LaTeX, and have it render as much
like human-readable mathematics as possible.

For example, this equation is verified by Agda:
\begin{code}
--\[
%oneAndOneIsTwo : 
  1 + 1 /eq 2
%oneAndOneIsTwo = /refl
--\]
\end{code}


\end{document}
