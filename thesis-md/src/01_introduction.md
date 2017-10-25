# Introduction

The specification for a type-\&-effect system with algebraic subtyping for algebraic effects and handlers is given in this document. The formal properties of this system are studied in order to find which properties are satisfied compared to other type-\&-effect systems. The proposed type-\&-effect system builds on two very recent developments in the area of programming language theory.

\paragraph{Algebraic subtyping}
In his December 2016 PhD thesis, Stephen Dolan (University of Cambridge, UK), has presented a novel type system that combines subtyping and parametric polymorphism in a particulary attractive and elegant fashion. A cornerstone of his design are the algebraic properties that the subtyping relation should respect.

\paragraph{Algebraic effects and handlers}
These are a new formalism for formally modelling side-effects (e.g. mutable state or non-determinism) in programming languages, developed by Matija Pretnar (University of Ljubjana) and Gordon Plotkin (University of Edinburgh). This approach is gaining a lot of traction, not only as a formalism but also as a practical feature in actual programming languages (e.g. the Koka language developed by Microsoft Research). We are collaborating with Matija Pretnar on the efficient implementation of one such language, called Eff. Axel Faes has contributed to this collaboration during a project he did for the Honoursprogramme of the Faculty of Engineering Science.

## Motivation
Algebraic effects and handlers benefit from a custom type-\&-effect system, a type system that also tracks which effects can happen in a program. Several such type-\&-effect systems have been proposed in the literature, but all are unsatisfactory. We attribute this to the lack of the elegant properties of Dolan's type system. Indeed the existing type-\&-effect systems are not only theoretically unsatisfactory, but they are also awkward to implement and use in practice.

## Research questions
\begin{itemize}
\item How can Dolan's elegant type system be extended with effect information?
\item Which properties are preserved and which aren't preserved?
\item What advantages are there to an type-\&-effect system based on Dolan's elegant type system?
\end{itemize}

## Goals
The goal of this thesis is to derive a type-\&-effect system that extends Dolan's elegant type system with effect information. This type-\&-effect system should inherit Dolan's harmonious combination of subtyping (in our case induced by a lattice structure on the effect information) with parametric polymorphism and preserve all of its desirable properties (both low-level algebraic properties and high-level meta-theoretical properties like type soundness and the existence of principal types). Afterwards this type-\&-effect system The following approach is taken:
\begin{enumerate}
\item Study of the relevant literature and theoretical background.
\item Design of a type-\&-effect system derived from Dolan's, that integrates effects.
\item Proving the desirable properties of the proposed type-\&-effect system: type soundness, principal typing, ...
\item Time permitting: Design of a type inference algorithm that derives the principal types of programs without type annotations and proving its correctness.
\item Time permitting: Implementation of the algorithm and comparing it to other algorithms (such as row polymorphism based type-\&-effect systems).
\end{enumerate}