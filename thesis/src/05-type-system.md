# Core language (\core)
\core is a language with row-based effects, intersection and union types and effects and is subtyping based.

## Types and terms
\paragraph{Terms}
Figure~\ref{fig:terms:core} shows the two types of terms in \core. There are values $v$ and computations $c$. Computations are terms that can contain effects. Effects are denoted as operations $Op$ which can be called. The function term is explicitly annotated with a type and type abstraction and type application has been added to the language. These terms only work on pure types.

\paragraph{Types}
Figure~\ref{fig:types:core} shows the types of \core. There are two main sorts of types. There are (pure) types $A, B$ and dirty types $\C, \D$. A dirty type is a pure type $A$ tagged with a finite set of operations $\dirt$, which we call dirt, that can be called. It can also be an union or intersection of dirty types. In further sections, the relations between dirty intersections or unions and pure intersections or unions are explained. The finite set $\dirt$ is an over-approximation of the operations that are actually called. Row variables are introduced as well as intersection and unions. The $\dirtend$ is used to close rows that do not end with a row variable. The type $\C \hto \D$ is used for handlers because a handler takes an input computation $\C$, handles the effects in this computation and outputs computation $\D$ as the result.

\begin{figure}[h]
\begin{center}
\framebox{
\begin{minipage}{0.98\columnwidth}
\[\begin{array}{r@{~}c@{~}l@{\quad}l}
  \text{value}~v & \bnfis {} & x & \text{variable} \\
    & \bnfor & \const & \text{constant} \\
    & \bnfor & \funtyped{x}{A}{c} & \text{function} \\
    & \bnfor & \Lambda \alpha . v & \text{type abstraction} \\
    & \bnfor & v \, A & \text{type application} \\
    & \bnfor & \{ & \text{handler} \\
    & & \quad \ret x \mapsto c_r, & \quad\text{return case} \\
    & & \quad \shortcases & \quad\text{operation cases} \\
    & & \} & \\
  \text{comp}~c & \bnfis & v_1 \, v_2 & \text{application} \\
    & \bnfor & \conditional{e}{c_1}{c_2} & \text{conditional} \\
    & \bnfor & \letrecin{f \, x = c_1} c_2 & \text{rec definition} \\
    & \bnfor & \ret v  & \text{returned val} \\
    & \bnfor & \op \, v & \text{operation call} \\
    & \bnfor & \doin{x \leftarrow c_1} c_2 & \text{sequencing} \\
    & \bnfor & \withhandle{v}{c} & \text{handling}
\end{array}\]
\end{minipage}
}
\end{center}
\caption{Terms of \core}\label{fig:terms:core}
\end{figure}

\begin{figure}[h]
\begin{center}
\framebox{
\begin{minipage}{0.98\columnwidth}
\[\begin{array}{r@{~}c@{~}l@{\quad}l}
  \text{(pure) type}~A, B & \bnfis {}
    & \boolty \bnfor \intty & \text{basic types} \\
    & \bnfor & A \to \C & \text{function type} \\
    & \bnfor & \C \hto \D & \text{handler type} \\
    & \bnfor & \alpha & \text{type variable} \\
    & \bnfor & \polytype{A} & \text{polytype} \\
    & \bnfor & \top & \text{top} \\
    & \bnfor & \bot & \text{bottom} \\
    & \bnfor & A \intersection B & \text{intersection} \\
    & \bnfor & A \union B & \text{union} \\
  \text{dirty type}~\C, \D & \bnfis {} & A \E \dirt \\
    & \bnfor & \C \intersection \D & \text{intersection} \\
    & \bnfor & \C \union \D & \text{union} \\
  \text{dirt}~\dirt & \bnfis {} & \{\text{R}\} \\
  \text{R} & \bnfis {}
    & \op \row & \text{row} \\
    & \bnfor & \delta & \text{row variable} \\
    & \bnfor & . & \text{closed row} \\
    & \bnfor & \delta_1 \intersection \delta_2 & \text{\textbf{row intersection}} \\
    & \bnfor & \delta_1 \union \delta_2 & \text{\textbf{row union}} \\
    & \bnfor & R_1 \intersection R_2 & \text{intersection} \\
    & \bnfor & R_1 \union R_2 & \text{union}
\end{array}\]
\end{minipage}
}
\end{center}
\caption{Types of \core}\label{fig:types:core}
\end{figure}

## Type system
### Subtyping
The subtyping rules are given in Figure~\ref{fig:core-subtyping}, Figure~\ref{fig:core-subtyping-dist} and Figure~\ref{fig:core-subtyping-dirt}. Figure~\ref{fig:core-subtyping} contains all subtyping rules related to types. Figure~\ref{fig:core-subtyping-dist} contains the distributative subtyping rules. Finally Figure~\ref{fig:core-subtyping-dirt} contains the subtyping rules that govern the dirts.

The dirty type $A \E \dirt$ is assigned to a computation returning values of type $A$ and potentially calling operations from the set $\dirt$. This set $\dirt$ is always an over-approximation of the actually called operations, and may safely be increased, inducing a natural subtyping judgement $A \E \dirt \leq A \E \dirt'$ on dirty types. As dirty types can occur inside pure types, we also get a derived subtyping judgement on pure types. Observe that, as usual, subtyping is contravariant in the argument types of functions and handlers, and covariant in their return types.

\paragraph{Dirt intersection and union}
There are several possible methods to compute the dirt intersection and union. If row variables were to be disregarded, dirt union and intersection could be defined as set union and intersection. This methods allows unions and intersections to be eliminated. This has an advantage, eliminating unions and intersections simplifies the effect system. However, we cannot disregard row variables.

Thus, set union and intersection cannot simply be used. It would be possible to define two extra types, namely $\delta_1 \union \delta_2$ and $\delta_1 \intersection \delta_2$. Using these types, it is possible to use a form of set union and intersection. The following union $\{Op_1, ..., Op_n, \delta_1\} \union \{Op_{n+1}, ..., Op_{n+m}, \delta_2\}$ could be defined as $\{Op_1, ..., Op_n, Op_{n+1}, ..., Op_{n+m}, (\delta_1 \union \delta_2)\}$. A similar construction can be used for intersection. This simplifies the subtyping rules since the more complicated aspects are enclosed within the row variables.

\begin{figure}[h]
\begin{center}
\framebox{
\begin{minipage}{0.95\columnwidth}
\textbf{Subtyping of pure and dirty types}
\begin{mathpar}
  \inferrule[Sub-Top]{
  }{
    A \le \top
  }

  \inferrule[Sub-Bottom]{
  }{
    \bot \le A
  }
  \\

  \inferrule[Sub-$\boolty$]{
  }{
    \boolty \le \boolty
  }

  \inferrule[Sub-$\intty$]{
  }{
    \intty \le \intty
  }
  \\

  \inferrule[Sub-Refl]{
  }{
    A \le A
  }

  \inferrule[Sub-Trans]{
    A_1 \le A_2 \\
    A_2 \le A_3
  }{
    A_1 \le A_3
  }
  \\

  \inferrule[Sub-$\E$]{
    A_1 \le A'_2 \\
    \dirt_1 \le \dirt'_2
  }{
    A_1 \E \dirt_1 \le A_2 \E \dirt_2
  }

  \inferrule[Sub-All]{
    A \le B
  }{
   \polytype{A} \le \polytype{B}
  }
  \\

  \inferrule[Sub-$\to$]{
    A_2 \le A_1 \\
    \C_1 \le \C_2
  }{
    A_1 \to \C_1 \le A_2 \to \C_2
  }

  \inferrule[Sub-$\hto$]{
    \C_2 \le \C_1 \\
    \D_1 \le \D_2
  }{
    \C_1 \hto \D_1 \le \C_2 \hto \D_2
  }
  \\
  \inferrule[Sub-Inter]{
    A_1 \le A_2 \\
    B_1 \le B_2 \\
  }{
    A_1 \intersection B_1 \le A_2 \intersection B_2
  }

  \inferrule[Sub-Union]{
    A_1 \le A_2 \\
    B_1 \le B_2 \\
  }{
    A_1 \union B_1 \le A_2 \union B_2
  }

  \inferrule[Sub-Inter-G]{
    A \le B_1 \\
    A \le B_2 \\
  }{
    A \le B_1 \intersection B_2
  }

  \inferrule[Sub-Inter-LB]{
    i \in \{1; 2\}
  }{
    A_1 \intersection A_2 \le A_i
  }

  \inferrule[Sub-Union-L]{
    B_1 \le A \\
    B_2 \le A \\
  }{
    B_1 \union B_2 \le A
  }

  \inferrule[Sub-Inter-UB]{
    i \in \{1; 2\}
  }{
    A_i \le A_1 \union A_2
  }
\end{mathpar}
\end{minipage}
}
\end{center}
\caption{Subtyping for pure and dirty types of \core}\label{fig:core-subtyping}
\end{figure}

\begin{figure}[h]
\begin{center}
\framebox{
\begin{minipage}{0.95\columnwidth}
\textbf{Distributivity Subtyping of pure and dirty types}
\begin{mathpar}
  \inferrule[Sub-Dist-Func-Inter]{
  }{
    (A \to \C) \intersection (A \to \D) \le A \to (\C \intersection \D)
  }

  \inferrule[Sub-Dist-Func-Union]{
  }{
    (A \to \C) \intersection (B \to \C) \le (A \union B) \to \C
  }

  \inferrule[Sub-Dist-Hand-Inter]{
  }{
    (A \hto \C) \intersection (A \hto \D) \le A \hto (\C \intersection \D)
  }

  \inferrule[Sub-Dist-Hand-Union]{
  }{
    (A \hto \C) \intersection (B \hto \C) \le (A \union B) \hto \C
  }

  \inferrule[Sub-Dist-All]{
  }{
    \polytype{A} \intersection \polytype{B} \le \polytype{A \intersection B}
  }

  \inferrule[Sub-Inter-Union]{
  }{
    (A_1 \intersection A_3) \union (A_2 \intersection A_4) \le (A_1 \union A_2) \intersection (A_3 \union A_4)
  }

  \inferrule[Sub-Union-Inter]{
  }{
    (A_1 \union A_3) \intersection (A_2 \union A_4) \le (A_1 \intersection A_2) \union (A_3 \intersection A_4)
  }
\end{mathpar}
\end{minipage}
}
\end{center}
\caption{Distributivity Subtyping for pure and dirty types of \core}\label{fig:core-subtyping-dist}
\end{figure}

\begin{figure}[h!]
\begin{center}
\framebox{
\begin{minipage}{0.95\columnwidth}
\textbf{Subtyping of dirts}
\begin{mathpar}
  \inferrule[Sub-$\E$-Empty]{
  }{
    \emptyrow \le \dirt
  }

  \inferrule[Sub-$\E$-Top]{
  }{
     \{Op_1, ..., Op_n, .\} \le \{Op_1, ..., Op_n, \delta\}
  }
  \\

  \inferrule[Sub-$\E$-Refl]{
  }{
     \dirt \le \dirt
  }

  \inferrule[Sub-$\E$-Trans]{
    \dirt_1 \le \dirt_2 \\
    \dirt_2 \le \dirt_3
  }{
     \dirt_1 \le \dirt_3
  }
  \\

  \inferrule[Sub-$\E$-Row-Row]{
    n \ge 0 \\
    m \ge 0 \\
    p \ge 0 \\
    \{Op_1, ..., Op_{n}, Op_{n+m+1}, ..., Op_{n+m+p}, \delta_1\} \le \\ \{Op_1, ..., Op_n, Op_{n+1}, ..., Op_{n+m}, \delta_2\}
  }{
    \{\delta_1\} \le \{Op_{n+1}, ..., Op_{n+m}, \delta_2\} \\
    Op_{n+m}, ..., Op_{n+m+p} \subseteq \delta_2
  }

  \inferrule[Sub-$\E$-Dot-Row]{
    n \ge 0 \\
    m \ge 0 \\
    p \ge 0 \\
    \{Op_1, ..., Op_{n}, Op_{n+m+1}, ..., Op_{n+m+p}, .\} \le \\ \{Op_1, ..., Op_n, Op_{n+1}, ..., Op_{n+m}, \delta_2\}
  }{
    \emptyrow \le \{Op_{n+1}, ..., Op_{n+m}, \delta_2\} \\
    Op_{n+m}, ..., Op_{n+m+p} \subseteq \delta_2
  }

  % \inferrule[Sub-$\E$-Row-Row]{
  %   n \ge 0 \\
  %   m \ge 0 \\
  %   \{Op_1, ..., Op_n, \delta_1\} \le \{Op_1, ..., Op_n, Op_{n+1}, Op_{n+m}, \delta_2\}
  % }{
  %   \{\delta_1\} \le \{Op_{n+1}, Op_{n+m}, \delta_2\}
  % }

  \inferrule[Sub-$\E$-Row-Dot]{
    n \ge 0 \\
    m \ge 0 \\
    \{Op_1, ..., Op_n, \delta_1\} \le \{Op_1, ..., Op_n, Op_{n+1}, Op_{n+m}, .\}
  }{
    \{\delta_1\} \le \{Op_{n+1}, Op_{n+m}, .\}
  }

  % \inferrule[Sub-$\E$-Dot-Row]{
  %   n \ge 0 \\
  %   m \ge 0 \\
  %   \{Op_1, ..., Op_n, .\} \le \{Op_1, ..., Op_n, Op_{n+1}, ..., Op_{n+m}, \delta_2\}
  % }{
  %   \emptyrow \le \{Op_{n+1}, Op_{n+m}, \delta_2\}
  % }

  \inferrule[Sub-$\E$-Dot-Dot]{
    n \ge 0 \\
    m \ge 0 \\
    \{Op_1, ..., Op_n, .\} \le \{Op_1, ..., Op_n, Op_{n+1}, ..., Op_{n+m}, .\}
  }{
    \emptyrow \le \{Op_{n+1}, Op_{n+m}, .\}
  }

  \inferrule[Sub-Inter-$\E$]{
    \dirt_1 \le \dirt_2 \\
    \dirt_3 \le \dirt_4 \\
  }{
    \dirt_1 \intersection \dirt_3 \le \dirt_2 \intersection \dirt_4
  }

  \inferrule[Sub-Union-$\E$]{
    \dirt_1 \le \dirt_2 \\
    \dirt_3 \le \dirt_4 \\
  }{
    \dirt_1 \union \dirt_3 \le \dirt_2 \union \dirt_4
  }

  \inferrule[Sub-Inter-G-$\E$]{
    \dirt_1 \le \dirt_2 \\
    \dirt_1 \le \dirt_3
  }{
    \dirt_1 \le (\dirt_2 \intersection \dirt_3)
  }

  \inferrule[Sub-Inter-LB-$\E$]{
    i \in \{1; 2\}
  }{
    (\dirt_1 \intersection \dirt_2) \le \dirt_i
  }

  \inferrule[Sub-Union-L-$\E$]{
    \dirt_2 \le \dirt_1 \\
    \dirt_3 \le \dirt_1
  }{
    (\dirt_2 \union \dirt_3) \le \dirt_1
  }

  \inferrule[Sub-Union-UB-$\E$]{
    i \in \{1; 2\}
  }{
    \dirt_i \le (\dirt_1 \union \dirt_2)
  }

  \inferrule[Sub-Inter-Union-$\E$]{
  }{
    (\dirt_1 \intersection \dirt_3) \union (\dirt_2 \intersection \dirt_4) \le (\dirt_1 \union \dirt_2) \intersection (\dirt_3 \union \dirt_4)
  }

  \inferrule[Sub-Union-Inter-$\E$]{
  }{
    (\dirt_1 \union \dirt_3) \intersection (\dirt_2 \union \dirt_4) \le (\dirt_1 \intersection \dirt_2) \union (\dirt_3 \intersection \dirt_4)
  }
\end{mathpar}
\end{minipage}
}
\end{center}
\caption{Subtyping for dirts of \core}\label{fig:core-subtyping-dirt}
\end{figure}

\begin{figure}[h!]
\begin{center}
\framebox{
\begin{minipage}{0.95\columnwidth}
\textbf{Subtyping of dirts}
\begin{mathpar}
  \inferrule[Sub-$\E$-Empty]{
  }{
    . \le \delta
  }

  \inferrule[Sub-$\E$-Refl]{
  }{
     \delta \le \delta
  }

  \inferrule[Sub-$\E$-Trans]{
    \delta_1 \le \delta_2 \\
    \delta_2 \le \delta_3
  }{
     \delta_1 \le \delta_3
  }

  \inferrule[Sub-Inter-$\E$]{
    \delta_1 \le \delta_2 \\
    \delta_3 \le \delta_4 \\
  }{
    \delta_1 \intersection \delta_3 \le \delta_2 \intersection \delta_4
  }

  \inferrule[Sub-Union-$\E$]{
    \delta_1 \le \delta_2 \\
    \delta_3 \le \delta_4 \\
  }{
    \delta_1 \union \delta_3 \le \delta_2 \union \delta_4
  }

  \inferrule[Sub-Inter-G-$\E$]{
    \delta_1 \le \delta_2 \\
    \delta_1 \le \delta_3
  }{
    \delta_1 \le (\delta_2 \intersection \delta_3)
  }

  \inferrule[Sub-Inter-LB-$\E$]{
    i \in \{1; 2\}
  }{
    (\delta_1 \intersection \delta_2) \le \delta_i
  }

  \inferrule[Sub-Union-L-$\E$]{
    \delta_2 \le \delta_1 \\
    \delta_3 \le \delta_1
  }{
    (\delta_2 \union \delta_3) \le \delta_1
  }

  \inferrule[Sub-Union-UB-$\E$]{
    i \in \{1; 2\}
  }{
    \delta_i \le (\delta_1 \union \delta_2)
  }

  \inferrule[Sub-Inter-Union-$\E$]{
  }{
    (\delta_1 \intersection \delta_3) \union (\delta_2 \intersection \delta_4) \le (\delta_1 \union \delta_2) \intersection (\delta_3 \union \delta_4)
  }

  \inferrule[Sub-Union-Inter-$\E$]{
  }{
    (\delta_1 \union \delta_3) \intersection (\delta_2 \union \delta_4) \le (\delta_1 \intersection \delta_2) \union (\delta_3 \intersection \delta_4)
  }

  \inferrule[Dirt-Var-Union-$\E$]{
  }{
     \{Op_1, ..., Op_n, Op_{n+1}, ..., Op_{n+m}, (\delta_1 \union \delta_2)\} \le\\
     \{Op_1, ..., Op_n, \delta_1\} \union \{Op_{n+1}, ..., Op_{n+m}, \delta_2\}
  }

  \inferrule[Dirt-Var-Intersection-$\E$]{
  }{
    \{Op_i | Op_i \in \{Op_1, ..., Op_n\} \land \\Op_i \in \{Op_{n+1}, ..., Op_{n+m}\}, (\delta_1 \intersection \delta_2)\} \le\\
    \{Op_1, ..., Op_n, \delta_1\} \intersection \{Op_{n+1}, ..., Op_{n+m}, \delta_2\}
  }

\end{mathpar}
\end{minipage}
}
\end{center}
\caption{Subtyping for dirts of \core using row variable unions and intersections}\label{fig:core-subtyping-dirt2}
\end{figure}

### Typing rules
Figure~\ref{fig:core-typing} defines the typing judgements for values and computations with respect to a standard typing context $\ctx$.

\paragraph{Values}
The rules for subtyping, variables, type abstraction, type application and functions are entirely standard. For constants we assume a signature $\sig$ that assigns a type~$A$ to each constant~$\const$, which we write as $(\const \T A) \in \sig$.

A handler expression has type $A \E \dirt \cup \ops \hto B \E \dirt$ iff all branches (both the operation cases and the return case) have dirty type $B \E \dirt$ and the operation cases cover the set of operations $\ops$. Note that the intersection $\dirt \cap \ops$ is not necessarily empty (with $\cap$ being the intersection of the operations, not to be confused with the $\intersection$ type). The handler deals with the operations $\ops$, but in the process may re-issue some of them (i.e., $\dirt \cap \ops$).

When typing operation cases, the given signature for the operation $(\op \T A_\op \to B_\op) \in \sig$ determines the type $A_\op$ of the parameter $x$ and the domain $B_\op$ of the continuation $k$. As our handlers are deep, the codomain of $k$ should be the same as the type $B \E \dirt$ of the cases.

\paragraph{Computations}
With the following exceptions, the typing judgement $\ctx \ent c : \C$ has a straightforward definition. The $\ret$ construct renders a value $v$ as a pure computation, i.e., with empty dirt. In this case, this is defined as a set with the $\dirtend$ as the only element. An operation invocation $\op\,v$ is typed according to the operation's signature, with the operation itself as its only operation. Finally, rule \textsc{With} shows that a handler with type $\C \hto \D$ transforms a computation with type $\C$ into a computation with type $\D$.

\begin{figure}[h]
\begin{center}
\framebox{
\begin{minipage}{0.95\columnwidth}
\[\begin{array}{r@{~}c@{~}l}
  \text{typing contexts}~\ctx & \bnfis {} & \epsilon \bnfor \ctx, x : A, x : \polytype{B}\\
\end{array}\]
\textbf{Expressions}
\begin{mathpar}
  \inferrule[Val]{
    \ctx \ent v \T A \\
    A \le B
  }{
    \ctx \ent v \T B
  }

  \inferrule[Var]{
    (x \T A) \in \ctx
  }{
    \ctx \ent x \T A
  }

  \inferrule[Const]{
    (\const \T A) \in \sig
  }{
    \ctx \ent \const \T A
  }

  \inferrule[Type Abs]{
    \ctx, \alpha \ent v \T A
  }{
    \ctx \ent \Lambda \alpha . v \T \polytype{A}
  }

  \inferrule[Type App]{
    \ctx \ent v \T \polytype{B}
  }{
    \ctx \ent v \, A \T B[A/\alpha]
  }

  \inferrule[Fun]{
    \ctx, x \T A \ent c \T \C
  }{
    \ctx \ent \funtyped{x}{A}{c} \T A \to \C
  }

  % \inferrule[Hand]{
  % 	\C = A \E \{Op_i \row\} \\
  % 	\D = B \E \{Op_i \row\} \\
  % 	(\op_i \T A_\op \to B_\op) \in \sig \qquad \\
  % 	h = \shorthand \\
  % 	\ctx, x \T A_\op \ent c_r \T \D \\
  % 	\ctx, y \T A_\op, k \T B_\op \to \D \ent c_{op} \T \D \\
  % }{
  % 	\ctx \ent h \T \C \hto \D
  % }

  \inferrule[Hand]{
    \ctx, x \T A \ent c_r \T B \E \dirt \\
    \Big[
      (\op \T A_\op \to B_\op) \in \sig \qquad \\
      \ctx, x \T A_\op, k \T B_\op \to B \E \dirt \ent c_\op \T B \E \dirt
    \Big]_{\op \in \ops}
  }{
    \ctx \ent \shorthand \T \\ A \E \dirt \cup \ops \hto B \E \dirt
  }

\end{mathpar}
\textbf{Computations}
\begin{mathpar}
  \inferrule[Comp]{
    \ctx \ent c \T \C \\
    \C \le \D
  }{
    \ctx \ent c \T \D
  }

  \inferrule[App]{
    \ctx \ent v_1 \T A \to \C \\
    \ctx \ent v_2 \T A
  }{
    \ctx \ent v_1 \, v_2 \T \C
  }

  \inferrule[Cond]{
    \ctx \ent v \T A \\
    \ctx \ent c_1 \T \C \\
    \ctx \ent c_2 \T \D \\
  }{
    \ctx \ent \conditional{v}{c_1}{c_2} \T (\C \union \D)
  }

 \inferrule[LetRec]{
    \ctx, f \T A \to \C, x \T A \ent c_1 \T \C \\
    \ctx, f \T A \to \C \ent c_2 \T \D
  }{
    \ctx \ent \letrecin{f \, x = c_1} c_2 \T \D
  }

  \inferrule[Ret]{
    \ctx \ent v \T A
  }{
    \ctx \ent \ret v \T A \E \emptyrow
  }

  \inferrule[Op]{
    (\op \T A \to B) \in \sig \\
    \ctx \ent v \T A \\
    \C \T B \E \{\op \row\}
  }{
    \ctx \ent \op \, v \T \C
  }

  \inferrule[Do]{
    \ctx \ent c_1 \T A \E \dirt \\
    \ctx, x \T A \ent c_2 \T B \E \dirt
  }{
    \ctx \ent \doin{x \leftarrow c_1} c_2 \T B \E \dirt
  }

  \inferrule[With]{
    \ctx \ent v \T \C \hto \D \\
    \ctx \ent c \T \C
  }{
    \ctx \ent \withhandle{v}{c} \T \D
  }

\end{mathpar}
\end{minipage}
}
\end{center}
\caption{Typing of \core}\label{fig:core-typing}
\end{figure}