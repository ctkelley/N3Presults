hlu!(
    A::AbstractMatrix,
    pivot::Union{RowMaximum,NoPivot,RowNonZero} = lupivottype(eltype(A));
    check::Bool = true,
) = generic_hlufact!(A, pivot; check = check)
function generic_hlufact!(
    A::AbstractMatrix{T},
    pivot::Union{RowMaximum,NoPivot,RowNonZero} = lupivottype(T);
    check::Bool = true,
) where {T}
    check && LAPACK.chkfinite(A)
    # Extract values
    m, n = size(A)
    minmn = min(m, n)

    # Initialize variables
    info = 0
    BlasInt = LinearAlgebra.BLAS.BlasInt
    ipiv = Vector{BlasInt}(undef, minmn)
    @inbounds begin
        for k = 1:minmn
            # find index max
            kp = k
            if pivot === RowMaximum() && k < m
                amax = abs(A[k, k])
                for i = k+1:m
                    absi = abs(A[i, k])
                    if absi > amax
                        kp = i
                        amax = absi
                    end
                end
            elseif pivot === RowNonZero()
                for i = k:m
                    if !iszero(A[i, k])
                        kp = i
                        break
                    end
                end
            end
            ipiv[k] = kp
            if !iszero(A[kp, k])
                if k!= kp
                    # Interchange
                    for i = 1:n
                        tmp = A[k, i]
                        A[k, i] = A[kp, i]
                        A[kp, i] = tmp
                    end
                end
                # Scale first column
                Akkinv = inv(A[k, k])
                for i = k+1:m
                    A[i, k] *= Akkinv
                end
            elseif info == 0
                info = k
            end
            # Update the rest
                @batch for j = k+1:n
                    @simd ivdep for i = k+1:m
                       @inbounds A[i, j] -= A[i, k] * A[k, j]
                    end
                end
        end
    end
    check && checknonsingular(info, pivot)
    return LU{T,typeof(A),typeof(ipiv)}(A, ipiv, convert(BlasInt, info))
end

function hlu(A)
    C = copy(A)
    AF = hlu!(C)
    return AF
end


# More stuff I got from Base
lupivottype(::Type{T}) where {T} = RowMaximum()
checknonsingular(info, pivot) = LinearAlgebra.checknonsingular(info, pivot)
