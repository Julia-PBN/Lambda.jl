module Lambda
export LEval

function LEval(str) #... it's unreadable, why did I wrote it this way???
    o = split(str, r"\r?\n") .|> String
    if length(o) == 0
        return
    elseif length(o) == 1
        s = o[1]
        if (r = match(r":=", s)) != nothing
            i = r.offset
            return Expr(:(=), Symbol(s[1:prevind(o[1], i)]), LEval(s[nextind(o[1], i, 2):end]))
        end
        if (r = match(r"\(", s)) != nothing
            if (r2 = match(r"λ.*\[.*\]", s)) != nothing
                if r2.offset < r.offset
                    @goto END_P
                end
            end
            i = r.offset
            u = mfc(s, ')', '(', i)
            z = Expr(:block, LEval(s[nextind(s, i):prevind(s, u)]))
            if u != lastindex(s)
                z = call_AAAAA(deepcopy(z), LEval(s[nextind(s, u):end]))
            end
            if i != firstindex(s)
                z = call_AAAAA(LEval(s[1:prevind(s, i)]), deepcopy(z))
            end
            return z
            @label END_P
        end
        if (r = match(r"λ.*\[.*\]", s)) != nothing
            i = r.offset
            u = mff(s, '[', i+1)
            e = mfc(s, ']', '[', u)
            ex = Expr(:->, Symbol(s[nextind(s, i):prevind(s, u)]), LEval(s[nextind(s, u):prevind(s, e)]))
            if e == lastindex(s)
                return ex
            else
                z = LEval(s[nextind(s, e):end])
                return call_AAAAA(ex, z) # too much mental pain from that function, thus the name
            end
        end
        if length(split(s, " ")) == 1
            return Meta.parse(idk(s))
        else
            throw("owo not implemedeeded") # coz idk
        end
    else
        println("not implmeented lolr")
        sleep(2)
        println("just joking :P")
        LEval.(o)
    end
end

function call_AAAAA(ex, z::Expr)
    l = 0
    if z.head == :call
        return Expr(:call, call_AAAAA(ex, z.args[1]), z.args[2])
    else
        return Expr(:call, ex, z)
    end
end

function call_AAAAA(ex, z)
    Expr(:call, ex, z)
end

macro LEval_str(str)
    LEval(str)
end

function mfc(str, c, n, i = 1)
    o = 0
    for d in eachindex(str)
        if d >= i
            if str[d] == n
                o -= 1
            elseif str[d] == c
                o += 1
                if o == 0
                    return d
                end
            end
        end
    end
    missing
end
function mff(str, c, i = 1)
    for d in eachindex(str)
        if d >= i
            str[d] == c && return d
        end
    end
    missing
end

function idk(s)
    o = ""
    for i in s
        if i ∉ "()"
            o = o * "($i)"
        else
            o = o * "$i"
        end
    end
    o
end

end
