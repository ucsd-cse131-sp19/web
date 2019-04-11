# Lecture 4 (prim ops + vars)

## Quiz 1      

Consider the adder-3 grammar:

```
expr ::= <number>
       | add1(<expr>)
       | sub1(<expr>)
```

Which string is allowed by the grammar?

A. 1 + 2
B. add1(3, 3)
C. add1(add1(4))
D. add1(sub1, 4)
E. add1(x)






















## Quiz 2
Recall the `compile` function, more or less reproduced below:

```haskell
compile (Number n _)   = [ printf "mov eax, %d" n]
compile (Prim1 op e _) = arg_istrs
                      ++ [ printf "add eax, %d" add]
    where
      arg_istrs        = compile e
      add              = case op of
                    Add1 -> 1
                    Sub1 -> (-1)
                    
```
What is the assembly code generated for 

`add1(sub1(4))`

A.    mov eax, 4
      add eax, 1
      add eax, -1

B.    add eax, 1
      add eax, -1
      mov eax, 4

C.    mov eax, 4
      add eax, -1
      add eax, 1
     
     
     
     
     
     
     
     
     
     
     









## Quiz 3

Consider the adder-4 grammar:

```
expr ::= <number>
       | add1(<expr>)
       | sub1(<expr>)
       | let <id> = <expr>  -- value 
                  in <expr> -- body
       | <id>
```

Which string is allowed by the grammar?

A. let x = 5, add1(2)
B. let x = 5 in add1(x)
C. let x = 5
D. let 10 = add(9)



## Quiz 4

Which is a reasonable definition for the AST with let?

```haskell
data Expr = Number Integer
          | Add1 Expr
          | Sub1 Expr
          | -- Case goes here
```

A. `Let Expr Expr Expr`
B. `Let String Expr`
C. `Let String Expr Expr`
D. `Let String Int Expr`
































# Quiz 5

```haskell
stackloc i = i * 4

type Env = [(String, Int)]

lookup x []          = Nothing
lookup x ((y,i):env) 
  | x == y           = Just i
  | otherwise        = lookup x env

-- old cases left out
-- New:
compile env (Number n) = [ printf "mov eax, %d", n ]
compile env (Id x)   = [ printf "mov eax, [esp - %d]" pos ]
  where 
    pos = case lookup x env of
            Nothing -> error "Unbound id"
            Just i  -> stackloc i
```

b. What instructions do we get from running:
`compile [("x", 1), ("y", 2)] (Id "z")`

A. mov eax, [esp-4]
B. mov eax, [esp-8]
C. mov eax, 2
D. mov eax, 8
E. Error - "Unbound Id"

a. What instructions do we get from running:
`compile [("x", 1), ("y", 2), ("z", 3)] (Id "y")`

A. mov eax, [esp-4]
B. mov eax, [esp-8]
C. mov eax, 2
D. mov eax, 8
E. Error - "Unbound Id"














## Example:

```
let x = 10 in
  let cat = 3 in
  let y = add1(x) in
    let z = add1(y) in
      z
```
should compile to

```
mov eax, 10
mov [esp-4], eax
;; storing "cat"
mov eax, 3
mov [esp-16], eax
;; now load x

mov eax, [esp-4]
add eax, 1
mov [esp-8], eax
mov eax, [esp-8]
add eax, 1
mov [esp-12], eax
mov eax, [esp-12]
```

What should the stack look like?







Where do the "-4", "-8" come from?
































## Example:


Now let's map out what the environment looks like in each step:

```
let x = 10 in          -- env: [x |-> 1 ]
  let y = add1(x) in   -- env: [y |-> 2, x |-> 1]
    let z = add1(y) in -- env: [z |-> 3, y |-> 2, x |-> 1]
      z
```





















## Example


```
let a = 10                  -- env [ a |-> 1 ]
in 
  let c = let b = add1(a)   -- step into expr for "b", [ b |-> 2, a |-> 1]
          in
             add1(b)        -- env [ c |-> 2, a |-> 1 ]
  in
    add1(c)                 -- env [ c |-> 2, a |-> 1 ]
```

What does the environment look like at each step?
What instructions do we expect?











What does memory look like after execution?












## Exercise 

Can we start to fill in the `let` case?

```haskell
compile env (Id x)   = [ printf "mov eax, [esp - %d]" pos ]
  where 
    pos = case lookup x env of
            Nothing -> error "Unbound id"
            Just i  -> stackloc i

compile env (Let x e1 e2) = value_instrs
                         ++ [ printf "mov [esp - %d], eax" offset ]
                         ++ body_instrs
  where
    value_instrs = compile env e1
    i            = length env + 1
    offset       = stackloc i -- (i * 4)
                              -- top of the stack ==> declaring a new variable
    body_instrs  = compile env' e2
    env'         = -- add the variable to the new environment
                   ((x, i) : env)
```
Q: what to replace the '???'s with

"shadowing" test case
let x = (let x = ...)
