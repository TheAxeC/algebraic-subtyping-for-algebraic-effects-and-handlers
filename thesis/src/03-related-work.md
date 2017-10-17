# Related Work (\eff)
The type-\&-effect system that is used in \eff is based on subtyping and dirty types [@effectsystem].
<!-- \cite{effectsystem} -->

## Types and terms
\paragraph{Terms}
Figure~\ref{fig:terms:eff} shows the two types of terms in \eff. There are values $v$ and computations $c$. Computations are terms that can contain effects. Effects are denoted as operations $Op$ which can be called.

\paragraph{Types}
Figure~\ref{fig:types:eff} shows the types of \eff. There are two main sorts of types. There are (pure) types $A, B$ and dirty types $\C, \D$. A dirty type is a pure type $A$ tagged with a finite set of operations $\dirt$, which we call dirt, that can be called. This finite set $\dirt$ is an over-approximation of the operations that are actually called. The type $\C \hto \D$ is used for handlers because a handler takes an input computation $\C$, handles the effects in this computation and outputs computation $\D$ as the result.

\begin{figure}[h]
\begin{center}
\framebox{
\begin{minipage}{0.98\columnwidth}
\[\begin{array}{r@{~}c@{~}l@{\quad}l}
  \text{value}~v & \bnfis {} & x & \text{variable} \\
    & \bnfor & \const & \text{constant} \\
    & \bnfor & \fun{x} c & \text{function} \\
    & \bnfor & \{ & \text{handler} \\
    & & \quad \ret x \mapsto c_r, & \quad\text{return case} \\
    & & \quad \shortcases & \quad\text{operation cases} \\
    & & \} & \\
  \text{comp}~c & \bnfis & v_1 \, v_2 & \text{application} \\
    & \bnfor & \letrecin{f \, x = c_1} c_2 & \text{rec definition} \\
    & \bnfor & \ret v  & \text{returned val} \\
    & \bnfor & \op \, v & \text{operation call} \\
    & \bnfor & \doin{x \leftarrow c_1} c_2 & \text{sequencing} \\
    & \bnfor & \withhandle{v}{c} & \text{handling}
\end{array}\]
\end{minipage}
}
\end{center}
\caption{Terms of \eff}\label{fig:terms:eff}
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
  \text{dirty type}~\C, \D & \bnfis {} & A \E \dirt \\
  \text{dirt}~\dirt & \bnfis {} &\set{\op_1, \dots, \op_n}
\end{array}\]
\end{minipage}
}
\end{center}
\caption{Types of \eff}\label{fig:types:eff}
\end{figure}

## Type System
### Subtyping
The dirty type $A \E \dirt$ is assigned to a computation returning values of type $A$ and potentially calling operations from the set $\dirt$. This set $\dirt$ is always an over-approximation of the actually called operations, and may safely be increased, inducing a natural subtyping judgement $A \E \dirt \leq A \E \dirt'$ on dirty types. As dirty types can occur inside pure types, we also get a derived subtyping judgement on pure types. Both judgements are defined in Figure~\ref{fig:subtyping}. Observe that, as usual, subtyping is contravariant in the argument types of functions and handlers, and covariant in their return types.

\begin{figure}[h]
\begin{center}
\framebox{
\begin{minipage}{0.95\columnwidth}
\textbf{Subtyping}
\begin{mathpar}
  \inferrule[Sub-$\boolty$]{
  }{
    \boolty \le \boolty
  }

  \inferrule[Sub-$\intty$]{
  }{
    \intty \le \intty
  }

  \inferrule[Sub-$\to$]{
    A' \le A \\
    \C \le \C'
  }{
    A \to \C \le A' \to \C'
  }

  \inferrule[Sub-$\hto$]{
    \C' \le \C \\
    \D \le \D'
  }{
    \C \hto \D \le \C' \hto \D'
  }

  \inferrule[Sub-$\E$]{
    A \le A' \\
    \dirt \subseteq \dirt'
  }{
    A \E \dirt \le A' \E \dirt'
  }
\end{mathpar}
\end{minipage}
}
\end{center}
\caption{Subtyping for pure and dirty types of \eff}\label{fig:subtyping}
\end{figure}

### Typing rules
Figure~\ref{fig:eff-typing} defines the typing judgements for values and computations with respect to a standard typing context $\ctx$.

\paragraph{Values}
The rules for subtyping, variables, and functions are entirely standard. For constants we assume a signature $\sig$ that assigns a type~$A$ to each constant~$\const$, which we write as $(\const \T A) \in \sig$.

A handler expression has type $A \E \dirt \cup \ops \hto B \E \dirt$ iff all branches (both the operation cases and the return case) have dirty type $B \E \dirt$ and the operation cases cover the set of operations $\ops$. Note that the intersection $\dirt \cap \ops$ is not necessarily empty. The handler deals with the operations $\ops$, but in the process may re-issue some of them (i.e., $\dirt \cap \ops$).

When typing operation cases, the given signature for the operation $(\op \T A_\op \to B_\op) \in \sig$ determines the type $A_\op$ of the parameter $x$ and the domain $B_\op$ of the continuation $k$. As our handlers are deep, the codomain of $k$ should be the same as the type $B \E \dirt$ of the cases.

\paragraph{Computations}
With the following exceptions, the typing judgement $\ctx \ent c : \C$ has a straightforward definition. The $\ret$ construct renders a value $v$ as a pure computation, i.e., with empty dirt. An operation invocation $\op\,v$ is typed according to the operation's signature, with the operation itself as its only operation. Finally, rule \textsc{With} shows that a handler with type $\C \hto \D$ transforms a computation with type $\C$ into a computation with type $\D$.

\begin{figure}[h]
\begin{center}
\framebox{
\begin{minipage}{0.95\columnwidth}
\[\begin{array}{r@{~}c@{~}l}
  \text{typing contexts}~\ctx & \bnfis {} & \epsilon \bnfor \ctx, x : A\\
\end{array}\]
\textbf{Expressions}
\begin{mathpar}
  \inferrule[SubVal]{
    \ctx \ent v \T A \\
    A \le A'
  }{
    \ctx \ent v \T A'
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

  \inferrule[Fun]{
    \ctx, x \T A \ent c \T \C
  }{
    \ctx \ent \fun{x} c \T A \to \C
  }

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
  \inferrule[SubComp]{
    \ctx \ent c \T \C \\
    \C \le \C'
  }{
    \ctx \ent c \T \C'
  }

  \inferrule[App]{
    \ctx \ent v_1 \T A \to \C \\
    \ctx \ent v_2 \T A
  }{
    \ctx \ent v_1 \, v_2 \T \C
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
    \ctx \ent \ret v \T A \E \emptyset
  }

  \inferrule[Op]{
    (\op \T A \to B) \in \sig \\
    \ctx \ent v \T A
  }{
    \ctx \ent \op \, v \T B \E \{\op\}
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
\caption{Typing of \eff}\label{fig:eff-typing}
\end{figure}
