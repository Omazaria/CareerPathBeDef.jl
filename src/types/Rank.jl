requiredTypes = [ "AbstractLevel" ]

for reqType in requiredTypes
    if !isdefined( Symbol( uppercase( string( reqType[ 1 ] ) ) * reqType[ 2:end ] ) )
        include(  reqType * ".jl" )
    end  # if !isdefined( Symbol( ...
end

export Rank

type Rank <: AbstractLevel

    # Name of the Rank ex: LT, CPN
    Name::String

    # Code of the rank ex: LT => 250, CPN =>220
    RankCode::Int

    # Maximum and minimum stay in this Rank
    MinStay::Int
    MaxStay::Int

    # A list of allowed Assignment
    NextLevel::Array{String}

    Rank() = new("", 0, 0, 0, Array{String}())
    Rank(nm::String,
         code::Int;
         min::Int = 0,
         max::Int = 0,
         next::Array{String} = Array{String}()) = new(nm, code, min, max, next)



end
