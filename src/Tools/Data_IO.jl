function readmpdata(fname, data)
    open(fname, "r") do io
        read!(io, data)
    end
end

function writempdata(fname, data)
    open(fname, "w") do io
        write(io, data)
    end
end

function Fname(c, n, descriptor)
    fname = string(descriptor, ";c=", string(c), ";dim=", string(n), ".mpdat")
    return fname
end
