# Lambda.jl
To use lambda-calculus notation in Julia code.

# How
LEval (Lambda Evaluation) take a string.
Returns an expression.

If you want to name your lambda expression, do
"<expression_name>:=<expression>".
  
For an function/lambda to be used in <expression>, it must be one character long.
This allow notation such as
```julia
LEval("S:=λx[λy[λz[xz(yz)]]") |> eval
LEval("K:=λx[λy[x]]") |> eval
LEval("I:=λx[SKKx]") |> eval
```
 
If the string is in multiple lines, each line will be evaluated separately, and will return an array of Expression.
