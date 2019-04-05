module SAT where
import Data.Monoid
import Data.List

data Formula
  = Var String
  | Not Formula
  | And Formula Formula
  | Or Formula Formula
  | Implies Formula Formula

data SFormula
  = SVar String
  | SNot SFormula
  | SAnd SFormula SFormula

simplify :: Formula -> SFormula
simplify (Implies f1 f2)
  = simplify (Or (Not f1) f2)
simplify (Or f1 f2)
  = SNot (SAnd (SNot (simplify f1))
               (SNot (simplify f2)))
simplify (And f1 f2)
  = (SAnd (simplify f1) (simplify f2))
simplify (Not f)
  = SNot (simplify f)
simplify (Var v)
  = SVar v

data SAT = UNSAT | SAT
  deriving (Show)

example = (Var "A")
-- sat example ===> SAT
example' = And (Var "A") (Not (Var "A"))
-- sat example' ===> UNSAT
example'' = And (Var "A") (Not (Var "B"))
-- sat example' ===> SAT

type Assignment = [(String, Bool)]
eval :: Formula -> Assignment -> Bool
eval (Var s) assignment
  = case lookup s assignment of
      Nothing -> error "Uhhhhhhhh"
      Just value -> value
eval (Not f) a
  = not (eval f a)
eval (And f1 f2) a
  = eval f1 a && eval f2 a
eval (Or f1 f2) a
  = eval f1 a || eval f2 a
eval (Implies f1 f2) a
  = eval f1 a ==> eval f2 a

vars :: Formula -> [String]
vars (Var v)         = [v]
vars (Not f)         = vars f
vars (And f1 f2)     = nub (vars f1 ++ vars f2)
vars (Or f1 f2)      = nub (vars f1 ++ vars f2)
vars (Implies f1 f2) = nub (vars f1 ++ vars f2)

assignments :: [String] -> [Assignment]
assignments [] = [[]]
assignments (v:vs)
  = [ ((v,b):vs') | b <- [True, False]
                  , vs' <- assignments vs
                  ]

b1 ==> b2 = (not b1) || b2

sat :: Formula -> SAT
sat f
  | null res  = UNSAT
  | otherwise = SAT
  where
    vs  = vars f
    as  = assignments vs
    res = dropWhile (not . eval f) as

-- f . g = \x -> f (g x)
-- does there exist a :: Assignment s.t.
-- eval f a == True??
