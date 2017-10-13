# Coherent Nested Composition with Disjoint Intersection Types
## 06 October 2017
## Was the level of presentation appropriate for the audience (e.g., was sufficient background information given)?
The presentation was appropriate for the audience. The presentation assumed knowledge about subtyping and typing rules. Some comparisons were made towards algebraic data types, object-oriented language concepts (such as interfaces and classes). All these concepts can be assumed to be known by the audience, those doing a master's thesis or PhD with professor Schrijvers.

More complex aspects such as intersection types were explained using records. The expressivity problem was also explained using an example such that the audience wasn't required to already know about the expressivity problem.

## What were the strong points of the presentation
* Clear structure of the presentation
  - problem statement
  - existing solutions (and why they fall short)
  - new solution
  - implementation details (and explanation of the magic behind the solution)
* Similar to the first point, the solution was presented in an incremental way
  - first how to add more types
  - then how to add operations
  - finally the combination

The first point allowed the audience to give a context to this research (what is being solved, why don't existing solutions work).
The second point explained the complex solution in a clear way.

## What could be improved?
There was an aspect of the presentation, that duplication is allowed since both elements of the tuple will be the same, which was explained to make the algorithm to prove coherence less complex. However, I did not fully understand why it made the algorithm less complex. A small explanation of this could be helpful.
