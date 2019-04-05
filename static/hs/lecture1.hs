module Lecture1 where
import Text.Printf (printf)
import Debug.Trace (trace)
import Prelude hiding (negate, filter)


main :: IO ()
main = putStrLn "hello world"

-- Functions
-----

-- incr(int x) { return (x+1) }
-- incr (x : int) : int = x + 1

incr :: Int -> Int
incr x = x + 1

eleven :: Int
eleven = incr 10

--
-- sep = ", "
-- words = ["cat", "dog", "horse"]
-- out "cat, dog, horse"

-- joinWords :: [Char] -> [[Char]] -> [Char]
joinWords :: String -> [String] -> String
joinWords sep [] = ""
joinWords sep [w] = w
joinWords sep (w:ws) = w ++ sep ++ joinWords sep ws

joinWords' :: [a] -> [[a]] -> [a]
joinWords' sep [] = []
joinWords' sep [w] = w
joinWords' sep (w:ws) = w ++ sep ++ joinWords' sep ws
-- Any Type
-- [a] -> [[a]] -> [a]
-- Type error
  
{-
joinWords sep words
  = case words of
      []     -> ""
      [w]    -> w
      (w:ws) -> w ++ sep ++ joinWords sep ws
-}


isEven :: Int -> Bool
isEven x = x `mod` 2 == 0
-- isEven x = mod x 2 == 0

filter :: (a -> Bool) -> [a] -> [a]
filter p [] = []
filter p (x:xs) = if p x then x : rest else rest
  where
    rest        = filter p xs
--filter p (x:xs) = let rest = filter p xs in
--                    if p x then x : rest else rest

quiz = x + y
  where
    y = x + 1
    x = y
-- circular def?
-- infinite type? occurs check?

---- Closures
-- negate f = fun x -> not (f x)
negate :: (a -> Bool) -> a -> Bool
negate f = \x -> not (f x)

odd = negate even
-- ocaml: .. ......................-> ('a list * 'a list)
partition :: (a -> Bool) -> [a] -> ([a], [a])
partition p xs = ( filter p          xs
                 , filter (negate p) xs
                 )


sort :: (Ord a) => [a] -> [a]
sort [] = []
sort (h:t) = sort ls ++ [h] ++ sort rs
  where
    (ls, rs) = partition isLessThanHead {- (\x -> x < h) -} t
    isLessThanHead x = x < h

sort' [] = []
sort' (h:t) = sort' ls ++ [h] ++ sort' rs
  where
    ls = [ x | x <- t, x  < h ]
    rs = [ x | x <- t, x >= h ]

--
quiz2 = [0..5]
quiz3 = [ x*10 | x <- quiz2 ]
quiz4 = [ x*10 | x <- quiz2, x < 3, x > 1]


---------- 4/4
-- type expr = Number of double
--           | Plus of (expr * expr) ...

data Expr a
  = Number a
  | Plus   (Expr a) (Expr a)
  | Minus  (Expr a) (Expr a)
  | Times  (Expr a) (Expr a)
  deriving (Show)

ex0 = Number 3.0
{-
Concrete: 3.0 + 76.0
Concrete': 3.0 76.0 +
AST: ex1
-}
ex1 = Plus   ex0 (Number 76.0)
ex2 = Minus  ex1 ex0
ex3 = Times  ex2 ex2
ex4 = Minus ex3 ex1

ex_weird = Number ()

eval :: Expr Double -> Double
eval e = let res =
               case e of
                 (Number n)    -> n
                 (Plus e1 e2)  -> eval e1 + eval e2
                 (Minus e1 e2) -> eval e1 - eval e2
                 (Times e1 e2) -> eval e1 * eval e2
         in
           trace (show (e, res)) res
-- eval e@(Number n)    = trace (msg n) n
-- eval (Plus e1 e2)  = eval e1 - eval e2
-- eval (Minus e1 e2) = eval e1 - eval e2
-- eval (Times e1 e2) = eval e1 * eval e2

























  
