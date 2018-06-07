# Algebraic Subtyping for Algebraic Effects and Handlers

## Abstract

Algebraic effects and handlers benefit from a custom type-&-effect system, a type system that also tracks which effects can happen in a program. Several such type-&-effect systems have been proposed in the literature, but all are unsatisfactory. Recently, Stephen Dolan (University of Cambridge, UK) presented a novel type system that combines subtyping and parametric polymorphism in a particulary attractive and elegant fashion. A cornerstone of his design are the algebraic properties that the subtyping relation should respect. In this work, a type-&-effect system is derived that extends Dolan's elegant type system with effect information. This type-&-effect system inherits Dolan's harmonious combination of subtyping (in our case induced by a lattice structure on the effect information) with parametric polymorphism and preserves all of its desirable properties (both low-level algebraic properties and high-level meta-theoretical properties like type soundness and the existence of principal types). This type-&-effect system has been implemented in the Eff programming language in order to provide a proof-of-concept.

## Evaluation

The folder `src` contains the testing programs used for the emperical evaluation done during my thesis. `evaluate.sh` is the script used to execute the benchmarks.