# Using Dynamic Programming to Predict RNA Secondary Structure

Source: *Algorithm Design*, J. Kleinberg and E. Tardos, Addison Wesley, 2006.

## Background

RNA molecules are crucial to the functioning of cells. They are central to the synthesis of proteins, they regulate which genes get expressed, and they form the genome of most viruses. An RNA molecule is a single strand of bases. There are four kinds of bases: A, C, G, and U. The sequence of bases is called the *primary structure* of the RNA molecule.
Sometimes a strand of RNA will loop back on itself, causing some of the bases to pair with each other. The only pairings possible are A with U, and C with G. The resulting configuration is called *secondary structure*. Understanding the secondary structure gives important information about the workings of the molecule.

Given a length n RNA strand B = b1, b2, ..., bn where each bi belongs to {A, U, C, G}, we can model a secondary structure as a set of pairs S = {(i,j)}, where i and j are both between 1 and n. Due to biochemical constraints, the secondary structure must satisfy these conditions:

1. No sharp turns: for each pair, j must be greater than i + 4
2. Proper pairing: for each pair, either one is A and the other is U, or one is C and the other is G
3. Matching: no base appears in more than one pair
4. Noncrossing: if (i,j) and (k,l) are two pairs, then we cannot have i < k < j < l.

Biochemists are interested in what secondary structures are most likely to arise in nature. One (overly) simplistic approximation is to consider those secondary structures that have the largest number of base pairs in them.

## Problem Statement

You are to write a **well-structured** and **well-documented** program to solve the following problem using dynamic programming:

> Given a sequence B = b1, b2, ..., bn, determine a secondary structure (defined above and subject to the 4 conditions above) with the largest number of base pairs.

Base your program on the following recursive expression for the maximum number of pairs.

Let OPT(i,j) be the maximum number of base pairs that can occur on bi, b(i+1), ..., bj.

Goal: OPT(1,n).

Basis: OPT(i,j) = 0 if the difference between i and j is less than 5 (by the no-sharp-turns condition).

Induction: The intuition is that there are two cases for the base bj: either it is not involved in a pair, or it is paired with some prior base that occurs sufficiently far back (at least 5). If bj is not involved in a pair, then the best situation for bi, ..., bj is the same as the best situation for bi, ..., b(j-1). If bj is involved in a pair, let's say with bt, then the best situation for bi, ..., bj is when we have the pair (t,j), and we have the best situation for bi, ..., b(t-1), and we have the best situation for b(t+1), ..., b(j-1). Because of the no-crossing condition, we can cleanly separate the two situations at bt. After computing these two quantities, we take whichever is larger. More precisely:

OPT(i,j) is the maximum of

1. OPT(i,j-1) and
2. 1 + max(OPT(i,t-1) + OPT(t+1,j-1))

In the second case, the maximum is taken over all t such that (t,j) satisfies the no-sharp-turns condition and the proper pairing condition.

In addition to computing the maximum number of pairs, you are also to compute the actual set of pairs.

*Input and Output:* Your program should read in from a file the input string, which is just a sequence of capital letters A, C, G, and U (example: ACCAUGGCUUA). Your program should write the output to a file also; the format for the output is, first, the number of pairs found, followed by a list of the pairs (example: 3, (1, 10), (2, 9), (3,8) )

## Experiments and Report

Part of the assignment is to explore the performance of your program. You will need to run your program on different size inputs and measure how fast it is. For each input size that you choose (e.g., a sequence of length 50), there are many possible inputs, so you need to think about which inputs of each fixed size you will test. You will need to write an auxiliary program to create your inputs (for instance, randomly generate sequences, and/or generate sequences that are guaranteed to have some matches).

You will write a brief report that includes theoretical analysis, a description of your experiments, and discussion of your results. At a minimum, your report should include the following sections:

1. *Introduction.* Describe the objective of this assignment.
2. *Theoretical analysis.* Provide a brief analysis of the running time of your program using asymptotic notation.
3. *Experimental Setup.* Provide a description of your experiment setup, which includes but is not limited to
  - Machine specification.
  - What is your timing mechanism?
  - How did you generate the test inputs? What input sizes did you test? Why?
  - How many times did you repeat each experiment?
4. *Experimental Results.* Compare the observed running time of your program to the theoretical complexity.
  - Make a plot showing the running time (y-axis) vs. the input size (x-axis). You must use some electronic tool (e.g., matlab, gnuplot, excel) to create the plot - handwritten plots will NOT be accepted.
  - Discuss your results. To what extent does theoretical analysis agree with the experimental results? Attempt to understand and explain any discrepancies you note.

## Bureaucracy

- Use the turnin program to turn in ONE tar or zip file containing:
  - all your source code, including that for creating your test inputs, and
  - your experimental report in PDF format.
- Grading will be based on
  - quality of your code (how well structured and documented it is)
  - correctness of your code (as indicated in your demo to Grant)
  - quality of your report

Stay tuned for more information on scheduling your demo with Grant.
