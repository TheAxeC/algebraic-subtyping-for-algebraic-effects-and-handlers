# Masterthesis log

This is my main log file for my masterthesis. Progress will be recorded in the log directory.

| Config        |          |
| ------------- |:--------:|

## Meetings

| Thesis meetings        |          |
| ------------- |:--------:|
| 26 September 2017  |  Thesis meeting with daily advisor  |

| Project meetings        |          |
| ------------- |:--------:|

| Seminars        |          |
| ------------- |:--------:|

| Administrative        |          |
| ------------- |:--------:|
| 3 October 2017 | Info session |

## Summary
This topic is situated in the area of Programming Language Theory, the formal study of programming language features and their properties. Specifically, a novel type system will be designed and its formal properties studied. This type system will be focused on algebraic effects and handlers.

## Background
This thesis builds on two very recent developments in the area of programming language theory:
- In his December 2016 PhD thesis, Stephen Dolan (University of Cambridge, UK), has presented a novel type system that combines subtyping and parametric polymorphism in a particulary attractive and elegant fashion. A cornerstone of his design are the algebraic properties that the subtyping relation should respect.
-  "Algebraic effects and handlers" are a new formalism for formally modelling side-effects (e.g. mutable state or non-determinism) in programming languages, developed by Matija Pretnar (University of Ljubjana) and Gordon Plotkin (University of Edinburgh). This approach is gaining a lot of traction, not only as a formalism but also as a practical feature in actual programming languages (e.g. the Koka language developed by Microsoft Research). We are collaborating with Matija Pretnar on the efficient implementation of one such language, called Eff. Axel Faes has contributed to this collaboration during a project he did for the Honoursprogramme of the Faculty of Engineering Science.

Algebraic effects and handlers benefit from a custom type-&-effect system, a type system that also tracks which effects can happen in a program. Several such type-&-effect systems have been proposed in the literature, but all are unsatisfactory. We attribute this to the lack of the elegant properties of Dolan's type system. Indeed the existing type-&-effect systems are not only theoretically unsatisfactory, but they are also akward to implement and use in practice.

## Goals
The goal of this thesis is to derive a type-&-effect system that extends Dolan's elegant type system with effect information. This type-&-effect system should inherit Dolan's harmonious combination of subtyping (in our case induced by a lattice structure on the effect information) with parametric polymorphism and preserve all of its desirable properties (both low-level algebraic properties and high-level meta-theoretical properties like type soundness and the existence of principal types).

I would like to publish my results. Either in the Student Research Competition of ICFP, a workshop of ICFP (such as the ML-family, OCaml or HOPE). Most ideal would be to publish in POPL.

## Research questions
- How can Dolan's elegant type system be extended with effect information?
- Which properties are preserved and which aren't preserved?
  - Working out the metatheory.
- What advantages are there to an type-&-effect system based on Dolan's elegant type system?
  - Does the system lend itself to optimisations?

## Approach
- Study of the relevant literature and theoretical background.
- Design of a type-&-effect system derived from Dolan's, that integrates effects.
- Proving the desirable properties of the proposed type-&-effect system: type soundness, principal typing, ...
- Time permitting: Design of a type inference algorithm that derives the principal types of programs without type annotations and proving its correctness.
- Time permitting: Implementation of the algorithm and comparing it to other algorithms (such as row polymorphism based type-&-effect systems).

## Literature Study
1. *Matija Pretnar. An Introduction to Algebraic Effects and Handlers. 2015. url: http://www.eff-lang.org/handlers-tutorial.pdf.*

2. *Stephen Dolan. Algebraic Subtyping. 2016. url: https://www.cl.cam.ac.uk/~sd601/thesis.pdf.*

3. *Stephen Dolan. Prototype type inference engine. 2016. url: https://github.com/stedolan/mlsub.*

4. *Stephen Dolan and Alan Mycroft. Polymorphism, Subtyping, and Type Inference in MLsub. 2016. url: http://www.cl.cam.ac.uk/~sd601/lfcs_slides.pdf.*

5. *Stephen Dolan and Alan Mycroft. “Polymorphism, Subtyping, and Type Inference in ML- sub”. In: Proceedings of the 44th ACM SIGPLAN Symposium on Principles of Programming Languages. POPL 2017. Paris, France: ACM, 2017, pp. 60–72. isbn: 978-1-4503-4660-3. doi: 10.1145/3009837.3009882. url: http://doi.acm.org/10.1145/3009837.3009882.*

6. *Gordon D. Plotkin and Matija Pretnar. “Handling Algebraic Effects”. In: Logical Methods in Computer Science 9.4 (2013). doi: 10.2168/LMCS-9(4:23)2013. url: http://dx.doi.org/10.2168/LMCS-9(4:23)2013.*

7. *Gordon D. Plotkin and Matija Pretnar. “A Logic for Algebraic Effects”. In: Proceedings of the Twenty-Third Annual IEEE Symposium on Logic in Computer Science, LICS 2008, 24-27 June 2008, Pittsburgh, PA, USA. IEEE Computer Society, 2008, pp. 118–129. isbn: 978-0- 7695-3183-0. doi: 10.1109/LICS.2008.45. url: http://dx.doi.org/10.1109/LICS.2008.45.*

8. *Benjamin C. Pierce. 2002. Types and Programming Languages (1st ed.). The MIT Press. url: http://dl.acm.org/citation.cfm?id=509043*

9. *Andrej Bauer and Matija Pretnar. 2014. An Effect System for Algebraic Effects and Handlers. Logical Methods in Computer Science 10, 4 (2014). https://doi.org/10.2168/LMCS-10(4:9)2014*

10. *Andrej Bauer and Matija Pretnar. 2015. Programming with algebraic effects and handlers. Journal of Logical and Algebraic Methods in Programming. 84, 1 (2015), 108–123. https://doi.org/10.1016/j.jlamp.2014.02.001*

11. *Daniel Hillerström and Sam Lindley. 2016. Liberating Effects with Rows and Handlers. In Proceedings of the 1st International Workshop on Type-Driven Development (TyDe 2016). ACM, New York, NY, USA, 15–27. https://doi.org/10.1145/2976022.2976033*

12. *Daan Leijen. 2014. Koka: Programming with row polymorphic effect types. arXiv preprint arXiv:1406.2061 (2014).*

13. *Daan Leijen. 2017. Type Directed Compilation of Row-typed Algebraic Effects. In Proceedings of the 44th ACM SIGPLAN Symposium on Principles of Programming Languages (POPL 2017). ACM, New York, NY, USA, 486–499. https://doi.org/10.1145/3009837.3009872*

14. *Sam Lindley, Conor McBride, and Craig McLaughlin. 2017. Do Be Do Be Do. In Proceedings of the 44th ACM SIGPLAN Symposium on Principles of Programming Languages (POPL 2017). ACM, New York, NY, USA, 500–514. https://doi.org/10.1145/3009837.3009897*

15. *Matija Pretnar. 2014. Inferring Algebraic Effects. Logical Methods in Computer Science 10, 3 (2014). https://doi.org/10.2168/LMCS-10(3: 21)2014*

16. *Compagnoni, A.B., 1995. Higher-order subtyping with intersection types. [Sl: sn].*

17. *Benjamin Pierce, 1991. Programming with intersection types and bounded polymorphism (Doctoral dissertation, Carnegie Mellon University).*

18. *Benjamin Pierce, 1991. Programming with intersection types, union types, and polymorphism.*

### August
[1], [6] and [7] were read during my honoursprogramme. These papers and others from Matija Pretnar, Daan Leijen, Daniel Hillerström and Sam Lindley describe algebraic effects and handlers. I have worked through this material during my honourprojects. During these projects, I designed and implemented a new type-&-effect system based on row polymorphism.

[8] is Types and Programming Languages, a book written by Benjamin Pierce. This books provides an excellent background for type systems, polymorphism and subtyping.

[4] and [5] were read during the summer vacation in August, while [2] was read in September. The prototype type inference engine [3] provided an implementation to play around with. These papers describe how ML-type polymorphism can be extended with subtyping. An advantage of this is that relationships between input and output types can be defined instead of just stating equivalences between input and output types.

## Intermediate report/presentation #1

## Intermediate report/presentation #2

## Intermediate report/presentation #3

## Poster

## Text

## Paper
